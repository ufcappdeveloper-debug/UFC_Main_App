import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/main.dart';
import 'package:ufc_mobile/global/util/analytic/sentry_tracker.dart';
import 'package:ufc_mobile/global/util/dio/dio_utils.dart';
import 'package:ufc_mobile/global/util/log/log_utils.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Add authorization token to request headers if available
    if (AppConfig.token != null) {
      // Log request token
      debugLog('Token: ${AppConfig.token!}');
      print('Token: ${AppConfig.token!}');
      options.headers['Authorization'] = 'Bearer ${AppConfig.token}';
    }

    // Log request details to Sentry
    SentryTracker.recordRequest(options);

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Log response token
    debugLog("response is ${response.data.toString()}");

    // Log response details to Sentry
    SentryTracker.recordResponse(response);

    if ((response.data != null) &&
        (response.data.runtimeType != List<dynamic>) &&
        (response.data.runtimeType.toString() == "_Map<String, dynamic>") &&
        response.data['token'] != null) {
      if (!response.requestOptions.path
          .contains('api/ufc/v1/get_agora_token')) {
        await preferences.setString('token', response.data['token']);
        AppConfig.token = response.data['token'];
      }
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log the error using a custom logger
    AppErrorLogger.onDioErrorLogger(err);

    // Reports the error to Sentry
    Sentry.captureException(err);

    // Handle response if present
    if (err.response != null) {
      final response = err.response!;
      final responseData = response.data;
      final responseStatusCode = response.statusCode;

      // Handle different error statuses and throw appropriate exceptions
      String errorMessage = err.error?.toString() ??
          'An unexpected error occurred. Please contact the admin for assistance';

      if (responseStatusCode == null) throw errorMessage;

      // Extract relevant data from the response
      dynamic message = (responseData is Map)
          ? _extractErrorMessage(responseData) ??
              response.statusMessage ??
              err.message
          : null;

      debugLog('Response Data: $responseData');

      switch (responseStatusCode) {
        case 400:
          _throwCustomDioError(err, response, message ?? 'Bad Request');
        case 401:
          _throwCustomDioError(err, response, message ?? 'Unauthorized');
        case 403:
          _throwCustomDioError(err, response, message ?? 'Forbidden');
        default:
          if (responseStatusCode >= 500) {
            debugLog('Request Data: ${err.requestOptions.data}');
            debugLog('Request Headers: ${err.requestOptions.headers}');
            _throwCustomDioError(err, response, 'Internal Server Error');
          }
          _throwCustomDioError(err, response, message ?? errorMessage);
      }
    } else {
      // No response, handle Dio-specific errors
      DioUtils.handleDioError(err);
    }

    super.onError(err, handler);
  }
}

dynamic _extractErrorMessage(Map responseData) {
  // Attempt to get the most relevant error message field
  var responseMessage = responseData['message'] ??
      responseData['data'] ??
      responseData['error'] ??
      responseData['detail'];

  // If the message itself is a Map, extract its 'message' field
  return responseMessage is Map ? responseMessage['message'] : responseMessage;
}

/// Provides a default error message for DioException.
void _throwCustomDioError(
    DioException err, Response response, Object errorMessage) {
  final responseData = response.data;
  throw DioException(
    type: err.type,
    error: errorMessage,
    requestOptions: err.requestOptions,
    response: Response(
      statusCode: response.statusCode,
      requestOptions: response.requestOptions,
      data: responseData is Map ? responseData : null,
    ),
  );
}

extension DioMessage on DioException {
  String get dioMessage =>
      error?.toString() ??
      "An unexpected error occurred. Please contact the admin for assistance";
}
