import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class FarmChartComponent extends StatelessWidget {
  const FarmChartComponent({
    super.key,
    required this.child,
    this.title,
    this.height = 220,
    this.needBorder = true,
    this.padding,
  });

  final String? title;
  final Widget child;
  final double? height;
  final bool needBorder;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        height: !needBorder ? null : height,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: !needBorder
              ? []
              : [
                  BoxShadow(
                    color: Colors.grey.shade300, // subtle shadow
                    offset: const Offset(0, 0),
                    blurRadius: 10,
                  ),
                ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (title != null)
              CustomText(
                text: title!,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            kHeight5,
            child
          ],
        ),
      ),
    );
  }
}
