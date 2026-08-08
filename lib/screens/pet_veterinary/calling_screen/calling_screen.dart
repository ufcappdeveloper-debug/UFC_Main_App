import 'dart:async';
import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:draggable_widget/draggable_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/picture_in_picture.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ufc_mobile/data/notification_service.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/extensions/app_svg.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
import 'package:ufc_mobile/models/params/send_notification_param.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/screens/pet_veterinary/calling_screen/call_loading_widget.dart';
import 'package:ufc_mobile/screens/pet_veterinary/calling_screen/call_session_manager.dart';
import 'package:ufc_mobile/screens/pet_veterinary/calling_screen/dr_video_call_widget.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';
import 'package:ufc_mobile/screens/pet_veterinary/pages/chat/chat_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary/pages/doctor_rating_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary/pages/schedule_page.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_model.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/global/shared/functions/route_tracker.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/util/call/agora_engine_singleton.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

class CallingScreen extends ConsumerStatefulWidget {
  final String token;
  final String channelName;
  final int uid;
  final Doctor? doctor;
  final AppointmentModel? appointment;
  final bool fromNotification;
  final int? senderID;
  final String? doctorNameFrmNotification;
  final String? specializationFrmNotification;
  final int? doctorIdFrmNotification;
  final int? appointmentIdFrmNotification;
  const CallingScreen({
    super.key,
    required this.token,
    required this.channelName,
    required this.uid,
    this.doctor,
    this.appointment,
    this.fromNotification = false,
    required this.senderID,
    this.doctorNameFrmNotification,
    this.specializationFrmNotification,
    this.doctorIdFrmNotification,
    this.appointmentIdFrmNotification,
  });

  @override
  ConsumerState<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends ConsumerState<CallingScreen>
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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => DoctorRatingScreen(
            doctorId: widget.doctor!.id ?? 0,
            bookingId: widget.appointment!.id ?? 0,
            doctorName: getLocalizedName(context, widget.doctor!),
            specialization: getLocalizedSpecalizedName(context, widget.doctor!),
            profileImage: widget.doctor!.profileImage,
            rating: widget.doctor!.rating ?? 0.0,
          ),
        ),
        (route) => false,
      );
    } else if (widget.fromNotification) {
      if (widget.appointmentIdFrmNotification != null &&
          widget.doctorIdFrmNotification != null) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => DoctorRatingScreen(
              doctorId: widget.doctorIdFrmNotification!,
              bookingId: widget.appointmentIdFrmNotification!,
              doctorName: widget.doctorNameFrmNotification ?? '',
              specialization: widget.specializationFrmNotification ?? '',
              profileImage: null,
              rating: 0.0,
            ),
          ),
          (route) => false,
        );
      } else {
        // If no bookingId, navigate to schedule page
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const BottomBar(initialIndex: 3),
          ),
          (route) => false,
        );

        Future.delayed(Duration.zero, () {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SchedulePage(),
            ),
          );
        });
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
    final size = MediaQuery.of(context).size;
    return PopScope(
      canPop: !widget.fromNotification,
      onPopInvokedWithResult: (didPop, result) {
        onPopPressed();
      },
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Visibility(
            visible: showUser(size.width),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 48,
                        spreadRadius: 0,
                        offset: Offset(0, 2),
                        color: Colors.black.withValues(alpha: 0.08),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        onPopPressed();
                      },
                      borderRadius: BorderRadius.circular(15),
                      splashColor: Colors.grey.withValues(alpha: 0.11),
                      highlightColor: Colors.grey.withValues(alpha: 0.11),
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
                        // Remote user joined — show remote full screen
                        ? DrVideoCallWidget(
                            agora: agora,
                            widget: widget,
                            size: size,
                          )
                        // Remote user NOT joined — show local full screen
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
                    : const CallLoadingWidget(),
              ),

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: isArabic ? 0 : 12,
                      right: isArabic ? 12 : 0,
                    ),
                    child: Container(
                      width: 90.59,
                      height: 41.32,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(33),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 9.17,
                            height: 9.17,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: PetVeterinaryColors.borderLeftColor,
                            ),
                          ),
                          SizedBox(width: 9.17),
                          ValueListenableBuilder(
                            valueListenable: agora.secondsElapsed,
                            builder: (context, value, _) {
                              return Text(
                                _formatTime(value),
                                style: PetVeterinaryFontstyles
                                    .poppinsRegularTextStyle14,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8.03),
                  Padding(
                    padding: EdgeInsets.only(
                      left: isArabic ? 0 : 10,
                      right: isArabic ? 10 : 0,
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: PetVeterinaryFontstyles.poppinsRegularTextStyle14
                            .copyWith(color: Colors.white),
                        children: [
                          if (!isStringEmpty(doctorName)) ...[
                            TextSpan(text: '${'DR.'.tr()}\t'),
                            TextSpan(
                              text: (doctorName).toUpperCase(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 3.44),
                  if (!isStringEmpty(specialization))
                    Padding(
                      padding: EdgeInsets.only(
                        left: isArabic ? 0 : 10,
                        right: isArabic ? 10 : 0,
                      ),
                      child: Text(
                        specialization,
                        style: PetVeterinaryFontstyles.poppinsRegularTextStyle12
                            .copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              height: 101,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(33),
                color: showUser(size.width)
                    ? AppColors.white.withValues(alpha: 0.4)
                    : Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Chat Button
                  if (widget.senderID != null) ...{
                    _iconCard(
                      icon: AppSvgs.agoraChat,
                      onPressed: () {
                        gotoChatScreen();
                      },
                    ),
                  },

                  // End Call Button
                  _iconCard(
                    icon: AppSvgs.agoraEndCall,
                    onPressed: _endCall,
                  ),

                  // Switch Camera Button
                  _iconCard(
                    icon: AppSvgs.agoraRotate,
                    onPressed: agora.switchCamera,
                  ),
                  appBarIcon(
                    activeIcon: Icons.videocam_outlined,
                    inactiveIcon: Icons.videocam_off_outlined,
                    onPressed: () async {
                      await agora.toggleCamera();
                      setState(() {});
                    },
                    isActive: agora.cameraEnabled,
                  ),

                  appBarIcon(
                    activeIcon: Icons.mic_none_sharp,
                    inactiveIcon: Icons.mic_off_outlined,
                    onPressed: () async {
                      await agora.toggleMicrophone();
                      setState(() {});
                    },
                    isActive: agora.microphoneEnabled,
                  ),
                ],
              ),
            ),
          ],
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
          },
          child: DrVideoCallWidget(
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
          return ChatScreen(
            doctor: agora.appoinmentInfo?.doctor,
            receiverId: agora.localUid!,
            senderId: widget.senderID!,
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
          },
          child: DrVideoCallWidget(agora: agora, widget: widget),
        ),
      );
    }
    if (!mounted) return;
    if (widget.fromNotification == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const BottomBar(initialIndex: 3),
        ),
        (route) => false,
      );

      Future.delayed(Duration.zero, () {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SchedulePage(),
          ),
        );
      });
    } else {
      Navigator.pop(context);
    }
  }

  String get doctorName {
    if (widget.fromNotification) {
      return widget.doctorNameFrmNotification ?? '';
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

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  Widget _iconCard({required String icon, required VoidCallback onPressed}) {
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: SvgPicture.asset(icon, width: 14, height: 14),
          ),
        ),
      ),
    );
  }

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

  String getLocalizedName(BuildContext context, Doctor doctor) {
    final nameEn = doctor.nameEn?.trim();
    final nameAr = doctor.nameAr?.trim();

    if (isEnglish) {
      return (nameEn?.isNotEmpty ?? false)
          ? nameEn!
          : (nameAr?.isNotEmpty ?? false)
              ? nameAr!
              : '';
    } else {
      return (nameAr?.isNotEmpty ?? false)
          ? nameAr!
          : (nameEn?.isNotEmpty ?? false)
              ? nameEn!
              : '';
    }
  }

  String getLocalizedSpecalizedName(BuildContext context, Doctor doctor) {
    final specEn = doctor.specializationEn?.trim();
    final specAr = doctor.specializationAr?.trim();

    if (isEnglish) {
      return (specEn?.isNotEmpty ?? false)
          ? specEn!
          : (specAr?.isNotEmpty ?? false)
              ? specAr!
              : '';
    } else {
      return (specAr?.isNotEmpty ?? false)
          ? specAr!
          : (specEn?.isNotEmpty ?? false)
              ? specEn!
              : '';
    }
  }
}
