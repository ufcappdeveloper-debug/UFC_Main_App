import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_review_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/provider/doctor_review_provider.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/pet_vet_bottom_bar.dart';

class DoctorRatingScreen2 extends ConsumerStatefulWidget {
  final int doctorId;
  final int bookingId;
  final String doctorName;
  final String specialization;
  final String? profileImage;
  final double rating;

  const DoctorRatingScreen2({
    super.key,
    required this.doctorId,
    required this.bookingId,
    required this.doctorName,
    required this.specialization,
    this.profileImage,
    this.rating = 0.0,
  });

  @override
  ConsumerState<DoctorRatingScreen2> createState() =>
      _DoctorRatingScreen2State();
}

class _DoctorRatingScreen2State extends ConsumerState<DoctorRatingScreen2> {
  int selectedRating = 0;
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.black, size: 18),
              onPressed: () {
                context.read<SelectedAppbarItemCubit>().setIndex(1);
                ref.read(petVetTabIndexProvider.notifier).state = 0;
                Navigator.of(context).pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        const BottomBar(initialIndex: 1),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 100),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 6, 24, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 120),
              Text("How was your experience with the doctor?".tr(),
                  textAlign: TextAlign.center,
                  style: PetVeterinaryFontstyles2.getMediumStyle(context, 22)),
              const SizedBox(height: 32),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 43,
                      backgroundImage: (widget.profileImage != null &&
                              widget.profileImage!.isNotEmpty)
                          ? NetworkImage(widget.profileImage!)
                          : const AssetImage(
                                  'assets/new_design/sample/doctor_circle.png')
                              as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      widget.doctorName,
                      style:
                          PetVeterinaryFontstyles2.getMediumStyle(context, 17),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.specialization,
                          style: PetVeterinaryFontstyles2.getRegularStyle(
                                  context, 11)
                              .copyWith(
                            color: PetVeterinaryColors.customBlackColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.rating.toStringAsFixed(1),
                          style: PetVeterinaryFontstyles2.getRegularStyle(
                                  context, 11)
                              .copyWith(
                            color: PetVeterinaryColors.newPetDarkGray,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.star,
                            color: PetVeterinaryColors.softYellow, size: 10),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: selectedRating > 0 ? 24 : 32),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  // Smooth fade + scale combo
                  return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(opacity: animation, child: child));
                },
                child: selectedRating > 0
                    ? Column(
                        key: ValueKey<int>(selectedRating),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("$selectedRating / 5",
                                  style:
                                      PetVeterinaryFontstyles2.getMediumStyle(
                                              context, 12)
                                          .copyWith(
                                              color: PetVeterinaryColors
                                                  .newPetMainColorVeterinary)),
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.star,
                                color: PetVeterinaryColors
                                    .newPetMainColorVeterinary,
                                size: 22,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),

              /// Rating stars
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center-align the stars
                children: List.generate(5, (index) {
                  int starIndex = index + 1;
                  bool isSelected = selectedRating >= starIndex;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRating = starIndex;
                        });
                      },
                      child: AnimatedScale(
                        scale: isSelected ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutBack,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          width: 35,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? PetVeterinaryColors.newPetMainColorVeterinary
                                : PetVeterinaryColors.customBackgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 23.2,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 40),

              /// Add Comments
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Add Comments".tr(),
                      style:
                          PetVeterinaryFontstyles2.getMediumStyle(context, 12)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: commentController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Write your opinion".tr(),
                      hintStyle: PetVeterinaryFontstyles2.getLightStyle(
                              context, 15)
                          .copyWith(color: PetVeterinaryColors.newPetLightGray),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: PetVeterinaryColors.customBorderColor2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: PetVeterinaryColors.customBorderColor2),
                      ),
                    ),
                  ),
                ],
              ),

              /// Submit Button
              Center(
                child: GestureDetector(
                  onTap: () async {
                    final review = DoctorReviewRequest(
                      doctorId: widget.doctorId,
                      doctorBookingId: widget.bookingId,
                      rating: selectedRating,
                      review: commentController.text.trim().isEmpty
                          ? 'No comments'
                          : commentController.text.trim(),
                    );

                    final notifier =
                        ref.read(doctorReviewProviderProvider.notifier);
                    await notifier.submitReview(review);

                    final state = ref.read(doctorReviewProviderProvider);

                    if (state.hasError) {
                      if (context.mounted) {
                        final errorMessage = state.error.toString();
                        if (errorMessage.contains('at least 1')) {
                          CustomSnackBar.error(context,
                              'Please rate the doctor before submitting');
                        } else {
                          CustomSnackBar.error(context, errorMessage);
                        }
                      }
                      return;
                    }

                    if (context.mounted) {
                      CustomSnackBar.success(
                          context, "Review submitted successfully");
                      context.read<SelectedAppbarItemCubit>().setIndex(1);
                      ref.read(petVetTabIndexProvider.notifier).state = 0;

                      Navigator.of(context).pushAndRemoveUntil(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              const BottomBar(initialIndex: 1),
                          transitionsBuilder: (_, animation, __, child) {
                            return FadeTransition(
                                opacity: animation, child: child);
                          },
                          transitionDuration: const Duration(milliseconds: 250),
                        ),
                        (route) => false,
                      );
                    }

                    debugPrint("Rating: $selectedRating");
                    debugPrint("Comment: ${commentController.text}");
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    margin: const EdgeInsets.only(bottom: 40, top: 60),
                    height: 54,
                    decoration: BoxDecoration(
                      color: PetVeterinaryColors.newPetMainColorVeterinary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text("Submit".tr(),
                        style: PetVeterinaryFontstyles2.getRegularStyle(
                                context, 15)
                            .copyWith(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
