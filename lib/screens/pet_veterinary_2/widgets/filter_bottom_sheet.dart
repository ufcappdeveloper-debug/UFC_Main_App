import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/provider/doctor_service_provider.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';

class FilterBottomSheet {
  static Future<Map<String, String?>?> show(BuildContext context, WidgetRef ref,
      {String? currentRankOrder, String? currentAvailability}) {
    String? ratingSort;
    if (currentRankOrder == "desc") {
      ratingSort = "Highest to Lowest";
    } else if (currentRankOrder == "asc") {
      ratingSort = "Lowest to Highest";
    }

    String? availability;
    if (currentAvailability == "available") {
      availability = "Available";
    } else if (currentAvailability == "unavailable") {
      availability = "Unavailable";
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      "Filter".tr(),
                      style: PetVeterinaryFontstyles2.getSuperBoldStyle(
                          context, 15),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Sort by rating".tr(),
                    style: PetVeterinaryFontstyles2.getRegularStyle(context, 14)
                        .copyWith(color: PetVeterinaryColors.newPetDarkGray),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _FilterChip(
                        label: "Highest to Lowest",
                        selected: ratingSort == "Highest to Lowest",
                        onSelected: () {
                          setState(() => ratingSort = "Highest to Lowest");
                        },
                      ),
                      kWidth15,
                      _FilterChip(
                        label: "Lowest to Highest",
                        selected: ratingSort == "Lowest to Highest",
                        onSelected: () {
                          setState(() => ratingSort = "Lowest to Highest");
                        },
                      ),
                    ],
                  ),

                  const Divider(height: 40),

                  Text(
                    "Sort by availability".tr(),
                    style: PetVeterinaryFontstyles2.getRegularStyle(context, 14)
                        .copyWith(color: PetVeterinaryColors.newPetDarkGray),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _FilterChip(
                        label: "Available",
                        selected: availability == "Available",
                        onSelected: () {
                          setState(() => availability = "Available");
                        },
                      ),
                      kWidth15,
                      _FilterChip(
                        label: "Unavailable",
                        selected: availability == "Unavailable",
                        onSelected: () {
                          setState(() => availability = "Unavailable");
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 42),

                  /// Apply Button
                  GestureDetector(
                    onTap: () {
                      String? rankOrder;
                      if (ratingSort == "Highest to Lowest") {
                        rankOrder = "desc";
                      } else if (ratingSort == "Lowest to Highest") {
                        rankOrder = "asc";
                      }

                      String? availabilityParam;
                      if (availability == "Available") {
                        availabilityParam = "available";
                      } else if (availability == "Unavailable") {
                        availabilityParam = "unavailable";
                      }

                      // Close bottom sheet and return filters
                      Navigator.pop(context, {
                        "rankOrder": rankOrder,
                        "availability": availabilityParam,
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      margin: const EdgeInsets.only(bottom: 16),
                      height: 54,
                      decoration: BoxDecoration(
                        color: PetVeterinaryColors.newPetMainColorVeterinary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Apply filter".tr(),
                        style: PetVeterinaryFontstyles2.getRegularStyle(
                                context, 14)
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        ratingSort = null;
                        availability = null;
                      });

                      ref
                          .read(doctorServiceProviderProvider.notifier)
                          .fetchInitialDoctors();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: PetVeterinaryColors.newPetMainColorVeterinary,
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Clear the filter".tr(),
                        style: PetVeterinaryFontstyles2.getRegularStyle(
                                context, 14)
                            .copyWith(
                          color: PetVeterinaryColors.newPetMainColorVeterinary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected
              ? PetVeterinaryColors.newPetMainColorVeterinary
              : PetVeterinaryColors.customColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label.tr(),
            style: selected
                ? PetVeterinaryFontstyles2.getMediumStyle(context, 14)
                    .copyWith(color: Colors.white)
                : PetVeterinaryFontstyles2.getRegularStyle(context, 14)
                    .copyWith(color: PetVeterinaryColors.greyColor)),
      ),
    );
  }
}
