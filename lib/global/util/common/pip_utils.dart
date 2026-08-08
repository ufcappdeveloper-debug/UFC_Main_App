import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class PiPHelper {
  static const _channelAndroid = MethodChannel('com.ufc.pip');
  static const MethodChannel _channelIos = MethodChannel('agora_pip');
  static Future<void> setCallActive(bool isActive) async {
    try {
      if (Platform.isIOS) {
        await _channelIos.invokeMethod('startPiP');
      } else if (Platform.isAndroid) {
        await _channelAndroid.invokeMethod('updateCallState', isActive);
      }
    } catch (e) {
      debugPrint("Failed to update call state: $e");
    }
  }

  static Future<void> enterPiPIfCallActive() async {
    try {
      if (Platform.isIOS) {
        await _channelIos.invokeMethod('stopPiP');
      } else if (Platform.isAndroid) {
        await _channelAndroid.invokeMethod('enterPiPIfCallActive');
      }
    } catch (e) {
      debugPrint("Failed to enter PiP: $e");
    }
  }
}
