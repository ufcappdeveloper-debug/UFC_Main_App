import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

Widget suffixSend(BuildContext context, Function() onTap, Color imageColor) =>
    InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: 16,
        backgroundColor: cream,
        child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isArOrUr ? math.pi : 0),
            child: SvgPicture.asset(
              "assets/svg/top_bar/send-arrow.svg",
              colorFilter: ColorFilter.mode(
                imageColor,
                BlendMode.srcIn,
              ),
            )),
      ),
    );
