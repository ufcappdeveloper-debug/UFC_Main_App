import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';
import 'package:ufc_mobile/global/util/exception/app_exception.dart';

class ErrorHandler {
  static void handleError(BuildContext context, Object error) {
    String message = 'Something went wrong!';

    if (error is DioException) {
      message = error.dioMessage;
      if (message.contains('"id_token" is not allowed to be empty')) {
        message = 'Sign-in failed. Please try again.';
      }
    } else if (error is PlatformException) {
      if (error.code == 'network_error') {
        message = 'Could not connect to the server. Please check your network.';
      } else {
        message = error.message ?? 'Platform Exception';
      }
    } else if (error is SignInWithAppleAuthorizationException) {
      message = error.message;
    } else if (error is CustomException) {
      message = error.message;
    } else if (error is String) {
      message = error;
    }

    if (message.isEmpty || message.contains("type 'Null'")) {
      message = 'Oops, something went wrong!';
    }

    if (message.contains('{currency}')) {
      CustomSnackBar.richError(context, message);
    } else {
      CustomSnackBar.error(context, message);
    }

    // CustomSnackBar.error(context, message);
  }

  static String getErrorMessage(Object error) {
    String message = 'Something went wrong!';

    if (error is DioException) {
      message = error.dioMessage;
      if (message.contains('"id_token" is not allowed to be empty')) {
        message = 'Sign-in failed. Please try again.';
      }
    } else if (error is PlatformException) {
      if (error.code == 'network_error') {
        message = 'Could not connect to the server. Please check your network.';
      } else {
        message = error.message ?? 'Platform Exception';
      }
    } else if (error is CustomException) {
      message = error.message;
    } else if (error is String) {
      message = error;
    }

    if (message.isEmpty || message.contains("type 'Null'")) {
      message = 'Oops, something went wrong!';
    }

    return message;
  }
}
