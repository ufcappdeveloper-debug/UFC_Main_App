import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';

import '../../../../global/shared/constants/constants.dart';

class PointerIndicatorData {
  final Color color;
  final String name;
  final double total;
  const PointerIndicatorData({
    required this.color,
    required this.name,
    required this.total,
  });
}

class PointerIndicator extends StatelessWidget {
  final PointerIndicatorData pointerIndicatorData;
  const PointerIndicator({super.key, required this.pointerIndicatorData});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: pointerIndicatorData.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          pointerIndicatorData.name.tr(),
          style: TextStyle(
            fontSize: 11,
            // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
            fontFamily:
                isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          pointerIndicatorData.total.toStringAsFixed(0),
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
