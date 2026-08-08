import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_png_images.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/feed/presentation/authentication/widgets/guest_guard.dart';
import 'package:ufc_mobile/screens/feed/presentation/category/pages/category_screen.dart';
import 'package:ufc_mobile/screens/feed/presentation/home/pages/feed_home.dart';
import 'package:ufc_mobile/screens/feed/presentation/product/pages/feed_cart_screen.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/pages/feed_profile_page.dart';

import '../../../application/authentication/auth_cubit.dart';
import '../../../application/cart/cart_cubit.dart';

class FeedBottomBarUtils {
  static List<String> tabNames = [
    "Home",
    "Products",
    "Cart",
    "Profile",
  ];

  static Widget getPageForTab(String name, BuildContext context) {
    switch (name) {
      case "Home":
        return Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.315,
            ),
            child: FeedHomePage());

      case "Products":
        return CategoryScreen(key: CategoryScreen.categoryKey);

      case "Cart":
        final cartCubit = context.read<CartCubit>();
        final authUser = context.read<AuthCubit>().currentUser;
        if (authUser != null) {
          cartCubit.fetchCart();
        }

        return BlocProvider.value(
          value: cartCubit,
          child: GuestGuard(
              color: primaryColor,
              appType: AppType.feed,
              child: FeedCartScreen()),
        );

      case "Profile":
        return GuestGuard(
            color: primaryColor,
            appType: AppType.feed,
            child: FeedProfilePage());

      default:
        return const Center(child: Text("Page not found"));
    }
  }

  static String? getIconForTab(String name, {required bool isSelected}) {
    switch (name) {
      case "Home":
        return isSelected
            ? AppPngImages.feedHomeSelectedIcon
            : AppPngImages.feedHomeUnselectedIcon;
      case "Products":
        return isSelected
            ? AppPngImages.feedCategorySelectedIcon
            : AppPngImages.feedCategoryUnselectedIcon;
      case "Cart":
        return isSelected
            ? AppPngImages.feedCartSelectedIcon
            : AppPngImages.feedCartUnselectedIcon;
      case "Profile":
        return isSelected
            ? AppPngImages.feedAccountSelectedIcon
            : AppPngImages.feedAccountUnselectedIcon;
    }
    return null;
  }
}
