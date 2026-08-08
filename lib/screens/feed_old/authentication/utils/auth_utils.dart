// import 'dart:io';

// import 'package:app_settings/app_settings.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:location/location.dart';
// import 'package:ufc_mobile/global/config/firebase_notification.dart';
// import 'package:ufc_mobile/global/shared/constants/app_location.dart';
// import 'package:ufc_mobile/global/util/analytic/adjust_tracker.dart';
// import 'package:ufc_mobile/riverpod/auth/auth.dart';
// import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
// import 'package:ufc_mobile/screens/feed_old/stations/stations_map.dart';
// import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';

// import '../../../../main.dart';
// import '../../../app_launch.dart';

// class AuthUtils {
//   static Future<void> showNearbyStations(BuildContext context, WidgetRef ref,
//       {int? initPage, UserModel? userModel}) async {
//     bool showWelcome = preferences.getBool('show_welcome') ?? false;
//     AdjustTracker.trackLogin();
//     final user = userModel ?? ref.watch(authProvider).value;
//     if (user == null) {
//       return;
//     }
//     final notificationHandled = await FirebaseNotification().initMessaging();
//     if (notificationHandled) {
//       debugPrint('📬 Notification tap handled. Skipping BottomBar navigation.');
//       return;
//     }
//     if (user.preferredShopDetails == null ||
//         (user.preferredShop == null || user.preferredShop == 0)) {
//       final Location location = Location();
//       PermissionStatus givenPermission = await location.hasPermission();
//       debugPrint(givenPermission.toString());

//       if (!showWelcome && context.mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const AppLaunch()),
//         );

//         showWelcome = true;
//         preferences.setBool('show_welcome', true);
//       }

//       if (givenPermission == PermissionStatus.granted) {
//         WidgetsBinding.instance.addPostFrameCallback(
//           (_) async => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => StationMapScreen(
//                   fetchLocation: true, initialAppIndex: initPage ?? 0),
//             ),
//           ),
//         );
//       } else {
//         if (!Platform.isIOS) {
//           givenPermission = await location.requestPermission();
//         }
//         WidgetsBinding.instance.addPostFrameCallback(
//           (_) async => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => LocationPermissionScreen(
//                 initialAppIndex: initPage ?? 0,
//                 onPressed: () async =>
//                     AppSettings.openAppSettings(type: AppSettingsType.location),
//               ),
//             ),
//           ),
//         );
//       }
//     } else {
//       Future.delayed(
//         const Duration(milliseconds: 500),
//         () async {
//           if (!context.mounted) return;
//           if (!showWelcome) {
//             await Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const AppLaunch()),
//             );

//             showWelcome = true;
//             preferences.setBool('show_welcome', true);
//           }
//           if (!context.mounted) return;
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(
//               builder: (context) => BottomBar(initialIndex: initPage ?? 0),
//               settings: const RouteSettings(name: BottomBar.routeName),
//             ),
//             (route) => false,
//           );
//         },
//       );
//     }
//   }
// }
