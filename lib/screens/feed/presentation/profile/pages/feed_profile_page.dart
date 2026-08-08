import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_png_images.dart';
import 'package:ufc_mobile/global/util/common/logout_handler.dart';

import '../../../../../global/shared/constants/constants.dart';
import '../../../../../global/shared/widgets/custom_widgets/custom_expansion_tile.dart';
import '../../../../../global/shared/widgets/profile_widgets/account_widget.dart';
import '../../../../../global/shared/widgets/profile_widgets/logout_widget.dart';
import '../../../../../global/shared/widgets/profile_widgets/settings_widget.dart';
import '../../../../../global/util/common/common_utils.dart';
import '../../../../farm/domain/entities/farm_profile_items.dart';
import '../../../application/authentication/auth_cubit.dart';
import '../widgets/station_widget.dart';

class FeedProfilePage extends StatefulWidget {
  const FeedProfilePage({super.key});

  @override
  State<FeedProfilePage> createState() => _FeedProfilePageState();
}

class _FeedProfilePageState extends State<FeedProfilePage> {
  final accountManagment = FarmProfileItems(
    icon: AppPngImages.accountManagmentPngIcon,
    title: 'Account Management',
    children: [
      FarmProfileChildItem(value: 'My Orders', needArrow: true),
      FarmProfileChildItem(value: 'Favorites', needArrow: true),
      FarmProfileChildItem(value: 'My Wallet', needArrow: true),
      FarmProfileChildItem(value: 'Address', needArrow: true),
      FarmProfileChildItem(value: 'Notifications', needArrow: true),
    ],
  );
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      /// ✅ Always fetch fresh profile
      context.read<AuthCubit>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ListView(padding: const EdgeInsets.all(16), children: [
      AccountTile(),
      kHeight20,
      stationWidget(context),
      kHeight20,
      CustomExpansionTile(
        onLanguageChange: () {},
        // isExpanded: false,
        onExpansionChanged: (bool expanded) {
          // Handle expansion state change if needed
        },
        icon: accountManagment.icon,
        title: accountManagment.title,
        children: accountManagment.children,
      ),
      kHeight20,
      SettingsWidget(
        onLanguageChange: () {
          setState(() {});
        },
      ),
      kHeight20,
      LogoutWidget(
        appType: AppType.feed,
        parentContext: context,
        onLogout: (ctx) => performFullLogout(
          context: ctx,
          appType: AppType.feed,
        ),
      ),
      kHeight20,
    ]));
  }
}
