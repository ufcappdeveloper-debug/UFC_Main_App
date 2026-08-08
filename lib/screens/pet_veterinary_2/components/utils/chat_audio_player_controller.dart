import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class ChatAudioPlayerController {
  // static final ChatAudioPlayerController _instance =
  //     ChatAudioPlayerController._internal();
  // factory ChatAudioPlayerController() => _instance;
  // ChatAudioPlayerController._internal() {
  //   init();
  // }

  VoidCallback? onPlay;

  ChatAudioPlayerController() {
    init();
  }

  bool _isDisposed = false;
  final AudioPlayer _player = AudioPlayer();
  final ValueNotifier<bool> _isPlaying = ValueNotifier(false);
  final ValueNotifier<String?> _currentPath = ValueNotifier(null);
  final ValueNotifier<Duration> _position = ValueNotifier(Duration.zero);
  final ValueNotifier<Duration> _duration = ValueNotifier(Duration.zero);

  ValueNotifier<bool> get isPlaying => _isPlaying;
  ValueNotifier<Duration> get duration => _duration;
  ValueNotifier<Duration> get position => _position;
  ValueNotifier<String?> get currentPath => _currentPath;
  bool get hasCompleted => _player.processingState == ProcessingState.completed;

  void init() {
    _isDisposed = false;

    _player.positionStream.listen((pos) => _position.value = pos);

    _player.durationStream.listen((dur) {
      _duration.value = dur ?? Duration.zero;
    });

    _player.playerStateStream.listen((state) {
      _isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        _isPlaying.value = false;
        _position.value = Duration.zero;
      }
    });
  }

  Future<void> play(
    String path, {
    bool isFile = false,
    VoidCallback? onStop,
  }) async {
    final isSamePath = _currentPath.value == path;
    if (!isSamePath) {
      await _player.stop();
      if (isFile) {
        await _player.setFilePath(path);
      } else {
        await _player.setUrl(path);
      }
      _currentPath.value = path;
    } else {
      final state = _player.playerState;
      if (state.processingState == ProcessingState.completed) {
        // Audio finished, restart from beginning
        await _player.seek(Duration.zero);
      }
    }

    onPlay?.call();
    await _player.play();
    _isPlaying.value = true;
  }

  void pause() async {
    await _player.pause();
    _isPlaying.value = false;
  }

  void seek(Duration position) {
    _player.seek(position);
  }

  Future<void> stop() async {
    await _player.stop();
    _isPlaying.value = false;
    _currentPath.value = null;
    _position.value = Duration.zero;
    _duration.value = Duration.zero;
  }

  void dispose() {
    if (_isDisposed) return;

    _player.stop();
    // _player.dispose();

    _isPlaying.value = false;
    _currentPath.value = null;
    _position.value = Duration.zero;
    _duration.value = Duration.zero;

    _isDisposed = true;
  }
}
