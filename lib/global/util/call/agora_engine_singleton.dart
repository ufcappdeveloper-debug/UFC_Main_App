import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_in_app_pip/picture_in_picture.dart';
import 'package:ufc_mobile/global/config/agora_config.dart';
import 'package:ufc_mobile/global/util/common/pip_utils.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';

class AgoraEngineSingleton {
  static final AgoraEngineSingleton _instance =
      AgoraEngineSingleton._internal();

  factory AgoraEngineSingleton() => _instance;

  AgoraEngineSingleton._internal();

  /// variables
  RtcEngine? _engine;
  RtcEngineEventHandler? rtcEngineEventHandler;
  AppointmentModel? appoinmentDetials;

  bool _joined = false;
  bool _isInitialized = false;
  bool _cameraEnabled = true;
  bool _microphoneEnabled = true;

  final ValueNotifier<bool> _isDrMicMuted = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isDrCameraMuted = ValueNotifier<bool>(false);
  int? _remoteUid;
  int? _localUid;

  String? channelNames;

  final ValueNotifier<int> _secondsElapsed = ValueNotifier<int>(0);

  Timer? _timer;
  static final String _appId = AgoraConfig.appId;

  /// Getters
  RtcEngine? get engine => _engine;
  bool get isJoined => _joined;
  int? get localUid => _localUid;
  int? get remoteUid => _remoteUid;
  ValueNotifier<int> get secondsElapsed => _secondsElapsed;
  bool get cameraEnabled => _cameraEnabled;
  bool get microphoneEnabled => _microphoneEnabled;
  bool get isInitialized => _isInitialized;
  bool get isCallOngoing => _remoteUid != null;
  bool get isCallEnded => _remoteUid == null;
  ValueNotifier<bool> get isDrMicMuted => _isDrMicMuted;
  ValueNotifier<bool> get isDrCameraMuted => _isDrCameraMuted;
  AppointmentModel? get appoinmentInfo => appoinmentDetials;

  /// Initialize the engine
  Future<void> initialize({
    required int uid,
    required String token,
    required String channelName,
    required void Function() updateState,
    required void Function() onUserOffline,
    required AppointmentModel? appoinmentInfo,
  }) async {
    if (_isInitialized) {
      _engine?.registerEventHandler(rtcEngineEventHandler!);
      return;
    }

    _engine = createAgoraRtcEngine();

    if (_engine != null) {
      channelNames = channelName;
      appoinmentDetials = appoinmentInfo;
      await _engine?.initialize(
        RtcEngineContext(
          appId: _appId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );
    }

    rtcEngineEventHandler = RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) async {
        _joined = true;
        _localUid = connection.localUid;
        if (!isInitialized) {
          _startCallTimer(); // Set call start time
        }

        updateState();
      },
      onUserJoined:
          (RtcConnection connection, int remoteUid, int elapsed) async {
        _isInitialized = true;
        _remoteUid = remoteUid;
        await PiPHelper.setCallActive(true);
        updateState();
      },
      onUserOffline: (
        RtcConnection connection,
        int remoteUid,
        UserOfflineReasonType reason,
      ) async {
        _remoteUid = null;
        await PiPHelper.setCallActive(false);
        dispose();
        // updateState();
        onUserOffline();
      },
      onUserMuteAudio: (connection, remoteUid, enabled) {
        _isDrMicMuted.value = enabled;
      },
      onUserMuteVideo: (connection, remoteUid, muted) {
        _isDrCameraMuted.value = muted;
      },
    );
    if (rtcEngineEventHandler != null) {
      _engine?.registerEventHandler(rtcEngineEventHandler!);
    }
    await _engine?.enableVideo();
    await _engine?.startPreview();

    await joinChannel(
      token: token,
      channelName: channelName,
      uid: uid,
    );
  }

  /// Join a channel
  Future<void> joinChannel({
    required String token,
    required String channelName,
    required int uid,
  }) async {
    await _engine?.joinChannel(
      token: token,
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  // Leave channel
  Future<void> leaveChannel() async {
    await _engine?.leaveChannel();

    _stopCallTimer();
  }

  // Dispose engine manually (only when you're done with everything)
  Future<void> dispose() async {
    if (PictureInPicture.isActive) {
      PictureInPicture.stopPiP();
    }
    await PiPHelper.setCallActive(false);
    _joined = false;
    _localUid = null;
    _stopCallTimer();
    _remoteUid = null;
    _isInitialized = false;
    _cameraEnabled = true;
    _microphoneEnabled = true;
    channelNames = null;
    _secondsElapsed.value = 0;
    appoinmentDetials = null;

    if (rtcEngineEventHandler != null) {
      _engine?.unregisterEventHandler(rtcEngineEventHandler!);
      rtcEngineEventHandler = null;
    }

    await _engine?.leaveChannel();
    await _engine?.release();
  }

  void _startCallTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsElapsed.value++;
    });
  }

  void _stopCallTimer() {
    _timer?.cancel();
    _timer = null;
    _secondsElapsed.value = 0;
  }

  Future<void> toggleCamera() async {
    _cameraEnabled = !_cameraEnabled;
    await engine?.muteLocalVideoStream(!_cameraEnabled);
  }

  Future<void> toggleMicrophone() async {
    _microphoneEnabled = !_microphoneEnabled;
    await engine?.muteLocalAudioStream(!_microphoneEnabled);
  }

  Future<void> switchCamera() async {
    await engine?.switchCamera();
  }
}
