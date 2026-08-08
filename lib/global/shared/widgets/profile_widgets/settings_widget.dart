import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_png_images.dart';

import '../../../../screens/farm/domain/entities/farm_profile_items.dart';
import '../../../util/common/common_utils.dart';
import '../custom_widgets/custom_expansion_tile.dart';

class SettingsWidget extends StatefulWidget {
  final AppType? appType;
  final Function() onLanguageChange;
  final bool isFromVet;
  final bool isFromFarm;
  const SettingsWidget({
    super.key,
    required this.onLanguageChange,
    this.appType,
    this.isFromVet = false,
    this.isFromFarm = false,
  });

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final data = FarmProfileItems(
    icon: AppPngImages.profileSettingsPngIcon,
    title: 'Settings',
    children: [
      FarmProfileChildItem(value: 'Language'),
      // FarmProfileChildItem(value: 'Theme'),
      // FarmProfileChildItem(value: 'Communication Preferences', needArrow: true),
      FarmProfileChildItem(value: 'Contact Us', needArrow: true),
      FarmProfileChildItem(value: 'Support', needArrow: true),
      FarmProfileChildItem(value: 'About App', needArrow: true),
      FarmProfileChildItem(value: 'Terms and conditions', needArrow: true),
      FarmProfileChildItem(value: 'Privacy Policy', needArrow: true),
      FarmProfileChildItem(value: 'Delete Account', color: Colors.red),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
        onLanguageChange: () {
          widget.onLanguageChange();
        },
        // isExpanded: false,
        onExpansionChanged: (bool expanded) {
          // Handle expansion state change if needed
        },
        icon: data.icon,
        title: data.title,
        children: data.children,
        isFromFarm: widget.isFromFarm,
        isFromVet: widget.isFromVet);
  }
}
