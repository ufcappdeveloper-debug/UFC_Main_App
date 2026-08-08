import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';

class CustomCamera extends StatefulWidget {
  const CustomCamera({super.key});

  @override
  State<CustomCamera> createState() => _CustomCameraState();
}

class _CustomCameraState extends State<CustomCamera> {
  bool _hasCaptured = false;
  final ValueNotifier<bool> _isCameraVisible = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _isCameraVisible.dispose(); // Dispose the ValueNotifier
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: _isCameraVisible,
        builder: (context, value, _) {
          return Visibility(
            visible: value,
            child: CameraAwesomeBuilder.awesome(
              saveConfig: SaveConfig.photo(),
              previewFit: CameraPreviewFit.contain,
              sensorConfig: SensorConfig.single(
                // flashMode: FlashMode.auto,
                aspectRatio: CameraAspectRatios.ratio_1_1,
                sensor: Sensor.position(SensorPosition.back),
              ),
              onMediaCaptureEvent: (mediaCapture) async {
                if (_hasCaptured) return; // Prevent multiple triggers
                if (mediaCapture.status == MediaCaptureStatus.success &&
                    mediaCapture.captureRequest is SingleCaptureRequest) {
                  final single =
                      mediaCapture.captureRequest as SingleCaptureRequest;
                  final filePath = single.file?.path;

                  if (filePath != null && filePath.isNotEmpty) {
                    final file = File(filePath);
                    if (await file.exists()) {
                      _hasCaptured = true;

                      if (!context.mounted) return;
                      Navigator.pop(context, file);
                    }
                  }
                }
              },
              topActionsBuilder: (state) => AwesomeTopActions(
                padding: EdgeInsets.zero,
                state: state,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(11),
                    child: AwesomeFlashButton(state: state),
                  ),
                ],
              ),
              middleContentBuilder: (state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Builder(
                      builder: (context) {
                        return AwesomeZoomSelector(state: state);
                      },
                    ),
                  ],
                );
              },
              bottomActionsBuilder: (state) {
                return AwesomeBottomActions(
                  state: state,
                  left: AwesomeCameraSwitchButton(
                    state: state,
                    scale: 1.0,
                    onSwitchTap: (state) {
                      state.switchCameraSensor(
                        aspectRatio: state.sensorConfig.aspectRatio,
                      );
                    },
                  ),
                  right: SizedBox.shrink(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
