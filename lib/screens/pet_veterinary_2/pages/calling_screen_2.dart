import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:draggable_widget/draggable_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_in_app_pip/picture_in_picture.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ufc_mobile/data/notification_service.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/extensions/app_images.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/global/shared/functions/route_tracker.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/util/call/agora_engine_singleton.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/models/params/send_notification_param.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';
import 'package:ufc_mobile/screens/pet_veterinary/calling_screen/call_session_manager.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/chat/chat_screen_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/pet_vet_bottom_bar.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/util/call_utils.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/chat/call_loading_widget_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/chat/dr_video_call_widget_2.dart';

class CallingScreen2 extends ConsumerStatefulWidget {
  final String token;
  final String channelName;
  final int uid;
  final Doctor? doctor;
  final AppointmentModel? appointment;
  final bool fromNotification;
  final int? senderID;
  final int? doctorIdFrmNotification;
  final int? appointmentIdFrmNotification;
  final bool isFromCallingScreen;

  final String? doctorNameEnFromNotification;
  final String? doctorNameArFromNotification;
  final String? doctorProfileImageFrmNotification;
  final String? doctorSpecializationEnFrmNotification;
  final String? doctorSpecializationArFrmNotification;
  final String? doctorRatingFrmNotification;

  const CallingScreen2({
    super.key,
    required this.token,
    required this.channelName,
    required this.uid,
    this.doctor,
    this.appointment,
    this.fromNotification = false,
    this.isFromCallingScreen = false,
    required this.senderID,
    this.doctorIdFrmNotification,
    this.appointmentIdFrmNotification,
    this.doctorNameEnFromNotification,
    this.doctorNameArFromNotification,
    this.doctorProfileImageFrmNotification,
    this.doctorSpecializationEnFrmNotification,
    this.doctorSpecializationArFrmNotification,
    this.doctorRatingFrmNotification,
  });

  @override
  ConsumerState<CallingScreen2> createState() => _CallingScreen2State();
}

class _CallingScreen2State extends ConsumerState<CallingScreen2>
    with RouteAware, ScreenEngagementTracker {
  final agora = AgoraEngineSingleton();
  AppointmentModel? appointment;
  final bool _isLocal = true;
  bool _isEndingCall = false;
  @override
  void initState() {
    super.initState();
    Future(() => initAgora());
  }

  Future<void> initAgora() async {
    if (PictureInPicture.isActive) {
      PictureInPicture.stopPiP();
    }
    if (agora.remoteUid != null) {
      return;
    }

    if (widget.appointment != null) {
      appointment = widget.appointment;
    }
    CallSessionManager().setSession(
      token: widget.token,
      channelName: widget.channelName,
      uid: widget.uid,
      doctor: widget.doctor,
      appointment: widget.appointment,
      senderID: widget.senderID,
    );
    await [Permission.camera, Permission.microphone].request();
    await agora.initialize(
      uid: widget.uid,
      token: widget.token,
      channelName: widget.channelName,
      appoinmentInfo: appointment,
      updateState: () {
        setState(() {});
      },
      onUserOffline: () {
        if (mounted) {
          CustomSnackBar.success(context, "Doctor ended the call");
        }

        _endCall();
      },
    );

    Future.delayed(
      Duration(seconds: 2),
      () async {
        if (mounted) {
          final user = ref.read(authProvider).value;
          if (agora.remoteUid == null) {
            /// send notification to dr
            final param = SendNotificationParam(
              title: '📞 Incoming Patient Call',
              sendToDoctorId: int.tryParse(widget.senderID.toString())!,
              body: '${userName(user)} calling you for a  . Tap to join.',
              data: SendNotificationDataParam(
                patientName: userName(user),
                occupation: (user?.occupation ?? '').toString(),
                patientId: user?.id?.toString(),
                bookingId: appointment?.id?.toString(),
              ),
            );
            await NotificationService().sendNotificationtoDoctor(param: param);
          }
        }
      },
    );
  }

  String userName(UserModel? user) {
    return user?.name ?? user?.lastName ?? user?.middleName ?? '';
  }

  Future<void> _endCall() async {
    if (_isEndingCall) return;
    _isEndingCall = true;

    await agora.dispose();
    if (!mounted) return;

    final user = ref.read(authProvider).value;
    final param = SendNotificationParam(
      body: '',
      title: '',
      sendToDoctorId: int.tryParse(widget.senderID.toString())!,
      data: SendNotificationDataParam(
        isCallEnded: true,
        patientName: userName(user),
        occupation: user?.occupation,
        patientId: user?.id?.toString(),
        bookingId: appointment?.id?.toString(),
      ),
    );
    await NotificationService().sendNotificationtoDoctor(param: param);

    if (widget.doctor != null && widget.appointment != null) {
      if (!mounted) return;
      CallUtils.navigateToDoctorRatingScreen(context,
          doctor: widget.doctor, appointment: widget.appointment);
    } else if (widget.fromNotification) {
      if (widget.appointmentIdFrmNotification != null &&
          widget.doctorIdFrmNotification != null) {
        if (!mounted) return;
        CallUtils.navigateToDoctorRatingScreen(context,
            doctor: Doctor(
              id: widget.doctorIdFrmNotification,
              nameEn: widget.doctorNameEnFromNotification,
              specializationEn: widget.doctorSpecializationEnFrmNotification,
              specializationAr: widget.doctorSpecializationArFrmNotification,
              profileImage: widget.doctorProfileImageFrmNotification,
              nameAr: widget.doctorNameArFromNotification,
              rating: widget.doctorRatingFrmNotification != null
                  ? double.tryParse(widget.doctorRatingFrmNotification!) ?? 0.0
                  : 0.0,
            ),
            appointment:
                AppointmentModel(id: widget.appointmentIdFrmNotification));
      } else {
        // If no bookingId, navigate to schedule page
        if (!mounted) return;
        context.read<SelectedAppbarItemCubit>().setIndex(1);
        ref.read(petVetTabIndexProvider.notifier).state = 0;

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const BottomBar(initialIndex: 1)),
          (route) => false,
        );
        // Navigator.of(context)
        //     .popUntil((route) => route.settings.name == BottomBar.routeName);
      }
    } else {
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Constants.routeObserver
        .subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPopNext() {
    if (PictureInPicture.isActive) {
      PictureInPicture.stopPiP();
    }
  }

  @override
  void dispose() {
    Constants.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('📡 agora.engine: ${agora.engine}');
    debugPrint('📡 agora.isJoined: ${agora.isJoined}');
    debugPrint('📡 _isLocal: $_isLocal');
    debugPrint('📡 agora.cameraEnabled: ${agora.cameraEnabled}');
    debugPrint('📡📡 ${widget.fromNotification}');
    final size = MediaQuery.of(context).size;
    return PopScope(
      canPop: !widget.fromNotification,
      onPopInvokedWithResult: (didPop, result) {
        onPopPressed();
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        bottomNavigationBar:
            agora.isJoined ? bottomActionsWidget(context, size) : null,
        body: Container(
          color: agora.cameraEnabled
              ? Colors.transparent
              : Colors.black.withOpacity(0.8),
          child: Stack(
            children: [
              Center(
                child: agora.engine != null && agora.isJoined
                    ? agora.remoteUid != null
                        ? DrVideoCallWidget2(
                            agora: agora,
                            widget: widget,
                            size: size,
                          )
                        : agora.cameraEnabled
                            ? AgoraVideoView(
                                controller: VideoViewController(
                                  rtcEngine: agora.engine!,
                                  canvas: const VideoCanvas(uid: 0),
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 100,
                                color: Colors.white,
                              )
                    : const CallLoadingWidget2(),
              ),

              agora.isJoined
                  ? Positioned(
                      top: 64,
                      left: 24,
                      right: 24,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            !isStringEmpty(doctorName)
                                ? RichText(
                                    text: TextSpan(
                                      style: PetVeterinaryFontstyles2
                                              .getMediumStyle(context, 17)
                                          .copyWith(color: Colors.white),
                                      children: [
                                        TextSpan(text: '${'Dr.'.tr()} '),
                                        TextSpan(
                                          text: doctorName,
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(width: 10),
                            Container(
                              width: 44,
                              height: 42.5,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: 24.5,
                                  icon: Image.asset(
                                    AppImages.cameraSwitchIcon,
                                    width: 20,
                                    height: 24.5,
                                    fit: BoxFit.contain,
                                  ),
                                  onPressed: agora.switchCamera,
                                ),
                              ),
                            ),
                          ]))
                  : const SizedBox(),

              // Show draggable local video only when remote user is present
              if (agora.remoteUid != null)
                Visibility(
                  visible: showUser(size.width),
                  child: DraggableWidget(
                    topMargin: 0,
                    bottomMargin: 12,
                    horizontalSpace: 20,
                    verticalSpace: Platform.isIOS ? 151 : 111,
                    initialPosition: AnchoringPosition.topRight,
                    child: Container(
                      color: Colors.black,
                      width: 100,
                      height: 150,
                      child: agora.cameraEnabled
                          ? AgoraVideoView(
                              controller: VideoViewController(
                                rtcEngine: agora.engine!,
                                canvas: const VideoCanvas(uid: 0),
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 100,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool showUser(double width) {
    bool istrE = width > 300;
    debugPrint('Device width: $istrE');
    return istrE;
  }

  Widget bottomActionsWidget(BuildContext context, Size size) {
    return Visibility(
      visible: showUser(size.width),
      child: BottomAppBar(
        height: 233,
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.senderID != null)
                  Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: IconButton(
                          icon: Image.asset(
                            AppImages.volumeOn,
                            width: 28,
                            height: 28,
                            fit: BoxFit.contain,
                          ),
                          onPressed: () {})),
                Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: IconButton(
                      icon: agora.microphoneEnabled
                          ? Image.asset(
                              AppImages.microphoneOn,
                              width: 28,
                              height: 28,
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              AppImages.microphoneOff,
                              width: 28,
                              height: 28,
                              fit: BoxFit.contain,
                            ),
                      onPressed: () async {
                        await agora.toggleMicrophone();
                        setState(() {});
                      },
                    )),
                Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: IconButton(
                      icon: agora.cameraEnabled
                          ? Image.asset(
                              AppImages.videoOn,
                              width: 28,
                              height: 28,
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              AppImages.videoOff,
                              width: 28,
                              height: 28,
                              fit: BoxFit.contain,
                            ),
                      onPressed: () async {
                        await agora.toggleCamera();
                        setState(() {});
                      },
                    )),
                Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: IconButton(
                      icon: Image.asset(
                        AppImages.chatIcon,
                        width: 28,
                        height: 28,
                        fit: BoxFit.contain,
                      ),
                      onPressed: gotoChatScreen,
                    )),
                Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: IconButton(
                      icon: Image.asset(
                        AppImages.callEndIcon,
                        width: 28,
                        height: 28,
                        fit: BoxFit.contain,
                      ),
                      onPressed: _endCall,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void gotoChatScreen() async {
    if (agora.remoteUid != null) {
      if (PictureInPicture.isActive) {
        PictureInPicture.stopPiP();
      }
      PictureInPicture.startPiP(
        pipWidget: GestureDetector(
          onTap: () async {
            if (!agora.isJoined) return;
            if (RouteTracker.currentRoute != '/calling') {
              final session = CallSessionManager();
              Constants.navigatorKey.currentState?.push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: '/calling'),
                  builder: (_) => CallingScreen2(
                    fromNotification: widget.fromNotification,
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
          },
          child: DrVideoCallWidget2(
            agora: agora,
            widget: widget,
          ),
        ),
      );
    }
    if (!mounted) return;

    if (RouteTracker.currentRoute != '/chat') {
      showGeneralDialog(
        context: Constants.navigatorKey.currentContext!,
        barrierDismissible: false,
        barrierLabel: "Chat",
        pageBuilder: (context, anim1, anim2) {
          return ChatScreen2(
            isFromCallingScreen: true,
            doctor: agora.appoinmentInfo?.doctor,
            // receiverId: agora.localUid!,
            // senderId: widget.senderID!,
            senderId: agora.localUid!,
            receiverId: widget.senderID!,
            bookingId: (agora.appoinmentInfo?.id ?? '').toString(),
            roomId: 'room_${widget.senderID}_${agora.localUid}',
            userId: agora.localUid!,
            appointment: agora.appoinmentInfo,
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: Offset.zero)
                .animate(anim1),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ).then((value) async {
        if (PictureInPicture.isActive) {
          PictureInPicture.stopPiP();
        }
      });
    }
  }

  void onPopPressed() async {
    if (agora.remoteUid != null) {
      PictureInPicture.startPiP(
        pipWidget: GestureDetector(
          onTap: () {
            if (!agora.isJoined) return;
            if (RouteTracker.currentRoute != '/calling') {
              final session = CallSessionManager();
              Constants.navigatorKey.currentState?.push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: '/calling'),
                  builder: (_) => CallingScreen2(
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
          },
          child: DrVideoCallWidget2(agora: agora, widget: widget),
        ),
      );
    }
    if (!mounted) return;
    if (widget.fromNotification == true) {
      context.read<SelectedAppbarItemCubit>().setIndex(1);
      ref.read(petVetTabIndexProvider.notifier).state = 0;

      if (!context.mounted) return;

      // Navigator.of(context)
      //     .popUntil((route) => route.settings.name == BottomBar.routeName);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const BottomBar(initialIndex: 1)),
        (route) => false,
      );
    } else {
      Navigator.pop(context);
    }
  }

  String get doctorName {
    if (widget.fromNotification) {
      return isEnglish
          ? widget.doctorNameEnFromNotification ?? ''
          : widget.doctorNameArFromNotification ??
              widget.doctorNameEnFromNotification ??
              '';
    }

    if (isEnglish) {
      return widget.doctor?.nameEn ?? '';
    } else {
      return widget.doctor?.nameAr ?? widget.doctor?.nameEn ?? '';
    }
  }

  String get specialization {
    if (isEnglish) {
      return widget.doctor?.specializationEn ??
          widget.doctor?.specializationEn ??
          '';
    } else {
      return widget.doctor?.specializationAr ??
          widget.doctor?.specializationEn ??
          '';
    }
  }

  // String _formatTime(int seconds) {
  //   int minutes = seconds ~/ 60;
  //   int remainingSeconds = seconds % 60;
  //   return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  // }

  // Widget _iconCard({required String icon, required VoidCallback onPressed}) {
  //   return Container(
  //     width: 40,
  //     height: 40,
  //     decoration: BoxDecoration(
  //       color: AppColors.dateSelectorBgColor,
  //       borderRadius: BorderRadius.circular(7),
  //     ),
  //     child: Material(
  //       color: Colors.transparent,
  //       child: InkWell(
  //         onTap: onPressed,
  //         borderRadius: BorderRadius.circular(7),
  //         splashColor: Colors.grey.withValues(alpha: 0.11),
  //         highlightColor: Colors.grey.withValues(alpha: 0.11),
  //         child: Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  //           child: SvgPicture.asset(icon, width: 14, height: 14),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget appBarIcon({
    required IconData activeIcon,
    required IconData inactiveIcon,
    required VoidCallback onPressed,
    required bool isActive,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.dateSelectorBgColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(7),
          splashColor: Colors.grey.withValues(alpha: 0.11),
          highlightColor: Colors.grey.withValues(alpha: 0.11),
          child: Icon(
            isActive ? activeIcon : inactiveIcon,
            size: 28,
            color: Color(0xff34C759),
          ),
        ),
      ),
    );
  }
}
