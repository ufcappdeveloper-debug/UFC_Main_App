import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/riverpod/transactions/recent_transactions_provider.dart';
import 'package:ufc_mobile/screens/feed_old/my_wallet/pages/recent_transactions.dart';
import 'package:ufc_mobile/screens/feed_old/my_wallet/widgets/wallet_total_amount_card.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

import '../../../../global/shared/constants/app_colors.dart';
import '../../../../global/shared/widgets/custom_appbar.dart';
import '../../../../global/shared/widgets/custom_reload_provider.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen>
    with ScreenEngagementTracker {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Wallet"),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          children: [
            //* Wallet Total Amount
            WalletTotalAmountCard(),
            const SizedBox(height: 25),

            //* Recent Transactions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Recent Transaction",
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecentTransactions(),
                      ),
                    );
                  },
                  child: CustomText(
                    text: "See all",
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Consumer(
              builder: (context, ref, child) {
                final result = ref.watch(recentTransactionsProvider);
                return Expanded(
                    child: result.when(
                        data: (data) => data.isEmpty
                            ? Center(
                                child: Text("No Data Available".tr()),
                              )
                            : ListView.separated(
                                itemBuilder: (context, index) => ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            const Color(0xFFE8FFCF),
                                        radius: 21,
                                        child: CustomText(
                                          text: (data[index].title ?? 'UFC')
                                              .characters
                                              .first
                                              .toUpperCase(),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 21,
                                          color: Colors.black,
                                        ),
                                      ),
                                      title: CustomText(
                                        text: data[index].title ?? 'UFC',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                      subtitle: CustomText(
                                        text:
                                            '${getFormattedSecondaryDate(data[index].createdAt!)} • ${getFormattedSecondaryTime(data[index].createdAt!)}',
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14,
                                        color: const Color(0XFF737373),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          CustomText(
                                            text:
                                                "${data[index].type == "ADDITION" ? '' : '-'}${(data[index].amount ?? 0.0)}",
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                data[index].type == "ADDITION"
                                                    ? primaryColor
                                                    : Colors.red,
                                          ),
                                          // CustomText(
                                          //   text: "SAR",
                                          //   fontSize: 12,
                                          //   fontWeight: FontWeight.w300,
                                          //   color:
                                          //       data[index].type == "ADDITION"
                                          //           ? primaryColor
                                          //           : Colors.red,
                                          // ),
                                          SaudiRiyalIcon(
                                            size: 12,
                                            color:
                                                data[index].type == "ADDITION"
                                                    ? primaryColor
                                                    : Colors.red,
                                          ),
                                        ],
                                      ),
                                    ),
                                separatorBuilder: (context, _) =>
                                    const Divider(),
                                itemCount: data.length),
                        error: (e, s) => CustomReloadProvider(
                              height: 118,
                              onPressed: () =>
                                  ref.refresh(recentTransactionsProvider),
                            ),
                        loading: () => Center(
                              child: CircularProgressIndicator.adaptive(
                                backgroundColor: Platform.isIOS
                                    ? mediumGreenColor
                                    : Colors.transparent,
                                valueColor: const AlwaysStoppedAnimation(
                                    mediumGreenColor),
                              ),
                            )));
              },
            ),
          ],
        ),
      ),
    );
  }
}
