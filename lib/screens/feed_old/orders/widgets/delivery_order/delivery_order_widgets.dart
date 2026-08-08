import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/cart/extensions/cart_colors.dart';
import 'package:ufc_mobile/screens/feed_old/cart/extensions/cart_fonts.dart';
import 'package:ufc_mobile/global/shared/functions/url_launcher.dart';

Widget customtitleAndValue({required String title, required String value}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        title,
        style: CartFonts.lightHeadingTextStyle
            .copyWith(color: CartColors.lightHeadingTextColor),
      ),
      Text(
        value,
        style: CartFonts.boldTextStyle.copyWith(
          color: CartColors.boldTextColor,
        ),
      )
    ],
  );
}

Widget customtitleAndValueForOrderStatus(
    {required String title, required String value}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title.tr(),
        style: CartFonts.boldTextStyle.copyWith(
          color: CartColors.boldTextColor,
        ),
      ),
      Text(
        value.tr(),
        style: CartFonts.smallSigninTextStyle
            .copyWith(color: CartColors.lightHeadingTextColor),
      ),
    ],
  );
}

Widget driverContactCardView({
  String? value,
  String? driverImg,
  required String title,
  required String customerPhone,
  required BuildContext context,
}) {
  return Container(
    height: 56,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: CartColors.borderColor,
        width: 1,
      ),
    ),
    padding: const EdgeInsets.fromLTRB(12, 5, 6, 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            ClipOval(
              child: Container(
                  width: 46,
                  height: 46, // Diameter of the circle
                  color: Colors
                      .grey[200], // Optional background color for the circle
                  child: driverImg != null && driverImg.isNotEmpty
                      ? Image.network(
                          driverImg,
                          fit: BoxFit
                              .cover, // Ensures the image covers the circle area
                          errorBuilder: (context, error, stackTrace) {
                            // Display a fallback if the image URL is invalid or fails to load
                            return Container(
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.person, // Placeholder icon
                                size: 24,
                                color: Colors.grey[500], // Icon color
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.person, // Placeholder icon
                            size: 24,
                            color: Colors.grey[500], // Icon color
                          ),
                        )),
            ),
            const SizedBox(
              width: 30,
            ),
            if (value != null) customtitleAndValue(title: title, value: value),
          ],
        ),
        GestureDetector(
          onTap: () async {
            try {
              launchPhoneCall(customerPhone);
            } catch (e) {
              // if (!mounted) return;
              // CustomSnackBar.error(context, e.toString());
            }
          },
          child: ClipOval(
            child: Image.asset(
              'assets/images/call_green.png',
              width: 46,
              height: 46,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    ),
  );
}
