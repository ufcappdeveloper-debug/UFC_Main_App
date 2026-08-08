import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/common_back_app_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/global/util/product/product_util.dart';
import 'package:ufc_mobile/models/order_summary_model/order_summary_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/feed_old/order_details/widgets/order_details/order_details_order_summary_section.dart';
import 'package:ufc_mobile/screens/feed_old/order_details/widgets/order_details/order_details_product_container.dart';
import 'package:ufc_mobile/screens/feed_old/orders/utils/order_utils.dart';
import 'package:ufc_mobile/screens/feed_old/orders/widgets/order_driver_details_card.dart';
import 'package:ufc_mobile/screens/feed_old/orders/widgets/order_grey_gap_divider.dart';

import '../../../../global/shared/widgets/checkout_title.dart';
import '../../../../global/util/image_network_extension_method.dart';
import '../../../../riverpod/order/order_summary.dart';
import '../../../feed/domain/entities/order/order_model.dart';
import '../../orders/widgets/menu_item.dart';

class OrderDetails extends ConsumerStatefulWidget {
  const OrderDetails({
    super.key,
    required this.orderHistory,
  });

  final OrderModel orderHistory;
  // late  OrderSummaryModel? orderSummary;

  @override
  ConsumerState<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends ConsumerState<OrderDetails>
    with ScreenEngagementTracker {
  bool isLoading = false;
  Future<void>? future;
  List<OrderSummaryModel> orderSummary = [];

  @override
  void initState() {
    super.initState();

    Future(() => ref
        .read(orderSummaryProvider.notifier)
        .getOrderSummary(widget.orderHistory.id!));
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(orderSummaryProvider).when(
        data: (List<OrderSummaryModel> data) =>
            data.isEmpty ? debugPrint("Error happeend") : orderSummary = data,
        error: (e, s) => Center(child: Text(e.toString())),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonBackAppBar(title: "Order Details"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    CustomText(
                        text: "Order no: ",
                        color: const Color(0xffA1A1A1),
                        fontSize: 14),
                    CustomText(
                        text: "#" "${widget.orderHistory.id}",
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ]),
                  InkResponse(
                    onTap: () async {
                      await OrderUtils.onOrderStatusPressed(context, ref,
                          order: widget.orderHistory);
                    },
                    highlightColor: Colors.transparent,
                    splashColor: Colors.grey.withValues(alpha: 0.11),
                    child: Container(
                        height: 28,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.5),
                          border: Border.all(
                              width: 1.0,
                              color:
                                  widget.orderHistory.orderStatus == "COMPLETED"
                                      ? const Color(0xffFFC53F)
                                      : primaryColor),
                        ),
                        child: Text(
                          (widget.orderHistory.orderStatus == "COMPLETED"
                                  ? "Order again"
                                  : "Track Order")
                              .tr(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                widget.orderHistory.orderStatus == "COMPLETED"
                                    ? const Color(0xffFFC53F)
                                    : primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        )),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xffE9E9E9), height: 1, thickness: 1),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: 120,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                      child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffE8FFCF),
                    ),
                    child: widget.orderHistory.orderItems!.first.product!
                                    .images ==
                                null ||
                            widget.orderHistory.orderItems!.first.product!
                                .images!.isEmpty
                        ? SvgPicture.asset(
                            "assets/images/global/Pattens-Blue-Bg-No-Image-Placeholder.svg",
                            fit: BoxFit.contain)
                        : CachedNetworkImage(
                            imageUrl: widget.orderHistory.orderItems!.first
                                .product!.images!.first.location!,
                            placeholder: loadingPlaceholder,
                            errorWidget: errorWidget,
                            fit: BoxFit.contain),
                  )),
                  const SizedBox(width: 10),
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        text: ProductUtils.productName(
                                            productFromOrder),
                                        maxLines: 1,
                                        fontSize: 12,
                                        fontFamily: 'Kanit',
                                        overflow: TextOverflow.clip,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                CustomText(
                                  text: (isEnglish
                                          ? widget.orderHistory.orderItems
                                              ?.first.product?.descriptionEn
                                          : isArabic
                                              ? widget.orderHistory.orderItems
                                                  ?.first.product?.descriptionAr
                                              : widget
                                                  .orderHistory
                                                  .orderItems
                                                  ?.first
                                                  .product
                                                  ?.descriptionUr) ??
                                      "",
                                  maxLines: 1,
                                  fontSize: 10,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                  overflow: TextOverflow.clip,
                                  color: const Color(0xff9C9CA0),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        CustomText(
                                          text: (widget.orderHistory.orderItems
                                                      ?.first.orderPrice ??
                                                  0.00)
                                              .toStringAsFixed(2),
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        // CustomText(
                                        //   text: "SAR",
                                        //   fontFamily: 'Kanit',
                                        //   fontSize: 11,
                                        //   textAlign: TextAlign.end,
                                        //   fontWeight: FontWeight.w300,
                                        // ),
                                        SaudiRiyalIcon(
                                          size: 11,
                                          color: Colors
                                              .black, // Or any color you want
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                CustomText(
                                  text: widget.orderHistory.orderItems!.first
                                              .quantity!
                                              .toInt() >
                                          1
                                      ? "${widget.orderHistory.orderItems!.first.quantity ?? 0} ${"Items".tr()}"
                                      : "${widget.orderHistory.orderItems!.first.quantity ?? 0} ${"Item".tr()}",
                                  fontFamily: 'Poppins',
                                  fontSize: 10,
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
            Container(
              child: menuItem(
                  iconPath: "assets/images/order/clock.svg",
                  title: "Order on",
                  description:
                      "${DateFormat('dd MMM yyyy', 'en').format(DateTime.parse(widget.orderHistory.createdAt!.toString()))} ${"at".tr()} ${DateFormat.jm('en').format(widget.orderHistory.createdAt!)}",
                  iconSize: 16),
            ),
            const SizedBox(height: 5),
            const Divider(
              color: Color(0xffE9E9E9),
              height: 0,
              thickness: 1,
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                top: 15,
                right: 15,
              ),
              width: double.infinity,
              child: Container(
                color: Colors.white,
                child: InkWell(
                  onTap: () {},
                  child: Row(children: [
                    Expanded(
                      child: SvgPicture.asset(
                        "assets/images/order/fast_delivery.svg",
                        height: 16,
                        width: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 15,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                    text: orderSummary.isEmpty ||
                                            orderSummary[0].userAddress == null
                                        ? 'Delivery Method'
                                        : 'Delivery address',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300),
                              ),
                              Expanded(
                                child: CustomText(
                                    overflow: TextOverflow.ellipsis,
                                    text: widget.orderHistory.orderType ==
                                            "DELIVERY"
                                        ? "Delivery"
                                        : "Pick Up",
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    textAlign: TextAlign.end,
                                    color: const Color(0xff929292)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 5),
            const Divider(color: Color(0xffE9E9E9), height: 2, thickness: 1),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20, top: 15, right: 15),
              child: Container(
                color: Colors.white,
                child: InkWell(
                  onTap: () {},
                  child: Row(children: [
                    Expanded(
                      child: SvgPicture.asset(
                        'assets/images/order/money.svg',
                        height: 16,
                        width: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 15,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CustomText(
                                      text: "Payment",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300),
                                ],
                              ),
                              if (widget.orderHistory.paymentMethod != "SADAD")
                                CustomText(
                                    text:
                                        widget.orderHistory.paymentMethod ?? "",
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300),
                              if (widget.orderHistory.paymentMethod == "SADAD")
                                Image.asset("assets/images/global/sadad.png",
                                    height: 20),
                            ],
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 5),
            if (isDriverDetailsExist) const OrderGreyGapDivider(),
          //  if (isDriverDetailsExist)
              OrderDriverDetailsCard(
                driverName: widget.orderHistory.driverName,
                plateNumber: widget.orderHistory.driverPlate,
              ),
            const OrderGreyGapDivider(),
            if (widget.orderHistory.goPay != null)
              Container(
                margin: const EdgeInsets.only(
                  left: 20,
                  top: 15,
                  right: 15,
                ),
                width: double.infinity,
                child: Container(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(
                          text: widget.orderHistory.goPay!.billNumber ?? "-"));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: CustomText(
                              text: "Bill Number",
                              fontSize: 15,
                              fontWeight: FontWeight.w300),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            height: 25,
                            decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(color: primaryColor)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                    text: widget.orderHistory.goPay!.billNumber
                                        .toString(),
                                    fontSize: 14),
                                Image.asset("assets/images/cart/copy.png"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (widget.orderHistory.goPay != null)
              Container(
                margin: const EdgeInsets.only(
                  left: 20,
                  top: 15,
                  right: 15,
                ),
                width: double.infinity,
                child: Container(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(
                          text: widget.orderHistory.goPay!.sadadNumber!));
                    },
                    child: Row(children: [
                      Expanded(
                        flex: 15,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomText(
                                      text: "SADAD Number",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    height: 25,
                                    decoration: BoxDecoration(
                                        color:
                                            Colors.grey.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(3),
                                        border:
                                            Border.all(color: primaryColor)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                            text: widget.orderHistory.goPay!
                                                    .sadadNumber ??
                                                "-",
                                            fontSize: 14),
                                        Image.asset(
                                            "assets/images/cart/copy.png"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
              ),
            const SizedBox(height: 5),
            if (widget.orderHistory.goPay != null) const OrderGreyGapDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                checkoutTitle(title: 'Your order', color: Colors.black),
                checkoutTitle(
                  fontWeight: FontWeight.w300,
                  title: widget.orderHistory.orderItems!.isEmpty
                      ? "0"
                      : widget.orderHistory.orderItems!.length > 1
                          ? '${widget.orderHistory.orderItems!.length} ${"Items".tr()}'
                          : '${widget.orderHistory.orderItems!.length} ${"Item".tr()}',
                  color: const Color(0xff929292),
                ),
              ],
            ),
            ...widget.orderHistory.orderItems!.map((orderItem) =>
                OrderDetailsProductContainer(orderItem: orderItem)),
            const Divider(color: Color(0xffE9E9E9), height: 1),
            const OrderGreyGapDivider(),
            OrderDetailsOrderSummarySection(
              orderSummary: orderSummary,
              orderHistory: widget.orderHistory,
            ),
          ],
        ),
      ),
    );
  }

  bool get isDriverDetailsExist {
    if (widget.orderHistory.driverName == null ||
        widget.orderHistory.driverName!.isEmpty ||
        widget.orderHistory.driverPlate == null ||
        widget.orderHistory.driverPlate!.isEmpty) {
      return false;
    }
    return true;
  }

  ProductModel? get productFromOrder {
    return widget.orderHistory.orderItems?.first.product;
  }
}
