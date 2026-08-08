import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/global/util/analytic/sentry_tracker.dart';

/// Logs messages to the console in debug mode with an optional logging level.
void debugLog(String message) {
  if (kDebugMode) log(message);
}

class AppErrorLogger {
  AppErrorLogger._();

  static Future<void> logError(String errorMessage, {String? type}) async {
    // Log error details
    debugLog("-----------------${type ?? 'Error'}-----------------");
    debugLog(errorMessage);
    debugLog("-----------------End ${type ?? 'Error'}-----------------");
    return;
  }

  static Future<void> onDioErrorLogger(DioException error) async {
    // Log error details to Sentry
    SentryTracker.recordDioError(error);

    final response = error.response;
    final requestOptions = error.requestOptions;
    final timestamp = DateTime.now().toIso8601String();

    // Log basic Dio error details
    debugLog('-----------------Dio Error-----------------');
    debugLog('Timestamp: $timestamp');
    debugLog('Error: $error');
    debugLog('Message: ${error.message ?? 'No message available'}');

    // Log response details (if available)
    if (response != null) {
      debugLog('Response:');
      debugLog('Status Code: ${response.statusCode ?? 'N/A'}');
      debugLog('Status Message: ${response.statusMessage ?? 'N/A'}');
      debugLog('Response Data: ${response.data ?? 'N/A'}');
    } else {
      debugLog('Response: No response available');
    }

    // Log request details
    debugLog('Request:');
    debugLog('Base URL: ${requestOptions.baseUrl}');
    debugLog('Path: ${requestOptions.path}');
    debugLog('Token: ${AppConfig.token}');
    debugLog(
      'Query Parameters: ${requestOptions.queryParameters.isNotEmpty ? requestOptions.queryParameters : 'None'}',
    );
    debugLog('Request Headers: ${requestOptions.headers}');
    debugLog('Request Data: ${requestOptions.data ?? 'No data'}');

    debugLog('-----------------End Dio Error-----------------');
    return;
  }
}
