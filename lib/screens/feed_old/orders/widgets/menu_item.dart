import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';

Container menuItem({
  VoidCallback? onTap,
  String? iconPath,
  double? iconSize = 22,
  String? title,
  String? description,
}) {
  return Container(
    //  color: Colors.blue,
    margin: const EdgeInsets.only(
      left: 20,
      top: 15,
      right: 15,
      // bottom: 20,
    ),
    // height: 40,
    width: double.infinity,
    child: Container(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Row(children: [
          Expanded(
            child: SvgPicture.asset(
              iconPath ?? 'assets/images/profile/shopping-bag.png',
              height: iconSize,
              width: iconSize,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 15,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CustomText(
                              text: (title ?? 'Menu Item').tr(),
                              fontSize: 15,
                              fontWeight: FontWeight.w300),

                          // SvgPicture.asset("assets/images/order/apple_pay.svg",
                          //     color: primaryColor)
                        ],
                      ),
                    ),
                    kWidth10,
                    title == "Payment"
                        ? Image.asset("assets/images/global/sadad.png",
                            height: 20)

                        // SvgPicture.asset(
                        //     "assets/images/order/apple_pay.svg",
                        //   )
                        : Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomText(
                                      text: description ??
                                          "8 Jun2023 at 02:55 PM",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      overflow: TextOverflow.ellipsis,
                                      color: const Color(0xff929292)),
                                ),
                                // if (title == "Delivery address")
                                //   const SizedBox(width: 5),
                                // if (title == "Delivery address")
                                //   SvgPicture.asset(
                                //     "assets/images/order/add.svg",
                                //   )
                              ],
                            ),
                          ),
                  ],
                ),
              ],
            ),
          )
        ]),
      ),
    ),
  );
}
