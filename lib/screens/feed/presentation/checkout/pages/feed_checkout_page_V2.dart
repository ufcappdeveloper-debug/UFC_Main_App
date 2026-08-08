import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_divider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/analytic/adjust_tracker.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/global/util/exception/error_handler.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/custome_container.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/farm_appbar.dart';
import 'package:ufc_mobile/screens/feed/application/address/address_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/address/address_state.dart';
import 'package:ufc_mobile/screens/feed/application/app_settings/app_setting_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/checkout/sadad/sadad_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/checkout/sadad/sadad_state.dart';
import 'package:ufc_mobile/screens/feed/application/coupon/coupon_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/coupon/coupon_state.dart';
import 'package:ufc_mobile/screens/feed/application/delivery_cost/delivery_cost_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/delivery_cost/delivery_cost_state.dart';
import 'package:ufc_mobile/screens/feed/application/payment/payment_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/address/profile_address_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/cart/feed_cart_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/coupon/coupon_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/enum/delivery_option.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/utils/feed_checkout_utils.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/widgets/feed_checkout_default_address.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/widgets/feed_checkout_functions.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/widgets/feed_checkout_payment_method.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/widgets/feed_coupon_field.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/widgets/feed_date_widget.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/widgets/feed_delivery_note.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/widgets/feed_delivery_widget.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/widgets/vehicle_number_widget.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/pages/feed_address_page.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/pages/feed_order_details.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/widgets/my_orders_page/order_items_card.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/widgets/station_widget.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/enum/payment_option.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

class FeedCheckoutPageV2 extends StatefulWidget {
  final ProductModel? productItem;
  final List<FeedCartItemModel>? cartItems;
  final int quantity;
  final bool directBuy;
  const FeedCheckoutPageV2({
    super.key,
    this.productItem,
    this.cartItems,
    this.quantity = 0,
    this.directBuy = false,
  });

  @override
  State<FeedCheckoutPageV2> createState() => _FeedCheckoutPageV2State();
}

class _FeedCheckoutPageV2State extends State<FeedCheckoutPageV2> {
  DeliveryOptionsEnum selectedDevliveryOption = DeliveryOptionsEnum.none;
  PaymentOptionsEnum selectedPaymentOption = PaymentOptionsEnum.none;
  bool isWalletChecked = false;
  double subTotal = 0;
  TextEditingController couponController = TextEditingController();
  double itemsAndVatTotal = 0;
  double? discountAmount;
  double vatAmount = 0;
  int vatPercentage = 0;
  int shippingFee = 0;
  double deliveryVatAmount = 0;
  TextEditingController plateNumberController = TextEditingController();
  TextEditingController driverNameController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isVoucherClaimed = false;
  bool isLoading = false;
  String addressId = '';
  ValueNotifier<double> deliveryAmount = ValueNotifier(0);
  double deliveryAndVatTotal = 0;
  CouponModel? couponData;
  double? discountedPrice;
  String formattedDate = '';
  ProfileAddressModel? defaultAddress;
  String? deliveryNote;
  double? distanceInKm;

  Future<void> _init() async {
    AdjustTracker.trackInitiateCheckout();
    final user = context.read<AuthCubit>().currentUser;
    final stationId = user?.preferredShopDetails?.id;

    if (stationId != null) {
      await context.read<PaymentCubit>().getBankDetails(stationId: stationId);
    }
  }

  @override
  void initState() {
    super.initState();

    fetchDefaultAndDelivery();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();

      context.read<AppSettingCubit>().fetchAppSettings();
      context.read<SadadUserInfoCubit>().getUserInfo();
    });

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

    vatPercentage =
        (context.read<AuthCubit>().currentUser?.vatPercentage ?? 0.0).toInt();
    getVatAmount(subTotal);
    itemsAndVatTotal = subTotal + vatAmount;
  }

//   @override
// void didChangeDependencies() {
//   super.didChangeDependencies();
//   resetDeliveryValues();
//   // context.read<DeliveryCostCubit>().reset();
//   // fetchDefaultAndDelivery();
// }

  void getVatAmount(double totalDiscountedAmount) {
    vatAmount = totalDiscountedAmount * (vatPercentage / 100);
  }

  void getDeliveryVatAmount(double totalDiscountedAmount) {
    deliveryVatAmount = totalDiscountedAmount * (vatPercentage / 100);
  }

  void resetDeliveryValues() {
    deliveryAmount.value = 0.0;
    deliveryVatAmount = 0.0;
    deliveryAndVatTotal = 0.0;
    discountAmount = 0.0;
    discountedPrice = 0.0;
    couponData = null;
    couponController.clear();
  }

  Future<void> fetchDefaultAndDelivery() async {
    final user = context.read<AuthCubit>().currentUser;
    final shopId = user?.preferredShopDetails?.id;
    if (shopId == null) return;

    final deliveryCubit = context.read<DeliveryCostCubit>();
    final addressCubit = context.read<AddressCubit>();

    try {
      // Emit loading state in UI through Cubit
      await addressCubit.getDefaultAddress();

      // Get latest state
      final state = addressCubit.state;

      if (state is AddressLoaded && state.defaultAddress != null) {
        final defaultAddr = state.defaultAddress!;

        // Calculate delivery cost
        await deliveryCubit.calculateDeliveryCost(
          shopId: shopId,
          userAddressId: defaultAddr.id,
        );

        // Update delivery amount & VAT
        deliveryAmount.value = deliveryCubit.deliveryCost?.totalCost ?? 0.0;
        getDeliveryVatAmount(deliveryAmount.value);
        deliveryAndVatTotal = deliveryAmount.value + deliveryVatAmount;
      } else {
        deliveryCubit.reset();
        setState(() {
          deliveryAmount.value = 0.0;
          deliveryAndVatTotal = 0.0;
          deliveryVatAmount = 0;
        });
      }
    } catch (e, st) {
      Sentry.captureException(e, stackTrace: st);
      deliveryCubit.reset();
      setState(() {
        deliveryAmount.value = 0.0;
        deliveryAndVatTotal = 0.0;
        deliveryVatAmount = 0;
      });

      if (context.mounted) {
        CustomSnackBar.error(context, "Error fetching address or delivery: $e");
      }
    } finally {
      if (mounted) setState(() {});
    }
  }

  void _resetCoupon([String? message]) {
    setState(() {
      couponData = null;
      discountAmount = 0;
      discountedPrice = 0;
      getVatAmount(subTotal);
      getDeliveryVatAmount(deliveryAmount.value);
      deliveryAndVatTotal = deliveryAmount.value + deliveryVatAmount;
      itemsAndVatTotal = subTotal + vatAmount;
    });
    couponController.clear();

    if (message != null) {
      CustomSnackBar.message(context, message);
    }

    setState(() {});
  }

  void _onDeliveryMethodChanged(DeliveryOptionsEnum option) {
    setState(() {
      selectedDevliveryOption = option;
      couponController.clear();

      if (option == DeliveryOptionsEnum.pickup) {
        shippingFee = 0;
      } else {
        selectedPaymentOption = PaymentOptionsEnum.none;
      }

      // Remove coupon if no longer valid
      if (couponData != null) {
        final isDeliveryCoupon = couponData?.isDelivery == true;

        if ((option == DeliveryOptionsEnum.pickup && isDeliveryCoupon) ||
            (option == DeliveryOptionsEnum.delivery && !isDeliveryCoupon)) {
          _resetCoupon(option == DeliveryOptionsEnum.pickup
              ? 'Delivery-only coupon removed because you switched to pickup'
                  .tr()
              : 'Pickup-only coupon removed because you switched to delivery'
                  .tr());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletAmount = context.read<AuthCubit>().currentUser?.walletAmount;
    final qty = widget.cartItems == null ? 1 : widget.cartItems!.length;
    final itemsText = qty == 1 ? 'item'.tr() : 'items'.tr();

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          appBar: CustomFarmAppBar(title: 'Checkout'),
          body: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(children: [
                    kHeight10,
                    // Order items
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: OrderItemsCard(
                          quantity: widget.quantity,
                          cartItems: widget.cartItems,
                          productItem: widget.productItem),
                    ),
                    kHeight12,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: FeedDeliveryWidget(
                              title: "Pickup from\nStation".tr(),
                              isSelected: selectedDevliveryOption ==
                                  DeliveryOptionsEnum.pickup,
                              selectedDevliveryOption: selectedDevliveryOption,
                              icon: 'assets/svg/feed/pickup.svg',
                              onTap: () => _onDeliveryMethodChanged(
                                  DeliveryOptionsEnum.pickup),
                            ),
                          ),
                          kWidth16,
                          Flexible(
                            child: FeedDeliveryWidget(
                              title: "Delivery".tr(),
                              height: 30,
                              width: 30,
                              isSelected: selectedDevliveryOption ==
                                  DeliveryOptionsEnum.delivery,
                              selectedDevliveryOption: selectedDevliveryOption,
                              icon: 'assets/svg/feed/truck.svg',
                              onTap: () => _onDeliveryMethodChanged(
                                  DeliveryOptionsEnum.delivery),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selectedDevliveryOption == DeliveryOptionsEnum.delivery)
                      kHeight24,
                    // station widget

                    if (selectedDevliveryOption == DeliveryOptionsEnum.delivery)
                      BlocConsumer<AddressCubit, AddressState>(
                        listener: (context, state) {
                          if (state is AddressError) {
                            ErrorHandler.handleError(context, state.message);
                          }
                        },
                        builder: (context, state) {
                          final defaultAddress = state is AddressLoaded
                              ? state.defaultAddress
                              : null;

                          return FeedCheckoutDefaultAddress(
                            defaultAddress: defaultAddress,
                            isLoading: state is AddressLoading,
                            errorMessage:
                                state is AddressError ? state.message : null,
                            onAddAddressPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddressScreen(
                                    currentDefaultAddressId: defaultAddress?.id,
                                  ),
                                ),
                              ).then((_) async {
                                await fetchDefaultAndDelivery();
                              });
                            },
                          );
                        },
                      ),
                    kHeight24,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: stationWidget(
                          showLocation: true,
                          context,
                          showEdit: false,
                          distance: distanceInKm),
                    ),
                    kHeight20,

                    if (selectedDevliveryOption == DeliveryOptionsEnum.pickup)
                      VehicleNumberWidget(
                        controller: plateNumberController,
                      ),
                    if (selectedDevliveryOption == DeliveryOptionsEnum.pickup)
                      kHeight20,

                    if (selectedDevliveryOption == DeliveryOptionsEnum.delivery)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DeliveryDatePicker(
                          onDateSelected: (date) {
                            formattedDate = DateFormat('dd-MM-yyyy HH:mm', 'en')
                                .format(date);
                            setState(() {});
                          },
                        ),
                      ),

                    if (selectedDevliveryOption == DeliveryOptionsEnum.delivery)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: DeliveryNoteWidget(
                          deliveryNote: deliveryNote,
                          onNoteSaved: (note) {
                            setState(() {
                              deliveryNote = note;
                            });
                          },
                        ),
                      ),
                    if (selectedDevliveryOption == DeliveryOptionsEnum.delivery)
                      SizedBox(
                        height: 6,
                      ),

                    // Coupon field
                    BlocConsumer<CouponCubit, CouponState>(
                      listener: (context, state) {
                        if (state is CouponError) {
                          ErrorHandler.handleError(context, state.message);
                        } else if (state is CouponLoaded) {
                          couponData = state.coupon;

                          final isDeliveryCoupon =
                              couponData?.isDelivery == true;
                          final isDeliveryOrder = selectedDevliveryOption ==
                              DeliveryOptionsEnum.delivery;

                          if (isDeliveryCoupon && !isDeliveryOrder) {
                            _resetCoupon(
                                'This coupon is only valid for delivery orders.');
                            return;
                          }

                          if (!isDeliveryCoupon && isDeliveryOrder) {
                            _resetCoupon(
                                'This coupon is only valid for pickup orders.'
                                    .tr());
                            return;
                          }

                          final DateTime now = DateTime.now(); // local time

                          if (couponData?.validTo != null &&
                              DateTime.tryParse(couponData!.validTo!) != null) {
                            final DateTime validToUtc =
                                DateTime.parse(couponData!.validTo!).toUtc();
                            final DateTime validToLocal = validToUtc.toLocal();

                            if (validToLocal.isBefore(now)) {
                              _resetCoupon(
                                "This coupon has expired.".tr(),
                              );
                              return;
                            }
                          }

                          double currentTotal = isDeliveryCoupon
                              ? deliveryAmount.value
                              : subTotal;

                          if (couponData?.minAmount != null &&
                              subTotal < (couponData?.minAmount ?? 0)) {
                            _resetCoupon(
                              '${"Cart total must exceed".tr()} ${couponData?.minAmount} ${"to use this coupon.".tr()}',
                            );
                          }

// DISCOUNT CALCULATION
                          double calculatedDiscount = 0.0;

                          if (couponData?.isPercentage == true) {
                            double percent = couponData?.amount ?? 0.0;
                            calculatedDiscount = (currentTotal * percent) / 100;

                            if (couponData?.maximumAmount != null &&
                                calculatedDiscount >
                                    (couponData?.maximumAmount ?? 0)) {
                              calculatedDiscount = couponData?.maximumAmount ??
                                  calculatedDiscount;
                            }
                          } else {
                            calculatedDiscount = isDeliveryCoupon
                                ? (couponData?.redeemableDeliveryAmount ?? 0)
                                : (couponData?.redeemableAmount ?? 0);
                          }

                          setState(() {
                            discountAmount = calculatedDiscount;

                            if (isDeliveryCoupon) {
                              discountedPrice =
                                  currentTotal - calculatedDiscount;
                              getDeliveryVatAmount(discountedPrice!);
                              deliveryAndVatTotal =
                                  deliveryVatAmount + discountedPrice!;
                            } else {
                              discountedPrice =
                                  currentTotal - calculatedDiscount;
                              getVatAmount(discountedPrice!);
                              itemsAndVatTotal = vatAmount + discountedPrice!;
                            }
                          });

                          CustomSnackBar.success(
                              context, "Coupon applied successfully 🎉".tr());
                          setState(() {});
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is CouponLoading;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Directionality(
                            textDirection: isArOrUr
                                ? ui.TextDirection.rtl
                                : ui.TextDirection.ltr,
                            child: FeedCustomCouponField(
                              controller: couponController,
                              fontFamily: isEnglish
                                  ? AppFontsFamily.english
                                  : AppFontsFamily.arabic,
                              hintText: 'Enter discount code'.tr(),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform:
                                      Matrix4.rotationY(isArOrUr ? 0 : math.pi),
                                  child: SvgPicture.asset(
                                    'assets/svg/feed/coupon.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                              prefixIcon: Container(
                                margin: EdgeInsets.fromLTRB(isEnglish ? 20 : 10,
                                    10, isEnglish ? 10 : 20, 10),
                                child: isLoading
                                    ? const CupertinoActivityIndicator()
                                    : ValueListenableBuilder<TextEditingValue>(
                                        valueListenable: couponController,
                                        builder: (context, value, _) {
                                          final isDisabled =
                                              couponData == null &&
                                                  value.text.isEmpty;

                                          return CustomButton(
                                            width: isEnglish ? 79 : 70,
                                            height: 29,
                                            fontSize: 14,
                                            disabled: isDisabled,
                                            color: couponData == null
                                                ? null
                                                : carminePink,
                                            title: couponData == null
                                                ? 'Apply'
                                                : 'Remove',
                                            onTap: isDisabled
                                                ? null
                                                : () {
                                                    if (couponData == null) {
                                                      // Apply coupon
                                                      if (couponController
                                                          .text.isEmpty) return;

                                                      if (selectedDevliveryOption ==
                                                          DeliveryOptionsEnum
                                                              .none) {
                                                        CustomSnackBar.message(
                                                          context,
                                                          "Please select a delivery method before proceeding"
                                                              .tr(),
                                                        );
                                                        return;
                                                      }

                                                      context
                                                          .read<CouponCubit>()
                                                          .validateCoupon(
                                                            couponController
                                                                .text,
                                                            deliveryFee:
                                                                deliveryAmount
                                                                    .value,
                                                          );
                                                    } else {
                                                      // Remove coupon
                                                      _resetCoupon(
                                                          'Coupon removed successfully'
                                                              .tr());
                                                    }
                                                  },
                                          );
                                        },
                                      ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    kHeight20,

                    // Payment methods
                    CustomFarmContainer(
                        padding: const EdgeInsets.all(0),
                        radius: 17,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: FeedCheckoutPaymentMethod(
                          isDelivery: selectedDevliveryOption ==
                              DeliveryOptionsEnum.delivery,
                          subTotal: subTotal,
                          isWalletChecked: isWalletChecked,
                          constraints: constraints,
                          onWalletChanged: (value) {
                            safeSetState(this, () => isWalletChecked = value);
                          },
                          selectedPaymentOption: selectedPaymentOption,
                          onSelectedPaymentOptionChanged: (paymentOption) {
                            safeSetState(this,
                                () => selectedPaymentOption = paymentOption);
                          },
                        )),

                    kHeight10,

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: InfoCard(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 8),
                              child: CustomText(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                text: 'Order Details',
                              ),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            DetailTile(
                              fontSize: 15,
                              isAmount: false,
                              title: 'Number of Items'.tr(),
                              amount: "$qty $itemsText",
                            ),

                            const CustomDivider(
                              horizontalPadding: 6,
                              thickness: 0.25,
                              color: PetVeterinaryColors.newPetLightGray,
                            ),

                            DetailTile(
                              fontSize: 15,
                              isAmount: true,
                              title: 'Total',
                              totalPrice: subTotal,
                            ),

                            const CustomDivider(
                              horizontalPadding: 6,
                              thickness: 0.25,
                              color: PetVeterinaryColors.newPetLightGray,
                            ),

                            // Coupon without delivery
                            if ((couponData != null) &&
                                (couponData?.isDelivery == false))
                              DetailTile(
                                  fontSize: 15,
                                  isAmount: true,
                                  isDiscount: true,
                                  title: 'Coupon',
                                  amount:
                                      '-${(discountAmount ?? 0.0).toStringAsFixed(2)}'),

                            if ((couponData != null) &&
                                (couponData?.isDelivery == false))
                              const CustomDivider(
                                horizontalPadding: 6,
                                thickness: 0.25,
                                color: PetVeterinaryColors.newPetLightGray,
                              ),

                            DetailTile(
                                fontSize: 15,
                                isAmount: true,
                                title: 'VAT Amount',
                                amount: (vatAmount).toStringAsFixed(2)),

                            const CustomDivider(
                              horizontalPadding: 6,
                              thickness: 0.25,
                              color: PetVeterinaryColors.newPetDarkGray,
                            ),
                            DetailTile(
                              fontSize: 15,
                              isAmount: true,
                              title: 'Sub Total',
                              totalPrice: itemsAndVatTotal,
                              isTotal: true,
                            ),

                            if (selectedDevliveryOption ==
                                DeliveryOptionsEnum.delivery)
                              SizedBox(
                                height: 28,
                              ),

                            BlocBuilder<DeliveryCostCubit, DeliveryCostState>(
                              builder: (context, state) {
                                if (state is DeliveryCostLoading &&
                                    selectedDevliveryOption ==
                                        DeliveryOptionsEnum.delivery) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: const CircularProgressIndicator(
                                            color: primaryColor)),
                                  );
                                } else if (state is DeliveryCostLoaded) {
                                  distanceInKm =
                                      state.deliveryCost?.distanceInKm;

                                  if (selectedDevliveryOption ==
                                      DeliveryOptionsEnum.delivery) {
                                    final originalDeliveryFee =
                                        state.deliveryCost?.totalCost ?? 0.0;

                                    final bool isDeliveryCouponApplied =
                                        couponData != null &&
                                            couponData?.isDelivery == true &&
                                            (discountAmount ?? 0) > 0;

                                    if (!isDeliveryCouponApplied) {
                                      deliveryAmount.value =
                                          originalDeliveryFee;
                                      getDeliveryVatAmount(
                                          deliveryAmount.value);
                                      deliveryAndVatTotal =
                                          deliveryAmount.value +
                                              deliveryVatAmount;
                                    }

                                    return Column(
                                      children: [
                                        DetailTile(
                                            fontSize: 15,
                                            isAmount: true,
                                            title: 'Delivery Fee',
                                            amount: deliveryAmount.value
                                                .toStringAsFixed(2)),
                                        if (selectedDevliveryOption ==
                                            DeliveryOptionsEnum.delivery)
                                          const CustomDivider(
                                            horizontalPadding: 6,
                                            thickness: 0.25,
                                            color: PetVeterinaryColors
                                                .newPetLightGray,
                                          ),

                                        // coupon with delivery
                                        if ((couponData != null) &&
                                            (couponData?.isDelivery == true) &&
                                            selectedDevliveryOption ==
                                                DeliveryOptionsEnum.delivery)
                                          DetailTile(
                                              fontSize: 15,
                                              isDiscount: true,
                                              isAmount: true,
                                              title: 'Coupon',
                                              amount:
                                                  '-${(discountAmount ?? 0.0).toStringAsFixed(2)}'),

                                        if ((couponData != null) &&
                                            (couponData?.isDelivery == true))
                                          const CustomDivider(
                                            horizontalPadding: 6,
                                            thickness: 0.25,
                                            color: PetVeterinaryColors
                                                .newPetLightGray,
                                          ),

                                        if (selectedDevliveryOption ==
                                            DeliveryOptionsEnum.delivery)
                                          DetailTile(
                                            fontSize: 15,
                                            isAmount: true,
                                            title: 'Delivery VAT Amount',
                                            totalPrice: deliveryVatAmount,
                                          ),
                                        if (selectedDevliveryOption ==
                                            DeliveryOptionsEnum.delivery)
                                          const CustomDivider(
                                            horizontalPadding: 6,
                                            thickness: 0.25,
                                            color: PetVeterinaryColors
                                                .newPetDarkGray,
                                          ),
                                        if (selectedDevliveryOption ==
                                            DeliveryOptionsEnum.delivery)
                                          DetailTile(
                                            fontSize: 15,
                                            isAmount: true,
                                            isTotal: true,
                                            title: 'Total',
                                            totalPrice: deliveryAndVatTotal,
                                          ),
                                      ],
                                    );
                                  }
                                } else if (state is DeliveryCostError &&
                                    selectedDevliveryOption ==
                                        DeliveryOptionsEnum.delivery) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                            size: 28.0,
                                          ),
                                          const SizedBox(height: 6.0),
                                          Text(
                                            "Delivery pricing isn't available for this shop. Please contact for support."
                                                .tr(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.red,
                                              fontFamily: isEnglish
                                                  ? AppFontsFamily.english
                                                  : AppFontsFamily.arabic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                return const SizedBox.shrink();
                              },
                            ),
                            if ((selectedPaymentOption ==
                                    PaymentOptionsEnum.wallet) &&
                                (((subTotal + shippingFee)) -
                                        (walletAmount ?? 0)) >
                                    0)
                              const CustomDivider(
                                horizontalPadding: 6,
                                thickness: 0.25,
                                color: PetVeterinaryColors.newPetLightGray,
                              ),

                            (selectedPaymentOption ==
                                        PaymentOptionsEnum.wallet) &&
                                    (((subTotal + shippingFee)) -
                                            (walletAmount ?? 0)) >
                                        0
                                ? DetailTile(
                                    isAmount: true,
                                    title:
                                        'Remaining Amount To Be Paid with SADAD',
                                    amount: (selectedDevliveryOption !=
                                            DeliveryOptionsEnum.delivery)
                                        ? (((itemsAndVatTotal + shippingFee)) -
                                                (walletAmount ?? 0))
                                            .toStringAsFixed(2)
                                        : (((itemsAndVatTotal +
                                                    deliveryAndVatTotal)) -
                                                (walletAmount ?? 0))
                                            .toStringAsFixed(2),
                                  )
                                : SizedBox.shrink(),
                          ])),
                    ),
                    kHeight20
                  ]))),
          bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, -2),
                    blurRadius: 6,
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(28, 8, 28, 24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                DetailTile(
                    fontWeight: FontWeight.w600,
                    title: 'Total',
                    totalPrice:
                        selectedDevliveryOption != DeliveryOptionsEnum.delivery
                            ? (itemsAndVatTotal + shippingFee)
                            : ((deliveryAndVatTotal + itemsAndVatTotal))),
                SizedBox(
                  height: 16,
                ),
                CustomButton(
                    radius: 12,
                    fontWeight: FontWeight.w400,
                    height: 54,
                    fontFamily: isEnglish
                        ? AppFontsFamily.english
                        : AppFontsFamily.arabic,
                    fontSize: 15,
                    width: double.infinity,
                    onTap: FeedCheckoutUtils.isCheckingOut
                        ? () {}
                        : () async {
                            final addressState =
                                context.read<AddressCubit>().state;

                            if (addressState is AddressLoaded &&
                                addressState.defaultAddress != null) {
                              defaultAddress = addressState.defaultAddress!;
                              addressId = defaultAddress!.id.toString();
                            }
                            if (_formKey.currentState!.validate()) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              try {
                                UserModel? user =
                                    context.read<AuthCubit>().currentUser;
                                if (selectedDevliveryOption ==
                                    DeliveryOptionsEnum.none) {
                                  CustomSnackBar.message(
                                      context,
                                      "Please select a delivery method before proceeding."
                                          .tr());
                                  return;
                                }
                                debugPrint("defaultAddress: $defaultAddress");

                                if (selectedDevliveryOption ==
                                    DeliveryOptionsEnum.delivery) {
                                  if (defaultAddress == null) {
                                    CustomSnackBar.message(
                                        context,
                                        "No saved address found. Please add a default address to proceed."
                                            .tr());
                                    return;
                                  }

                                  if (formattedDate == "") {
                                    CustomSnackBar.message(
                                      context,
                                      "Please select a delivery date before proceeding."
                                          .tr(),
                                    );
                                    return;
                                  }
                                }

                                final sadadUserInfo = context
                                        .read<SadadUserInfoCubit>()
                                        .state is SadadLoaded
                                    ? (context.read<SadadUserInfoCubit>().state
                                            as SadadLoaded)
                                        .userInfo
                                    : null;
                                if (!isSadadInfoExist(sadadUserInfo,
                                    selectedPaymentOption:
                                        selectedPaymentOption)) {
                                  CustomSnackBar.message(
                                      context,
                                      sadadUserInfo == null
                                          ? "SADAD user information not found. Kindly complete the missing details"
                                              .tr()
                                          : "SADAD user information is incomplete. Please fill the missing details"
                                              .tr());
                                  return;
                                } else if (!isUserPhoneNumberExist(user)) {
                                  await addOrUpdateUserPhoneDialog(
                                    context,
                                    context.read<AuthCubit>().currentUser,
                                  );

                                  return;
                                  // If still no phone, stop checkout
                                  // } else if (!isUserNameExist(user)) {
                                  //   final bool result = await showBtmSheet(
                                  //       context, addUserNameBtmSheet());
                                  //   if (!result) {
                                  //     return;
                                  //   }
                                } else if (selectedPaymentOption ==
                                    PaymentOptionsEnum.none) {
                                  CustomSnackBar.message(
                                      context,
                                      "Please select a payment method before proceeding."
                                          .tr());
                                  return;
                                }
                                await FeedCheckoutUtils.checkout(this, context,
                                    quantity: widget.quantity,
                                    note: deliveryNote,
                                    directBuy: widget.directBuy,
                                    isDelivery: selectedDevliveryOption ==
                                        DeliveryOptionsEnum.delivery,
                                    addressId: addressId,
                                    bookingTime:
                                        formatUtcBookingTime(DateTime.now()),
                                    walletAmount: walletAmount ?? 0,
                                    voucherCode: '',
                                    isWalletChecked: isWalletChecked,
                                    isVoucherClaimed: isVoucherClaimed,
                                    deliveryAmount: deliveryAmount.value,
                                    couponData: couponData,
                                    productItem:
                                        widget.productItem, // only direct buy
                                    defaultAddress: defaultAddress,
                                    selectedPaymentOption:
                                        selectedPaymentOption,
                                    driverNameController: driverNameController,
                                    plateNumberController:
                                        plateNumberController);
                              } catch (e) {
                                if (!context.mounted) return;
                                ErrorHandler.handleError(
                                  context,
                                  e.toString().tr(),
                                );
                              }
                            }
                          },
                    title: FeedCheckoutUtils.isCheckingOut
                        ? "Loading..."
                        : "Pay now"),
                kHeight30,
              ])));
    });
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

String formatUtcBookingTime(DateTime localTime) {
  final utc = localTime.toUtc();
 final formatter = DateFormat("dd-MM-yyyy HH:mm");
  return formatter.format(utc);
}
