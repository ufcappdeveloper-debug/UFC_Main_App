import 'dart:convert';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/log/log_utils.dart';

String _generateNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = math.Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

String _sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

Future<Map<String, String>> signInWithApple(BuildContext context) async {
  final rawNonce = _generateNonce();
  final nonce = _sha256ofString(rawNonce);
  try {
    final future = SignInWithApple.getAppleIDCredential(scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ], nonce: nonce);
    final appleCredential = await LoadingDialog.show(context, future);
    if (appleCredential.identityToken == null ||
        appleCredential.identityToken!.isEmpty) {
      throw 'User does not exist';
    }

    return {"apple_auth_code": appleCredential.identityToken ?? ""};
  } on SignInWithAppleAuthorizationException catch (e) {
    switch (e.code) {
      case AuthorizationErrorCode.canceled:
        throw 'User has cancelled login with Apple';
      case AuthorizationErrorCode.failed:
        rethrow;
      case AuthorizationErrorCode.invalidResponse:
        rethrow;
      case AuthorizationErrorCode.notHandled:
        rethrow;
      case AuthorizationErrorCode.unknown:
        throw 'Unable to fetch the Apple ID, Please Try again';
      default:
    }
    rethrow;
  } catch (e) {
    debugLog(e.toString());
    throw 'Apple Sign-In Failed. Please choose another sign-in method.';
  }
}
