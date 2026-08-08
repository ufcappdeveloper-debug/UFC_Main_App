import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_page_widgets.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods>
    with ScreenEngagementTracker {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: 'Payment Methods',
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.black.withValues(alpha: 0.3),
          leading: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(50),
              child: const Icon(Icons.arrow_back_ios_rounded,
                  color: Colors.black)),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  checkoutTitle(
                      title: 'Payment Method',
                      margin: const EdgeInsets.only(bottom: 20)),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.grey.withValues(alpha: 0.3),
                          )
                        ]),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: 'Credit / Debit Card Payment',
                              fontWeight: FontWeight.w500,
                            ),
                            Row(
                              children: [
                                Image.asset('assets/images/cart/visa.png',
                                    height: 9),
                                const SizedBox(width: 5),
                                Image.asset('assets/images/cart/mastercard.png',
                                    height: 13),
                                const SizedBox(width: 5),
                                Image.asset('assets/images/cart/mada_logo.png',
                                    height: 9),
                                const SizedBox(width: 5),
                                Image.asset('assets/images/cart/tamara.png',
                                    height: 6),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = 1;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                radioButton(selected: selectedIndex == 1),
                                Image.asset('assets/images/cart/visa.png',
                                    height: 13),
                                const SizedBox(width: 5),
                                CustomText(
                                  text: '**** - **** - 1234',
                                  color: Colors.grey,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                )
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          color: Color.fromRGBO(234, 234, 234, 1),
                          thickness: 1,
                          height: 10,
                        ),
                        const SizedBox(height: 5),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = 2;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                radioButton(selected: selectedIndex == 2),
                                Image.asset('assets/images/cart/mastercard.png',
                                    height: 16),
                                const SizedBox(width: 15),
                                CustomText(
                                  text: '**** - **** - 1234',
                                  color: Colors.grey,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = 3;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.grey.withValues(alpha: 0.3))
                            ]),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            radioButton(selected: selectedIndex == 3),
                            CustomText(
                              text: 'Apple Pay',
                              fontWeight: FontWeight.w500,
                            ),
                            const Spacer(),
                            Image.asset('assets/images/cart/apple_pay.png',
                                height: 33),
                            const SizedBox(width: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = 4;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: Colors.grey.withValues(alpha: 0.3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            radioButton(selected: selectedIndex == 4),
                            CustomText(
                              text: 'Cash on delivery',
                              fontWeight: FontWeight.w500,
                            ),
                            const Spacer(),
                            Image.asset('assets/images/cart/cod_hand.png',
                                height: 33),
                            const SizedBox(width: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              onTap: () {},
              title: 'Add new Card',
              width: 207,
              height: 36,
              color: Colors.white,
              textColor: primaryColor,
              fontSize: 12,
              border: Border.all(color: primaryColor),
            ),
            const SizedBox(height: 200),
            CustomButton(
              onTap: () {},
              title: 'Confirm',
            ),
          ],
        )));
  }
}
