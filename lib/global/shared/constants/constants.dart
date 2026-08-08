import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/util/lang/langauge_manager.dart';

// Widgets height
final double kNavBarHeight = Platform.isAndroid ? 85 : 75;

// Constant Empty Height
const kHeight5 = SizedBox(height: 5);
const kHeight2 = SizedBox(height: 2);
const kHeight8 = SizedBox(height: 8);
const kHeight10 = SizedBox(height: 10);
const kHeight12 = SizedBox(height: 12);
const kHeight15 = SizedBox(height: 15);
const kHeight16 = SizedBox(height: 16);
const kHeight14 = SizedBox(height: 14);
const kHeight18 = SizedBox(height: 18);
const kHeight20 = SizedBox(height: 20);
const kHeight24 = SizedBox(height: 24);
const kHeight25 = SizedBox(height: 25);
const kHeight30 = SizedBox(height: 30);
const kHeight35 = SizedBox(height: 35);
const kHeight40 = SizedBox(height: 40);
const kHeight45 = SizedBox(height: 45);
const kHeight50 = SizedBox(height: 50);
const kHeight100 = SizedBox(height: 100);

// Constant Empty Width
const kWidth5 = SizedBox(width: 5);
const kWidth6 = SizedBox(width: 6);
const kWidth10 = SizedBox(width: 10);
const kWidth15 = SizedBox(width: 15);
const kWidth16 = SizedBox(width: 16);
const kWidth20 = SizedBox(width: 20);
const kWidth24 = SizedBox(width: 24);
const kWidth25 = SizedBox(width: 25);
const kWidth30 = SizedBox(width: 30);
const kWidth35 = SizedBox(width: 35);
const kWidth40 = SizedBox(width: 40);
const kWidth45 = SizedBox(width: 45);
const kWidth50 = SizedBox(width: 50);

//box shadow
final customBoxShadow = BoxShadow(
  color:
      Colors.black.withAlpha((0.08 * 255).toInt()), // 0.08 opacity = 20 alpha
  blurRadius: 15,
  offset: Offset(0, 0),
  spreadRadius: 0,
);

//padding
EdgeInsets kall(double i) => EdgeInsets.all(i);
EdgeInsets ksymmetric(double h, double v) =>
    EdgeInsets.symmetric(horizontal: h, vertical: v);
EdgeInsets khoriz(double h) => EdgeInsets.symmetric(horizontal: h);
EdgeInsets konlyb(double i) => EdgeInsets.only(bottom: i);
EdgeInsets konlyt(double i) => EdgeInsets.only(top: i);
EdgeInsets konlyl(double i) => EdgeInsets.only(left: i);
EdgeInsets konlyr(double i) => EdgeInsets.only(right: i);
BorderRadius boRadius(double r) => BorderRadius.all(Radius.circular(r));

//screen height width
double sHeight(BuildContext context) => MediaQuery.of(context).size.height;
double sWidth(BuildContext context) => MediaQuery.of(context).size.width;

//lang

bool get isArOrUr =>
    LanguageManager.locale == 'ar' || LanguageManager.locale == 'ur';
bool get isArabic => LanguageManager.locale == 'ar';

bool get isEnglish => LanguageManager.locale == 'en';

bool get isUrdu => LanguageManager.locale == 'ur';

class Constants {
  static bool freeDoctorAppoinment = true;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
}
