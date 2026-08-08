import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/data/video_call_service.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/util/call/agora_engine_singleton.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';
import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/utils/doctor_utils.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/calling_screen_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/pet_vet_bottom_bar.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/chat/chat_action_circle_button.dart';

class ChatAppBar2 extends ConsumerWidget implements PreferredSizeWidget {
  final String doctorId;
  final String bookingId;
  final Doctor? doctor;
  final int userId;
  final AppointmentModel? appointment;
  final String userName;
  final bool isPast;
  final bool isFromNotification;
  final bool isFromCallingScreen;
  final String? doctorImage;
  final String? doctorName;
  final String? doctorNameAr;
  final String? specializationEn;
  final String? specializationAr;

  const ChatAppBar2({
    super.key,
    required this.doctorId,
    required this.bookingId,
    this.doctor,
    required this.userId,
    this.appointment,
    required this.userName,
    this.isPast = false,
    this.isFromNotification = false,
    this.isFromCallingScreen = false,
    this.doctorImage,
    this.doctorName,
    this.doctorNameAr,
    this.specializationEn,
    this.specializationAr,
  });

  @override
  Size get preferredSize => const Size.fromHeight(220);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
              child: Row(
                textDirection: flutter.TextDirection.ltr,
                children: [
                  InkWell(
                    onTap: () {
                      if (isFromNotification || isFromCallingScreen) {
                        context.read<SelectedAppbarItemCubit>().setIndex(1);
                        ref.read(petVetTabIndexProvider.notifier).state = 1;

                        if (!context.mounted) return;

                        Navigator.of(context).pushAndRemoveUntil(
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                const BottomBar(initialIndex: 1),
                            transitionsBuilder: (_, animation, __, child) {
                              return FadeTransition(
                                  opacity: animation, child: child);
                            },
                            transitionDuration:
                                const Duration(milliseconds: 250),
                          ),
                          (route) => false,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Directionality(
                        textDirection: flutter.TextDirection.ltr,
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.black,
                          size: 16,
                        )),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: PetVeterinaryColors.newPetMainColorVeterinary,
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Center(
                      child: (doctor?.profileImage != null &&
                              doctor!.profileImage!.isNotEmpty)
                          ? Image.network(
                              doctor!.profileImage!,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                if (doctorImage != null &&
                                    doctorImage!.isNotEmpty) {
                                  return Image.network(
                                    doctorImage!,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) {
                                      return Image.asset(
                                        'assets/new_design/icons/chat_user.png',
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  );
                                }
                                return Image.asset(
                                  'assets/new_design/icons/chat_user.png',
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : (doctorImage != null && doctorImage!.isNotEmpty)
                              ? Image.network(
                                  doctorImage!,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) {
                                    return Image.asset(
                                      'assets/new_design/icons/chat_user.png',
                                      width: 24,
                                      height: 24,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/new_design/icons/chat_user.png',
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (isEnglish ? doctorName : doctorNameAr) ??
                        DoctorUtils.doctorName(doctor),
                    style: PetVeterinaryFontstyles2.getMediumStyle(context, 16),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (isEnglish ? specializationEn : specializationAr) ??
                            DoctorUtils.doctorSpecialization(doctor),
                        style: PetVeterinaryFontstyles2.getRegularStyle(
                                context, 10)
                            .copyWith(
                          color: PetVeterinaryColors.customBlackColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.star,
                          color: PetVeterinaryColors.softYellow, size: 14),
                      const SizedBox(width: 1.5),
                      Text(
                        (doctor?.rating ?? 0.0).toStringAsFixed(1),
                        style:
                            PetVeterinaryFontstyles2.getRegularStyle(context, 9)
                                .copyWith(
                          color: PetVeterinaryColors.newPetDarkGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (!isPast)
                    ChatActionCircleButton(
                      icon: "assets/new_design/icons/video.png",
                      onPressed: () async {
                        final agora = AgoraEngineSingleton();

                        if (agora.remoteUid != null &&
                            doctorId != agora.remoteUid.toString()) {
                          CustomSnackBar.error(
                              context, 'You are already in a call');
                          return;
                        }
                        await VideoCallHelper.startVideoCall(
                          context: context,
                          doctorId: doctorId,
                          userId: userId.toString(),
                          doctor: appointment?.doctor,
                          appointment: appointment,
                        );
                      },
                    ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoCallHelper {
  static Future<void> startVideoCall({
    required BuildContext context,
    required String doctorId,
    required String userId,
    required dynamic doctor,
    required dynamic appointment,
    bool isFromDoctorCard = false,
  }) async {
    try {
      final response = await VideoCallService.getToken(
        userId: userId,
        channelName: 'call_${doctorId}_$userId',
      );

      if ((response.token ?? '').isEmpty) {
        if (!context.mounted) return;
        CustomSnackBar.error(context, 'Video Call Failed');
        return;
      }

      if (!context.mounted) return;

      final callingScreen = CallingScreen2(
        token: response.token ?? '',
        channelName: response.channelName ?? '',
        uid: int.tryParse(response.uId ?? '') ?? 0,
        doctor: doctor,
        appointment: appointment,
        senderID: int.tryParse(doctorId),
      );

      if (isFromDoctorCard) {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => callingScreen),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => callingScreen),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.error(
        context,
        AppConfig.isProduction ? 'Something went wrong'.tr() : e.toString(),
      );
    }
  }
}
