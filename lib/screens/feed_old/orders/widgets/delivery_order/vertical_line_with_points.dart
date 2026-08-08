import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/cart/extensions/cart_colors.dart';
import 'package:ufc_mobile/screens/feed_old/orders/utils/delivery_order_utils.dart';
import 'package:ufc_mobile/screens/feed_old/orders/widgets/delivery_order/delivery_order_widgets.dart';
import 'package:ufc_mobile/global/util/extension/string_extensions.dart';
import 'package:ufc_mobile/global/util/lang/langauge_manager.dart';

class VerticalLineWithPoints extends StatelessWidget {
  const VerticalLineWithPoints({
    super.key,
    required this.driverName,
    required this.statusChanges,
  });
  final String driverName;
  final List<Map<String, String>> statusChanges;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (index) {
        final item = index < statusChanges.length
            ? statusChanges[index]
            : {'created_at': '', 'description': ''};

        String formattedDate = '';
        String formattedTime = '';

        if (item['created_at'] != null && item['created_at']!.isNotEmpty) {
          try {
            final dateTime = DateTime.parse(item['created_at']!).toLocal();
            final locale = LanguageManager.locale;

            // Get month in locale, rest keep in English
            String month =
                DateFormat('MMMM', locale).format(dateTime); // May or مايو
            String day = DateFormat('dd', 'en').format(dateTime);
            formattedDate = '$month $day';
            String hourMinute = DateFormat('h:mm', 'en').format(dateTime);
            String amPm = DateFormat('a', locale).format(dateTime);
            formattedTime = '$hourMinute $amPm';
          } catch (e) {
            formattedDate = '';
            formattedTime = '';
          }
        }

        final isCompleted = index <= _getCurrentStatusIndex();

        final (title, subtitle) = DeliveryOrderUtils.getStatusMessage(
            item['description'] ?? '',
            driverName: driverName);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 75,
              child: customtitleAndValueForOrderStatus(
                title: formattedDate,
                value: formattedTime,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: CartColors.orderStatusLineGreyColor,
                      ),
                    ),
                    if (isCompleted)
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: CartColors.orderStatusLineGreenColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                if (index != 3)
                  Stack(
                    children: [
                      Container(
                        width: 2,
                        height: 76.5,
                        color: CartColors.orderStatusLineGreyColor,
                      ),
                      if (index < _getCurrentStatusIndex())
                        Container(
                          width: 2,
                          height: 76.5,
                          color: CartColors.orderStatusLineGreenColor,
                        ),
                      if (index == _getCurrentStatusIndex())
                        Container(
                          width: 2,
                          height: 28.5,
                          color: CartColors.orderStatusLineGreenColor,
                        ),
                    ],
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: customtitleAndValueForOrderStatus(
                title: title?.capitalize() ?? '',
                value: subtitle?.capitalize() ?? '',
              ),
            ),
          ],
        );
      }),
    );
  }

  int _getCurrentStatusIndex() {
    for (int i = 0; i < statusChanges.length; i++) {
      if (statusChanges[i]['description']?.toLowerCase().contains('current') ==
          true) {
        return i;
      }
    }
    return statusChanges.length - 1;
  }
}
