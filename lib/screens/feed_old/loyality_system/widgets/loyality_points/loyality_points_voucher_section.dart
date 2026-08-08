import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/screens/loyality_points_page.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/model/user_points_model.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/provider/claimed_vouchers.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/provider/user_points.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/utilities/loyality_points_utils.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/utilities/points_calculator.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/widgets/loyality_points_voucher_container.dart';

class LoyalityPointsVoucherSection extends ConsumerWidget {
  const LoyalityPointsVoucherSection({
    super.key,
    required this.vouchers,
  });
  final List<Voucher> vouchers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(userPointsProvider);
    final tiers = points.value?.data?.tiers ?? [];
    int tierMaxPoints = tiers.last.tierMaxPoints ?? 0;
    final int userPoints = points.value?.data?.userPoints ?? 0;
    final int remainingPoints =
        calculateRemainingPoints(userPoints, tierMaxPoints);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rewardsTitle(title: 'Vouchers'),
        const SizedBox(height: 12),
        if (vouchers.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Center(
              child: Text(
                "No reward vouchers available".tr(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            child: Consumer(
              builder: (context, ref, child) {
                final claimedVouchers =
                    ref.watch(claimedVouchersProvider).asData?.value;

                return GridView.builder(
                  itemCount: vouchers.length,
                  shrinkWrap:
                      true, // Important to make GridView work in SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 17,
                    childAspectRatio: 1.3,
                    maxCrossAxisExtent: 197,
                  ),
                  itemBuilder: (context, index) {
                    final voucher = vouchers[index];
                    final isClaimed = claimedVouchers != null &&
                        claimedVouchers.id == voucher.pivot?.voucherId;

                    return LoyalityPointsVoucherContainer(
                      discountType: voucher.type ?? '',
                      voucherCode: voucher.code ?? 'No voucher code',
                      expiryDate: voucher.expiryDate.toString(),
                      amount: voucher.discountValue.toString(),
                      isClaimed: claimedVouchers != null &&
                          claimedVouchers.id == voucher.pivot?.voucherId,
                      onClaim: () async {
                        if (isClaimed) {
                          await LoyalityPointsUtils.unclaimVoucher(context, ref,
                              voucher: voucher);
                        } else {
                          await LoyalityPointsUtils.claimVoucher(context, ref,
                              voucher: voucher,
                              remainingPoints: remainingPoints);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
