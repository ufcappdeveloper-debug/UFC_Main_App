import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

class ReturnExchangePolicy extends StatefulWidget {
  const ReturnExchangePolicy({super.key});

  @override
  State<ReturnExchangePolicy> createState() => _ReturnExchangePolicyState();
}

class _ReturnExchangePolicyState extends State<ReturnExchangePolicy>
    with ScreenEngagementTracker {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: const Color(0xffe5e5e5).withValues(alpha: 0.2),
          elevation: 8,
          title: Column(
            children: [
              CustomText(
                text: 'Return & Exchange Policy',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              CustomText(
                text: 'Last Updated: May 07, 2025'.tr(),
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ],
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child:
                const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: SelectionArea(
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Products can be returned in the following cases:',
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 5),
                    CustomText(
                      text:
                          '1. If the product does not match the description agreed upon in the invoice, in this case, the return request can be completed under the following conditions:',
                      fontSize: 11,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: '   - ',
                          fontSize: 11,
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsetsDirectional.only(start: 8.0),
                            child: CustomText(
                              text:
                                  'The product must be in its original condition and accompanied by the invoice.',
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: '   - ',
                          fontSize: 11,
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsetsDirectional.only(start: 8.0),
                            child: CustomText(
                              text:
                                  "All products can be returned within a period not exceeding 3 days from the date of receiving the order, in order to maintain the product's quality and preservation.",
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      text:
                          '2. If the product is damaged from the same date of receiving the order, and the quality team has confirmed this damage, the product will be replaced for the customer.',
                      fontSize: 11,
                    ),
                  ]),
            ),
          ),
        ));
  }
}
