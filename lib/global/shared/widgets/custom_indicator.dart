import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({
    super.key,
    required this.padding,
    this.color = primaryColor,
  });

  final double padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: CircularProgressIndicator.adaptive(
        backgroundColor: Platform.isIOS ? color : Colors.transparent,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }
}
