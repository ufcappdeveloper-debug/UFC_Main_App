import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/payment/bank_details_model.dart';

class CheckoutBackPaymentInfo extends StatelessWidget {
  const CheckoutBackPaymentInfo({
    super.key,
    required this.bankDetails,
  });
  final BankDetailsModel? bankDetails;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'IBAN: ${bankDetails?.iban ?? 'n/a'}',
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                kHeight10,
                CustomText(
                  text: 'Bank Name: ${bankDetails?.bankName ?? 'n/a'}',
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                kHeight10,
                CustomText(
                  text: 'Bank Branch: ${bankDetails?.bankBranch ?? 'n/a'}',
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                kHeight10,
                CustomText(
                  text:
                      'Bank Account Name: ${bankDetails?.bankAccountName ?? 'n/a'}',
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
