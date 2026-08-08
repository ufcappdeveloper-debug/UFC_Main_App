import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ufc_mobile/data/order_service.dart';
import 'package:ufc_mobile/screens/feed_old/order_details/widgets/receipt/receipt_product_container.dart';
import 'package:ufc_mobile/screens/feed_old/order_details/widgets/receipt/reciept_amount_summary_section.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/checkout_title.dart';
import 'package:ufc_mobile/global/shared/widgets/common_back_app_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

import '../../../feed/domain/entities/order/order_model.dart';
import '../../../../models/order_summary_model/order_summary_model.dart';
import '../../../../global/shared/constants/app_colors.dart';
import '../../../../global/shared/widgets/checkout_details.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';

class ReceiptPage extends ConsumerStatefulWidget {
  const ReceiptPage({
    super.key,
    required this.orderDetails,
    required this.orderSummary,
  });

  final OrderModel orderDetails;
  final List<OrderSummaryModel> orderSummary;

  @override
  ConsumerState<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends ConsumerState<ReceiptPage>
    with ScreenEngagementTracker {
  Future<void> downloadOrderInvoiceAsPDF() async {
    if (widget.orderDetails.id == null) {
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
      String fullPath =
          "${tempDir?.path}/${widget.orderDetails.id}-invoice.pdf";
      Response response = await OrderService()
          .getOrderInvoice(widget.orderDetails.id, fullPath);
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
    return Scaffold(
      appBar: CommonBackAppBar(title: "Receipt", actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 10),
          child: IconButton(
            onPressed: () async {
              try {
                final future = downloadOrderInvoiceAsPDF();
                await LoadingDialog.show(context, future);
              } catch (e) {
                if (!context.mounted) return;
                CustomSnackBar.error(context, e.toString());
              }
            },
            icon: const Icon(
              Icons.print_rounded,
              color: Colors.grey,
            ),
          ),
        ),
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Color(0xffe5e5e5),
                      offset: Offset(0, 4),
                      blurRadius: 8)
                ],
              ),
              child: Column(
                children: [
                  checkoutTitle(
                    title: 'Your order confirmed',
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        checkoutDetails(
                          statusSize: 14,
                          title: 'Order Date',
                          amount: DateFormat('dd MMM yyyy', 'en').format(
                              DateTime.parse(
                                  widget.orderDetails.createdAt.toString())),
                          fontWeight: FontWeight.w500,
                        ),
                        const Divider(),
                        checkoutDetails(
                            title: 'Order No',
                            amountCurrency: '#${widget.orderDetails.id}',
                            currency: false,
                            fontWeight: FontWeight.w500,
                            statusSize: 12),
                        const Divider(),
                        checkoutDetails(
                            title: 'Status',
                            amountCurrency: widget.orderDetails.orderStatus,
                            currency: false,
                            fontWeight: FontWeight.w500,
                            statusSize: 10),
                        const Divider(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: widget.orderSummary.isEmpty ||
                                          widget.orderSummary[0].userAddress ==
                                              null
                                      ? "Delivery Method"
                                      : "Delivery Address",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: const Color.fromRGBO(143, 155, 179, 1),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 30,
                                  child: CustomText(
                                    text: widget.orderSummary.isEmpty ||
                                            widget.orderSummary[0]
                                                    .userAddress ==
                                                null
                                        ? "Pick Up"
                                        : (widget.orderSummary[0].userAddress!
                                                .address ??
                                            "_"),
                                    fontFamily: "Kanit",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        if (isDriverDetailsExist) ...[
                          checkoutDetails(
                            title: 'Driver Name',
                            amountCurrency:
                                widget.orderDetails.driverName ?? '-',
                            currency: false,
                            fontWeight: FontWeight.w500,
                            statusSize: 10,
                          ),
                          kHeight10,
                          const Divider(),
                          checkoutDetails(
                              title: 'Plate number',
                              amountCurrency:
                                  widget.orderDetails.driverPlate ?? '-',
                              currency: false,
                              fontWeight: FontWeight.w500,
                              statusSize: 10),
                          const Divider(),
                        ],
                        ...widget.orderDetails.orderItems!.map((orderItem) =>
                            ReceiptProductContainer(orderItem: orderItem)),

                        //* Reciept Amount Summary
                        RecieptAmountSummarySection(
                          orderDetails: widget.orderDetails,
                        ),
                      ],
                    ),
                  ),
                  checkoutTitle(title: 'Payment Method', color: Colors.black),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        if (widget.orderDetails.paymentMethod == "SADAD")
                          Image.asset("assets/images/global/sadad.png",
                              height: 20),
                        const SizedBox(width: 10),
                        if (widget.orderDetails.paymentMethod != "SADAD")
                          Text(widget.orderDetails.paymentMethod ?? ""),
                      ],
                    ),
                  ),
                  if (widget.orderDetails.goPay != null)
                    checkoutDetails(
                      currency: false,
                      title: 'Bill Number',
                      amountCurrency:
                          widget.orderDetails.goPay!.billNumber ?? "-",
                      fontWeight: FontWeight.w500,
                    ),
                  if (widget.orderDetails.goPay != null) const Divider(),
                  if (widget.orderDetails.goPay != null)
                    checkoutDetails(
                      currency: false,
                      title: 'SADAD Number',
                      amountCurrency:
                          widget.orderDetails.goPay!.sadadNumber ?? "-",
                      fontWeight: FontWeight.w600,
                      priceColor: primaryColor,
                    ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  bool get isDriverDetailsExist {
    if (widget.orderDetails.driverName == null ||
        widget.orderDetails.driverName!.isEmpty ||
        widget.orderDetails.driverPlate == null ||
        widget.orderDetails.driverPlate!.isEmpty) {
      return false;
    }
    return true;
  }
}
