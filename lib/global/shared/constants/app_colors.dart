import 'package:flutter/material.dart';

const List<BoxShadow> boxShadow = [
  BoxShadow(
    color: Color(0x10000000),
    offset: Offset(0, 10),
    blurRadius: 20,
  ),
];

const Color carminePink = Color(0xFFEE403F);
const Color redColor = Color(0XFFFF3B30);
const Color primaryColor = Color(0xff78B833);
const Color darkGreen = Color.fromARGB(255, 94, 141, 43);
const Color primaryColorLight = Color(0xffFAF1F1);
const Color mediumGreenColor = Color(0xFF2DBB4F);
const Color primaryGrey = Color(0xFFC7C7C7);
const Color primaryPurple = Color(0xff9D4EDD);
const Color lightGrey = Color.fromARGB(255, 237, 237, 237);
const Color cream = Color(0xFFF9F6F4);
const Color textGrey = Color(0xFF44444F);
const Color yellowColor = Color(0xFFF7D66D);

const svgRedColor = ColorFilter.mode(redColor, BlendMode.srcIn);
const svgBlackColor = ColorFilter.mode(Colors.black, BlendMode.srcIn);
const svgGreenColor = ColorFilter.mode(primaryColor, BlendMode.srcIn);
const svgYellowColor =
    ColorFilter.mode(Color.fromRGBO(247, 214, 109, 0.15), BlendMode.srcIn);
const svgYellowColor2 = ColorFilter.mode(yellowColor, BlendMode.srcIn);
