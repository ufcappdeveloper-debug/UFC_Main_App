import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/functions/is_network_error.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/no_internet.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';

import '../../../../../global/extensions/saudi_riyal_icon.dart';
import '../../../../../global/shared/constants/app_colors.dart';
import '../../../../../global/shared/constants/constants.dart';
import '../../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../../../../../global/util/mixin/screen_engagement_tracker.dart';
import '../../../../feed_old/my_wallet/widgets/wallet_total_amount_card.dart';
import '../../../application/wallet/wallet_cubit.dart';
import '../../../application/wallet/wallet_state.dart';

class FeedWalletScreen extends StatefulWidget {
  const FeedWalletScreen({super.key});

  @override
  State<FeedWalletScreen> createState() => _FeedWalletScreenState();
}

class _FeedWalletScreenState extends State<FeedWalletScreen>
    with ScreenEngagementTracker {
  void callApi() {
    context
        .read<WalletCubit>()
        .fetchWalletTransactions(DateTime.now().timeZoneName);
  }

  @override
  void initState() {
    super.initState();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        final List allResults = state is WalletLoaded
            ? state.transactions.expand((tx) => tx.result ?? []).toList()
            : [];
        return Scaffold(
          appBar: AppBar(
            title: CustomText(
              text: 'Wallet',
              // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
              fontFamily:
                  isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
              fontSize: 18,
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            // elevation: 1,
          ),
          body: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              children: [
                state is WalletError && isNetworkError(state.message)
                    ? SizedBox.shrink()
                    : Column(
                        children: [
                          WalletTotalAmountCard(),
                          const SizedBox(height: 25),

                          /// Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                fontFamily:
                                    isArOrUr ? 'Graphik Arabic' : 'Kanit',
                                text: "Recent Transactions",
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),

                /// Transactions List
                Expanded(
                    child: state is WalletLoading
                        ? Center(
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: Platform.isIOS
                                  ? mediumGreenColor
                                  : Colors.transparent,
                              valueColor: const AlwaysStoppedAnimation(
                                  mediumGreenColor),
                            ),
                          )
                        : state is WalletLoaded
                            ? state.transactions.isEmpty
                                ? Center(
                                    child: CustomText(
                                    fontSize: 16,
                                    text: "No Data Available",
                                    fontFamily: isEnglish
                                        ? AppFontsFamily.english
                                        : AppFontsFamily.arabic,
                                  ))

                                // Flatten transactions (grouped by date → results)

                                : RefreshIndicator(
                                    onRefresh: () async {
                                      await context
                                          .read<WalletCubit>()
                                          .fetchWalletTransactions(
                                              DateTime.now().timeZoneName);
                                    },
                                    child: ListView.separated(
                                      itemBuilder: (context, index) {
                                        final tx = allResults[index];
                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: CustomText(
                                            text: tx.title?.toString().tr() ??
                                                'UFC',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: Colors.black,
                                          ),
                                          subtitle: CustomText(
                                            text:
                                                formatDate(tx.createdAt ?? ''),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                            color: const Color(0xFF737373),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SaudiRiyalIcon(
                                                size: 16,
                                                color: tx.type == "ADDITION"
                                                    ? primaryColor
                                                    : Colors.red,
                                              ),
                                              const SizedBox(width: 4),
                                              CustomText(
                                                text:
                                                    "${tx.type == "ADDITION" ? '' : '-'}${tx.amount ?? 0}",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: tx.type == "ADDITION"
                                                    ? primaryColor
                                                    : Colors.red,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, _) =>
                                          const Divider(),
                                      itemCount: allResults.length,
                                    ),
                                  )
                            : state is WalletError
                                ? isNetworkError(state.message)
                                    ? NoInternet(
                                        type: AppType.feed,
                                        onTap: () => callApi(),
                                      )
                                    : Center(
                                        child: CustomReloadProviderV2(
                                          error: state.message,
                                          height: 120,
                                          decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          onPressed: () {
                                            context
                                                .read<WalletCubit>()
                                                .fetchWalletTransactions(
                                                    DateTime.now()
                                                        .timeZoneName);
                                          },
                                        ),
                                      )
                                : const SizedBox()),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatDate(String rawDate) {
    try {
      final dateTime = DateTime.parse(rawDate);
      final locale = context.locale.languageCode;

      final monthName = DateFormat('MMMM', locale).format(dateTime);
      String amPm = DateFormat('a', locale).format(dateTime);

      if (locale == 'ur') {
        amPm = amPm == 'AM' ? 'صبح' : 'شام';
      }

      final day = dateTime.day;
      final year = dateTime.year;
      final hour = DateFormat('hh').format(dateTime);
      final minute = DateFormat('mm').format(dateTime);

      return '$day $monthName $year • $hour:$minute $amPm';
    } catch (_) {
      return rawDate;
    }
  }
}
