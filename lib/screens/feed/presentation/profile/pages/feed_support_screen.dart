import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/extensions/app_png_images.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/farm_appbar.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedSupportScreen extends StatelessWidget {
  const FeedSupportScreen({
    super.key,
    this.isFromVet = false,
    this.isFromFarm = false,
  });

  final bool isFromVet;
  final bool isFromFarm;

  @override
  Widget build(BuildContext context) {
    Color getBgColor() {
      if (isFromVet) return PetVeterinaryColors.newPetMainColorVeterinary;
      if (isFromFarm) return AppColors.farmColor;
      return primaryColor;
    }

    return Scaffold(
        appBar: CustomFarmAppBar(title: 'Support'),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            kHeight30,
            GestureDetector(
              onTap: () {
                launchUrl(Uri.parse("tel:+966551193955"));
              },
              child: Column(
                children: [
                  Center(
                      child: CircleAvatar(
                    radius: 32,
                    backgroundColor: getBgColor(),
                    child: SvgPicture.asset('assets/svg/profile/call.svg'),
                  )),
                  kHeight12,
                  CustomText(
                    fontSize: 15,
                    text: 'Phone Support',
                  ),
                  kHeight16,
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: CustomText(
                      color: PetVeterinaryColors.supportNumberColor,
                      fontSize: 15,
                      text: '+966 551193955',
                    ),
                  ),
                  kHeight20,
                ],
              ),
            ),
            kHeight16,
            GestureDetector(
              onTap: () {
                launchUrl(Uri.parse("mailto:h.jameel@unitedgroup.sa"));
              },
              child: Column(
                children: [
                  Center(
                    child: CircleAvatar(
                        radius: 32,
                        backgroundColor: getBgColor(),
                        child: Image.asset(
                          AppPngImages.supportEmailPngImg,
                          height: 32,
                          width: 32,
                        )),
                  ),
                  kHeight12,
                  CustomText(
                    fontSize: 15,
                    text: 'Email Support',
                  ),
                  kHeight16,
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: CustomText(
                      color: PetVeterinaryColors.supportNumberColor,
                      fontSize: 15,
                      text: 'h.jameel@unitedgroup.sa',
                    ),
                  ),
                  kHeight20,
                ],
              ),
            ),
          ],
        ));
  }
}
