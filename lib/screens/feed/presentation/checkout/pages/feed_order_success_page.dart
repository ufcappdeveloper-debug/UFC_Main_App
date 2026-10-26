import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/extensions/app_images.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/global/util/product/product_util.dart';
import 'package:ufc_mobile/models/checkout/checkout_model.dart';
import 'package:ufc_mobile/screens/feed/application/bottom_bar_bloc/bottom_bar_bloc.dart';
import 'package:ufc_mobile/screens/feed/application/my_orders/my_orders_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/my_orders/my_orders_state.dart';
import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';
import 'package:ufc_mobile/screens/feed/presentation/bottom_bar/page/feed_bottom_bar.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/pages/feed_order_details.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';

import '../../../../../global/shared/widgets/show_confirmation_dailog.dart';

class FeedOrderSuccessPage extends StatefulWidget {
  const FeedOrderSuccessPage(
      {super.key, this.onPressed, required this.checkoutDetails});
  final VoidCallback? onPressed;
  final CheckoutModel checkoutDetails;

  @override
  State<FeedOrderSuccessPage> createState() => _FeedOrderSuccessPageState();
}

class _FeedOrderSuccessPageState extends State<FeedOrderSuccessPage>
    with ScreenEngagementTracker {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      context
          .read<MyOrdersCubit>()
          .getOrderDetails(widget.checkoutDetails.checkoutSummary?.id ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: WillPopScope(
        onWillPop: () async {
          final shouldExit = await showConfirmationDialog(
            context: context,
            title: 'exit_app_title'.tr(),
            content: 'exit_app_content'.tr(),
          );

          return shouldExit ?? false;
        },
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            extendBodyBehindAppBar: true,
            body: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                kHeight40,
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Lottie.asset(
                      'assets/new_design/animations/celebrate.json',
                      width: 260,
                      height: 150,
                      fit: BoxFit.contain,
                      repeat: false,
                    ),
                    Container(
                      width: 85,
                      height: 85,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: SvgPicture.asset(
                          'assets/svg/feed/success.svg',
                          width: 82.5,
                          height: 82.5,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                CustomText(
                  // fontFamily: isArOrUr ? 'Graphik Arabic' : "Kanit",
                  fontFamily: isEnglish
                      ? AppFontsFamily.english
                      : AppFontsFamily.arabic,
                  text: "Your order has been\nprocessed successfully",
                  textAlign: TextAlign.center,
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(30, 51, 84, 1),
                ),
                kHeight20,
                BlocBuilder<MyOrdersCubit, MyOrdersState>(
                    builder: (context, state) {
                  if (state is MyOrdersLoading) {
                    return const Center(child: CupertinoActivityIndicator());
                  } else if (state is MyOrdersError) {
                    return Center(
                      child: CustomText(
                        text: state.message.toString(),
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    );
                  } else if (state is MyOrdersLoaded) {
                    if (state.orders.isEmpty) {
                      return Center(
                        child: CustomText(
                          text: 'No order details found.',
                          fontSize: 16,
                        ),
                      );
                    }
                    double walletPaid =
                        (state.orders.first.payableAmount != null &&
                                state.orders.first.payableAmount != 0 &&
                                state.orders.first.totalWithVat != null)
                            ? state.orders.first.totalWithVat! -
                                state.orders.first.payableAmount!
                            : 0;
                    return Column(
                      children: [
                        InfoCard(
                            title: 'Order Status',
                            child: Column(
                              children: [
                                kHeight10,
                                InfoTile(
                                    title: 'Order Number',
                                    value: '#${state.orders.first.id ?? 0}'),
                                Divider(
                                    height: 12,
                                    thickness: 0.5,
                                    color: Colors.grey[300]),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        // fontFamily: isArOrUr
                                        //     ? 'Graphik Arabic'
                                        //     : 'Kanit',
                                        fontFamily: isEnglish
                                            ? AppFontsFamily.english
                                            : AppFontsFamily.arabic,
                                        text: 'Ordered Products',
                                        fontSize: 16,
                                      ),
                                      kWidth15,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: (state.orders.first
                                                      .orderItems ??
                                                  [])
                                              .map((item) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: CustomText(
                                                      // fontFamily: isArOrUr
                                                      //     ? 'Graphik Arabic'
                                                      //     : 'Kanit',
                                                      fontFamily: isEnglish
                                                          ? AppFontsFamily
                                                              .english
                                                          : AppFontsFamily
                                                              .arabic,
                                                      text: ProductUtils
                                                          .productName(
                                                              item.displayProduct),
                                                      fontSize: 13,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  CustomText(
                                                    text:
                                                        '${item.quantity}${isArOrUr ? ' كيس' : ' Bag'}',
                                                    fontSize: 13,
                                                    // fontFamily: isArOrUr
                                                    //     ? 'Graphik Arabic'
                                                    //     : 'Kanit',
                                                    fontFamily: isEnglish
                                                        ? AppFontsFamily.english
                                                        : AppFontsFamily.arabic,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                    height: 12,
                                    thickness: 0.5,
                                    color: Colors.grey[300]),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: isArOrUr ? 0 : 10,
                                      right: isArOrUr ? 10 : 0),
                                  child: DetailTile(
                                    title: 'Total',
                                    amount: (state.orders.first.totalWithVat ??
                                            0.00)
                                        .toStringAsFixed(2),
                                  ),
                                ),
                                if (state.orders.first.orderType == 'DELIVERY')
                                  Divider(
                                      height: 12,
                                      thickness: 0.5,
                                      color: Colors.grey[300]),
                                if (state.orders.first.orderType == 'DELIVERY')
                                  InfoTile(
                                      title: 'Estimated Arrival Time',
                                      value:
                                          state.orders.first.bookingDateTime !=
                                                  null
                                              ? DateFormat('MMM dd-yyyy', 'en')
                                                  .format(DateTime.parse(state
                                                      .orders
                                                      .first
                                                      .bookingDateTime
                                                      .toString()))
                                              : '-'),
                                Divider(
                                    height: 12,
                                    thickness: 0.5,
                                    color: Colors.grey[300]),
                                InfoTileV2(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 4),
                                    title:
                                        state.orders.first.userAddress == null
                                            ? 'Delivery Method'
                                            : 'Delivery Address',
                                    value: state.orders.first.userAddress ==
                                            null
                                        ? state.orders.first.orderType ==
                                                "DELIVERY"
                                            ? 'Delivery'
                                            : 'Pickup from Station'
                                        : state.orders.first.userAddress
                                                ?.address ??
                                            '-'),
                                Divider(
                                    height: 12,
                                    thickness: 0.5,
                                    color: Colors.grey[300]),
                                kHeight10,
                                if (state.orders.first.goPay != null)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 3,
                                            child: CustomText(
                                              // fontFamily: isArOrUr
                                              //     ? 'Graphik Arabic'
                                              //     : "Kanit",
                                              fontFamily: isEnglish
                                                  ? AppFontsFamily.english
                                                  : AppFontsFamily.arabic,
                                              text: 'Bill Number',
                                              fontSize: 16,
                                            )),
                                        Expanded(
                                          flex: 2,
                                          child: InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                      text: state
                                                              .orders
                                                              .first
                                                              .goPay
                                                              ?.billNumber ??
                                                          '-'))
                                                  .whenComplete(() =>
                                                      CustomSnackBar.show(
                                                          context,
                                                          "${state.orders.first.goPay?.billNumber} copied to clipboard",
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFF4D4D4D)));
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              height: 25,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  border: Border.all(
                                                      color: primaryColor)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                      text: state
                                                              .orders
                                                              .first
                                                              .goPay
                                                              ?.billNumber ??
                                                          "",
                                                      fontSize: 14),
                                                  Image.asset(
                                                      "assets/images/cart/copy.png"),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (state.orders.first.goPay != null)
                                  Divider(
                                      height: 12,
                                      thickness: 0.5,
                                      color: Colors.grey[300]),
                                if (state.orders.first.goPay != null)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 3,
                                            child: CustomText(
                                              // fontFamily: isArOrUr
                                              //     ? 'Graphik Arabic'
                                              //     : "Kanit",
                                              fontFamily: isEnglish
                                                  ? AppFontsFamily.english
                                                  : AppFontsFamily.arabic,
                                              text: 'SADAD Number',
                                              fontSize: 16,
                                            )),
                                        Expanded(
                                          flex: 2,
                                          child: InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                      text: state
                                                              .orders
                                                              .first
                                                              .goPay
                                                              ?.sadadNumber ??
                                                          '-'))
                                                  .whenComplete(() =>
                                                      CustomSnackBar.show(
                                                          context,
                                                          "${state.orders.first.goPay?.sadadNumber} copied to clipboard",
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFF4D4D4D)));
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              height: 25,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  border: Border.all(
                                                      color: primaryColor)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                      text: state
                                                              .orders
                                                              .first
                                                              .goPay
                                                              ?.sadadNumber ??
                                                          "",
                                                      fontSize: 14),
                                                  Image.asset(
                                                      "assets/images/cart/copy.png"),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                InfoTile(
                                    leadingWidget: Image.asset(
                                      state.orders.first.paymentMethod ==
                                              "SADAD"
                                          ? "assets/images/global/sadad.png"
                                          : state.orders.first.paymentMethod ==
                                                  "MADA"
                                              ? "assets/images/cart/mada_logo.png"
                                              : state.orders.first
                                                          .paymentMethod ==
                                                      "WALLET"
                                                  ? "assets/images/profile/wallet.png"
                                                  : state.orders.first
                                                              .paymentMethod ==
                                                          "CASH"
                                                      ? 'assets/images/cart/cod_hand.png'
                                                      : '',
                                      height: 20,
                                      color: state.orders.first.paymentMethod ==
                                              "WALLET"
                                          ? Colors.grey
                                          : null,
                                    ),
                                    value: state.orders.first.paymentMethod ==
                                            "WALLET"
                                        ? state.orders.first.totalWithVat
                                            ?.toStringAsFixed(2)
                                        : state.orders.first.payableAmount
                                            ?.toStringAsFixed(2)),
                                if (state.orders.first.paymentMethod !=
                                        "WALLET" &&
                                    walletPaid > 0)
                                  Column(
                                    children: [
                                      Divider(
                                          thickness: 0.5,
                                          color: Colors.grey[300]),
                                      InfoTile(
                                          leadingWidget: Image.asset(
                                            "assets/images/profile/wallet.png",
                                            height: 20,
                                            color: Colors.grey,
                                          ),
                                          value: walletPaid.toStringAsFixed(2)),
                                    ],
                                  ),
                                if (state.orders.first.goPay != null)
                                  Divider(
                                      thickness: 0.5, color: Colors.grey[300]),
                                InfoTile(
                                    title: 'Payment Method',
                                    value: state.orders.first.paymentMethod !=
                                            "SADAD"
                                        ? state.orders.first.paymentMethod ?? ''
                                        : null,
                                    trailingWidget: state
                                                .orders.first.paymentMethod ==
                                            "SADAD"
                                        ? Image.asset(
                                            "assets/images/global/sadad.png",
                                            height: 20)
                                        : state.orders.first.paymentMethod ==
                                                "MADA"
                                            ? Image.asset(
                                                "assets/images/cart/mada_logo.png",
                                                height: 20)
                                            : null),
                              ],
                            )),
                        const SizedBox(height: 10),
                        Column(children: [
                          CustomButton(
                              // fontFamily: isArOrUr ? 'Graphik Arabic' : "Kanit",
                              fontFamily: isEnglish
                                  ? AppFontsFamily.english
                                  : AppFontsFamily.arabic,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FeedOrderDetails(
                                            order: state.orders.first)));
                              },
                              title: "Track my Order",
                              fontSize: 15),
                          const SizedBox(height: 20),
                          CustomButton(
                              // fontFamily: isArOrUr ? 'Graphik Arabic' : "Kanit",
                              fontFamily: isEnglish
                                  ? AppFontsFamily.english
                                  : AppFontsFamily.arabic,
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          BottomBar(initialIndex: 0)),
                                  (route) => false,
                                );
                                context.read<FeedBottomNavCubit>().changeTab(0);

                                context
                                    .read<FeedBackgroundCubit>()
                                    .updateBackground(AppImages.feedBg);
                                context
                                    .read<AppBarCubit>()
                                    .setMode(AppBarMode.normal);
                              },
                              title: "Back to Home",
                              fontSize: 15,
                              textColor: primaryColor,
                              color: Colors.white,
                              border: Border.all(color: primaryColor)),
                        ]),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),
                kHeight40
              ]),
            )),
      ),
    );
  }
}
