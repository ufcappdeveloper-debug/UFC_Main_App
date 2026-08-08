import 'package:flutter/material.dart';

import '../../../../global/shared/constants/constants.dart';

class CustomFarmContainer extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? radius;
  final bool needShadow;
  final List<BoxShadow>? customShadow;

  const CustomFarmContainer(
      {super.key,
      this.child,
      this.height,
      this.width,
      this.padding,
      this.margin,
      this.radius,
      this.customShadow,
      this.needShadow = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? EdgeInsets.all(10),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius ?? 10),
        boxShadow: needShadow ? (customShadow ?? [customBoxShadow]) : [],
      ),
      child: child,
    );
  }
}
