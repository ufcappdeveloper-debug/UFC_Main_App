import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/feed/application/app_settings/app_setting_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/app_settings/app_setting_state.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/checkout/sadad/sadad_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/checkout/sadad/sadad_state.dart';
import 'package:ufc_mobile/screens/feed/application/payment/payment_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/payment/payment_state.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/widgets/feed_checkout_payment_method_check_card.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/widgets/feed_checkout_payment_method_radio_card.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/enum/payment_option.dart';

class FeedCheckoutPaymentMethod extends StatelessWidget {
  const FeedCheckoutPaymentMethod({
    super.key,
    required this.subTotal,
    this.isDelivery = false,
    required this.constraints,
    this.isWalletChecked = false,
    required this.onWalletChanged,
    required this.selectedPaymentOption,
    required this.onSelectedPaymentOptionChanged,
  });
  final bool isDelivery;
  final double subTotal;
  final bool isWalletChecked;
  final BoxConstraints constraints;
  final Function(bool value) onWalletChanged;
  final PaymentOptionsEnum selectedPaymentOption;
  final Function(PaymentOptionsEnum paymentOption)
      onSelectedPaymentOptionChanged;

  @override
  Widget build(BuildContext context) {
    final walletAmount = context.read<AuthCubit>().currentUser?.walletAmount;

    return BlocBuilder<AppSettingCubit, AppSettingState>(
        builder: (context, state) {
      if (state is AppSettingLoading) {
        return const Center(
            child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(color: primaryColor),
        ));
      } else if (state is AppSettingError) {
        return CustomReloadProviderV2(
          error: state.message,
          height: 120,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          onPressed: () {
            context.read<AppSettingCubit>().fetchAppSettings();
            context.read<SadadUserInfoCubit>().getUserInfo();
          },
        );
      } else if (state is AppSettingLoaded) {
        final appSettings = state.appSettings;
        final madaStatus = appSettings.madaStatus;
        final sadadStatus = appSettings.sadadStatus;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kHeight10,
            Padding(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: CustomText(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  text: 'Payment Method',
                )),
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //* Pay with Wallet
                  FeedCheckoutPaymentMethodCheckCard(
                    isSelected: isWalletChecked,
                    title: "Pay with Wallet".tr(),
                    icon: 'assets/images/profile/wallet.png',
                    walletAmount: walletAmount?.toStringAsFixed(2),
                    onPressed: () {
                      if (isWalletChecked) {
                        onWalletChanged(false);
                        if (selectedPaymentOption ==
                            PaymentOptionsEnum.wallet) {
                          onSelectedPaymentOptionChanged(
                              PaymentOptionsEnum.none);
                        }
                      } else {
                        onWalletChanged(true);
                        if (selectedPaymentOption == PaymentOptionsEnum.none) {
                          onSelectedPaymentOptionChanged(
                              PaymentOptionsEnum.wallet);
                        }
                      }
                    },
                  ),
                  // Divider(
                  //   thickness: 1,
                  //   color: Color(0XFFF5F5F5),
                  // ),
                  //* Pay with SADAD
                  if (sadadStatus == 'ACTIVE' || sadadStatus == 'INACTIVE')
                    SadadPaymentMethod(
                      status: sadadStatus,
                      title: 'Pay with SADAD'.tr(),
                      icon: 'assets/images/global/sadad.png',
                      paymentOption: PaymentOptionsEnum.sadad,
                      selectedPaymentOption: selectedPaymentOption,
                      constraints: constraints,
                      onPressed: () {
                        if (sadadStatus != "INACTIVE" &&
                            sadadStatus != "DISABLE") {
                          if (selectedPaymentOption ==
                              PaymentOptionsEnum.sadad) {
                            onSelectedPaymentOptionChanged(PaymentOptionsEnum
                                .none); // Deselect if already selected
                          } else {
                            onSelectedPaymentOptionChanged(
                                PaymentOptionsEnum.sadad);
                          }
                        }
                      },
                    ),

                  // Divider(
                  //   thickness: 1,
                  //   color: Color(0XFFF5F5F5),
                  // ),

                  //* Pay with MADA
                  if (madaStatus == 'ACTIVE')
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: FeedCheckoutPaymentMethodRadioCard(
                        sadadUserInfo: null,
                        status: madaStatus,
                        constraints: constraints,
                        title: 'Pay with MADA'.tr(),
                        icon: 'assets/images/cart/mada_logo.png',
                        paymentOption: PaymentOptionsEnum.mada,
                        selectedPaymentOption: selectedPaymentOption,
                        isSelected:
                            selectedPaymentOption == PaymentOptionsEnum.mada,
                        onPressed: () {
                          if (selectedPaymentOption ==
                              PaymentOptionsEnum.mada) {
                            onSelectedPaymentOptionChanged(
                                PaymentOptionsEnum.none);
                          } else {
                            onSelectedPaymentOptionChanged(
                                PaymentOptionsEnum.mada);
                          }
                        },
                      ),
                    ),

                  /* NOTE: APPLE PAY WIDGET HIDDEN */
                  /* Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = 3;
                                      });
                                    },
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        radioButton(selected: selectedIndex == 3),
                                        CustomText(
                                          text: 'Apple Pay',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        const Spacer(),
                                        Image.asset('assets/images/cart/apple_pay.png',
                                            height: 33),
                                        const SizedBox(width: 5),
                                      ],
                                    ),
                                  ),
                                ), */
                  // if (!isDelivery)
                  //   Divider(
                  //     thickness: 1,
                  //     color: Color(0XFFF5F5F5),
                  //   ),

                  // * Cash on Pickup
                  if (!isDelivery)
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: FeedCheckoutPaymentMethodRadioCard(
                        constraints: constraints,
                        title: 'Pay at the station'.tr(),
                        paymentOption: PaymentOptionsEnum.cash,
                        icon: 'assets/images/cart/cod_hand.png',
                        isSelected:
                            selectedPaymentOption == PaymentOptionsEnum.cash,
                        onPressed: () {
                          if (selectedPaymentOption ==
                              PaymentOptionsEnum.cash) {
                            onSelectedPaymentOptionChanged(
                                PaymentOptionsEnum.none);
                          } else {
                            onSelectedPaymentOptionChanged(
                                PaymentOptionsEnum.cash);
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      }
      return const SizedBox.shrink();
    });
  }
}

class SadadPaymentMethod extends StatelessWidget {
  final String? status;
  final BoxConstraints constraints;
  final String title;
  final String icon;
  final PaymentOptionsEnum paymentOption;
  final PaymentOptionsEnum selectedPaymentOption;
  final VoidCallback onPressed;

  const SadadPaymentMethod({
    super.key,
    this.status,
    required this.constraints,
    required this.title,
    required this.icon,
    required this.paymentOption,
    required this.selectedPaymentOption,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SadadUserInfoCubit, SadadUserInfoState>(
      builder: (context, state) {
        final sadadUserInfo = (state is SadadLoaded)
            ? state.userInfo
            : context.read<SadadUserInfoCubit>().userInfo;

        return Padding(
          padding: const EdgeInsets.only(top: 0),
          child: FeedCheckoutPaymentMethodRadioCard(
            isSadad: true,
            sadadUserInfo: sadadUserInfo,
            status: status,
            constraints: constraints,
            title: title.tr(),
            icon: icon,
            paymentOption: paymentOption,
            selectedPaymentOption: selectedPaymentOption,
            isSelected: (status == 'INACTIVE')
                ? false
                : selectedPaymentOption == paymentOption,
            onPressed: onPressed,
          ),
        );
      },
    );
  }
}

class BankPaymentMethod extends StatelessWidget {
  final String? status;
  final BoxConstraints constraints;
  final String title;
  final String icon;
  final PaymentOptionsEnum paymentOption;
  final PaymentOptionsEnum selectedPaymentOption;
  final VoidCallback onPressed;

  const BankPaymentMethod({
    super.key,
    this.status,
    required this.constraints,
    required this.title,
    required this.icon,
    required this.paymentOption,
    required this.selectedPaymentOption,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(builder: (context, state) {
      final bankDetails = state is PaymentLoaded ? state.bankDetails : null;
      return (status == 'ACTIVE')
          ? Column(
              children: [
                Divider(
                  thickness: 1,
                  color: Color(0XFFF5F5F5),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: FeedCheckoutPaymentMethodRadioCard(
                    sadadUserInfo: null,
                    status: status,
                    constraints: constraints,
                    bankDetails: bankDetails,
                    title: title,
                    icon: icon,
                    paymentOption: PaymentOptionsEnum.bank,
                    selectedPaymentOption: selectedPaymentOption,
                    isSelected:
                        selectedPaymentOption == PaymentOptionsEnum.bank,
                    onPressed: onPressed,
                  ),
                ),
              ],
            )
          : SizedBox.shrink();
    });
  }
}
