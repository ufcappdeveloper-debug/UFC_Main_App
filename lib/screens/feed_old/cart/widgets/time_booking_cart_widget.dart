import 'package:flutter/cupertino.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/extensions/app_fonts.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

// Bottom Sheet for Displaying Carrier Numbers
Widget timeBookingBtmSheet() {
  return LayoutBuilder(
    builder: (context, constraints) => DraggableScrollableSheet(
      expand: false,
      maxChildSize: constraints.maxWidth < 400 ? 0.9 : 0.8,
      minChildSize: constraints.maxWidth < 400 ? 0.8 : 0.7,
      initialChildSize: constraints.maxWidth < 400 ? 0.9 : 0.8,
      builder: (context, scrollController) {
        DateTime now = DateTime.now();
        int selectedDate = now.day;
        int selectedHour = now.hour;
        int selectedMinute = now.minute;

        // Format the date as "Wed, Jun 8" or "Today"
        // ignore: unused_local_variable
        String formattedDate = now.isToday()
            ? "Today"
            : "${now.weekdayToString()}, ${now.monthToString()} ${now.day}";

        return StatefulBuilder(
          builder: (context, setState) => Column(
            children: [
              Expanded(
                  child: Align(
                alignment: Alignment.center,
                child: CustomText(
                  text:
                      // "Carriers we highly recommend",
                      "Time Booking",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              )),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  children: [
                    const SizedBox(height: 19),
                    // Date, Hour, and Minute Pickers in a Horizontal Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Date Picker
                        _buildPicker(
                          context: context,
                          itemCount: 31,
                          initialValue: now.day - 1,
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedDate = index + 1; // Day 1 to 31
                              DateTime selectedDateTime = DateTime(
                                  now.year,
                                  now.month,
                                  selectedDate); // Create DateTime object
                              if (selectedDateTime.isToday()) {
                                formattedDate =
                                    "Today"; // Display "Today" if selected date is today
                              } else {
                                formattedDate =
                                    "${selectedDateTime.weekdayToString()}, ${selectedDateTime.monthToString()} ${selectedDateTime.day}";
                              }
                            });
                          },
                          builder: (context, index) {
                            bool isSelected = index == selectedDate - 1;
                            // DateTime date = DateTime(now.year, now.month, index + 1); // Create a DateTime object
                            // String formattedDate = _getFormattedDate(date);
                            DateTime date = DateTime(now.year, now.month,
                                index + 1); // Create DateTime object
                            String formattedDate = _getFormattedDate(date);

                            return Center(
                                child:
                                    //  CustomText(
                                    //   text: formattedDate,
                                    //   fontSize: 18,
                                    //   fontWeight: FontWeight.bold,
                                    // ),
                                    Text(formattedDate,
                                        style: isSelected
                                            ? AppFonts
                                                .dateSelectorActiveTextStyle
                                                .copyWith(
                                                    color: AppColors
                                                        .dateSelectorActiveTextColor)
                                            : AppFonts
                                                .dateSelectorInactiveTextStyle
                                                .copyWith(
                                                    color: AppColors
                                                        .dateSelectorInactiveTextColor)));
                          },
                        ),
                        // Hour Picker
                        _buildPicker(
                          context: context,
                          itemCount: 24,
                          initialValue: now.hour,
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedHour = index; // Hour 0 to 23
                            });
                          },
                          builder: (context, index) {
                            bool isSelected = index == selectedHour;
                            return Center(
                                child: Text(index.toString(),
                                    style: isSelected
                                        ? AppFonts.dateSelectorActiveTextStyle
                                            .copyWith(
                                                color: AppColors
                                                    .dateSelectorActiveTextColor)
                                        : AppFonts.dateSelectorInactiveTextStyle
                                            .copyWith(
                                                color: AppColors
                                                    .dateSelectorInactiveTextColor)));
                          },
                        ),
                        // Minute Picker
                        _buildPicker(
                          context: context,
                          itemCount: 60,
                          initialValue: now.minute,
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedMinute = index; // Minute 0 to 59
                            });
                          },
                          builder: (context, index) {
                            bool isSelected = index == selectedMinute;
                            return Center(
                                child: Text(index.toString(),
                                    style: isSelected
                                        ? AppFonts.dateSelectorActiveTextStyle
                                            .copyWith(
                                                color: AppColors
                                                    .dateSelectorActiveTextColor)
                                        : AppFonts.dateSelectorInactiveTextStyle
                                            .copyWith(
                                                color: AppColors
                                                    .dateSelectorInactiveTextColor)));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 3, left: 53, right: 53, bottom: 23),
                child: CustomButton(
                  width: double.infinity,
                  title: "Proceed to Payment",
                  onTap: () {
                    DateTime selectedDateTime = DateTime(
                      now.year,
                      now.month,
                      selectedDate,
                      selectedHour,
                      selectedMinute,
                    );
                    Navigator.pop(context, selectedDateTime);
                  },
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

// Helper function for building CupertinoPickers
Widget _buildPicker(
    {required int itemCount,
    required int initialValue,
    required Function(int) onSelectedItemChanged,
    required Widget Function(BuildContext, int) builder,
    required BuildContext context}) {
  return SizedBox(
    width: 100,
    height: 150,
    child: CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: initialValue),
      itemExtent: 50,
      onSelectedItemChanged: onSelectedItemChanged,
      children: List.generate(itemCount, (index) {
        return builder(context, index);
      }),
    ),
  );
}

String _getFormattedDate(DateTime date) {
  // Get the day of the week (Mon, Tue, etc.)
  String weekday = date.weekdayToString();
  // Get the month abbreviation (Jan, Feb, etc.)
  String month = date.monthToString();
  // Return the formatted string
  return "$weekday, $month ${date.day}";
}

// Extension for getting the weekday and month names in strings
extension DateTimeFormat on DateTime {
  String weekdayToString() {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  String monthToString() {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  bool isToday() {
    final today = DateTime.now();
    return year == today.year && month == today.month && day == today.day;
  }
}
