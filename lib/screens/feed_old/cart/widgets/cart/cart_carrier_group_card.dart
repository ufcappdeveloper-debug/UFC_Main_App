import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/models/shop_carrier_group_model.dart';
import 'package:ufc_mobile/screens/feed_old/cart/widgets/cart/cart_carriers_number_card.dart';
import 'package:ufc_mobile/global/shared/functions/url_launcher.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_cached_image.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class CartCarrierGroupCard extends StatefulWidget {
  const CartCarrierGroupCard({super.key, required this.shopCarrierGroupData});
  final ShopCarrierGroupModel shopCarrierGroupData;

  @override
  State<CartCarrierGroupCard> createState() => _CartCarrierGroupCardState();
}

class _CartCarrierGroupCardState extends State<CartCarrierGroupCard> {
  String? selectedNumber;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: isShopCarriersEmpty
                    ? [
                        CustomText(
                            text: "Soon",
                            fontSize: 15,
                            fontWeight: FontWeight.w500)
                      ]
                    : widget.shopCarrierGroupData.shopCarriers!
                        .map((carrier) => Padding(
                              padding: const EdgeInsets.only(bottom: 18),
                              child: CartCarriersNumberCard(
                                number: getCarrierNumber(carrier),
                                selectedNumber: selectedNumber ?? "",
                                onPressed: (details) async {
                                  try {
                                    if (details.localPosition.dx <= 100) {
                                      // Tapped on the first half
                                      launchPhoneCall(
                                          getCarrierNumber(carrier));
                                    } else {
                                      // Tapped on the second half
                                      await Clipboard.setData(ClipboardData(
                                          text: getCarrierNumber(carrier)));
                                      setState(() => selectedNumber =
                                          getCarrierNumber(carrier));
                                    }
                                  } catch (e) {
                                    if (!mounted) return;
                                    CustomSnackBar.error(context, e.toString());
                                  }
                                },
                              ),
                            ))
                        .toList(),
              ),
            ),
          ),
          Container(
              width: 1,
              color: const Color(0xFFE2E2E2),
              margin: const EdgeInsets.symmetric(horizontal: 15)),
          Expanded(
              flex: 1,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                child: CustomCachedImage(
                    height: 77,
                    fit: BoxFit.contain,
                    imageUrl: widget.shopCarrierGroupData.image,
                    noImagePlaceholderWidget: SvgPicture.asset(
                        'assets/images/global/No-Image-Placeholder.svg',
                        fit: BoxFit.contain,
                        height: 99)),
              )),
        ],
      ),
    );
  }

  bool get isShopCarriersEmpty {
    if (widget.shopCarrierGroupData.shopCarriers == null ||
        widget.shopCarrierGroupData.shopCarriers!.isEmpty) {
      return true;
    }
    return false;
  }

  String getCarrierNumber(ShopCarriermodel carrier) {
    String code = carrier.countryCode ?? "";
    String number = carrier.phoneNumber ?? "";
    if (number.isNotEmpty) {
      if (code.isNotEmpty) return "+$code-$number";
      return number;
    }
    return "";
  }
}
