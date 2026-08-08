import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

class DeliveryDatePicker extends StatefulWidget {
  final Function(DateTime)? onDateSelected; // callback

  const DeliveryDatePicker({super.key, this.onDateSelected});

  @override
  State<DeliveryDatePicker> createState() => _DeliveryDatePickerState();
}

class _DeliveryDatePickerState extends State<DeliveryDatePicker> {
  DateTime currentMonth = DateTime.now();
  DateTime? selectedDate;
  final _scrollController = ScrollController();

  List<DateTime> get daysInMonth {
    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDay = DateTime(currentMonth.year, currentMonth.month + 1, 0);

    return List.generate(
      lastDay.day,
      (index) => DateTime(currentMonth.year, currentMonth.month, index + 1),
    );
  }

  void _prevMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
      selectedDate = null;
      _scrollController.jumpTo(0);
    });
  }

  void _nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
      selectedDate = null;
      _scrollController.jumpTo(0);
    });
  }

  void _selectDate(DateTime day, int index) {
    setState(() {
      selectedDate = day;
    });

    if (widget.onDateSelected != null) {
      widget.onDateSelected!(day);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      final normalWidth = 42.14;
      final selectedWidth = 65;
      final spacing = 8;

      double offset = 0;

      for (int i = 0; i < index; i++) {
        final width =
            (selectedDate == daysInMonth[i]) ? selectedWidth : normalWidth;
        offset += width + spacing;
      }

      offset = offset - (screenWidth / 2) + (selectedWidth / 2);

      double previousExtraWidth = 0;
      for (int i = 0; i < index; i++) {
        if (selectedDate == daysInMonth[i]) {
          previousExtraWidth += selectedWidth - normalWidth;
        }
      }
      offset -= previousExtraWidth / 2;

      _scrollController.animateTo(
        offset.clamp(
          _scrollController.position.minScrollExtent,
          _scrollController.position.maxScrollExtent,
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();

      if (currentMonth.year == now.year && currentMonth.month == now.month) {
        final todayIndex = now.day - 1;
        const double itemExtent = 50 + 12;
        _scrollController.jumpTo(todayIndex * itemExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthName = DateFormat.MMMM(isArabic
            ? 'ar'
            : isUrdu
                ? 'ur'
                : isEnglish
                    ? 'en'
                    : 'en')
        .format(currentMonth);
    final year = currentMonth.year;

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- Top Row with Month, Year and Arrows ---

          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    text: 'Choose delivery date',
                  )
                ],
              )),
          SizedBox(
            height: 16,
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _prevMonth,
              ),
              CustomText(
                text: '$monthName $year',
                fontSize: 15,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _nextMonth,
              ),
            ],
          ),

          Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: SizedBox(
                height: 83,
                child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: daysInMonth.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final day = daysInMonth[index];
                    final now = DateTime.now();
                    final isPastOrToday = day.isBefore(
                      DateTime(now.year, now.month, now.day),
                    );
                    final isSelected = selectedDate != null &&
                        selectedDate!.year == day.year &&
                        selectedDate!.month == day.month &&
                        selectedDate!.day == day.day;

                    return GestureDetector(
                      onTap: isPastOrToday
                          ? () => CustomSnackBar.message(
                              context, "You cannot select past dates".tr())
                          : () => _selectDate(day, index),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            height: isSelected ? 83 : 66,
                            width: isSelected ? 65 : 42.14,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? yellowColor
                                  : isPastOrToday
                                      ? PetVeterinaryColors.darkGrayBackground2
                                          .withOpacity(0.9)
                                      : PetVeterinaryColors.lightGrayBackground,
                              borderRadius:
                                  BorderRadius.circular(isSelected ? 40 : 24),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat.E(
                                    isArabic
                                        ? 'ar'
                                        : isUrdu
                                            ? 'ur'
                                            : isEnglish
                                                ? 'en'
                                                : 'en',
                                  ).format(day),
                                  style: TextStyle(
                                    fontSize: isSelected
                                        ? 13
                                        : isEnglish
                                            ? 13
                                            : 10,
                                    fontFamily: isEnglish
                                        ? AppFontsFamily.english
                                        : AppFontsFamily.arabic,
                                    fontWeight: isSelected
                                        ? FontWeight.w500
                                        : FontWeight.w300,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isPastOrToday
                                        ? Colors.grey.shade300
                                        : Colors.white,
                                  ),
                                  child: Center(
                                      child: Text(
                                    day.day.toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.w500
                                          : FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ))
        ],
      ),
    );
  }
}
