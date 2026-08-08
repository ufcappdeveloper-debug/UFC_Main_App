import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/models/recent_transaction_model.dart';
import 'package:ufc_mobile/riverpod/transactions/transactions_provider.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_appbar.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

import '../../../../global/shared/widgets/custom_reload_provider.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';

class RecentTransactions extends ConsumerStatefulWidget {
  const RecentTransactions({super.key});

  @override
  ConsumerState<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends ConsumerState<RecentTransactions>
    with ScreenEngagementTracker {
  @override
  void initState() {
    Future(() => ref.read(transactionsProvider.notifier).getAllTransactions());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final transactionsDataProvider = ref.watch(transactionsProvider);
    return Scaffold(
      appBar: CustomAppbar(title: "Recent Transactions"),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: transactionsDataProvider.when(
              data: (recentTransactions) => recentTransactions.isEmpty
                  ? Center(
                      child: Text("No Data Available".tr()),
                    )
                  : ListView(
                      children: List.generate(
                        recentTransactions.length,
                        (index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: CustomText(
                                text: getFormattedDate(
                                    recentTransactions[index].date!),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, indexed) {
                                final List<Result> result =
                                    recentTransactions[index].result ?? [];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    backgroundColor: const Color(0xFFE8FFCF),
                                    radius: 21,
                                    child: CustomText(
                                      text: (result[indexed].title ?? 'UFC')
                                          .characters
                                          .first
                                          .toUpperCase(),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 21,
                                      color: Colors.black,
                                    ),
                                  ),
                                  title: CustomText(
                                    text: result[indexed].title ?? 'UFC',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                  subtitle: CustomText(
                                    text:
                                        '${getFormattedSecondaryDate(result[indexed].createdAt!)} • ${getFormattedSecondaryTime(result[indexed].createdAt!)}',
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
                                            "${result[indexed].type == "ADDITION" ? '' : '-'}${(result[indexed].amount ?? 0.0)}",
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            result[indexed].type == "ADDITION"
                                                ? primaryColor
                                                : Colors.red,
                                      ),
                                      // CustomText(
                                      //   text: "SAR",
                                      //   fontSize: 12,
                                      //   fontWeight: FontWeight.w300,
                                      //   color:
                                      //       result[indexed].type == "ADDITION"
                                      //           ? primaryColor
                                      //           : Colors.red,
                                      // ),
                                      SaudiRiyalIcon(
                                        size: 12,
                                        color:
                                            result[indexed].type == "ADDITION"
                                                ? primaryColor
                                                : Colors.red,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, _) => const Divider(),
                              itemCount:
                                  recentTransactions[index].result?.length ?? 0,
                            )
                          ],
                        ),
                      ),
                    ),
              error: (e, s) => CustomReloadProvider(
                    height: 118,
                    onPressed: () => ref.refresh(transactionsProvider),
                  ),
              loading: () => Center(
                      child: CircularProgressIndicator.adaptive(
                    backgroundColor:
                        Platform.isIOS ? mediumGreenColor : Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation(mediumGreenColor),
                  )))),
    );
  }
}

String getFormattedDate(String s) {
  final dateTime = DateTime.parse(s).toLocal();
  return DateFormat("EEEE, d MMMM y", 'en').format(dateTime);
}

String getFormattedSecondaryDate(String s) {
  final dateTime = DateTime.parse(s).toLocal();
  return DateFormat("MMM d'th' y", 'en').format(dateTime);
}

String getFormattedSecondaryTime(String s) {
  final dateTime = DateTime.parse(s).toLocal();
  return DateFormat("hh:mm a", 'en').format(dateTime);
}
