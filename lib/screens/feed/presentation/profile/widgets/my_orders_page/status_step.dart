import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/util/common/screen_width_utils.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

class StatusStep extends StatelessWidget {
  final String label;
  final bool isDone;
  final bool isCancelled;
  final Axis direction;
  final double? height;
  final Color? color;
  final bool isActive;
  const StatusStep({
    super.key,
    required this.label,
    this.isDone = false,
    this.isCancelled = false,
    this.direction = Axis.horizontal,
    this.height,
    this.color,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = ScreenWidthUtils.isWide(context);
    final icon = isActive
        ? SvgPicture.asset(
            'assets/svg/global/check.svg',
            height: height ??
                (direction == Axis.horizontal
                    ? isWide
                        ? 15
                        : 14
                    : isWide
                        ? 15
                        : 13),
          )
        : SvgPicture.asset(
            'assets/svg/feed/check_icon_grey.svg',
            height: height ??
                (direction == Axis.horizontal
                    ? isWide
                        ? 15
                        : 14
                    : isWide
                        ? 15
                        : 13),
          );

    final text = AutoSizeText(
      label.tr(),
      maxLines: 2,
      minFontSize: direction == Axis.horizontal
          ? isWide
              ? 12
              : 11
          : isWide
              ? 11
              : 9,
      style: TextStyle(
          color: isActive ? Colors.black : PetVeterinaryColors.newPetLightGray,
          fontSize: direction == Axis.horizontal
              ? isWide
                  ? 12
                  : 11
              : isWide
                  ? 11
                  : 9,
          fontFamily:
              isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
          fontWeight: FontWeight.w300),
    );

    return direction == Axis.horizontal
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [icon, const SizedBox(width: 4), Flexible(child: text)],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(height: 4),
              text,
            ],
          );
  }
}
