import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_in_app_pip/picture_in_picture.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/global/config/farm_session.dart';
import 'package:ufc_mobile/screens/farm/application/members/farm_account_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/feed_channel/feed_channel_cubit.dart';
import 'package:ufc_mobile/global/shared/constants/custom_loading_dialog.dart';
import 'package:ufc_mobile/global/util/call/agora_engine_singleton.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/global/util/storage/local_storage.dart';
import 'package:ufc_mobile/main.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/bottom_bar_bloc/bottom_bar_bloc.dart';
import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/notification/notification_cubit.dart';
import 'package:ufc_mobile/screens/feed/presentation/authentication/pages/login_with_number_page.dart';

Future<void> performFullLogout({
  required BuildContext context,
  required AppType appType,
}) async {
  try {
    // Start logout
    final future = context.read<AuthCubit>().logout();

    // Dispose Agora engine
    AgoraEngineSingleton().dispose();

    // Stop PiP if active
    if (PictureInPicture.isActive) {
      PictureInPicture.stopPiP();
    }

    final isFromFarm = appType == AppType.farm;
    final isFromVet = appType == AppType.veterinary;

    // Show loading while logout completes
    await LoadingDialog.show(
      context,
      future,
      isFromFarm: isFromFarm,
      isFromVet: isFromVet,
    );

    // Clear preferences
    await preferences.remove("token");
    await preferences.setBool('init_fcm', false);
    await clearPreferencesExceptLanguage();

    // Clear app-level token and the selected farm / feed channel
    AppConfig.token = null;
    await FarmSession.clear();
    context.read<FarmAccountCubit>().reset();
    context.read<FeedChannelCubit>().clear();

    // Reset app state cubits
    context.read<FeedBottomNavCubit>().changeTab(0);
    context.read<AppBarCubit>().setMode(AppBarMode.normal);
    context.read<NotificationCubit>().resetNotifications();

    // Navigate to login page
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => LoginWithNumber(
          appType: appType,
          isNotFromStart: true,
        ),
      ),
      (route) => false,
    );
  } catch (e) {
    debugPrint("Logout error: $e");
  }
}

Future<void> clearPreferencesExceptLanguage() async {
  int? languageIndex = preferences.getInt(LocalStorage.language);
  for (String key in preferences.getKeys()) {
    if (key != "no_onboard" && key != 'show_welcome') {
      preferences.remove(key);
    }
  }
  if (languageIndex != null) {
    await preferences.setInt(LocalStorage.language, languageIndex);
  }
}
