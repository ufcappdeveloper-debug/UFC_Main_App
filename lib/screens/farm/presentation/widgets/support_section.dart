import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/extensions/app_png_images.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({
    super.key,
    this.isFromVet = false,
    this.isFromFarm = false,
  });

  final bool isFromVet;
  final bool isFromFarm;

  Color _getBgColor() {
    if (isFromVet) return PetVeterinaryColors.newPetMainColorVeterinary;
    if (isFromFarm) return AppColors.farmColor;
    return primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _SupportItem(
            onTap: () => launchUrl(Uri.parse("tel:+966551193955")),
            icon: SvgPicture.asset(
              'assets/svg/profile/call.svg',
              height: 26,
              width: 26,
              color: Colors.white,
            ),
            bgColor: _getBgColor(),
            title: 'Phone Support',
            subtitle: '+966 551193955',
          ),
          const SizedBox(height: 20),
          _SupportItem(
            onTap: () => launchUrl(Uri.parse("mailto:h.jameel@unitedgroup.sa")),
            icon: Image.asset(
              AppPngImages.supportEmailPngImg,
              height: 30,
              width: 30,
            ),
            bgColor: _getBgColor(),
            title: 'Email Support',
            subtitle: 'h.jameel@unitedgroup.sa',
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SupportItem extends StatelessWidget {
  final VoidCallback onTap;
  final Widget icon;
  final String title;
  final String subtitle;
  final Color bgColor;

  const _SupportItem({
    required this.onTap,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: bgColor,
              child: icon,
            ),
            const SizedBox(height: 14),
            CustomText(
              fontSize: 16,
              text: title,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            Directionality(
              textDirection: TextDirection.ltr,
              child: CustomText(
                color: PetVeterinaryColors.supportNumberColor,
                fontSize: 14.5,
                text: subtitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
