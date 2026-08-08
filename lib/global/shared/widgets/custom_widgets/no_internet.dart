import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';

class NoInternet extends StatelessWidget {
  final AppType type;
  final Function() onTap;
  const NoInternet({Key? key, required this.type, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/svg/global/no-internet.svg',
          width: 240,
        ),
        kHeight40,
        CustomText(
          text: 'No internet connection',
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
        CustomText(
          text: 'The internet is slow or not connected',
          fontSize: 18,
          fontWeight: FontWeight.w300,
        ),
        SizedBox(
          height: 60,
        ),
        CustomButton(
            title: 'Try Again',
            color: CommonUtils.getAppThemeColor(type),
            onTap: onTap),
        kHeight10
      ],
    ));
  }
}
