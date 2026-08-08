import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/extensions/app_png_images.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_expansion_tile.dart';
import 'package:ufc_mobile/global/shared/widgets/profile_widgets/account_widget.dart';
import 'package:ufc_mobile/global/shared/widgets/profile_widgets/logout_widget.dart';
import 'package:ufc_mobile/global/shared/widgets/profile_widgets/settings_widget.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/global/util/common/logout_handler.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/farm_profile_items.dart';
import 'package:ufc_mobile/screens/feed/presentation/authentication/widgets/guest_guard.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

class VetUserProfilePage2 extends ConsumerStatefulWidget {
  const VetUserProfilePage2({super.key});

  @override
  ConsumerState<VetUserProfilePage2> createState() =>
      _VetUserProfilePage2State();
}

class _VetUserProfilePage2State extends ConsumerState<VetUserProfilePage2> {
  final medicalConatiner = FarmProfileItems(
    icon: AppPngImages.profileMedicalPngIcon,
    title: 'Medical Record',
    children: [
      FarmProfileChildItem(value: 'Booked Appointments', needArrow: true),
      // FarmProfileChildItem(value: 'Medical Record', needArrow: true),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: GuestGuard(
                color: PetVeterinaryColors.newPetMainColorVeterinary,
                appType: AppType.veterinary,
                child: ListView(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 40,
                  ),
                  children: [
                    AccountTile(
                      isFromVet: true,
                    ),
                    kHeight20,
                    CustomExpansionTile(
                      onLanguageChange: () {},
                      // isExpanded: false,
                      onExpansionChanged: (bool expanded) {
                        // Handle expansion state change if needed
                      },
                      icon: medicalConatiner.icon,
                      title: medicalConatiner.title,
                      children: medicalConatiner.children,
                    ),
                    kHeight20,
                    SettingsWidget(
                      onLanguageChange: () {
                        setState(() {});
                      },
                      isFromVet: true,
                    ),
                    kHeight20,
                    LogoutWidget(
                      appType: AppType.veterinary,
                      isFromVet: true,
                      parentContext: context,
                      onLogout: (ctx) => performFullLogout(
                        context: ctx,
                        appType: AppType.veterinary,
                      ),
                    ),
                    kHeight20,
                  ],
                ))));
  }
}
