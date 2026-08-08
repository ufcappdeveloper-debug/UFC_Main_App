import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/log/log_utils.dart';

Future<Map<String, String>> signInWithGoogle(BuildContext context) async {
  try {
   GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>['email', 'profile'],
  serverClientId: '121184558555-k8rjv6ofm34u6vpeq0c9ge0f76ed2bh6.apps.googleusercontent.com',
);
    try {
      final signOutFuture = googleSignIn.signOut();
      await LoadingDialog.show(context, signOutFuture);
    } finally {}
    final googleUserFuture = googleSignIn.signIn();
    if (!context.mounted) throw 'Google Sign-In Failed, Please Try again';
    final GoogleSignInAccount? googleUser =
        await LoadingDialog.show(context, googleUserFuture);
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    if (googleAuth == null) {
      throw 'User has cancelled login with Google';
    }
    if (googleAuth.accessToken == null || googleAuth.accessToken!.isEmpty) {
      throw 'User does not exist';
    }

    return {"google_auth_code": googleAuth.accessToken ?? ""};
  } on PlatformException catch (e) {
    debugLog('platform exception ${e.message ?? ''}');
    throw e.message ??
        'Google Sign-In Failed. Please choose another sign-in method.';
  } catch (e) {
    debugLog(e.toString());
    throw e.toString();
  }
}
