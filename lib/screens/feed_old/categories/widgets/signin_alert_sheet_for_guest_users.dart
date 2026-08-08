import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_colors.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_fontstyles.dart';

import '../../../../global/extensions/app_colors.dart';
import '../../../../global/util/common/common_utils.dart';

Future<void> showUnauthorizedBottomSheet(BuildContext context,
    {required VoidCallback onSignInPressed,
    AppType? appType,
    bool isDismissible = true}) {
  return showModalBottomSheet<void>(
    enableDrag: isDismissible,
    isDismissible: isDismissible,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return SizedBox(
          height: 280,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Lottie Animation
                Lottie.asset(
                  'assets/animations/auth_icon_animation.json',
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),
                // const SizedBox(height: 5),
                // Title
                Text(
                  'You are not registered!'.tr(),
                  style: const TextStyle(
                    fontSize: 16, // Reduced font size for better alignment
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                // Subtitle
                Text(
                  'Please sign in to access this page.'.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                // Sign-In Button
                InkWell(
                  onTap: onSignInPressed,
                  splashColor: Colors.green[300],
                  borderRadius: BorderRadius.circular(9.0),
                  child: Ink(
                    height: 42,
                    width: 260,
                    decoration: BoxDecoration(
                      color: appType == AppType.farm
                          ? AppColors.farmColor
                          : const Color(0xff78B833),
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Go to Sign In'.tr(),
                            style: LoyalityPointsFontstyles
                                .bottomSheetButtonTextStyle
                                .copyWith(
                                    color: LoyalityPointsColors
                                        .lpMainTitleTextColor),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons
                                .login, // Use a suitable icon from Material Icons, e.g., login.
                            size: 16, // Adjust size as needed.
                            color: LoyalityPointsColors
                                .lpMainTitleTextColor, // Match the color with text.
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                    height: 20), // Ensure no extra free space at the bottom
              ],
            ),
          ));
    },
  );
}
