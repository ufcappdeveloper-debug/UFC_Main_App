import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_page_widgets.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/open_map_widget.dart';

class CheckoutStationAddress extends ConsumerWidget {
  const CheckoutStationAddress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferredShopDetails =
        ref.watch(authProvider).asData?.value?.preferredShopDetails;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        checkoutTitle(title: 'Station Address'),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Image.asset(
                  'assets/images/cart/shop_pin.png',
                  height: 22,
                ),
                const SizedBox(width: 5),
                CustomText(
                    text: (isArabic
                            ? preferredShopDetails?.nameAr
                            : isUrdu
                                ? preferredShopDetails?.nameUr
                                : preferredShopDetails?.nameEn) ??
                        '-'),
              ]),
              Container(
                margin: const EdgeInsets.only(left: 7, right: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //NOTE: HIDE THE DISTANCE BECAUSE THIS REQUIRES USER LOCATION TO BE ON
                    /* const SizedBox(height: 5),
                                          Text.rich(TextSpan(
                                            children: <InlineSpan>[
                                              TextSpan(
                                                text: '1.5 KM',
                                                style: TextStyle(
                                                    fontFamily: "Kanit",
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 10),
                                              ),
                                              TextSpan(
                                                text: ' Away'.tr(),
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: 'Kanit',
                                                  fontWeight: FontWeight.w300,
                                                  color: Color.fromRGBO(
                                                      114, 114, 114, 1),
                                                ),
                                              ),
                                            ],
                                          )), */
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: ref
                                  .read(authProvider)
                                  .value
                                  ?.preferredShopDetails
                                  ?.address ??
                              "-",
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          color: const Color.fromRGBO(114, 114, 114, 1),
                        ),
                        CustomButton(
                          onTap: () async {
                            if (preferredShopDetails == null) return;
                            openMapsWidget(preferredShopDetails, context);
                          },
                          height: 20,
                          width: 100,
                          radius: 20,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          boxShadow: const [],
                          border: Border.all(color: primaryGrey, width: 0.8),
                          title: '',
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                    'assets/images/cart/traffic_right_turn.png'),
                                const SizedBox(width: 10),
                                CustomText(
                                    text: 'Direction',
                                    fontSize: 10,
                                    color: primaryColor),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
