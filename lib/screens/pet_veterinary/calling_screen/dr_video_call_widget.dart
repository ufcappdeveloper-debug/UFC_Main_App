import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/calling_screen/calling_screen.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/call/agora_engine_singleton.dart';

class DrVideoCallWidget extends StatefulWidget {
  const DrVideoCallWidget({
    super.key,
    required this.agora,
    required this.widget,
    this.showDeleteCallButton = false,
    this.onDeleteCall,
    this.size,
  });

  final AgoraEngineSingleton agora;
  final CallingScreen widget;
  final bool showDeleteCallButton;
  final VoidCallback? onDeleteCall;

  final Size? size;

  @override
  State<DrVideoCallWidget> createState() => _DrVideoCallWidgetState();
}

class _DrVideoCallWidgetState extends State<DrVideoCallWidget> {
  bool isCameraOff = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder(
          valueListenable: widget.agora.isDrCameraMuted,
          builder: (context, isCamerMuted, _) {
            isCameraOff = isCamerMuted;
            return isCamerMuted
                ? Container(
                    color: Colors.black87,
                    width: widget.size?.width ?? 100,
                    height: widget.size?.height ?? 150,
                    child: Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.white,
                    ),
                  )
                : SizedBox(
                    width: widget.size?.width ?? 100,
                    height: widget.size?.height ?? 150,
                    child: AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: widget.agora.engine!,
                        canvas: VideoCanvas(uid: widget.agora.remoteUid),
                        connection: RtcConnection(
                          channelId: widget.widget.channelName,
                        ),
                      ),
                    ),
                  );
          },
        ),
        Positioned(
          bottom: 160,
          right: rghtPosition,
          child: ValueListenableBuilder(
            valueListenable: widget.agora.isDrMicMuted,
            builder: (context, isMicMuted, _) {
              return Visibility(
                visible: isMicMuted,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: widget.size?.width != null &&
                          widget.size!.width > 400,
                      child: CustomText(
                        text: 'Dr. muted the call',
                        color: isCameraOff ? AppColors.white : Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.mic_off_rounded,
                      size: 20,
                      color: isCameraOff ? AppColors.white : Colors.black,
                      shadows: [
                        BoxShadow(
                          blurRadius: 11,
                          spreadRadius: 0,
                          offset: Offset(0, 2),
                          color: Colors.black.withValues(
                            alpha: 0.08,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  double get rghtPosition {
    double? width = widget.size?.width;
    if (width != null) {
      return width / 2.5;
    } else {
      return 100;
    }
  }
}
