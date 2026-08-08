import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/models/cart_item_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/coupon/coupon_model.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/currency/currency_riverpod.dart';
import 'package:ufc_mobile/riverpod/order/delivery_cost.dart';
import 'package:ufc_mobile/screens/feed_old/cart/widgets/custom_coupon_field.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/enum/payment_option.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_widgets.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/provider/claimed_vouchers.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/provider/user_points_feature_access.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/provider/user_tier.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/widgets/loyality_points_reusable_progress_card.dart';

class CheckoutProceedSection extends ConsumerWidget {
  const CheckoutProceedSection({
    super.key,
    this.onChanged,
    required this.subTotal,
    required this.vatAmount,
    required this.cartItems,
    required this.isDelivery,
    required this.couponData,
    required this.shippingFee,
    required this.isCheckingOut,
    required this.vatPercentage,
    required this.deliveryAmount,
    required this.discountAmount,
    required this.itemsAndVatTotal,
    required this.isVoucherClaimed,
    required this.onProceedPressed,
    required this.couponController,
    required this.deliveryVatAmount,
    required this.deliveryAndVatTotal,
    required this.percentageIntoAmount,
    required this.onCouponApplyPressed,
    required this.selectedPaymentOption,
  });
  final bool isDelivery;
  final int shippingFee;
  final double subTotal;
  final double vatAmount;
  final int vatPercentage;
  final bool isCheckingOut;
  final bool isVoucherClaimed;
  final double? discountAmount;
  final double itemsAndVatTotal;
  final CouponModel? couponData;
  final double deliveryVatAmount;
  final double deliveryAndVatTotal;
  final double percentageIntoAmount;
  final Function(String)? onChanged;
  final VoidCallback onProceedPressed;
  final List<CartItemModel>? cartItems;
  final VoidCallback onCouponApplyPressed;
  final ValueNotifier<double> deliveryAmount;
  final TextEditingController couponController;
  final PaymentOptionsEnum selectedPaymentOption;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryFeeState = ref.watch(deliveryCostProvider);
    final featureAccess =
        ref.watch(userPointsFeatureAccessProvider).asData?.value;
    final currencyData = ref.watch(currencyProvider).selectedCurrency;
    final walletAmount = ref.watch(authProvider).asData?.value?.walletAmount;
    final claimedVouchers = ref.watch(claimedVouchersProvider).asData?.value;
    final currencyRate = ref.watch(currencyProvider).selectedCurrencyRate ?? 1;

    final userTier = ref.watch(userTierProvider).asData?.value;
    final currentTierIndex = userTier?.data?.currentTierIndex;
    final double orderPoints = currentTierIndex == null
        ? 0.0
        : (!isDelivery)
            ? ((userTier?.data?.tiers?[currentTierIndex].pointsPerUnitSpent ??
                    0) *
                (itemsAndVatTotal + shippingFee))
            : ((userTier?.data?.tiers?[currentTierIndex].pointsPerUnitSpent ??
                    0) *
                (deliveryAndVatTotal + itemsAndVatTotal));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.grey.withValues(alpha: 0.4),
          ),
        ],
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          //* Loyalty Progress Bar Card
          if (featureAccess ?? true)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: LoyaltyProgressBarCard(
                height: 137, // Custom height for the widget
                parentPaddingSize: 8,
                isInCheckOutPage: true,
                orderPoints: orderPoints,
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 25),
                checkoutDetails(
                    title: 'Items',
                    amount:
                        cartItems == null ? "1" : cartItems!.length.toString()),
                // checkoutDetails(
                //     title: 'Sub Total',
                //     amountCurrency:
                //         (subTotal * currencyRate)
                //             .toStringAsFixed(2),
                //     currencyCode:
                //         ' ${currencyData?.code ?? "SAR"}'),
                checkoutDetails(
                  title: 'Sub Total',
                  amountCurrency: (subTotal * currencyRate).toStringAsFixed(2),
                  currencyCode: ' ${currencyData?.code ?? "SAR"}',
                ),

                if (isVoucherClaimed)
                  checkoutDetails(
                      title: 'Voucher Discount',
                      amountCurrency: (claimedVouchers?.type == 'percentage')
                          ? '-${(percentageIntoAmount * currencyRate).toStringAsFixed(2)}'
                          : '-${(claimedVouchers?.discountValue! ?? 0 * currencyRate).toStringAsFixed(2)}',
                      currencyCode: ' ${currencyData?.code ?? "SAR"}'
                      //  couponData
                      //             ?.isPercentage ==
                      //         true
                      //     ? couponData?.amount
                      //     : couponData
                      //         ?.redeemableAmount,
                      // currencyCode: couponData
                      //             ?.isPercentage ==
                      //         true
                      //     ? ' %'
                      //     : ' ${currencyData?.code ?? "SAR"}'),

                      ),

                if ((couponData != null) && (couponData?.isDelivery == false))
                  checkoutDetails(
                      title: 'Coupon',
                      amountCurrency:
                          '-${(discountAmount! * currencyRate).toStringAsFixed(2)}',
                      currencyCode: ' ${currencyData?.code ?? "SAR"}'
                      //  couponData
                      //             ?.isPercentage ==
                      //         true
                      //     ? couponData?.amount
                      //     : couponData
                      //         ?.redeemableAmount,
                      // currencyCode: couponData
                      //             ?.isPercentage ==
                      //         true
                      //     ? ' %'
                      //     : ' ${currencyData?.code ?? "SAR"}'),

                      ),

                checkoutDetails(
                  title: 'VAT Amount',
                  amountCurrency: (vatAmount * currencyRate).toStringAsFixed(2),
                  currencyCode: ' ${currencyData?.code ?? "SAR"}',
                ),

                // Separator Line
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 0),
                //   child: Divider(
                //     color: Colors.grey,
                //     thickness: 1.0,
                //   ),
                // ),

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  height: 1.0,
                  color: Colors.grey,
                ),

                // Total
                checkoutDetails(
                  title: 'Total',
                  totalPrice: itemsAndVatTotal * currencyRate,
                  currencyCode: ' ${currencyData?.code ?? "SAR"}',
                ),

                const SizedBox(height: 12),
                // Sipping Fee not is use
                // widget.isDelivery
                //     ? checkoutDetails(
                //         title: 'Shipping Fee',
                //         amountCurrency:
                //             (shippingFee * currencyRate)
                //                 .toStringAsFixed(2),
                //         currencyCode:
                //             ' ${currencyData?.code ?? "SAR"}')
                //     : const SizedBox.shrink(),

                // checkoutDetails(
                //     title: 'VAT Amount',
                //     amountCurrency:
                //         (vatAmount * currencyRate).toStringAsFixed(2),
                //     currencyCode:
                //         ' ${currencyData?.code ?? "SAR"}'),

                if (isDelivery)
                  deliveryFeeState.when(
                    data: (data) {
                      final deliveryFee = data?.totalCost ?? 0.0;

                      deliveryAmount.value = deliveryFee;

                      //  getDeliveryVatAmount(deliveryAmount);
                      return checkoutDetails(
                        title: 'Delivery Fee',
                        amountCurrency:
                            (deliveryFee * currencyRate).toStringAsFixed(2),
                        currencyCode: ' ${currencyData?.code ?? "SAR"}',
                      );
                    },
                    loading: () {
                      return const CircularProgressIndicator();
                    },
                    error: (error, stackTrace) {
                      return Center(
                        child: Padding(
                          padding:
                              EdgeInsets.all(8.0), // Further reduced padding
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 28.0, // Further reduced icon size
                              ),
                              SizedBox(height: 6.0), // Reduced spacing
                              Text(
                                "Delivery pricing isn't available for this shop. Please contact for support."
                                    .tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.0, // Smaller font size
                                  fontWeight:
                                      FontWeight.w400, // Standard font weight
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                if ((couponData != null) &&
                    (couponData?.isDelivery == true) &&
                    isDelivery)
                  checkoutDetails(
                      title: 'Coupon',
                      amountCurrency:
                          '-${(discountAmount! * currencyRate).toStringAsFixed(2)}',
                      currencyCode: ' ${currencyData?.code ?? "SAR"}'
                      //  couponData
                      //             ?.isPercentage ==
                      //         true
                      //     ? couponData?.amount
                      //     : couponData
                      //         ?.redeemableAmount,
                      // currencyCode: couponData
                      //             ?.isPercentage ==
                      //         true
                      //     ? ' %'
                      //     : ' ${currencyData?.code ?? "SAR"}'),

                      ),
                if (isDelivery)
                  checkoutDetails(
                      title: 'Delivery VAT Amount',
                      amountCurrency:
                          (deliveryVatAmount * currencyRate).toStringAsFixed(2),
                      currencyCode: ' ${currencyData?.code ?? "SAR"}'),

                if (isDelivery)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    height: 1.0,
                    color: Colors.grey,
                  ),

                // Total
                if (isDelivery)
                  checkoutDetails(
                    title: 'Total',
                    totalPrice: deliveryAndVatTotal * currencyRate,
                    currencyCode: ' ${currencyData?.code ?? "SAR"}',
                  ),

                (selectedPaymentOption == PaymentOptionsEnum.wallet) &&
                        (((subTotal + shippingFee) * currencyRate) -
                                (walletAmount ?? 0)) >
                            0
                    ? checkoutDetails(
                        title: 'Remaining Amount To Be Paid with SADAD',
                        amountCurrency: (!isDelivery)
                            ? (((itemsAndVatTotal + shippingFee) *
                                        currencyRate) -
                                    (walletAmount ?? 0))
                                .toStringAsFixed(0)
                            : (((itemsAndVatTotal + deliveryAndVatTotal) *
                                        currencyRate) -
                                    (walletAmount ?? 0))
                                .toStringAsFixed(0),
                        currencyCode: ' ${currencyData?.code ?? "SAR"}')
                    : const SizedBox.shrink(),

                const SizedBox(height: 15),
                checkoutDetails(
                    showVat: true,
                    title: 'Total Price',
                    vatPercentage: vatPercentage,
                    totalPrice: (!isDelivery)
                        ? (

                            // (subTotal +
                            //       vatAmount +
                            //       shippingFee)
                            (itemsAndVatTotal + shippingFee) * currencyRate)
                        : ((deliveryAndVatTotal + itemsAndVatTotal) *
                            currencyRate),
                    currencyCode: ' ${currencyData?.code ?? "SAR"}'),
                const SizedBox(height: 20),

                CustomCouponField(
                  onChanged: onChanged,
                  controller: couponController,
                  labelText: 'Do you have a coupon?'.tr(),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(10),
                    child: CustomButton(
                      width: 81,
                      height: 20,
                      fontSize: 12,
                      disabled: couponController.text.isEmpty,
                      color: couponData == null ? null : carminePink,
                      title: couponData == null ? 'Apply' : 'Remove',
                      onTap: onCouponApplyPressed,
                    ),
                  ),
                ),
                Center(
                  child: CustomButton(
                    width: 287,
                    height: 42,
                    title: 'Proceed',
                    color: isCheckingOut == true ? Colors.grey : null,
                    onTap: onProceedPressed,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
