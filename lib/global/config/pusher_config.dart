import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherConfig {
  late PusherChannelsFlutter _pusher;

  String PUSHER_ID = '2030775';
  String PUSHER_KEY = '1ca8f11096af5280e735';
  String PUSHER_SECRET = '2b3a0affcc44eeed9754';
  String PUSHER_API_CLUSTER = 'ap2';

  void onError(String message, int? code, dynamic e) {
    debugPrint("onError: $message code: $code exception: $e");
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    debugPrint("onSubscriptionSucceeded: $channelName data: $data");
    final me = _pusher.getChannel(channelName)?.me;
    debugPrint("SubscriptionSucceeded Me: $me");
  }

  void onSubscriptionError(String message, dynamic e) {
    debugPrint("onSubscriptionError: $message Exception: $e");
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    debugPrint("Connection: $currentState");
  }

  Future<void> initPusher(Function(PusherEvent) onEvent, int roomId) async {
    _pusher = PusherChannelsFlutter.getInstance();

    try {
      if (_pusher.connectionState != "CONNECTED") {
        await _pusher.init(
          apiKey: PUSHER_KEY,
          cluster: PUSHER_API_CLUSTER,
          onConnectionStateChange: onConnectionStateChange,
          onError: onError,
          onSubscriptionSucceeded: onSubscriptionSucceeded,
          onEvent: onEvent,
          onSubscriptionError: onSubscriptionError,
        );
        await _pusher.subscribe(channelName: 'channel.$roomId');
        await _pusher.connect();
      }
    } catch (e) {
      debugPrint("ERROR in initailalization -- $e");
    }
  }

  void disConnect() {
    _pusher.disconnect();
  }
}
