import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/data/video_call_service.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';
import 'package:ufc_mobile/models/video/video_call.dart';
import 'package:ufc_mobile/screens/pet_veterinary/calling_screen/calling_screen.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';
import 'package:ufc_mobile/screens/pet_veterinary/pages/chat/chat_action_button.dart';
import 'package:ufc_mobile/screens/pet_veterinary/pages/schedule_page.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_model.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/call/agora_engine_singleton.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String doctorId;
  final String bookingId;
  final Doctor? doctor;
  final int userId;
  final AppointmentModel? appointment;
  final String userName;
  final bool isFromNotification;
  final TabController? tabController;

  const ChatAppBar({
    super.key,
    required this.doctorId,
    required this.bookingId,
    this.doctor,
    required this.userId,
    this.appointment,
    required this.userName,
    this.isFromNotification = false,
    this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            spreadRadius: 0,
            offset: Offset(0, 4),
            color: Colors.black.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: AppBar(
        centerTitle: true,
        toolbarHeight: 62,
        leading: InkWell(
          onTap: () {
            if (isFromNotification) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const BottomBar(initialIndex: 3),
                ),
                (route) => false,
              );

              Future.delayed(Duration(milliseconds: 300), () {
                if (!context.mounted) return;
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
          },
          child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
        ),
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        title: CustomText(
          text: doctorName(context),
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
        actions: [
          Row(
            children: [
              // ChatActionButton(
              //   icon: "assets/images/call_icon.svg",
              //   onPressed: () {},
              // ),
              // SizedBox(width: 10),
              ChatActionButton(
                icon: "assets/images/video_call_icon.svg",
                onPressed: () async {
                  final agora = AgoraEngineSingleton();

                  if (agora.remoteUid != null &&
                      doctorId != agora.remoteUid.toString()) {
                    CustomSnackBar.error(context, 'You are alreay in a call');
                    return;
                  }
                  startVideoCall(context);
                },
              ),
              kWidth10,
            ],
          ),
        ],
      ),
    );
  }

  String doctorName(BuildContext context) {
    if (isEnglish) {
      return doctor?.nameEn ?? doctor?.nameAr ?? '';
    } else {
      return doctor?.nameAr ?? doctor?.nameEn ?? '';
    }
  }

  /// Video Call started
  Future<void> startVideoCall(BuildContext context) async {
    try {
      VideoCallTokenResponse response = await VideoCallService.getToken(
        userId: userId.toString(),
        channelName: 'call_${doctorId}_$userId',
      );

      if ((response.token ?? '').isEmpty) {
        if (!context.mounted) return;
        CustomSnackBar.error(context, 'Video Call Failed');
        return;
      }

      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallingScreen(
            token: response.token ?? '',
            channelName: response.channelName ?? '',
            uid: int.tryParse(response.uId ?? '') ?? 0,
            doctor: doctor,
            appointment: appointment,
            senderID: int.tryParse(doctorId),
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.error(context,
          AppConfig.isProduction ? 'Something went wrong'.tr() : e.toString());
    }
  }

  @override
  Size get preferredSize => Size(double.infinity, 62);
}
