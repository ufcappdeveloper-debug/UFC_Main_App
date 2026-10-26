import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Consumer;
import 'package:ufc_mobile/screens/farm/application/members/farm_account_cubit.dart';
import 'package:ufc_mobile/global/extensions/app_png_images.dart';
import 'package:ufc_mobile/global/util/common/logout_handler.dart';

import '../../../../global/shared/constants/constants.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_expansion_tile.dart';
import '../../../../global/shared/widgets/profile_widgets/account_widget.dart';
import '../../../../global/shared/widgets/profile_widgets/logout_widget.dart';
import '../../../../global/shared/widgets/profile_widgets/settings_widget.dart';
import '../../../../global/util/common/common_utils.dart';
import '../../domain/entities/farm_profile_items.dart';

class FarmProfilePage extends ConsumerStatefulWidget {
  final Function() onLanguageChange;
  const FarmProfilePage({
    super.key,
    required this.onLanguageChange,
  });

  @override
  ConsumerState<FarmProfilePage> createState() => _FarmProfilePageState();
}

class _FarmProfilePageState extends ConsumerState<FarmProfilePage> {
  @override
  Widget build(BuildContext context) {
    // Members are managed on the user's own farm only; finance screens need
    // finance access on the selected farm.
    final farm = context.watch<FarmAccountCubit>().state;
    final List<FarmProfileItems> expansionTiles = [
      FarmProfileItems(
        icon: AppPngImages.profileFarmPngIcon,
        title: 'Farm',
        children: [
          FarmProfileChildItem(value: 'Barns', needArrow: true),
          // FarmProfileChildItem(value: 'Veterinary Clinic', needArrow: true),
          // FarmProfileChildItem(value: 'Medications', needArrow: true),
          if (!farm.isOnOwnerFarm)
            FarmProfileChildItem(value: 'Members', needArrow: true),
        ],
      ),
      FarmProfileItems(
        icon: AppPngImages.profileReportsPngIcon,
        title: 'Reports & Statistics',
        children: [
          FarmProfileChildItem(value: 'Reports', needArrow: true),
          if (farm.canViewFinance)
            FarmProfileChildItem(value: 'Expenses and Sales', needArrow: true),
          FarmProfileChildItem(
              value: 'Critical Livestock Assets', needArrow: true),
          FarmProfileChildItem(value: 'Transfer Request', needArrow: true),
        ],
      ),
      FarmProfileItems(
        icon: 'assets/new_design/icons/medical_icon.png',
        title: 'Medical Record',
        children: [
          FarmProfileChildItem(value: 'Booked Appointments', needArrow: true),
          FarmProfileChildItem(value: 'Medical Record', needArrow: true),
        ],
      ),
    ];

    return SafeArea(
        child: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AccountTile(
          isFromFarm: true,
        ),
        kHeight20,
        ...expansionTiles.map(
          (tile) => Column(
            children: [
              CustomExpansionTile(
                onLanguageChange: () {
                  widget.onLanguageChange();
                },
                // isExpanded: false,
                onExpansionChanged: (bool expanded) {
                  // Handle expansion state change if needed
                },
                icon: tile.icon,
                title: tile.title,
                children: tile.children,
                isFromFarm: true,
              ),
              kHeight20,
            ],
          ),
        ),
        SettingsWidget(
          onLanguageChange: () {
            widget.onLanguageChange();
          },
          isFromFarm: true,
        ),
        kHeight20,
        LogoutWidget(
          appType: AppType.farm,
          isFromFarm: true,
          parentContext: context,
          onLogout: (ctx) => performFullLogout(
            context: ctx,
            appType: AppType.farm,
          ),
        ),
        kHeight20,
      ],
    ));
  }
}
