import 'package:flutter/material.dart';

class ScreenUtils {
  static bool isSmScr(BoxConstraints constraints) => constraints.maxWidth < 500;

  static bool isLgScr(BoxConstraints constraints) =>
      constraints.maxWidth >= 500;
}
