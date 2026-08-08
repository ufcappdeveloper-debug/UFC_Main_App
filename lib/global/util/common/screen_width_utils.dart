import 'package:flutter/material.dart';

class ScreenWidthUtils {
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static bool isWide(BuildContext context) => screenWidth(context) > 360;
  static bool isSmall(BuildContext context) => screenWidth(context) < 350;

  static bool isWideLess(BuildContext context) {
    final width = screenWidth(context);
    return width >= 390 && width < 430;
  }

  static bool isMiddle(BuildContext context) {
    final width = screenWidth(context);
    return width > 350 && width <= 360;
  }

  static bool isWideMore(BuildContext context) => screenWidth(context) >= 430;
}
