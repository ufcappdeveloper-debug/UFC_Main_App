import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/models/checkout/checkout_model.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';
import 'package:ufc_mobile/screens/feed_old/orders/pages/delivery_order_status_page.dart';
import 'package:ufc_mobile/screens/feed_old/orders/pages/order_status_page.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

class OrderSuccessPage extends StatefulWidget {
  const OrderSuccessPage(
      {super.key, this.onPressed, required this.checkoutDetails});
  final VoidCallback? onPressed;
  final CheckoutModel checkoutDetails;

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage>
    with ScreenEngagementTracker {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Image.asset(
                    'assets/images/global/success.png',
                    height: 120,
                    width: 120,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      CustomText(
                        text: (widget.checkoutDetails.checkoutSummary
                                    ?.totalWithVat ??
                                0.00)
                            .toStringAsFixed(2),
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                      ),
                      SaudiRiyalIcon(
                        size: 15,
                        color: primaryColor,
                      ),
                    ],
                  ),
                  CustomText(
                    text: "Your order has been\nprocessed successfully",
                    textAlign: TextAlign.center,
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(30, 51, 84, 1),
                  ),
                  const SizedBox(height: 20),
                  CustomText(
                    text:
                        "Your order has been placed successfully\nThank you for your purchase, you will get\nnotified with your order status",
                    textAlign: TextAlign.center,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: const Color.fromRGBO(30, 51, 84, 1),
                  ),
                  const SizedBox(height: 30),
                  if (widget.checkoutDetails.goPay != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: CustomText(
                                text: 'Bill Number',
                                fontSize: 14,
                                color: const Color(0xff777777),
                              )),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                        text: widget.checkoutDetails.goPay
                                                ?.billNumber ??
                                            '-'))
                                    .whenComplete(() => CustomSnackBar.show(
                                        context,
                                        "${widget.checkoutDetails.goPay?.billNumber} copied to clipboard",
                                        backgroundColor:
                                            const Color(0xFF4D4D4D)));
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                height: 25,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(color: primaryColor)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                        text: widget.checkoutDetails.goPay
                                                ?.billNumber ??
                                            "",
                                        fontSize: 14),
                                    Image.asset("assets/images/cart/copy.png"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (widget.checkoutDetails.goPay != null)
                    const Divider(color: Colors.grey),
                  if (widget.checkoutDetails.goPay != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: CustomText(
                                text: 'SADAD Number',
                                fontSize: 14,
                                color: const Color(0xff777777),
                              )),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                        text: widget.checkoutDetails.goPay
                                                ?.sadadNumber ??
                                            '-'))
                                    .whenComplete(() => CustomSnackBar.show(
                                        context,
                                        "${widget.checkoutDetails.goPay?.sadadNumber} copied to clipboard",
                                        backgroundColor:
                                            const Color(0xFF4D4D4D)));
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                height: 25,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(color: primaryColor)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                        text: widget.checkoutDetails.goPay
                                                ?.sadadNumber ??
                                            "",
                                        fontSize: 14),
                                    Image.asset("assets/images/cart/copy.png"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (widget.checkoutDetails.goPay != null)
                    const Divider(color: Colors.grey),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 5),
                      child: Row(children: [
                        Expanded(
                            flex: 3,
                            child: CustomText(
                              text: 'Payment Type',
                              fontSize: 14,
                              color: const Color(0xff777777),
                            )),
                        if (widget.checkoutDetails.checkoutSummary
                                ?.paymentMethod ==
                            "SADAD")
                          Expanded(
                            flex: 0,
                            child: Image.asset("assets/images/global/sadad.png",
                                height: 30),
                          ),
                        if (widget.checkoutDetails.checkoutSummary
                                ?.paymentMethod !=
                            "SADAD")
                          Expanded(
                              flex: 0,
                              child: CustomText(
                                text: widget.checkoutDetails.checkoutSummary
                                        ?.paymentMethod ??
                                    "",
                                fontSize: 14,
                                color: const Color(0xff777777),
                              )),
                      ])),
                  const SizedBox(height: 80),
                  Column(children: [
                    CustomButton(
                        onTap: () {
                          debugPrint(
                              'order id : ${widget.checkoutDetails.checkoutSummary?.id}');
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => OrderStatusPage(
                          //           orderId:
                          //               checkoutDetails.checkoutSummary?.id)),
                          // );

                          if (widget
                                  .checkoutDetails.checkoutSummary?.orderType ==
                              "DELIVERY") {
                            // Navigate to the page for delivery
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeliveryOrderStatusPage(
                                  orderId: widget
                                      .checkoutDetails.checkoutSummary?.id,
                                ),
                              ),
                            );
                          } else {
                            // Navigate to the page for other orders
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderStatusPage(
                                  orderId: widget
                                      .checkoutDetails.checkoutSummary?.id,
                                ),
                              ),
                            );
                          }
                        },
                        title: "Track my Order",
                        fontSize: 15),
                    const SizedBox(height: 20),
                    CustomButton(
                        onTap: () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BottomBar()),
                            (route) => false),
                        title: "Back to Home",
                        fontSize: 15,
                        textColor: primaryColor,
                        color: Colors.white,
                        border: Border.all(color: primaryColor)),
                  ]),
                ]))));
  }
}
