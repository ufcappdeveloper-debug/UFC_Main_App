import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/utils/truncate_strings.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/pet_vet_bottom_bar.dart';

class BookingSuccessPage extends ConsumerWidget {
  final String doctorName;
  final String specialization;
  final String doctorImage;
  final String dateTime;
  final bool isFromReschedule;

  const BookingSuccessPage({
    super.key,
    required this.doctorName,
    required this.specialization,
    required this.doctorImage,
    required this.dateTime,
    this.isFromReschedule = false,
  });

  String formatDateTime(String utcString) {
    try {
      final utcDate = DateTime.parse(utcString);
      final localDate = utcDate.toLocal();

      final locale = isEnglish ? 'en' : 'ar';
      final date = DateFormat.yMMMMd(locale).format(localDate);
      final time = DateFormat.jm(locale).format(localDate);

      return "$date / $time";
    } catch (e) {
      return utcString;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Lottie.asset(
                    'assets/new_design/animations/celebrate.json',
                    width: 260,
                    height: 260,
                    fit: BoxFit.contain,
                    repeat: false,
                  ),
                  Container(
                    width: 85,
                    height: 85,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/new_design/images/booking_success.png',
                        width: 82.5,
                        height: 82.5,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    isFromReschedule
                        ? "Your reservation has been rescheduled successfully"
                            .tr()
                        : "Your reservation has been confirmed successfully"
                            .tr(),
                    style: PetVeterinaryFontstyles2.getMediumStyle(context, 24),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "The doctor will contact you at the appointed time.".tr(),
                    style: PetVeterinaryFontstyles2.getLightStyle(context, 15)
                        .copyWith(color: PetVeterinaryColors.darkGray),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _BookingCard(
                name: doctorName,
                specialization: specialization,
                dateTime: formatDateTime(dateTime),
                imageUrl: doctorImage,
              ),
            ),
            const SizedBox(height: 36),
            _ActionButton(
              label: "Reservations".tr(),
              onTap: () {
                context.read<SelectedAppbarItemCubit>().setIndex(1);
                ref.read(petVetTabIndexProvider.notifier).state = 2;

                Navigator.of(context).pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        const BottomBar(initialIndex: 1),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 250),
                  ),
                  (route) => false,
                );
              },
            ),
            SizedBox(height: 10),
            _ActionButton(
              isOutlined: true,
              label: "Home".tr(),
              onTap: () {
                context.read<SelectedAppbarItemCubit>().setIndex(1);
                ref.read(petVetTabIndexProvider.notifier).state = 0;
                Navigator.of(context).pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        const BottomBar(initialIndex: 1),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 250),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        )),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final String name;
  final String specialization;
  final String dateTime;
  final String imageUrl;

  const _BookingCard({
    required this.name,
    required this.specialization,
    required this.dateTime,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 24, top: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 0.5,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14.5,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : const AssetImage(
                            'assets/new_design/sample/doctor_circle.png')
                        as ImageProvider,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: PetVeterinaryFontstyles2.getMediumStyle(context, 14),
                ),
              ),
              Text(
                truncateSpecialization(context, specialization),
                style: PetVeterinaryFontstyles2.getRegularStyle(context, 11),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.access_time, size: 18, color: Colors.black54),
              const SizedBox(width: 4),
              Text(
                dateTime,
                style: PetVeterinaryFontstyles2.getRegularStyle(context, 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isOutlined;

  const _ActionButton({
    required this.label,
    required this.onTap,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color mainColor = PetVeterinaryColors.newPetMainColorVeterinary;

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          margin: const EdgeInsets.only(left: 40, right: 40, bottom: 12),
          height: 54,
          decoration: BoxDecoration(
            color: isOutlined ? Colors.white : mainColor,
            border: Border.all(color: mainColor, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label.tr(),
            style: PetVeterinaryFontstyles2.getRegularStyle(context, 14)
                .copyWith(color: isOutlined ? mainColor : Colors.white),
          ),
        ),
      ),
    );
  }
}
