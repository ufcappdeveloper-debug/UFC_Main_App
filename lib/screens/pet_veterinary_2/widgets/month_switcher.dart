import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';

class MonthSwitcher extends StatefulWidget {
  final ValueChanged<int>? onMonthChanged; // callback to notify parent

  const MonthSwitcher({super.key, this.onMonthChanged});

  @override
  State<MonthSwitcher> createState() => _MonthSwitcherState();
}

class _MonthSwitcherState extends State<MonthSwitcher> {
  int currentMonthOffset =
      0; // 0 = current month, 1 = next, 2 = month after next

  void _updateOffset(int newOffset) {
    setState(() {
      currentMonthOffset = newOffset;
    });
    if (widget.onMonthChanged != null) {
      widget.onMonthChanged!(currentMonthOffset); // notify parent
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime baseDate = DateTime.now();
    final DateTime displayedMonth =
        DateTime(baseDate.year, baseDate.month + currentMonthOffset);

    final bool canGoBack = currentMonthOffset > 0;
    final bool canGoForward = currentMonthOffset < 2;

    return Row(
      children: [
        GestureDetector(
          onTap: canGoBack ? () => _updateOffset(currentMonthOffset - 1) : null,
          child: Icon(Icons.arrow_back_ios,
              size: 14, color: canGoBack ? Colors.black : Colors.grey),
        ),
        const SizedBox(width: 4),
        Text(
          DateFormat.MMMM(Localizations.localeOf(context).languageCode)
              .format(displayedMonth),
          style: PetVeterinaryFontstyles2.getRegularStyle(context, 14)
              .copyWith(color: PetVeterinaryColors.newPetDarkGray),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap:
              canGoForward ? () => _updateOffset(currentMonthOffset + 1) : null,
          child: Icon(Icons.arrow_forward_ios,
              size: 14, color: canGoForward ? Colors.black : Colors.grey),
        ),
      ],
    );
  }
}
