import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/flutter_in_app_pip.dart';
import 'package:flutter_in_app_pip/picture_in_picture.dart';
import 'package:ufc_mobile/screens/pet_veterinary/calling_screen/call_session_manager.dart';
import 'package:ufc_mobile/screens/pet_veterinary/calling_screen/calling_screen.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/functions/route_tracker.dart';
import 'package:ufc_mobile/global/util/call/agora_engine_singleton.dart';

class AppLifecycleHandler extends WidgetsBindingObserver {
  void startObserving() {
    WidgetsBinding.instance.addObserver(this);
  }

  void stopObserving() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.paused:
        if (PictureInPicture.isActive) {
          final agora = AgoraEngineSingleton();
          PictureInPicture.stopPiP();
          final session = CallSessionManager();
          if (!agora.isJoined || !session.isSessionAvailable) return;

          if (RouteTracker.currentRoute != '/calling') {
            Constants.navigatorKey.currentState?.push(
              MaterialPageRoute(
                settings: const RouteSettings(name: '/calling'),
                builder: (_) => CallingScreen(
                  token: session.token!,
                  channelName: session.channelName!,
                  uid: session.uid!,
                  doctor: session.doctor,
                  appointment: session.appointment,
                  senderID: session.senderID!,
                ),
              ),
            );
          }
        }
        break;
      case AppLifecycleState.inactive:
        if (PictureInPicture.isActive) {
          final agora = AgoraEngineSingleton();
          PictureInPicture.stopPiP();
          final session = CallSessionManager();
          if (!agora.isJoined || !session.isSessionAvailable) return;

          if (RouteTracker.currentRoute != '/calling') {
            Constants.navigatorKey.currentState?.push(
              MaterialPageRoute(
                settings: const RouteSettings(name: '/calling'),
                builder: (_) => CallingScreen(
                  token: session.token!,
                  channelName: session.channelName!,
                  uid: session.uid!,
                  doctor: session.doctor,
                  appointment: session.appointment,
                  senderID: session.senderID!,
                ),
              ),
            );
          }
        }
        break;
      default:
        break;
    }
  }
}
