import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ufc_mobile/global/util/analytic/sentry_tracker.dart';

/// Logs messages to the console in debug mode with an optional logging level.
void debugLog(String message) {
  if (kDebugMode) log(message);
}

final _secretValue = RegExp(
  r'''(["']?(?:token|access_token|refresh_token|password|otp|integrity)["']?\s*[:=]\s*["']?)([^"',}\s]+)''',
  caseSensitive: false,
);

/// Hides tokens, passwords and OTPs in text that is logged or sent to
/// crash reporting (request/response bodies).
String redactSecrets(Object? value) {
  final text = value?.toString() ?? '';
  return text
      .replaceAllMapped(_secretValue, (m) => '${m[1]}[REDACTED]')
      .replaceAll(RegExp(r'Bearer\s+\S+'), 'Bearer [REDACTED]');
}

/// Request headers without credentials.
Map<String, dynamic> safeHeaders(Map<String, dynamic>? headers) => {
      for (final e in (headers ?? const <String, dynamic>{}).entries)
        e.key: e.key.toLowerCase() == 'authorization' ||
                e.key.toLowerCase() == 'x-owner-id'
            ? '[REDACTED]'
            : e.value,
    };

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
      debugLog('Response Data: ${redactSecrets(response.data ?? 'N/A')}');
    } else {
      debugLog('Response: No response available');
    }

    // Log request details
    debugLog('Request:');
    debugLog('Base URL: ${requestOptions.baseUrl}');
    debugLog('Path: ${requestOptions.path}');
    debugLog(
      'Query Parameters: ${requestOptions.queryParameters.isNotEmpty ? requestOptions.queryParameters : 'None'}',
    );
    debugLog('Request Headers: ${safeHeaders(requestOptions.headers)}');
    debugLog('Request Data: ${redactSecrets(requestOptions.data ?? 'No data')}');

    debugLog('-----------------End Dio Error-----------------');
    return;
  }
}
