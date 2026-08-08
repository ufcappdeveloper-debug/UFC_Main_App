import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/models/cart_item_model.dart';
import 'package:ufc_mobile/screens/feed_old/cart/pages/cart_page.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/model/user_points_model.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/provider/claimed_vouchers.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/provider/user_points.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/widgets/claim_bottom_sheet.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/widgets/voucher_claim_bottom_sheet.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';

class LoyalityPointsUtils {
  static Future<void> claimProduct(State state, WidgetRef ref,
      {required Product product, required int remainingPoints}) async {
    try {
      Future future = ref.read(userPointsProvider.notifier).claimProduct(
            product.tierId ?? 0,
            product.id ?? 0,
            product.variantId ?? 0,
          );

      await LoadingDialog.show(state.context, future);

      rewardAddToCartButtonAction(
        state.context,
        isSuccessful: true,
        onButtonPressed: () {
          Navigator.pushReplacement(
            state.context,
            MaterialPageRoute(
              builder: (context) => CartPage(
                isFromLoyalty: true,
              ),
            ),
          );
        },
      );
    } catch (e) {
      rewardAddToCartButtonAction(
        state.context,
        remainingPoints: remainingPoints.toString(),
        isSuccessful: false,
        onButtonPressed: () {
          Navigator.pop(state.context);
        },
      );
    }
  }

  static Future<void> unclaimProduct(State state, WidgetRef ref,
      {required CartItemModel claimedProduct}) async {
    try {
      Future future = ref.read(userPointsProvider.notifier).unclaimProduct(
          claimedProduct.id ?? 0, claimedProduct.productId ?? 0);
      // Show loading dialog while performing the operation
      await LoadingDialog.show(state.context, future);

      safeSetState(state, () {});

      if (!state.mounted) return;
      CustomSnackBar.success(state.context, "Product has been unclaimed!");
    } catch (e) {
      // If an error occurs, update isSuccessful to false
      CustomSnackBar.error(state.context, "Failed to unclaim the product!");
    }
  }

  ///////////* <------ Loyalty Points Voucher Functionality ------> *///////////

  static Future<void> claimVoucher(BuildContext context, WidgetRef ref,
      {required Voucher voucher, required int remainingPoints}) async {
    try {
      Future future = ref.read(userPointsProvider.notifier).claimVoucher(
          voucher.pivot?.voucherId ?? 0, voucher.pivot?.tierId ?? 0);
      // Show loading dialog while performing the operation
      await LoadingDialog.show(context, future);
      await ref.read(claimedVouchersProvider.notifier).fetchClaimedVouchers();
      if (!context.mounted) return;
      // If successful, update isSuccessful to true
      rewardVocuherClaimBtnAction(
        context,
        isSuccessful: true,
        onButtonPressed: () {},
      );
    } catch (e) {
      if (!context.mounted) return;
      // If an error occurs, update isSuccessful to false
      rewardVocuherClaimBtnAction(
        context,
        isSuccessful: false,
        remainingPoints: remainingPoints.toString(),
        errorMessage: 'Claim failed: $e',
        onButtonPressed: () {},
      );
    }
  }

  static Future<void> unclaimVoucher(BuildContext context, WidgetRef ref,
      {required Voucher voucher}) async {
    try {
      Future future = ref.read(userPointsProvider.notifier).unclaimVoucher(
          voucher.pivot?.voucherId ?? 0, voucher.pivot?.tierId ?? 0);
      // Show loading dialog while performing the operation
      await LoadingDialog.show(context, future);
      await ref.read(claimedVouchersProvider.notifier).fetchClaimedVouchers();
      if (!context.mounted) return;
      CustomSnackBar.success(context, "Voucher has been unclaimed!");
    } catch (e) {
      // If an error occurs, update isSuccessful to false
      CustomSnackBar.error(context, "Failed to unclaim the voucher!");
    }
  }
}
