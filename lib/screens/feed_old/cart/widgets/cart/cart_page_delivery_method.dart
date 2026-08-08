import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/shadows.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

Future<void> deliveryMethod(BuildContext context,
    {required VoidCallback onDeliveryPressed,
    required VoidCallback onPickUpPressed}) {
  return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (BuildContext context) {
        return SizedBox(
          height: 280,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 40),
              CustomText(
                text: "Choose Delivery Method",
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    child: deliveryMethodType(
                        onTap: onDeliveryPressed, type: "Delivery"),
                  ),
                  const SizedBox(width: 20),
                  Material(
                    child: deliveryMethodType(
                        onTap: onPickUpPressed, type: "Pickup"),
                  ),
                ],
              )
            ],
          ),
        );
      });
}

Widget deliveryMethodType({required String type, required VoidCallback onTap}) {
  return Container(
      width: 158,
      height: 132,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: btmSmContainerShadow,
          borderRadius: BorderRadius.circular(10)),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Container(
                width: 3,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  color: type == "Delivery"
                      ? const Color.fromRGBO(232, 255, 207, 1)
                      : const Color.fromRGBO(255, 232, 178, 1),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    type == "Delivery"
                        ? const SizedBox(height: 20)
                        : const SizedBox(height: 10),
                    Image.asset(
                        type == "Delivery"
                            ? 'assets/images/global/truck.png'
                            : 'assets/images/global/pickup.png',
                        height: type == "Delivery" ? 40 : 60),
                    type == "Delivery"
                        ? const SizedBox(height: 20)
                        : const SizedBox(height: 15),
                    CustomText(
                      text: type.tr(),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    )
                  ],
                ),
              ),
              const VerticalDivider(
                width: 3,
                thickness: 3,
                color: Colors.transparent,
              ),
            ],
          ),
        ),
      ));
}

// Future<DateTime?> showTimeBookingPopup(BuildContext context) async {
//   DateTime selectedDate =
//       DateTime.now().add(const Duration(days: 1)); // Default to the next day
//   Key pickerKey = UniqueKey();
//   // if (selectedDate.hour < 12) {
//   //   selectedDate = DateTime(
//   //     selectedDate.year,
//   //     selectedDate.month,
//   //     selectedDate.day,
//   //     12, // Set hour to 12 PM
//   //     0, // Set minutes to 0
//   //   );
//   // }

//   // Ensure initialDateTime is not before minimumDate
//   DateTime minimumDate = DateTime.now().add(const Duration(days: 1));

//   // Make sure initialDateTime is not before minimumDate
//   if (selectedDate.isBefore(minimumDate)) {
//     selectedDate = minimumDate;
//   }

//   // Show the Cupertino Modal Popup and return the selected date and time
//   final result = await showCupertinoModalPopup<DateTime>(
//     context: context,
//     builder: (_) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         height: 310,
//         child: StatefulBuilder(builder: (context, setState) {
//           return Column(
//             children: [
//               const SizedBox(height: 30),
//               Text(
//                 "Time Booking".tr(), // Localization string for the title
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontFamily: "Kanit",
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   decoration: TextDecoration.none,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 height: 175,
//                 child: CupertinoDatePicker(
//                   mode: CupertinoDatePickerMode
//                       .date, // Mode changed to date and time
//                   showDayOfWeek: true,
//                   use24hFormat: true,
//                   key: pickerKey,
//                   minimumDate: minimumDate,
//                   initialDateTime: selectedDate,
//                   maximumDate: DateTime.now().add(const Duration(days: 90)),
//                   onDateTimeChanged: (DateTime value) {
//                     // selectedDate = value;  // Update the selected date and time
//                     // if (value.day < minimumDate.day &&
//                     //     value.month < minimumDate.month) {
//                     //   // If it's AM, set it to 12:00 PM
//                     //   value = DateTime(
//                     //     value.year,
//                     //     value.month,
//                     //     value.day,
//                     //     0, // Set to 12 PM
//                     //     0, // Set minutes to 0
//                     //   );

//                     //   // Force picker to reset

//                     // } else {
//                     //   setState(() {
//                     //     selectedDate = value;
//                     //   });
//                     // }

//                        setState(() {
//                         pickerKey =
//                             UniqueKey(); // Change key to rebuild the picker
//                         selectedDate = value;
//                       });
//                   },
//                 ),
//               ),
//               const SizedBox(height: 10),
//               CustomButton(
//                 title: 'Proceed to Payment',
//                 onTap: () {
//                   Navigator.pop(context,
//                       selectedDate); // Pass the selected date and time back
//                 },
//               ),
//               const SizedBox(height: 20),
//             ],
//           );
//         })),
//   );

//   return result; // Return selected date and time or null if canceled
// }

Future<DateTime?> showTimeBookingPopup(BuildContext context) async {
  // Set minimumDate to tomorrow's date with time set to midnight (00:00)
  DateTime now = DateTime.now();
  DateTime minimumDate = DateTime(
    now.year,
    now.month,
    now.day + 1,
    0,
    0,
  );

  // Initialize selectedDate to match minimumDate
  DateTime selectedDate = minimumDate;

  final result = await showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (_) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: 310,
      child: StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 20), // extra padding for safe overflow
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    "Time Booking".tr(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "Kanit",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 175,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      minimumDate: minimumDate,
                      initialDateTime: selectedDate,
                      maximumDate: DateTime.now().add(const Duration(days: 90)),
                      onDateTimeChanged: (DateTime value) {
                        DateTime adjustedDate = DateTime(
                          value.year,
                          value.month,
                          value.day,
                          0,
                          0,
                        );
                        setState(() {
                          selectedDate = adjustedDate;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    title: 'Proceed to Payment',
                    onTap: () {
                      Navigator.pop(context, selectedDate);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );

  return result;
}
