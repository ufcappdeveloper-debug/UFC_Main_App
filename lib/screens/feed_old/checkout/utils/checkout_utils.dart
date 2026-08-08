import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/data/payment_service.dart';
import 'package:ufc_mobile/models/address_model.dart';
import 'package:ufc_mobile/models/checkout/checkout_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/coupon/coupon_model.dart';

import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/state.dart';
import 'package:ufc_mobile/screens/feed_old/cart/pages/order_success_page.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/enum/payment_option.dart';
import 'package:ufc_mobile/screens/feed_old/payment/pages/mada_payment_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary/survey/pages/survey_flow.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/global/shared/functions/dio.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/analytic/adjust_tracker.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/global/util/exception/app_exception.dart';
import 'package:ufc_mobile/global/util/extension/bool_extensions.dart';
import 'package:ufc_mobile/global/util/lang/langauge_manager.dart';
import 'package:ufc_mobile/global/util/navigation/navigation.dart';

class CheckoutUtils {
  static bool isCheckingOut = false;

  static Future<void> checkout(
    State state,
    WidgetRef ref, {
    required int quantity,
    required bool directBuy,
    required bool isDelivery,
    required String addressId,
    required String bookingTime,
    required double walletAmount,
    required String? voucherCode,
    required bool isWalletChecked,
    required bool isVoucherClaimed,
    required double deliveryAmount,
    required CouponModel? couponData,
    required ProductModel? productItem,
    required AddressModel? defaultAddress,
    required PaymentOptionsEnum selectedPaymentOption,
    required TextEditingController driverNameController,
    required TextEditingController plateNumberController,
  }) async {
    if (selectedPaymentOption == PaymentOptionsEnum.wallet &&
        walletAmount == 0) {
      throw 'wallet_balance_zero'.tr(args: ['{currency}']);
    }

    try {
      safeSetState(state, () => isCheckingOut = true);

      final FormData data = _buildFormData(
        quantity: quantity,
        directBuy: directBuy,
        addressId: addressId,
        isDelivery: isDelivery,
        couponData: couponData,
        bookingTime: bookingTime,
        voucherCode: voucherCode,
        productItem: productItem,
        walletChecked: isWalletChecked,
        deliveryAmount: deliveryAmount,
        voucherClaimed: isVoucherClaimed,
        paymentOption: selectedPaymentOption,
        driverName: driverNameController.text,
        plateNumber: plateNumberController.text,
      );

      await handlePayment(
        state,
        ref,
        data: data,
        directBuy: directBuy,
        selectedPaymentOption: selectedPaymentOption,
      );
    } catch (e) {
      if (!state.mounted) return;
      if (e is DioException) {
        if (e.error == 'Required fields are missing') {
          throw CustomException(
              message:
                  'The phone number associated with your address is invalid');
        } else if (addressId.isEmpty) {
          throw CustomException(
              message: getErrorMessage('Address is required'));
        }
      }

      rethrow;
    } finally {
      safeSetState(state, () => isCheckingOut = false);
    }
  }

  static FormData _buildFormData({
    required int quantity,
    required bool directBuy,
    required bool isDelivery,
    required String addressId,
    required String driverName,
    required String bookingTime,
    required bool walletChecked,
    required String plateNumber,
    required String? voucherCode,
    required bool voucherClaimed,
    required double deliveryAmount,
    required CouponModel? couponData,
    required ProductModel? productItem,
    required PaymentOptionsEnum paymentOption,
  }) {
    if (directBuy && productItem?.variants?.isEmpty == true) {
      throw CustomException(
          message: "Oops! We couldn't find any products. Something went wrong");
    }
    if (isDelivery && deliveryAmount == 0) {
      throw CustomException(
          message: "Sorry! Delivery is unavailable at the moment");
    }
    return FormData.fromMap({
      if (directBuy) "quantity": quantity,
      if (isDelivery) ...{
        "address_id": addressId,
        "order_type": "DELIVERY",
        "booking_date_time": bookingTime,
      },
      "driver_name": driverName,
      "driver_plate": plateNumber,
      "use_wallet": walletChecked.toNum(),
      "payment_method": paymentOption.getValue,
      if (directBuy) "product_id": productItem?.id,
      if (voucherClaimed) "voucher_code": voucherCode,
      if (couponData != null)
        isDelivery ? "delivery_coupon_code" : "coupon_code":
            couponData.couponCode,
      if (directBuy) "variant_id": productItem?.variants?.first.id,
      if (paymentOption == PaymentOptionsEnum.mada) "platform": "DASHBOARD",
    });
  }

  static Future<void> handlePayment(
    State state,
    WidgetRef ref, {
    required FormData data,
    required bool directBuy,
    required PaymentOptionsEnum selectedPaymentOption,
  }) async {
    CheckoutModel checkoutDetails =
        await _purchaseProduct(data: data, directBuy: directBuy);

    if (selectedPaymentOption == PaymentOptionsEnum.mada) {
      await _handleMadaPayment(state, ref, checkoutDetails: checkoutDetails);
    } else {
      _processOtherPaymentOptionsResponse(
        state,
        ref,
        checkoutDetails: checkoutDetails,
        selectedPaymentOption: selectedPaymentOption,
      );
    }
  }

  static Future<CheckoutModel> _purchaseProduct({
    required FormData data,
    required bool directBuy,
  }) async {
    Response response;
    if (directBuy) {
      response = await api.post("api/ufc/v3/buy_product", data: data);
    } else {
      response = await api.post("api/ufc/v3/place_order", data: data);
    }

    final responseData = response.data?['data'];

    if (responseData == null || responseData is! Map<String, dynamic>) {
      throw CustomException(
          message: 'Something went wrong. Please try again later.');
    }

    return CheckoutModel.fromJson(responseData);
  }

  static Future<void> _handleMadaPayment(
    State state,
    WidgetRef ref, {
    required CheckoutModel checkoutDetails,
  }) async {
    if (isStringEmpty(checkoutDetails.checkoutId) ||
        isStringEmpty(checkoutDetails.integrity)) {
      _madaErrorPop(
          state, 'Unable to process payment. Please refresh and try again.');
      return;
    }

    if (!state.mounted) return;
    final payed = await Navigator.push(
      state.context,
      MaterialPageRoute(
        builder: (context) => MadaPaymentScreen(
          integrity: checkoutDetails.integrity ?? '',
          checkoutId: checkoutDetails.checkoutId ?? '',
          languageLocale: LanguageManager.locale,
        ),
      ),
    );

    if (payed != true) {
      _madaErrorPop(state, 'Payment was not completed. Please try again.');
      return;
    }

    if (!state.mounted) return;
    final future =
        PaymentService.verifyPayment(checkoutDetails.checkoutId ?? '');
    final isPaymentSuccess = await LoadingDialog.show(state.context, future);

    if (!isPaymentSuccess) {
      _madaErrorPop(state,
          'Payment verification failed. If the amount was deducted, please contact support.');
      return;
    }

    _navigateToSuccess(state, checkoutDetails);
  }

  static void _processOtherPaymentOptionsResponse(
    State state,
    WidgetRef ref, {
    required CheckoutModel checkoutDetails,
    required PaymentOptionsEnum selectedPaymentOption,
  }) async {
    ref.read(cartProvider).clear();

    if (selectedPaymentOption == PaymentOptionsEnum.wallet) {
      await ref.read(authProvider.notifier).autoLogin();
    }

    _navigateToSuccess(state, checkoutDetails);
  }

  static Future<void> _madaErrorPop(State state, String errorMsg) async {
    await Future.delayed(Duration(milliseconds: 111));
    if (!state.mounted) return;
    pop(state.context);
    CustomSnackBar.error(state.context, errorMsg);
  }

  static void _navigateToSuccess(
      State state, CheckoutModel checkoutDetails) async {
    final purchaseId = checkoutDetails.checkoutSummary?.id.toString();
    final purchaseAmount = checkoutDetails.checkoutSummary?.totalWithVat;
    if (purchaseId != null && purchaseId.isNotEmpty && purchaseAmount != null) {
      AdjustTracker.trackPurchase(
        orderId: purchaseId,
        amount: purchaseAmount,
      );
    }

    Navigator.push(
      state.context,
      MaterialPageRoute(
        builder: (context) => SurveyFlow(
          onSurveyCompleted: () {
            Navigator.pushAndRemoveUntil(
              state.context,
              MaterialPageRoute(
                builder: (context) => OrderSuccessPage(
                  checkoutDetails: checkoutDetails,
                ),
              ),
              (route) => false,
            );
          },
        ),
      ),
    );
  }
}
