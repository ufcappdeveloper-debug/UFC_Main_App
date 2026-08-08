import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_review_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/provider/doctor_review_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';

class DoctorRatingScreen extends ConsumerStatefulWidget {
  final int doctorId;
  final int bookingId;
  final String doctorName;
  final String specialization;
  final String? profileImage;
  final double rating;

  const DoctorRatingScreen({
    super.key,
    required this.doctorId,
    required this.bookingId,
    required this.doctorName,
    required this.specialization,
    this.profileImage,
    this.rating = 0.0,
  });

  @override
  ConsumerState<DoctorRatingScreen> createState() => _DoctorRatingScreenState();
}

class _DoctorRatingScreenState extends ConsumerState<DoctorRatingScreen> {
  int selectedRating = 0;
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          body: SingleChildScrollView(
            padding:
                const EdgeInsets.only(left: 44, right: 44, top: 48, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Rate your experience with \nthe doctor".tr(),
                  textAlign: TextAlign.center,
                  style: PetVeterinaryFontstyles.kanitMedium23
                      .copyWith(color: PetVeterinaryColors.titleColor2),
                ),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20.5,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage:
                          (widget.profileImage?.isNotEmpty ?? false)
                              ? NetworkImage(widget.profileImage!)
                              : null,
                      child: (widget.profileImage?.isEmpty ?? true)
                          ? const Icon(Icons.person,
                              size: 20.0, color: Colors.grey)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.doctorName,
                                  style: PetVeterinaryFontstyles
                                      .poppinsMediumTextStyle15,
                                ),
                              ),
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                widget.rating.toString(),
                                style: PetVeterinaryFontstyles
                                    .poppinsRegularSmallTextStyle2
                                    .copyWith(
                                  color:
                                      PetVeterinaryColors.customMediumGrayColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.specialization,
                            style: PetVeterinaryFontstyles
                                .poppinsRegularTextStyle12
                                .copyWith(
                              color: PetVeterinaryColors.customBlackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    int starIndex = index + 1;
                    bool isSelected = selectedRating >= starIndex;

                    return GestureDetector(
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
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? PetVeterinaryColors.customYellowColor
                                : PetVeterinaryColors.customBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Add Comments".tr(),
                        style: PetVeterinaryFontstyles.kanitMedium13),
                    const SizedBox(height: 6),
                    TextField(
                      controller: commentController,
                      maxLines: 8,
                      decoration: InputDecoration(
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
                const SizedBox(height: 56),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CustomButton(
                        title: "Submit",
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
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
                              CustomSnackBar.error(
                                  context, state.error.toString());
                            }
                            return;
                          }

                          if (context.mounted) {
                            CustomSnackBar.success(
                                context, "Review submitted successfully");
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const BottomBar(initialIndex: 3),
                              ),
                            );
                          }

                          debugPrint("Rating: $selectedRating");
                          debugPrint("Comment: ${commentController.text}");
                        }),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
