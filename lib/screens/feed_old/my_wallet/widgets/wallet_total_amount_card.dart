import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

import '../../../feed/application/wallet/wallet_cubit.dart';
import '../../../feed/application/wallet/wallet_state.dart';


class WalletTotalAmountCard extends StatelessWidget {
  const WalletTotalAmountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        double walletAmount = 0;

        if (state is WalletLoaded) {
          // Flatten all Result objects across all FeedWalletModels
          final allResults = state.transactions.expand((e) => e.result ?? []).toList();

          // Calculate wallet balance
          walletAmount = allResults.fold(0, (total, tx) {
            final amt = tx.amount ?? 0;
            return tx.type == "ADDITION" ? total + amt : total - amt;
          });
        }

        return Material(
          elevation: 2,
          color: Colors.white,
          shadowColor: Colors.black38,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 101,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/profile/wallet_amount_card.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Total Balance",
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            CustomText(
                              text: walletAmount.toStringAsFixed(2),
                              fontSize: 40,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            const SaudiRiyalIcon(
                              size: 20,
                              color: Colors.white,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                ],
              ),
            ],
          ),
        );
      },
    );

  }
}
