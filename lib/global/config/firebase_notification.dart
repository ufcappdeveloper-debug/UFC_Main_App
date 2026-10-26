import 'dart:convert';
import 'dart:io';

import 'package:corextra/corextra.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ufc_mobile/data/video_call_service.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/models/video/video_call.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/calling_screen_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/chat/chat_screen_2.dart';

import '../shared/constants/app_colors.dart';
import 'dio.dart';

class FirebaseNotification {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  bool _notificationTapHandled = false;

  // Future<void> initMessaging() async {
  //   NotificationSettings settings = await messaging.requestPermission();
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     // for foreground
  //     await messaging.setForegroundNotificationPresentationOptions(
  //       alert: true,
  //       badge: true,
  //       sound: true,
  //     );

  //     String? token;
  //     try {
  //       token = await messaging.getToken();
  //       debugPrint('registerFCM $token');
  //       await registerFCM(token); // register fcm token
  //     } catch (e) {
  //       debugPrint('error getting token $e');
  //     }
  //     configureLocalNotifications();

  //     // Foreground messages
  //     FirebaseMessaging.onMessage.listen(_showNotification);

  //     // Background (tapped)
  //     FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  //     // if (!_initialMessageHandled) {
  //     RemoteMessage? initialMessage =
  //         await FirebaseMessaging.instance.getInitialMessage();
  //     if (initialMessage != null) {
  //       _handleNotificationTap(initialMessage);
  //     }
  //     //   _initialMessageHandled = true;
  //     // }
  //   }
  // }
  Future<bool> initMessaging() async {
    try {
      NotificationSettings settings = await messaging.requestPermission();

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        debugPrint('❌ Notifications not authorized');
        return false;
      }

      // Enable foreground presentation
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      try {
        String? token = await messaging.getToken();
        debugPrint('registerFCM $token');
        if (token != null) {
          await registerFCM(token);
        }
      } catch (e) {
        debugPrint('❌ Error getting token: $e');
        return false;
      }

      configureLocalNotifications();

      // Listen for foreground messages
      FirebaseMessaging.onMessage.listen(_showNotification);

      // Listen for notification taps when app is backgrounded
      // FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        // if (!_notificationTapHandled) {
        _notificationTapHandled = true;
        _handleNotificationTap(message);
        // }
      });

      // Handle terminated case
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null && !_notificationTapHandled) {
        _notificationTapHandled = true;
        _handleNotificationTap(initialMessage);
        return true;
      }

      return false; // No notification tap occurred
    } catch (e) {
      debugPrint('⚠️ Error in initMessaging: $e');
      return false;
    }
  }

  void configureLocalNotifications() async {
    const androidSetting = AndroidInitializationSettings('@drawable/notif_icon');
    const iosSetting = DarwinInitializationSettings();

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: androidSetting,
        iOS: iosSetting,
      ),
      onDidReceiveNotificationResponse: (response) {
        onTapOfNotification(response);
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            color: primaryColor,
          ),
        ),
        payload: json.encode(message.data),
      );
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    final payload = json.encode(message.data);
    onTapOfNotification(NotificationResponse(
      payload: payload,
      notificationResponseType: NotificationResponseType.selectedNotification,
    ));
  }

  void onTapOfNotification(NotificationResponse response) async {
    final data = json.decode(response.payload ?? '');
    debugPrint('🔔 Notification Payload: ${response.payload}');

    if (data != null) {
      final context = Constants.navigatorKey.currentContext;
      final isCall = data['is_call']?.toString().toTryBool();

      if (isCall == true) {
        final senderId = data['doctor_id']?.toString().toTryInt();
        final receiverId = data['patient_id']?.toString().toTryInt();
        final appointmentId = data['booking_id']?.toString().toTryInt();

        final profileImage = data['profile_image']?.toString();
        final nameEn = data['name_en']?.toString();
        final nameAr = data['name_ar']?.toString();
        final specializationEn = data['specialization_en']?.toString();
        final specializationAr = data['specialization_ar']?.toString();
        final rating = data['total_reviews']?.toString();

        if (context != null && senderId != null && receiverId != null) {
          // final cameraStatus = await Permission.camera.request();
          // final micStatus = await Permission.microphone.request();

          // if (!cameraStatus.isGranted || !micStatus.isGranted) {
          //   if (!context.mounted) return;
          //   CustomSnackBar.error(
          //       context, 'Camera and microphone permissions are required');
          //   return;
          // }
          try {
            VideoCallTokenResponse response = await VideoCallService.getToken(
              userId: receiverId.toString(),
              channelName: 'call_${senderId}_$receiverId',
            );

            if ((response.token ?? '').isEmpty) {
              if (!context.mounted) return;
              CustomSnackBar.error(context, 'Video Call Failed');
              return;
            }

            if (!context.mounted) return;
            final isFromNotification = true;
            debugPrint(' +++ Navigating to CallingScreen with values:');
            debugPrint(' +++ channelName: ${response.channelName}');
            debugPrint(' +++ uid: ${response.uId}');
            debugPrint(' +++ senderID: $senderId');
            debugPrint(' +++ fromNotification: $isFromNotification');
            debugPrint(' +++ doctorId: $senderId');
            debugPrint(' +++ appointmentId: $appointmentId');

            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => CallingScreen2(
            //       token: response.token ?? '',
            //       channelName: response.channelName ?? '',
            //       uid: int.tryParse(response.uId ?? '') ?? 0,
            //       senderID: senderId,
            //       fromNotification: isFromNotification,
            //       doctorNameFrmNotification: doctorName,
            //       doctorIdFrmNotification: senderId,
            //       appointmentIdFrmNotification: appointmentId,
            //       specializationFrmNotification: '',
            //     ),
            //   ),
            //   (route) => false,
            // );

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => BottomBar(),
                settings: RouteSettings(name: BottomBar.routeName),
              ),
              (route) => false,
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CallingScreen2(
                  token: response.token ?? '',
                  channelName: response.channelName ?? '',
                  uid: int.tryParse(response.uId ?? '') ?? 0,
                  senderID: senderId,
                  fromNotification: isFromNotification,
                  doctorIdFrmNotification: senderId,
                  appointmentIdFrmNotification: appointmentId,
                  doctorNameArFromNotification: nameAr,
                  doctorNameEnFromNotification: nameEn,
                  doctorSpecializationArFrmNotification: specializationAr,
                  doctorSpecializationEnFrmNotification: specializationEn,
                  doctorProfileImageFrmNotification: profileImage,
                  doctorRatingFrmNotification: rating,
                ),
              ),
            );
          } catch (e) {
            if (!context.mounted) return;
            CustomSnackBar.error(
                context,
                AppConfig.isProduction
                    ? 'Something went wrong'.tr()
                    : e.toString());
          }
        }
      }
      if (data['isDoctor'] == 'true') {
        int? senderId = int.tryParse(data['sender_id']);
        int? receiverId = int.tryParse(data['receiver_id']);

        if (context != null && senderId != null && receiverId != null) {
          final isFromNotification = true;

          // await Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ChatScreen2(
          //       appointment: null,
          //       doctor: null,
          //       roomId: 'room_${senderId}_$receiverId',
          //       senderId: senderId,
          //       receiverId: receiverId,
          //       bookingId: '',
          //       userId: receiverId,
          //       isFromNotification: isFromNotification,
          //     ),
          //   ),
          //   (route) => false,
          // );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => BottomBar(),
              settings: RouteSettings(name: BottomBar.routeName),
            ),
            (route) => false,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen2(
                appointment: null,
                doctor: null,
                roomId: 'room_${senderId}_$receiverId',
                senderId: senderId,
                receiverId: receiverId,
                bookingId: '',
                userId: receiverId,
                isFromNotification: isFromNotification,
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> registerFCM(String? fcmToken) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appVersion = packageInfo.version;
      // String deviceModel = '';
      String deviceOSName = '';
      String deviceOSVersion = '';
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        deviceOSVersion = androidInfo.version.release;
        // deviceModel = '${androidInfo.manufacturer} ${androidInfo.model}';
        deviceOSName = 'Android';
      }
      if (Platform.isIOS) {
        final iosInfo = await DeviceInfoPlugin().iosInfo;
        deviceOSVersion = iosInfo.systemVersion;
        // deviceModel = iosInfo.name!;
        deviceOSName = 'iOS';
      }
      var data = {
        'os': deviceOSName,
        'os_version': deviceOSVersion,
        'os_type': deviceOSName,
        'app_version': appVersion,
        'fcm': fcmToken,
      };

      Response response =
          await api.post('api/ufc/v1/update_metadata', data: data);
      debugPrint('sys in ${response.data}');
      // debugPrint('sys in $data');
    } on DioException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> removeToken() async {
    try {
      await messaging.deleteToken();
      debugPrint("fcm token removed");
    } catch (e) {
      debugPrint("Error removing token: $e");
    }
  }
}
