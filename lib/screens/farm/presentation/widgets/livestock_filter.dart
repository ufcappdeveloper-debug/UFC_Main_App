import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/custome_container.dart';

import '../../../../global/extensions/app_colors.dart';
import '../../../../global/shared/constants/constants.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../../application/barn_details/barn_details_cubit.dart';
import '../../domain/entities/barn/barn_details_res_model.dart';
import '../charts/weight_chart.dart';

class LivestockFilter extends StatefulWidget {
  final String? category;
  final int? barnId;
  final bool isAllBarn;
  final List<AnimalCategory> availableFilters;

  const LivestockFilter({
    super.key,
    this.category,
    this.barnId,
    this.isAllBarn = false,
    required this.availableFilters,
  });

  @override
  State<LivestockFilter> createState() => _LivestockFilterState();
}

class _LivestockFilterState extends State<LivestockFilter> {
  final Map<String, List> animalFilterOptions = {
    "Gender": ["All", "Male", "Female"],
    "Age": [
      "Newborn",
      "1 to 3 years",
      "4 to 5 years",
    ],
  };

  @override
  void initState() {
    super.initState();
    // Add Status filter options dynamically (store full objects)
    animalFilterOptions['Status'] = widget.availableFilters;
  }

  Map<String, String> selectedOptions = {
    "Gender": 'All',
  };

  @override
  Widget build(BuildContext context) {
    var savedFilter = context.watch<BarnDetailsCubit>().filter;

    if (savedFilter.isNotEmpty) {
      // restore gender
      if (savedFilter['gender'] != null) {
        selectedOptions['Gender'] =
            (savedFilter['gender'] as String).capitalizeFirst ?? 'All';
      }

      // restore age
      if (savedFilter['age_filter'] != null) {
        selectedOptions['Age'] = savedFilter['age_filter'] == '1-3_years'
            ? '1 to 3 years'
            : savedFilter['age_filter'] == '4-5_years'
                ? '4 to 5 years'
                : savedFilter['age_filter'] == 'newborn'
                    ? 'Newborn'
                    : '';
      }

      // ✅ restore status
      for (var status in animalFilterOptions['Status'] ?? []) {
        final statusKey = (status as AnimalCategory).key;
        if (statusKey != null && savedFilter.containsKey(statusKey)) {
          selectedOptions['Status'] = statusKey; // store key
          break;
        }
      }
    } else {
      selectedOptions.clear();
      selectedOptions['Gender'] = 'All';
    }

    final data = animalFilterOptions.entries.toList();

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  kWidth10,
                  CustomText(
                    // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
                    fontFamily: isEnglish
                        ? AppFontsFamily.english
                        : AppFontsFamily.arabic,
                    text: 'Filter',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              // Clear filter
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 15),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOptions.clear();
                      selectedOptions['Gender'] = 'All';
                    });
                    context.read<BarnDetailsCubit>().filter.clear();
                  },
                  child: CustomFarmContainer(
                    child: CustomText(
                      text: "Clear Filter",
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // Filter components
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    data.length,
                    (index) {
                      return filterComponent(data[index]);
                    },
                  ),
                ),
              ),

              // Save button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    kHeight30,
                    CustomOutlinedContainer(
                      title: 'Save Filter',
                      fill: true,
                      onTap: () {
                        if (savedFilter['search'] != null) {
                          context
                              .read<BarnDetailsCubit>()
                              .filter
                              .remove('search');
                        }
                        if (widget.barnId != null) {
                          context.read<BarnDetailsCubit>().fetchBarnDetails(
                                widget.barnId!,
                                animalCategory: widget.category,
                                allBarn: widget.isAllBarn,
                              );
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              kHeight10,
            ],
          ),
        ),
      ),
    );
  }

  Column filterComponent(MapEntry<String, List> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: data.key,
          fontSize: 15,
          // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
          fontFamily:
              isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
        ),
        kHeight5,
        Wrap(
          spacing: 10,
          runSpacing: 10,
          runAlignment: WrapAlignment.start,
          children: List.generate(
            data.value.length,
            (index) {
              final tappedItem = data.value[index];
              final tappedValue = data.key == 'Status'
                  ? (tappedItem as AnimalCategory).key ?? ''
                  : tappedItem;
              final displayText = data.key == 'Status'
                  ? (tappedItem as AnimalCategory).name
                  : tappedItem;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    final currentSelection = selectedOptions[data.key];
                    final filter = context.read<BarnDetailsCubit>().filter;

                    if (currentSelection == tappedValue) {
                      // Unselect if already selected
                      switch (data.key) {
                        case 'Gender':
                          filter.remove('gender');
                          selectedOptions.remove(data.key);
                          break;
                        case 'Age':
                          filter.remove('age_filter');
                          selectedOptions.remove(data.key);
                          break;
                        case 'Status':
                          filter.remove(tappedValue);
                          selectedOptions.remove(data.key);
                          break;
                      }
                    } else {
                      // Select new option
                      switch (data.key) {
                        case 'Gender':
                          if (tappedValue.trim().toLowerCase() == 'all') {
                            filter.remove('gender');
                            selectedOptions['Gender'] = 'All';
                          } else {
                            filter['gender'] = tappedValue.toLowerCase();
                            selectedOptions[data.key] = tappedValue;
                          }
                          break;

                        case 'Age':
                          const ageMapping = {
                            '1 to 3 years': '1-3_years',
                            '4 to 5 years': '4-5_years',
                            'Newborn': 'newborn',
                          };
                          final ageValue = ageMapping[tappedValue];
                          if (ageValue != null) {
                            filter['age_filter'] = ageValue;
                            selectedOptions[data.key] = tappedValue;
                          }
                          break;

                        case 'Status':
                          // clear other statuses first (only 1 active)
                          for (var status in animalFilterOptions['Status']!) {
                            final s = (status as AnimalCategory).key;
                            if (s != null) filter.remove(s);
                          }
                          filter[tappedValue] = 1;
                          selectedOptions[data.key] = tappedValue;
                          break;
                      }
                    }
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  decoration: BoxDecoration(
                    color: selectedOptions[data.key] == tappedValue
                        ? AppColors.farmColor
                        : AppColors.boxGray,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: CustomText(
                    text: displayText,
                    // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
                    fontFamily: isEnglish
                        ? AppFontsFamily.english
                        : AppFontsFamily.arabic,
                    color: selectedOptions[data.key] == tappedValue
                        ? Colors.white
                        : Colors.black,
                    fontWeight: selectedOptions[data.key] == tappedValue
                        ? FontWeight.w500
                        : FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              );
            },
          ),
        ),
        Divider(
          thickness: 0.9,
          color: Colors.grey[300],
          height: 30,
        ),
      ],
    );
  }
}

extension StringX on String {
  String? get capitalizeFirst =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : null;
}

// CustomText(
//   text: 'Animal Fertility Count',
//   fontSize: 15,
//   fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
// ),
// kHeight5,
// kHeight10,
// LayoutBuilder(
//   builder: (context, constraints) {
//     final sliderWidth = constraints.maxWidth;
//     final position =
//         (_currentRangeValues.end / 200) * sliderWidth;

//     return Stack(
//       clipBehavior: Clip.none,
//       alignment: Alignment.centerLeft,
//       children: [
//         Positioned(
//           left: position -
//               (_currentRangeValues.end > 50 ? 15 : 5),
//           bottom: 10,
//           child: CustomText(
//             text: '${_currentRangeValues.end.toInt()}',
//             fontSize: 12,
//             color: AppColors.farmColor,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         Positioned(
//           left: 0,
//           bottom: 10,
//           child: CustomText(
//             text: '0',
//             fontSize: 12,
//             color: AppColors.farmColor,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         SliderTheme(
//           data: SliderTheme.of(context).copyWith(
//             trackHeight: 4,
//             overlayShape: SliderComponentShape.noOverlay,
//             thumbShape: const RoundSliderThumbShape(
//                 enabledThumbRadius: 6),
//             rangeThumbShape:
//                 const RoundRangeSliderThumbShape(
//                     enabledThumbRadius: 6,
//                     elevation: 3,
//                     pressedElevation: 3),
//           ),
//           child: RangeSlider(
//             values: _currentRangeValues,
//             min: 0,
//             max: 200,
//             divisions: 200,
//             labels: null,
//             activeColor: AppColors.farmColor,
//             inactiveColor: Colors.green.shade100,
//             onChanged: (RangeValues values) {
//               setState(() {
//                 _currentRangeValues =
//                     RangeValues(0, values.end);
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   },
// ),
