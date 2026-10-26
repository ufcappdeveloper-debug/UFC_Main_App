import 'package:ufc_mobile/global/util/log/log_utils.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryTracker {
  //* Private constructor to prevent instantiation
  SentryTracker._();

  static final SentryTracker _instance = SentryTracker._();

  factory SentryTracker() => _instance;

  static PackageInfo? packageInfo;
  static String operatingSystem = 'Unknown';

  // Initializes Sentry and gathers OS & app info
  static Future<void> init() async {
    packageInfo = await PackageInfo.fromPlatform();
    _getOperatingSystemInfo();
  }

  // Helper method to get current timestamp
  static String _getCurrentTimestamp() => DateTime.now().toIso8601String();

  // Retrieves operating system information
  static void _getOperatingSystemInfo() {
    operatingSystem =
        '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
  }

  // Extracts common attributes for requests and responses
  static Map<String, dynamic> _getCommonAttributes({
    String? statusCode,
    String? statusMessage,
    String? data,
    String? duration,
    dynamic userAgent,
    RequestOptions? options,
  }) {
    return {
      'timestamp': _getCurrentTimestamp(),
      'url': options?.uri.toString(),
      'method': options?.method,
      'statusCode': statusCode ?? 'Unknown',
      'statusMessage': statusMessage ?? 'No status message',
      'data': data == null ? 'No data' : redactSecrets(data),
      'duration': duration ?? 'Unknown',
      'userAgent': userAgent ?? 'Unknown',
      'appVersion': packageInfo?.version ?? 'Unknown',
      'operatingSystem': operatingSystem,
      'headers': options == null ? 'Unknown' : safeHeaders(options.headers),
      'queryParameters':
          options?.queryParameters.toString() ?? 'No query parameters',
      'requestSize': options?.data?.toString().length.toString() ?? 'Unknown',
    };
  }

  // Gets response-specific attributes
  static Map<String, dynamic> _getResponseAttributes(Response response) {
    return _getCommonAttributes(
      statusCode: response.statusCode?.toString(),
      statusMessage: response.statusMessage,
      data: response.data?.toString(),
      options: response.requestOptions,
      duration: response.requestOptions.extra['duration']?.toString(),
      userAgent: response.requestOptions.headers['User-Agent'],
    );
  }

  // Records a request event
  static void recordRequest(RequestOptions options) {
    final eventAttributes = _getCommonAttributes(
      data: options.data?.toString(),
      options: options,
    );

    Sentry.captureMessage(
      'Request Event',
      level: SentryLevel.info,
      withScope: (scope) {
        scope.setContexts('Request Details', eventAttributes);
      },
    );
  }

  // Records a response event
  static void recordResponse(Response response) {
    final eventAttributes = _getResponseAttributes(response);

    Sentry.captureMessage(
      'Response Event',
      level: SentryLevel.info,
      withScope: (scope) {
        scope.setContexts('Response Details', eventAttributes);
      },
    );
  }

  // Records a response error event
  static void recordResponseError(
    Response response, {
    String customMessage = 'Unknown',
    Map<String, String>? additionalAttributes,
  }) {
    final attributes = {
      ..._getResponseAttributes(response),
      'message': customMessage,
      'errorType': response.statusCode != null && response.statusCode! >= 500
          ? 'Server Error'
          : 'Client Error',
      'retryCount':
          response.requestOptions.extra['retryCount']?.toString() ?? '0',
    };

    if (additionalAttributes != null) attributes.addAll(additionalAttributes);

    Sentry.captureException(
      Exception('Response Error: ${response.statusCode}'),
      stackTrace: StackTrace.current,
      withScope: (scope) {
        scope.setContexts('Error Details', attributes);
      },
    );
  }

  // Records a Dio error event
  static void recordDioError(
    DioException error, {
    String customMessage = 'Unknown',
    Map<String, String>? additionalAttributes,
  }) {
    final attributes = _getCommonAttributes(
      statusCode: error.response?.statusCode?.toString(),
      data: error.response?.data?.toString(),
      options: error.requestOptions,
    )..addAll({'message': customMessage, 'errorType': error.type.toString()});

    if (additionalAttributes != null) attributes.addAll(additionalAttributes);

    Sentry.captureException(
      error,
      stackTrace: StackTrace.current,
      withScope: (scope) {
        scope.setContexts('Dio Error Details', attributes);
      },
    );
  }
}
