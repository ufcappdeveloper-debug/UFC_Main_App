import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/widgets/feed_checkout_page_widgets.dart';

import '../../../../../global/shared/widgets/custom_widgets/custom_text.dart';

class FeedCheckoutPaymentMethodCheckCard extends ConsumerWidget {
  const FeedCheckoutPaymentMethodCheckCard({
    super.key,
    this.status,
    this.walletAmount,
    required this.icon,
    required this.title,
    this.isSelected = false,
    required this.onPressed,
  });
  final String icon;
  final String title;
  final String? status;
  final bool isSelected;
  final String? walletAmount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: status == 'DISABLE' || status == 'INACTIVE' ? null : onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              (status == 'INACTIVE')
                  ? const Color.fromARGB(255, 236, 236, 236)
                  : Colors.white,
              BlendMode.modulate,
            ),
            child: status == 'DISABLE'
                ? SizedBox.shrink()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      kWidth5,
                      checkButtonV2(
                        selected: isSelected,
                        onChanged: (val) {
                          onPressed();
                        },
                      ),
                      kWidth5,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: title,
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          if (!isStringEmpty(walletAmount))
                            CustomText(
                              text:
                                  '${'Available balance'.tr()}: $walletAmount',
                              fontWeight: FontWeight.w300,
                            ),
                        ],
                      ),
                      const Spacer(),
                      Image.asset(icon,
                          height: 24, width: 40, color: Colors.black54),
                      const SizedBox(width: 20),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
