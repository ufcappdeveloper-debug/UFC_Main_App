
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/config/firebase_notification.dart';
import 'package:ufc_mobile/global/util/analytic/adjust_tracker.dart';
import 'package:ufc_mobile/main.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/screens/app_launch.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/utils/smooth_nav_utils.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/widgets/temporary_splash_screen.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';

class AuthUtils {
  static bool _navigating = false;

  static Future<void> showNearbyStations(
    BuildContext context, {
    WidgetRef? ref,
    int? initPage,
    UserModel? userModel,
  }) async {
    if (_navigating) return;
    _navigating = true;

    try {
      bool showWelcome = preferences.getBool('show_welcome') ?? false;
      AdjustTracker.trackLogin();

      // Get user from parameter, Riverpod, or Cubit
      final user = userModel ??
          ref?.watch(authProvider).value ??
          context.read<AuthCubit>().currentUser;

      if (user == null) {
        _navigating = false;
        return;
      }

      // Handle notification tap case
      final notificationHandled = await FirebaseNotification().initMessaging();
      if (notificationHandled) {
        debugPrint(
            '📬 Notification tap handled. Skipping BottomBar navigation.');
        _navigating = false;
        return;
      }

      await Future.delayed(const Duration(milliseconds: 150));

      if (!showWelcome && context.mounted) {
        final popped = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AppLaunch()),
        );

        if (popped == true && context.mounted) {
          // Show temporary splash (fully opaque)
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: true,
              pageBuilder: (_, __, ___) => const TemporarySplashScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );

          // Wait a small frame before next navigation for smoothness
          await Future.delayed(const Duration(milliseconds: 50));
          if (!context.mounted) return;

          // Straight into the app: the preferred station is asked only
          // when the user picks "Buy from Station" without one.
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            createSmoothRoute(
              BottomBar(initialIndex: initPage ?? 0),
              type: PageTransitionType.slideRight,
            ),
            (route) => false,
          );

          // Mark welcome as shown
          showWelcome = true;
          preferences.setBool('show_welcome', true);
        }
      } else {
        // Welcome already shown: straight into the app (the preferred
        // station is asked from "Buy from Station" only).
        if (!context.mounted) return;
        await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          createSmoothRoute(
            BottomBar(initialIndex: initPage ?? 0),
            type: PageTransitionType.slideRight,
          ),
          (route) => false,
        );
      }
    } catch (e, s) {
      debugPrint('❌ AuthUtils.showNearbyStations error: $e\n$s');
    } finally {
      _navigating = false;
    }
  }
}
