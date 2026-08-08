import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

import '../../../global/extensions/app_colors.dart';

class CustomTab extends StatelessWidget {
  final String title;
  final String asset;
  final bool isSelected;

  const CustomTab({
    super.key,
    required this.title,
    required this.asset,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: kNavBarHeight * 0.55),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isSvg == true)
            SvgPicture.asset(asset)
          else
            Image.asset(asset, height: 25.0, width: 25.0),
          if (isSelected)
            Container(
              width: 25,
              height: 1.5,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 3),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(11),
              ),
            ),
          Text(
            title.tr(),
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none, // Ensure no strikethrough
            ),
          ),
        ],
      ),
    );
  }

  bool get isSvg {
    return asset.contains('.svg');
  }
}

class ExpandedCustomTab extends StatelessWidget {
  final String title;
  final String asset;
  final bool isSelected;
  final Function onTap;

  const ExpandedCustomTab({
    super.key,
    required this.title,
    required this.asset,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.farmColor,
                borderRadius: BorderRadius.circular(30))
            : null,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal:isSelected? 15:23),
        constraints: BoxConstraints(maxHeight: kNavBarHeight * 0.55),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSvg == true)
              SvgPicture.asset(asset)
            else
              Image.asset(asset, height: 25.0, width: 25.0),
            if (isSelected) kWidth5,
            if (isSelected)
              Text(
                title.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool get isSvg {
    return asset.contains('.svg');
  }
}
