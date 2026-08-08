import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/cart/widgets/cart/cart_carrier_groups_list.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

// Bottom Sheet for Displaying Carrier Numbers
Widget carrierNumberBtmSheet() {
  return LayoutBuilder(
      builder: (context, constraints) => DraggableScrollableSheet(
          expand: false,
          maxChildSize: constraints.maxWidth < 400 ? 0.9 : 0.8,
          minChildSize: constraints.maxWidth < 400 ? 0.8 : 0.7,
          initialChildSize: constraints.maxWidth < 400 ? 0.9 : 0.8,
          builder: (context, scrollController) => Column(children: [
                Expanded(
                    child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        children: [
                      const SizedBox(height: 19),
                      Align(
                        alignment: Alignment.center,
                        child: CustomText(
                          text:
                              // "Carriers we highly recommend",
                              "Recommended Carriers",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: CustomText(
                          text:
                              // "United Feed Company hereby declares that it is not responsible for any delay or damage to goods after they leave the station. It is also not obligated to pay or bear any costs related to loading, unloading, transportation, or delay. United Feed Company has provided some carrier numbers to facilitate the purchase process for its customers. The carrier's responsibility lies entirely with the customer. The customer will communicate with the carrier and agree with them without any burden or follow-up from United Feed Company.",
                              "I acknowledge and undertake that United Feed Company is not responsible for the recommended carriers whose contact numbers are shown on this website, and I acknowledge that United Feed Company is not obligated to pay any costs related to the transportation, uploading or downloading of products ordered through this website, and I acknowledge that if any of the products ordered from this website are delayed in arriving, United Feed Company shall not be liable for any delay resulting from such delay, and I acknowledge that United Feed Company's provision of this recommendation is for the sole purpose of facilitating customers. I acknowledge that the United Feed Company is not responsible for any liability that may result from this delay, and I acknowledge that the United Feed Company provides this recommendation for the purpose of facilitating the customers only, and I hereby undertake to bear all the consequences related to the choice of the carrier and release the United Feed Company from any liability that may result from this.",
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFF565656),
                        ),
                      ),
                      const SizedBox(height: 45),
                      Align(
                        alignment: Alignment.center,
                        child: CustomText(
                          text: "Carriers numbers",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Directionality(
                          textDirection: TextDirection.ltr,
                          child: CartCarrierGroupsList(ctx: context)),
                      const SizedBox(height: 55),
                    ])),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 3, left: 53, right: 53, bottom: 23),
                    child: CustomButton(
                      width: double.infinity,
                      title: "I Agree",
                      onTap: () => Navigator.pop(context, true),
                    )),
              ])));
}
