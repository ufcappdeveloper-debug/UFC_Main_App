import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_divider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/feed/application/productList/filter_cubit.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

class FeedFilterBottomSheet extends StatefulWidget {
  const FeedFilterBottomSheet({super.key});

  @override
  State<FeedFilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FeedFilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: BlocBuilder<FilterCubit, FilterState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 24),
                      CustomText(
                          text: "Filter",
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 34,
                          width: 34,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  kHeight20,

                  // Type
                  CustomText(
                    text: "Product Type",
                    fontSize: 14,
                  ),
                  kHeight10,
                  Wrap(
                    spacing: 14,
                    children: ['Loose', 'Rolled', 'Flaked'].map((type) {
                      return ChoiceChip(
                        label: CustomText(
                          text: type,
                          fontSize: 15,
                          fontWeight: state.filterItems[0][0] == type
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                        selected: state.filterItems[0][0] == type,
                        onSelected: (_) => setState(() {
                          context
                              .read<FilterCubit>()
                              .updateFilter(0, 0, 1, 0, type);
                        }),
                        selectedColor: PetVeterinaryColors.mainColorUFC,
                        backgroundColor:
                            PetVeterinaryColors.lightGrayBackground,
                        labelStyle: TextStyle(
                            color: state.filterItems[0][0] == type
                                ? Colors.white
                                : PetVeterinaryColors.darkGrayBackground),
                      );
                    }).toList(),
                  ),

                  const CustomDivider(
                      horizontalPadding: 0,
                      thickness: 0.25,
                      color: PetVeterinaryColors.newPetLightGray),
                  SizedBox(
                    height: 6,
                  ),

                  // Kilograms
                  CustomText(
                    text: "Kilograms",
                    fontSize: 14,
                  ),
                  kHeight10,
                  Wrap(
                    spacing: 14,
                    children: ["30 kg", "40 kg", "50 kg"].map((kg) {
                      return ChoiceChip(
                        label: CustomText(
                          text: kg,
                          fontSize: 15,
                          fontWeight: state.filterItems[0][1] == kg
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                        selected: state.filterItems[0][1] == kg,
                        onSelected: (_) => setState(() {
                          context
                              .read<FilterCubit>()
                              .updateFilter(0, 1, 1, 1, kg);
                        }),
                        selectedColor: PetVeterinaryColors.mainColorUFC,
                        backgroundColor:
                            PetVeterinaryColors.lightGrayBackground,
                        labelStyle: TextStyle(
                            color: state.filterItems[0][1] == kg
                                ? Colors.white
                                : PetVeterinaryColors.darkGrayBackground),
                      );
                    }).toList(),
                  ),
                  const CustomDivider(
                      horizontalPadding: 0,
                      thickness: 0.25,
                      color: PetVeterinaryColors.newPetLightGray),

                  SizedBox(
                    height: 6,
                  ),

                  // Pricing
                  CustomText(
                    text: "Pricing",
                    fontSize: 14,
                  ),
                  kHeight12,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "0",
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: primaryColor,
                      ),
                      CustomText(
                        text: "1000",
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: primaryColor,
                      ),
                    ],
                  ),
                  kHeight2,
                  Slider(
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    value: state.filterPrice,
                    inactiveColor: PetVeterinaryColors.mainColorUFC,
                    activeColor: PetVeterinaryColors.mainColorUFC,
                    padding: ksymmetric(5, 0),
                    onChanged: (val) =>
                        context.read<FilterCubit>().updatePrice(val),
                  ),

                  const SizedBox(height: 30),

                  // Save Button
                  CustomButton(
                    fontSize: 14,
                    width: MediaQuery.sizeOf(context).width,
                    color: PetVeterinaryColors.mainColorUFC,
                    fontWeight: FontWeight.w400,
                    onTap: () {
                      List<String> size = state.filterItems[0][1].split(' ');
                      Navigator.pop(context, {
                        "type": state.filterItems[0][0],
                        "size": double.tryParse(size.firstOrNull ?? ''),
                        "price": state.filterPrice,
                      });
                    },
                    title: 'Save Filter',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
