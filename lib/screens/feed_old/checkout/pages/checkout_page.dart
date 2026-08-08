import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:ufc_mobile/global/shared/constants/widgets.dart';
import 'package:ufc_mobile/global/shared/functions/user.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/analytic/adjust_tracker.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/global/util/exception/error_handler.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/models/cart_item_model.dart';
import 'package:ufc_mobile/riverpod/app_setting/app_setting_riverpod.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/coupon/coupon_async_riverpod.dart';
import 'package:ufc_mobile/riverpod/default_address/default_address.dart';
import 'package:ufc_mobile/riverpod/order/delivery_cost.dart';
import 'package:ufc_mobile/riverpod/sadad/sadad_user_async_riverpod.dart';
import 'package:ufc_mobile/riverpod/state.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/coupon/coupon_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/enum/payment_option.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/utils/checkout_utils.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/utils/coupon_utils.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_default_address.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_functions.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_orders_list.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_payment_method.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_proceed_section.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_station_address.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_vehicle_details_card.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/reward_coupon_claim_card.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/provider/claimed_vouchers.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/provider/user_tier.dart';
import 'package:ufc_mobile/screens/feed_old/saved_address/pages/saved_address_list.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({
    super.key,
    this.cartItems,
    this.productItem,
    this.quantity = 0,
    this.deliveryTime,
    this.directBuy = false,
    this.isDelivery = false,
  }) : assert((cartItems != null && productItem == null) ||
            (cartItems == null && productItem != null));
  final int quantity;
  final bool directBuy;
  final bool isDelivery;
  final DateTime? deliveryTime;
  final ProductModel? productItem;
  final List<CartItemModel>? cartItems;

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage>
    with ScreenEngagementTracker {
  int page = 1;
  int shippingFee = 0;
  double subTotal = 0;
  double vatAmount = 0;
  String addressId = '';
  int vatPercentage = 0;
  bool isLoading = false;
  double totalAmount = 0;
  double? discountAmount;
  double? discountedPrice;
  String alphaCode = "SA";
  CouponModel? couponData;
  String countryCode = "+966";
  double itemsAndVatTotal = 0;
  bool isWalletChecked = false;
  double deliveryVatAmount = 0;
  final phoneNode = FocusNode();
  bool isVoucherClaimed = false;
  double deliveryAndVatTotal = 0;
  double percentageIntoAmount = 0;
  double? voucherDiscountedAmount;
  Map<String, String>? appSettings;
  final formKey = GlobalKey<FormState>();
  FocusNode plateNumberNode = FocusNode();
  final phoneController = TextEditingController();
  ValueNotifier<double> deliveryAmount = ValueNotifier(0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController couponController = TextEditingController();
  PaymentOptionsEnum selectedPaymentOption = PaymentOptionsEnum.none;
  TextEditingController driverNameController = TextEditingController();
  TextEditingController plateNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(_init);

    Future(() => ref.read(defaultAddressProvider.notifier).getDefaultAddress());
    Future(() =>
        ref.read(claimedVouchersProvider.notifier).fetchClaimedVouchers());
    Future(() => ref.read(userTierProvider.notifier).fetchUserTierList());

    if (widget.cartItems != null) {
      for (var element in widget.cartItems!) {
        // Check if the item is claimed
        if (!element.isClaimed) {
          subTotal = subTotal + (element.variant!.price! * element.quantity!);
        }
      }
    } else {
      subTotal = subTotal +
          (widget.productItem!.variants!.first.price! * widget.quantity);
    }

    if (!widget.isDelivery) {
      shippingFee = 0;
    }

    if (widget.isDelivery) {
      selectedPaymentOption = PaymentOptionsEnum.none;
    }

    Future(() async {
      try {
        final defaultAddress = await ref.read(defaultAddressProvider.future);
        if (defaultAddress != null) {}
        final savedAddress = defaultAddress?.id;

        setState(() {
          addressId = savedAddress.toString();
        });

        if (savedAddress != null) {
          final shopId = ref.read(authProvider).value?.preferredShopDetails?.id;

          if (shopId != null) {
            // Calculate delivery cost using the extracted shopId
            Future(() async {
              final response = await ref
                  .read(deliveryCostProvider.notifier)
                  .calculateDeliveryCost(
                    userAddressId: savedAddress, // Use the savedAddress id
                    shopId: shopId, // Use the extracted shopId
                  );

              setState(() {
                deliveryAmount.value = response?.totalCost ?? 0.0;
              });

              vatPercentage =
                  (ref.read(authProvider).value?.vatPercentage ?? 0.0).toInt();

              if (widget.isDelivery) {
                getDeliveryVatAmount(deliveryAmount.value);
                deliveryAndVatTotal = deliveryAmount.value + deliveryVatAmount;
              }
            });
          }
        }
      } catch (e) {
        Sentry.captureException(e, stackTrace: StackTrace.current);

        // Log the error and set a fallback state
        setState(() {
          addressId = 'Error fetching address';
          deliveryAmount.value = 0.0;
          deliveryAndVatTotal = 0.0;
        });
      }
    });

    Future(() {
      vatPercentage =
          (ref.read(authProvider).value?.vatPercentage ?? 0.0).toInt();
      getVatAmount(subTotal);
      itemsAndVatTotal = subTotal + vatAmount;
    });

    Future(() {
      ref.read(sadadUserAsyncProvider.notifier).getSadadUserInfo();
      ref.read(appSettingRiverpodProvider.notifier).getAppSetting();
    });
  }

  Future<void> _init() async {
    AdjustTracker.trackInitiateCheckout();
    final stationId = ref.read(authProvider).value?.preferredShopDetails?.id;
    if (stationId != null) {
      await ref.read(paymentMethodProvider).getBankDetails(stationId);
    }
  }

  void getVatAmount(double totalDiscountedAmount) {
    vatAmount = totalDiscountedAmount * (vatPercentage / 100);
  }

  void getDeliveryVatAmount(double totalDiscountedAmount) {
    deliveryVatAmount = totalDiscountedAmount * (vatPercentage / 100);
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy HH:mm', 'en')
        .format(widget.deliveryTime ?? DateTime.now());

    final claimedVouchers = ref.watch(claimedVouchersProvider).asData?.value;
    final haveVoucher = claimedVouchers != null;
    final user = ref.watch(authProvider);
    final sadadUserInfo = ref.watch(sadadUserAsyncProvider);
    final defaultAddress = ref.watch(defaultAddressProvider);
    final walletAmount = ref.watch(authProvider).asData?.value?.walletAmount;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        Future.microtask(() {
          ref.read(paymentMethodProvider).clear();
        });
      },
      child: LayoutBuilder(builder: (context, constraints) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            shadowColor: Colors.black.withValues(alpha: 0.3),
            title: CustomText(
                text: 'Checkout',
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600),
            leading: InkWell(
              onTap: () => Navigator.pop(context, true),
              child:
                  const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
            ),
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Checkout Orders List
                        CheckoutOrdersList(
                          quantity: widget.quantity,
                          cartItems: widget.cartItems,
                          productItem: widget.productItem,
                        ),
                        const SizedBox(height: 10),
                        const Divider(
                          thickness: 4,
                          color: Color.fromRGBO(251, 251, 251, 1),
                        ),

                        // Checkout Station Address
                        CheckoutStationAddress(),

                        // NOTE: Delevery Old Methods
                        // Checkout Default Address
                        if (widget.isDelivery)
                          CheckoutDefaultAddress(
                            onAddAddressPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SavedAddressList(
                                    currentDefaultAddressId:
                                        defaultAddress.asData?.value?.id,
                                  ),
                                ),
                              ).then((value) async {
                                if (value == true) {
                                  final defaultAddress =
                                      ref.read(defaultAddressProvider);

                                  // final defaultAddress =
                                  //     await ref.read(
                                  //         defaultAddressProvider
                                  //             .future);
                                  // Fetch the updated address from the provider state
                                  // Extract the updated address ID
                                  final updatedAddressId =
                                      defaultAddress.value?.id;

                                  addressId = updatedAddressId.toString();
                                  final shopId = ref
                                      .read(authProvider)
                                      .value
                                      ?.preferredShopDetails
                                      ?.id;

                                  if (updatedAddressId != null &&
                                      shopId != null) {
                                    final response = await ref
                                        .read(deliveryCostProvider.notifier)
                                        .calculateDeliveryCost(
                                          userAddressId: updatedAddressId,
                                          shopId: shopId,
                                        );
                                    deliveryAmount.value =
                                        response?.totalCost ?? 0.0;

                                    getDeliveryVatAmount(deliveryAmount.value);
                                    deliveryAndVatTotal = deliveryAmount.value +
                                        deliveryVatAmount;
                                    setState(() {});
                                  }
                                }
                              });
                            },
                          ),

                        const SizedBox(height: 20),
                        const Divider(
                          thickness: 4,
                          color: Color.fromRGBO(251, 251, 251, 1),
                        ),

                        // Checkout Payment Method
                        CheckoutPaymentMethod(
                          subTotal: subTotal,
                          constraints: constraints,
                          isDelivery: widget.isDelivery,
                          isWalletChecked: isWalletChecked,
                          selectedPaymentOption: selectedPaymentOption,
                          onWalletChanged: (value) {
                            safeSetState(this, () => isWalletChecked = value);
                          },
                          onSelectedPaymentOptionChanged: (paymentOption) {
                            safeSetState(this,
                                () => selectedPaymentOption = paymentOption);
                          },
                        ),

                        // Checkout Vehicle Details Card
                        if (!widget.isDelivery)
                          CheckoutVehicleDetailsCard(
                            plateNumberNode: plateNumberNode,
                            driverNameController: driverNameController,
                            plateNumberController: plateNumberController,
                          ),

                        // if (!widget.isDelivery)
                        if (haveVoucher) const SizedBox(height: 25),
                        if (haveVoucher)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: rewardCouponClaimCardWidget(
                              couponAmount: (claimedVouchers.type ==
                                      'percentage')
                                  ? '${claimedVouchers.discountValue} %  ${claimedVouchers.code ?? ''}'
                                  : 'SAR ${claimedVouchers.discountValue}  ${claimedVouchers.code ?? ''}',
                              onClaimedChanged: (bool isClaimed) {
                                setState(() {
                                  isVoucherClaimed = isClaimed;
                                  if (isClaimed) {
                                    // calculations here
                                    if (claimedVouchers.type == 'percentage') {
                                      percentageIntoAmount = (subTotal *
                                              (claimedVouchers.discountValue ??
                                                  0)) /
                                          100;
                                      voucherDiscountedAmount = subTotal -
                                          (discountAmount ?? 0) -
                                          (percentageIntoAmount);
                                    } else {
                                      voucherDiscountedAmount = subTotal -
                                          (discountAmount ?? 0) -
                                          (claimedVouchers.discountValue ?? 0);
                                    }
                                    getVatAmount(voucherDiscountedAmount!);
                                    itemsAndVatTotal = (vatAmount +
                                                (voucherDiscountedAmount ??
                                                    0)) <
                                            0
                                        ? 0
                                        : vatAmount +
                                            (voucherDiscountedAmount ?? 0);
                                  } else {
                                    voucherDiscountedAmount = 0;
                                    getVatAmount(
                                        subTotal - (discountAmount ?? 0));
                                    itemsAndVatTotal = (subTotal + vatAmount) -
                                        (discountAmount ?? 0);
                                  }
                                });
                              },
                            ),
                          ),

                        // if (haveVoucher)
                        SizedBox(height: (haveVoucher) ? 25 : 15),

                        CheckoutProceedSection(
                          subTotal: subTotal,
                          vatAmount: vatAmount,
                          couponData: couponData,
                          shippingFee: shippingFee,
                          cartItems: widget.cartItems,
                          vatPercentage: vatPercentage,
                          isDelivery: widget.isDelivery,
                          deliveryAmount: deliveryAmount,
                          discountAmount: discountAmount,
                          itemsAndVatTotal: itemsAndVatTotal,
                          isVoucherClaimed: isVoucherClaimed,
                          couponController: couponController,
                          deliveryVatAmount: deliveryVatAmount,
                          deliveryAndVatTotal: deliveryAndVatTotal,
                          isCheckingOut: CheckoutUtils.isCheckingOut,
                          percentageIntoAmount: percentageIntoAmount,
                          selectedPaymentOption: selectedPaymentOption,
                          onChanged: (value) => setState(() {}),
                          onCouponApplyPressed: couponData == null
                              ? () async {
                                  if (couponController.text.isEmpty) {
                                    return;
                                  }
                                  try {
                                    final couponCode = couponController.text;

                                    final future = ref
                                        .read(couponAsyncProvider.notifier)
                                        .validateCoupon(
                                            couponCode, deliveryAmount.value);
                                    couponData = await LoadingDialog.show(
                                        context, future);

                                    if (couponData != null) {
                                      if (!widget.isDelivery &&
                                          couponData?.isDelivery == true) {
                                        couponData = null;
                                        if (!context.mounted) return;
                                        CustomSnackBar.message(context,
                                            'This coupon is only valid for delivery orders.');
                                        return;
                                      }

                                      discountAmount = couponData?.isDelivery ==
                                              true
                                          ? couponData?.redeemableDeliveryAmount
                                          : couponData?.redeemableAmount;

                                      if (couponData?.isDelivery == true) {
                                        discountedPrice = deliveryAmount.value -
                                            (discountAmount ?? 0);

                                        getDeliveryVatAmount(discountedPrice!);

                                        deliveryAndVatTotal =
                                            deliveryVatAmount +
                                                (discountedPrice ?? 0);
                                      } else {
                                        discountedPrice = subTotal -
                                            (discountAmount ?? 0) -
                                            ((isVoucherClaimed
                                                ? claimedVouchers
                                                        ?.discountValue ??
                                                    0
                                                : 0));

                                        getVatAmount(discountedPrice!);

                                        itemsAndVatTotal =
                                            vatAmount + (discountedPrice ?? 0);
                                      }
                                      setState(() {});
                                    }
                                  } catch (e) {
                                    if (!context.mounted) return;

                                    if (e is DioException &&
                                        e.response?.statusCode == 400) {
                                      CouponUtils.handleError(context, e);
                                      return;
                                    }

                                    ErrorHandler.handleError(context, e);
                                  }
                                }
                              : () {
                                  if (couponData?.isDelivery == true) {
                                    getDeliveryVatAmount(deliveryAmount.value);
                                    deliveryAndVatTotal =
                                        (deliveryAmount.value +
                                            deliveryVatAmount);
                                  } else {
                                    getVatAmount(subTotal -
                                        ((isVoucherClaimed
                                            ? claimedVouchers?.discountValue ??
                                                0
                                            : 0)));
                                    itemsAndVatTotal = ((subTotal -
                                            ((isVoucherClaimed
                                                ? claimedVouchers
                                                        ?.discountValue ??
                                                    0
                                                : 0))) +
                                        vatAmount);
                                  }
                                  discountAmount = 0;
                                  discountedPrice = 0;
                                  couponData = null;

                                  setState(() {});
                                },
                          onProceedPressed: CheckoutUtils.isCheckingOut
                              ? () {}
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    try {
                                      if (widget.isDelivery) {
                                        if ((!defaultAddress.hasValue) ||
                                            defaultAddress.value == null) {
                                          // Show a snackbar if no saved address exists
                                          CustomSnackBar.message(
                                              context,
                                              "No saved address found. Please add a default address to proceed."
                                                  .tr());
                                          return;
                                        }
                                      }
                                      if (!isSadadInfoExist(sadadUserInfo.value,
                                          selectedPaymentOption:
                                              selectedPaymentOption)) {
                                        CustomSnackBar.message(
                                            context,
                                            sadadUserInfo.value == null
                                                ? "SADAD user information not found. Kindly complete the missing details"
                                                    .tr()
                                                : "SADAD user information is incomplete. Please fill the missing details"
                                                    .tr());
                                        return;
                                      } else if (!isUserPhoneNumberExist(
                                          user.value)) {
                                        await addOrUpdateUserPhoneDialog(
                                          ref,
                                          context,
                                          user,
                                        );
                                        return;
                                      } else if (!isUserNameExist(user.value)) {
                                        final bool result = await showBtmSheet(
                                            context, addUserNameBtmSheet());
                                        if (!result) {
                                          return;
                                        }
                                      } else if (selectedPaymentOption ==
                                          PaymentOptionsEnum.none) {
                                        CustomSnackBar.message(
                                            context,
                                            "Please select a payment method before proceeding."
                                                .tr());
                                        return;
                                      }

                                      await CheckoutUtils.checkout(
                                        this,
                                        ref,
                                        addressId: addressId,
                                        couponData: couponData,
                                        quantity: widget.quantity,
                                        bookingTime: formattedDate,
                                        directBuy: widget.directBuy,
                                        isDelivery: widget.isDelivery,
                                        voucherCode: isVoucherClaimed
                                            ? claimedVouchers?.code
                                            : null,
                                        selectedPaymentOption:
                                            selectedPaymentOption,
                                        driverNameController:
                                            driverNameController,
                                        plateNumberController:
                                            plateNumberController,
                                        walletAmount: walletAmount ?? 0,
                                        productItem: widget.productItem,
                                        isWalletChecked: isWalletChecked,
                                        isVoucherClaimed: isVoucherClaimed,
                                        deliveryAmount: deliveryAmount.value,
                                        defaultAddress: defaultAddress.value,
                                      );
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      ErrorHandler.handleError(
                                        context,
                                        e.toString().tr(),
                                      );
                                    }
                                  }
                                },
                        ),
                      ],
                    ),
                  ),
                ),
        );
      }),
    );
  }

  bool isUserPhoneNumberExist(UserModel? user) {
    if (selectedPaymentOption == PaymentOptionsEnum.sadad) return true;
    if (user == null ||
        user.phone == null ||
        user.phone?.phoneNumber == null ||
        user.phone!.phoneNumber!.isEmpty) {
      return false;
    }
    return true;
  }
}
