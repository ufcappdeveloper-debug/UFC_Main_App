import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/address/profile_address_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_shadows.dart';

class FeedCheckoutDefaultAddress extends StatelessWidget {
  final ProfileAddressModel? defaultAddress;
  final VoidCallback onAddAddressPressed;
  final Object? errorMessage;
  final bool isLoading;

  const FeedCheckoutDefaultAddress({
    super.key,
    required this.onAddAddressPressed,
    this.defaultAddress,
    this.errorMessage,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading, // show shimmer when loading
      child: Builder(
        builder: (context) {
          // Show error if present
          if (errorMessage != null) {
            return CustomReloadProviderV2(
              error: errorMessage,
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              onPressed: () {},
            );
          }

          // No default address
          if (defaultAddress == null) {
            return Column(
              children: [
                CustomText(
                  text: 'An address is required for checkout*',
                  color: Colors.red,
                ),
                const SizedBox(height: 15),
                CustomButton(
                  onTap: onAddAddressPressed,
                  height: 36,
                  width: 207,
                  radius: 10,
                  color: Colors.white,
                  textColor: primaryColor,
                  border: Border.all(color: primaryColor),
                  fontSize: 13,
                  title: "Add Address",
                  fontFamily: isEnglish
                      ? AppFontsFamily.english
                      : AppFontsFamily.arabic,
                ),
                kHeight10,
              ],
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: PetVeterinaryShadows.standard2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: icon, title, edit
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/feed/location.svg',
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomText(
                          text:
                              defaultAddress?.label == 'work' ? 'Work' : 'Home',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      InkWell(
                        onTap: onAddAddressPressed,
                        child: CustomText(
                          text: 'Edit',
                          fontSize: 13,
                          color: PetVeterinaryColors.mainColorUFC,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Address row aligned with icon

                  CustomText(
                    text: defaultAddress?.address ?? '',
                    fontSize: 13,
                    color: PetVeterinaryColors.newPetDarkGray,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
