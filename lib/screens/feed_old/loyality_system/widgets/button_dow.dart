import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_colors.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_fontstyles.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/widgets/custom_loyality_points_button.dart';

class ButtonRow extends StatefulWidget {
  final int initialIndex;
  final ValueChanged<int> onIndexChanged;

  const ButtonRow({
    super.key,
    this.initialIndex = 0,
    required this.onIndexChanged,
  });

  @override
  _ButtonRowState createState() => _ButtonRowState();
}

class _ButtonRowState extends State<ButtonRow> {
  late int activeIndex;

  @override
  void initState() {
    super.initState();
    activeIndex = widget.initialIndex;
  }

  void _handleTap(int index) {
    setState(() {
      activeIndex = index;
    });
    widget.onIndexChanged(index); // Notify parent widget of index change
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomLoyalityPointsButton(
              width: 112,
              height: 25,
              text: 'Product'.tr(),
              backgroundColor: activeIndex == 0
                  ? LoyalityPointsColors.lpCurrentPointsTextColor
                  : Colors.white,
              textStyle: activeIndex == 0
                  ? LoyalityPointsFontstyles.rewardScreenBtnTextStyle
                      .copyWith(color: Colors.white)
                  : LoyalityPointsFontstyles.rewardScreenBtnTextStyle
                      .copyWith(color: Colors.black),
              onTap: () => _handleTap(0),
              boxShadow: activeIndex == 1
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        offset: const Offset(0, 1),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                    ]
                  : []),
        ),
        // const SizedBox(width: 20),
        Expanded(
          child: CustomLoyalityPointsButton(
              width: 112,
              height: 25,
              text: 'Voucher'.tr(),
              backgroundColor: activeIndex == 1
                  ? LoyalityPointsColors.lpCurrentPointsTextColor
                  : Colors.white,
              textStyle: activeIndex == 1
                  ? LoyalityPointsFontstyles.rewardScreenBtnTextStyle
                      .copyWith(color: Colors.white)
                  : LoyalityPointsFontstyles.rewardScreenBtnTextStyle
                      .copyWith(color: Colors.black),
              onTap: () => _handleTap(1),
              boxShadow: activeIndex == 0
                  ? [
                      BoxShadow(
                        color:
                            Colors.black.withValues(alpha: 0.1), // Shadow color
                        offset: const Offset(0, 1), // X and Y offset
                        blurRadius: 3, // Blur radius
                        spreadRadius: 1, // Spread radius
                      ),
                    ]
                  : []),
        )
      ],
    ));
  }
}
