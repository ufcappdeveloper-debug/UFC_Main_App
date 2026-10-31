import 'dart:io';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ufc_mobile/data/order_service.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';
import 'package:ufc_mobile/global/util/navigation/navigation.dart';
import 'package:ufc_mobile/screens/feed/application/cart/cart_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/cart/cart_state.dart';
import 'package:ufc_mobile/screens/feed/application/my_orders/my_orders_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/my_orders/my_orders_state.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/pages/feed_contact_us_page.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/utils/feed_order_utils.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/widgets/my_orders_page/order_details_info_card.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/widgets/my_orders_page/order_info_card.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/widgets/my_orders_page/order_items_card.dart';
import 'package:ufc_mobile/screens/feed/presentation/distributor/widgets/bank_receipt_section.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/widgets/my_orders_page/order_status_card.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/bank_account_card.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_shadows.dart';

class FeedOrderDetails extends StatefulWidget {
  final OrderModel order;
  const FeedOrderDetails({super.key, required this.order});

  @override
  State<FeedOrderDetails> createState() => _FeedOrderDetailsState();
}

class _FeedOrderDetailsState extends State<FeedOrderDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<MyOrdersCubit>().getOrderDetails(widget.order.id ?? 0);
    });
  }

  Future<void> downloadOrderInvoiceAsPDF() async {
    if (widget.order.id == null) {
      throw 'Order not found';
    }
    try {
      Directory? tempDir;
      if (Platform.isIOS) {
        tempDir = await getApplicationDocumentsDirectory();
      } else {
        tempDir = Directory('/storage/emulated/0/Download');
        if (!await tempDir.exists()) {
          tempDir = await getExternalStorageDirectory();
        }
      }
      String fullPath = "${tempDir?.path}/${widget.order.id}-invoice.pdf";
      Response response =
          await OrderService().getOrderInvoice(widget.order.id, fullPath);
      if (response.statusCode == 200) {
        await OpenFilex.open(fullPath);
      } else {
        throw 'Unable to retrieve the PDF file';
      }
    } on DioException catch (e) {
      throw e.dioMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        context.read<MyOrdersCubit>().getMyOrders();
      },
      child: Scaffold(
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
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.order.orderStatus == "COMPLETED")
                  BlocConsumer<CartCubit, CartState>(
                      listener: (context, state) {
                    if (state is CartError) {
                      CustomSnackBar.error(context, state.message.toString());
                    } else if (state is CartLoaded) {}
                  }, builder: (context, state) {
                    final isLoading = state is CartLoading;

                    return CustomButton(
                        fontFamily: isEnglish
                            ? AppFontsFamily.english
                            : AppFontsFamily.arabic,
                        textColor: primaryColor,
                        border: BoxBorder.all(color: primaryColor),
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width * 0.8,
                        onTap: () async {
                          await FeedOrderUtils.onOrderStatusPressed(context,
                              order: widget.order);
                        },
                        title: isLoading ? 'Loading...' : "Reorder");
                  }),
                const SizedBox(height: 12),
                CustomButton(
                    fontFamily: isEnglish
                        ? AppFontsFamily.english
                        : AppFontsFamily.arabic,
                    width: MediaQuery.of(context).size.width * 0.8,
                    onTap: () async {
                      try {
                        final future = downloadOrderInvoiceAsPDF();
                        await LoadingDialog.show(context, future);
                      } catch (e) {
                        if (!context.mounted) return;
                        CustomSnackBar.error(context, e.toString());
                      }
                    },
                    title: "Receipt"),
                kHeight30,
              ],
            ),
          ),
          appBar: AppBar(
            title: CustomText(
              fontSize: 18,
              text: '#${widget.order.id}',
              color: Colors.black,
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            actions: [
              IconButton(
                padding: EdgeInsets.only(right: isArOrUr ? 0 : 15),
                onPressed: () {
                  push(context, FeedContactPage());
                },
                icon: SvgPicture.asset(
                  'assets/svg/feed/message.svg',
                  height: 24,
                  width: 24,
                ),
              ),
            ],
          ),
          body: BlocBuilder<MyOrdersCubit, MyOrdersState>(
            builder: (context, state) {
              if (state is MyOrdersError) {
                return CustomReloadProviderV2(
                  height: 120,
                  error: state.message,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  onPressed: () {
                    context
                        .read<MyOrdersCubit>()
                        .getOrderDetails(widget.order.id ?? 0);
                  },
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
              }
              final isLoading = state is MyOrdersLoading;
              final hasData =
                  state is MyOrdersLoaded && state.orders.isNotEmpty;
              final order = hasData ? state.orders.first : widget.order;

              return Skeletonizer(
                enabled: isLoading,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (order.orderStatus != 'CANCELLED')
                        OrderStatusCard(
                            order: order,
                            currentStatus: getOrderStatusFromString(
                                order.orderStatus.toString())),
                      OrderItemsCard(
                        items: hasData ? order.orderItems : [],
                      ),
                      // Unpaid BANK distributor order: keep the IBAN at hand.
                      if (order.bankTransfer != null &&
                          order.paymentStatus != 'PAID')
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          child: BankTransferBox(
                            transfer: order.bankTransfer!,
                            title: 'Payment pending: bank transfer',
                          ),
                        ),
                      if (order.id != null &&
                          (order.canUploadBankReceipt ||
                              (order.isBankDistributorOrder &&
                                  order.hasBankReceipt)))
                        BankReceiptSection(
                          orderId: order.id!,
                          receiptUrl: order.bankReceiptUrl,
                          uploadedAt: order.bankReceiptUploadedAt,
                          canUpload: order.canUploadBankReceipt,
                          onChanged: () => context
                              .read<MyOrdersCubit>()
                              .getOrderDetails(order.id!),
                        ),
                      OrderInfoCard(order: order),
                      SizedBox(height: 5),
                      if (!isStringEmpty(order.note))
                        InfoCard(
                            padding: const EdgeInsets.only(bottom: 5, left: 10),
                            title: 'Order notes',
                            child: DetailTile(
                                isAmount: false, title: order.note ?? '')),
                      if (!isStringEmpty(order.note)) kHeight5,
                      if (order.goPay != null)
                        InfoCard(
                            padding: const EdgeInsets.only(bottom: 5, left: 10),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: CustomText(
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
                                                    text: order.goPay
                                                            ?.billNumber ??
                                                        '-'))
                                                .whenComplete(() =>
                                                    CustomSnackBar.show(context,
                                                        "${order.goPay?.billNumber} copied to clipboard",
                                                        backgroundColor:
                                                            const Color(
                                                                0xFF4D4D4D)));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
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
                                                    text: order.goPay
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
                                                    text: order.goPay
                                                            ?.sadadNumber ??
                                                        '-'))
                                                .whenComplete(() =>
                                                    CustomSnackBar.show(context,
                                                        "${order.goPay?.sadadNumber} copied to clipboard",
                                                        backgroundColor:
                                                            const Color(
                                                                0xFF4D4D4D)));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
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
                                                    text: order.goPay
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
                              ],
                            )),
                      OrderDetailsCard(
                          order: order,
                          walletPaid: (order.payableAmount != null &&
                                  order.payableAmount != 0 &&
                                  order.totalWithVat != null)
                              ? order.totalWithVat! - order.payableAmount!
                              : 0),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}

enum OrderStatus {
  pending,
  processing,
  shipped,
  completed,
  cancelled,
  rejected,
  scheduled,
}

final List<String> orderSteps = [
  "Order Placed",
  "Preparing",
  "Shipped",
  "Completed",
];

int getStepIndex(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return 0;
    case OrderStatus.processing:
      return 1;
    case OrderStatus.shipped:
      return 2;
    case OrderStatus.completed:
      return 3;
    default:
      return -1;
  }
}

OrderStatus getOrderStatusFromString(String status) {
  try {
    return OrderStatus.values.firstWhere(
      (e) => e.toString().split('.').last == status.toLowerCase(),
      orElse: () => OrderStatus.pending,
    );
  } catch (_) {
    return OrderStatus.pending;
  }
}

class DetailTile extends StatelessWidget {
  final String title;
  final String? amount;
  final bool isDiscount;
  final bool isAmount;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? totalPrice;
  final bool isTotal;
  const DetailTile(
      {super.key,
      required this.title,
      this.amount,
      this.isDiscount = false,
      this.isAmount = true,
      this.fontSize,
      this.isTotal = false,
      this.fontWeight,
      this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        minVerticalPadding: 0,
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
        dense: true,
        title: CustomText(
          text: title,
          fontSize: 15,
          fontWeight: FontWeight.w300,
          color: PetVeterinaryColors.newPetDarkGray,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            amount != null
                ? CustomText(
                    text: amount ?? '',
                    fontSize: fontSize ?? 15,
                    fontWeight: fontWeight ??
                        (isTotal ? FontWeight.w400 : FontWeight.w300),
                    color: isDiscount
                        ? PetVeterinaryColors.mainColorUFC
                        : Colors.black,
                  )
                : totalPrice != null
                    ? CustomText(
                        text: (totalPrice!.isNegative ? 0.00 : totalPrice)!
                            .toStringAsFixed(2),
                        fontSize: fontSize ?? 15,
                        fontWeight: fontWeight ??
                            (isTotal ? FontWeight.w400 : FontWeight.w300),
                        color: isDiscount
                            ? PetVeterinaryColors.mainColorUFC
                            : Colors.black,
                      )
                    : SizedBox.shrink(),
            if (isAmount)
              SaudiRiyalIcon(
                  color: isDiscount
                      ? PetVeterinaryColors.mainColorUFC
                      : Colors.black,
                  size: isTotal ? 14 : 13)
          ],
        ));
  }
}

class InfoCard extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? containerPadding;

  const InfoCard({
    super.key,
    this.title,
    required this.child,
    this.padding,
    this.containerPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
      padding: containerPadding ?? const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: PetVeterinaryShadows.standard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding:
                  padding ?? EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: CustomText(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                text: title!,
              ),
            ),
          child,
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? value;
  final String? icon;
  final String? image;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  const InfoTile({
    super.key,
    this.title,
    this.value,
    this.icon,
    this.image,
    this.leadingWidget,
    this.trailingWidget,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 0,
      dense: true,
      subtitle: subtitle != null
          ? CustomText(
              text: subtitle ?? '',
              fontSize: 15,
            )
          : SizedBox.shrink(),
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      leading: leadingWidget ??
          (icon != null
              ? SvgPicture.asset(
                  icon!,
                  colorFilter: svgGreenColor,
                  width: 24,
                  height: 24,
                )
              : image != null
                  ? Image.asset(image!, height: 20)
                  : null),
      title: title != null
          ? CustomText(
              text: title!,
              fontSize: 15,
            )
          : null,
      trailing: trailingWidget ??
          (value != null
              ? CustomText(
                  text: value!,
                  fontSize: 14,
                )
              : null),
    );
  }
}

class InfoTileV2 extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? value;
  final String? icon;
  final String? image;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final EdgeInsetsGeometry? contentPadding;
  const InfoTileV2(
      {super.key,
      required this.title,
      this.value,
      this.icon,
      this.image,
      this.leadingWidget,
      this.trailingWidget,
      this.subtitle,
      this.contentPadding});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArOrUr ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: ListTile(
        visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minLeadingWidth: 0,
        dense: true,
        leading: leadingWidget ??
            (icon != null
                ? SvgPicture.asset(
                    icon!,
                    colorFilter: svgGreenColor,
                    width: 24,
                    height: 24,
                  )
                : image != null
                    ? Image.asset(image!, height: 20)
                    : null),
        title: CustomText(
          text: title,
          fontSize: 16,
          // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
          fontFamily:
              isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
        ),
        subtitle: subtitle != null
            ? CustomText(
                text: subtitle ?? '',
                fontSize: 12,
                // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
                fontFamily:
                    isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
              )
            : null,
        trailing: trailingWidget ??
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 130),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: CustomText(
                  text: value ?? '-',
                  fontSize: 14,
                  // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
                  fontFamily: isEnglish
                      ? AppFontsFamily.english
                      : AppFontsFamily.arabic,
                ),
              ),
            ),
      ),
    );
  }
}
