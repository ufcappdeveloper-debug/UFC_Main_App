import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/utils/app_file_picker.dart';
import 'package:ufc_mobile/screens/pet_veterinary/widgets/chat_upload_file_card.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/chat/chat_action_small_button.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/chat/chat_text_field_2.dart';

class ChatBottomCard2 extends StatefulWidget {
  const ChatBottomCard2({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onMediaSend,
    required this.scrollController,
    required this.selectedFile,
    required this.isUploading,
    required this.recorderController,
  });

  final TextEditingController controller;
  final RecorderController recorderController;
  final ScrollController scrollController;
  final Function(String message) onSend;
  final Function(List<File> files) onMediaSend;
  final ValueNotifier<File?> selectedFile;
  final bool isUploading;

  @override
  State<ChatBottomCard2> createState() => _ChatBottomCard2State();
}

class _ChatBottomCard2State extends State<ChatBottomCard2> {
  final FocusNode _focusNode = FocusNode();
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? filePath;
  int _recordingSeconds = 0;
  Timer? _recordingTimer;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _recorder!.openRecorder();
    _focusNode.addListener(() {
      setState(() {});
    });
    widget.controller.addListener(() {
      setState(() {
        _hasText = widget.controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _recorder?.closeRecorder();
    widget.controller.removeListener(() {});
    super.dispose();
  }

  Future<void> _handleVoiceRecord() async {
    var status = await Permission.microphone.request();

    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Microphone permission is required")),
      );
      return;
    }

    if (_isRecording) {
      final path = await _recorder!.stopRecorder();
      _recordingTimer?.cancel();

      setState(() {
        _isRecording = false;
        _recordingSeconds = 0;
      });

      if (path != null) {
        widget.onMediaSend([File(path)]); // ✅ changed here
      }
    } else {
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.aac';

      await _recorder!.startRecorder(toFile: path);

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          _recordingSeconds++;
        });
      });

      setState(() {
        _isRecording = true;
        filePath = path;
      });
    }
  }

  final GlobalKey _buttonKey = GlobalKey();

  void _pickFileOnly(BuildContext context) {
    try {
      ChatFilePicker.showFilePickerFromButton(
        context,
        _buttonKey,
        showCamera: false,
        allowMultiple: false,
        focusNode: _focusNode,
        onFilesPicked: (files) {
          if (files.isNotEmpty) {
            widget.selectedFile.value = files.first;
          }
        },
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(getFilePickError(context))),
        );
      }
    }
  }

  void _sendMessage(BuildContext context) {
    final message = widget.controller.text.trim();
    final file = widget.selectedFile.value;

    if (message.isEmpty && file == null) {
      _focusNode.unfocus();
      return;
    }

    if (file != null) {
      widget.onMediaSend([file]);
      widget.selectedFile.value = null;
    }

    if (message.isNotEmpty) {
      widget.onSend(message);
      widget.controller.clear();
    }

    _focusNode.requestFocus();

    widget.scrollController.animateTo(
      widget.scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _cancelVoiceRecording() async {
    if (_isRecording) {
      try {
        await _recorder?.stopRecorder();
      } catch (e) {
        debugPrint('Error stopping recorder: $e');
      }
      _recordingTimer?.cancel();
      _recordingTimer = null;
    }

    setState(() {
      _isRecording = false;
      _recordingSeconds = 0;
      filePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final file = widget.selectedFile.value;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      ValueListenableBuilder<File?>(
        valueListenable: widget.selectedFile,
        builder: (_, file, __) {
          if (file == null) return const SizedBox();
          return ChatUploadedFileCard(selectedFile: widget.selectedFile);
        },
      ),
      AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ));

            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: _isRecording
              ? Container(
                  key: const ValueKey('recording'),
                  height: 88,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.9),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(18)),
                    boxShadow: [
                      BoxShadow(
                        color: PetVeterinaryColors.borderLeftColor2
                            .withOpacity(0.1),
                        blurRadius: 16,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: PetVeterinaryColors.borderLeftColor,
                          boxShadow: [
                            BoxShadow(
                              color: PetVeterinaryColors
                                  .newPetMainColorVeterinary
                                  .withOpacity(0.3),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.mic, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Recording...",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _formatDuration(_recordingSeconds),
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.semiTransparentBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ChatActionSmallButton(
                        icon: "assets/images/cart/delete.png",
                        borderRadius: BorderRadius.circular(111),
                        onPressed: _cancelVoiceRecording,
                      ),
                      const SizedBox(width: 14),
                      ChatActionSmallButton(
                        key: const ValueKey('send'),
                        icon: 'assets/new_design/icons/chat_send.png',
                        isLoading: widget.isUploading,
                        borderRadius: BorderRadius.circular(111),
                        onPressed: _handleVoiceRecord,
                      )
                    ],
                  ),
                )
              : Container(
                  key: const ValueKey('default'),
                  height: 88,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 80,
                        spreadRadius: -16,
                        offset: const Offset(0, -64),
                        color: AppColors.dateSelectorActiveTextColor
                            .withOpacity(0.12),
                      ),
                    ],
                  ),
                  child: Directionality(
                      textDirection: flutter.TextDirection.ltr,
                      child: Row(
                        children: [
                          ChatActionSmallButton(
                            buttonKey: _buttonKey,
                            icon: 'assets/new_design/icons/files.png',
                            borderRadius: BorderRadius.circular(111),
                            onPressed: () => _pickFileOnly(
                              context,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Directionality(
                                textDirection:
                                    Directionality.of(context), // adaptive
                                child: ChatTextField2(
                                  controller: widget.controller,
                                  focusNode: _focusNode,
                                  onEditingComplete: () =>
                                      _sendMessage(context),
                                )),
                          ),

                          const SizedBox(width: 14),
                          // ChatActionSmallButton(
                          //   icon: 'assets/new_design/icons/microphone.png',
                          //   borderRadius: BorderRadius.circular(111),
                          //   onPressed: _handleVoiceRecord,
                          // ),
                          // const SizedBox(width: 14),
                          // ChatActionSmallButton(
                          //   icon: 'assets/new_design/icons/chat_send.png',
                          //   isLoading: widget.isUploading,
                          //   borderRadius: BorderRadius.circular(111),
                          //   onPressed: () => _sendMessage(context),
                          // ),
                          ValueListenableBuilder<File?>(
                            valueListenable: widget.selectedFile,
                            builder: (context, selectedFileValue, child) {
                              final shouldShowSend = _hasText ||
                                  _focusNode.hasFocus ||
                                  selectedFileValue != null;

                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: shouldShowSend
                                    ? ChatActionSmallButton(
                                        key: const ValueKey('send'),
                                        icon:
                                            'assets/new_design/icons/chat_send.png',
                                        isLoading: widget.isUploading,
                                        borderRadius:
                                            BorderRadius.circular(111),
                                        onPressed: () => _sendMessage(context),
                                      )
                                    : ChatActionSmallButton(
                                        key: const ValueKey('mic'),
                                        icon:
                                            'assets/new_design/icons/microphone.png',
                                        borderRadius:
                                            BorderRadius.circular(111),
                                        onPressed: _handleVoiceRecord,
                                      ),
                              );
                            },
                          )
                        ],
                      )),
                ))
    ]);
  }

  String getFilePickError(BuildContext context) {
    if (isArabic) {
      return "فشل اختيار الملف. الرجاء المحاولة مرة أخرى.";
    } else if (isUrdu) {
      return "فائل منتخب کرنے میں ناکامی ہوئی۔ دوبارہ کوشش کریں۔";
    } else {
      return "Failed to pick the file. Please try again.";
    }
  }
}

String _formatDuration(int seconds) {
  final duration = Duration(seconds: seconds);
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$secs';
}
