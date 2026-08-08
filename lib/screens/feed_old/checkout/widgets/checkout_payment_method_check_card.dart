import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_page_widgets.dart';

class CheckoutPaymentMethodCheckCard extends ConsumerWidget {
  const CheckoutPaymentMethodCheckCard({
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
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 30),
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
                      checkButton(selected: isSelected),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Kanit',
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(text: title),
                            if (!isStringEmpty(walletAmount))
                              TextSpan(text: ' ($walletAmount)'),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                        icon,
                        height: 25,
                        color: isSelected ? primaryColor : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
