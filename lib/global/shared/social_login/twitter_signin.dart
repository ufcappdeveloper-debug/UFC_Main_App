import 'package:flutter/material.dart';
import 'package:twitter_login/entity/user.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/log/log_utils.dart';

Future<User> signInWithTwitter(BuildContext context) async {
  try {
    final twitterLogin = TwitterLogin(
        redirectURI: 'twittersdk://',
        apiKey: 'xngVLrJiySLHxkHaw4PTFnP1C',
        apiSecretKey: 'T58dHvSahhfra1lgwTwHddXzH2SIKp3FOLHGgtX4UVS48QBQQ7');
    final future = twitterLogin.login();
    final authResult = await LoadingDialog.show(context, future);
    if (authResult.user == null) {
      throw 'User does not exist';
    }

    return authResult.user!;
  } catch (e) {
    debugLog(e.toString());
    throw e.toString();
  }
}
