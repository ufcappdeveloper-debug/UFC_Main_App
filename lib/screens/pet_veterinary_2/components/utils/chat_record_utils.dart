import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ufc_mobile/global/util/exception/app_exception.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class ChatRecordUtils {
  static final ChatRecordUtils _instance = ChatRecordUtils._internal();
  factory ChatRecordUtils() => _instance;
  ChatRecordUtils._internal();

  static Timer? _timer;

  static final ValueNotifier<bool> _isPaused = ValueNotifier<bool>(false);
  static final ValueNotifier<int> _recordDuration = ValueNotifier<int>(0);
  static final ValueNotifier<bool> _isRecording = ValueNotifier<bool>(false);
  static final ValueNotifier<File?> _recordedFile = ValueNotifier<File?>(null);
  static final ValueNotifier<File?> _recordedWaveFile = ValueNotifier<File?>(
    null,
  );

  // getters
  static ValueNotifier<bool> get isPaused => _isPaused;
  static ValueNotifier<bool> get isRecording => _isRecording;
  static ValueNotifier<File?> get recordedFile => _recordedFile;
  static ValueNotifier<int> get recordDuration => _recordDuration;
  static ValueNotifier<File?> get recordedWaveFile => _recordedWaveFile;

  static void dispose() {
    _timer?.cancel();
    _timer = null;

    WakelockPlus.disable();
    isPaused.value = false;
    _recordDuration.value = 0;
    _isRecording.value = false;
    _recordedFile.value = null;
    _recordedWaveFile.value = null;
  }

  static Future<void> startRecording({
    required Future<void> Function(String path, String? wavePath) startRecorder,
  }) async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw CustomException(
        message: 'Microphone permission is required to start recording.',
      );
    }

    final dir = await getTemporaryDirectory();
    _recordedFile.value = File(
      '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac',
    );
    _recordedWaveFile.value = File(
      '${dir.path}/audio_wave_${DateTime.now().millisecondsSinceEpoch}.aac',
    );

    final path = _recordedFile.value?.path;
    final wavePath = _recordedWaveFile.value?.path;

    if (path == null) {
      throw CustomException(
        message: 'Unable to create a path for the recorded audio file.',
      );
    }
    await startRecorder(path, wavePath);

    WakelockPlus.enable();
    isPaused.value = false;
    _isRecording.value = true;
    _recordDuration.value = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _recordDuration.value++;
    });
  }

  static Future<void> resumeRecording({
    required Future<void> Function() resumeRecording,
  }) async {
    await resumeRecording();

    WakelockPlus.enable();
    _isPaused.value = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _recordDuration.value++;
    });
  }

  static Future<void> pauseRecording({
    required Future<void> Function() pauseRecording,
  }) async {
    await pauseRecording();

    WakelockPlus.disable();
    _isPaused.value = true;
    _timer?.cancel();
  }

  static Future<void> stopRecording({
    required Future<void> Function() stopRecorder,
  }) async {
    await stopRecorder();

    WakelockPlus.disable();
    _recordDuration.value = 0;
    _timer?.cancel();
  }

  static Future<void> deleteRecording({
    required Future<void> Function(String path) deleteRecording,
  }) async {
    if (_recordedFile.value != null) {
      if (await _recordedFile.value?.exists() ?? false) {
        await deleteRecording(_recordedFile.value!.path);
        await _recordedFile.value?.delete();
        await _recordedWaveFile.value?.delete();

        WakelockPlus.disable();
        _recordDuration.value = 0;
        _timer?.cancel();
        _timer = null;

        _isPaused.value = false;
        _recordedFile.value = null;
        _recordedWaveFile.value = null;
      }
    }
  }
}
