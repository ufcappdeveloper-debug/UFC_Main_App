import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/models/order_summary_model/order_delivery_status.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_footer.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

import '../../../../riverpod/order/order_status.dart';
import '../../../../global/shared/constants/app_colors.dart';
import '../../../../global/shared/widgets/checkout_title.dart';
import '../../../../global/shared/widgets/common_back_app_bar.dart';
import '../../../../global/shared/widgets/custom_pagination_header.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';

class OrderStatusPage extends ConsumerStatefulWidget {
  const OrderStatusPage({
    super.key,
    this.orderId,
  });

  final int? orderId;

  @override
  ConsumerState<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends ConsumerState<OrderStatusPage>
    with ScreenEngagementTracker {
  int page = 1;
  String? pageLimit;
  late RefreshController controller;

  @override
  void initState() {
    super.initState();

    page = 1;
    pageLimit = null;
    Future(() =>
        ref.read(orderStatusProvider.notifier).getOrderStatus(widget.orderId!));
    controller = RefreshController(initialRefresh: false);
  }

  void _onRefresh() async {
    page = 1;
    pageLimit = null;

    await ref
        .read(orderStatusProvider.notifier)
        .getOrderStatus(widget.orderId!);
    if (mounted) setState(() {});
    controller.refreshCompleted();
  }

  void _onLoading() async {
    if (pageLimit != "empty") {
      page++;
    }

    pageLimit = await ref
        .read(orderStatusProvider.notifier)
        .loadOrders(page, widget.orderId!);
    if (mounted) setState(() {});
    controller.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final orderStatusList = ref.watch(orderStatusProvider);
    ref.listen(orderStatusProvider, (previous, next) {
      if (mounted && next.isLoading) {
        page = 1;
        controller.resetNoData();
      }
    });

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CommonBackAppBar(title: "Order Status"),
        body: Column(
          children: [
            checkoutTitle(title: "Tracking history", fontSize: 15),
            const SizedBox(height: 10),
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 8,
                          color: Colors.grey.withValues(alpha: 0.2))
                    ],
                    borderRadius: BorderRadius.circular(15)),
                child: SmartRefresher(
                  enablePullUp: true,
                  enablePullDown: true,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  controller: controller,
                  header: const CustomPaginationHeader(),
                  footer: CustomPaginationFooter(pageLimit: pageLimit),
                  physics: const BouncingScrollPhysics(),
                  child: orderStatusList.when(
                    error: (e, s) => Center(child: Text(e.toString())),
                    loading: () => Center(
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: Platform.isIOS
                            ? mediumGreenColor
                            : Colors.transparent,
                        valueColor:
                            const AlwaysStoppedAnimation(mediumGreenColor),
                      ),
                    ),
                    data: (List<OrderDeliveryStatus> data) => data.isEmpty
                        ? Center(
                            child: CustomText(
                              text: "No Order Status Exists",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : ListView.separated(
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  index == 0
                                      ? Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            SvgPicture.asset(
                                                "assets/images/order/check.svg"),
                                            const SizedBox(width: 45),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10),
                                                CustomText(
                                                    text: data[index]
                                                            .description ??
                                                        "",
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14),
                                                CustomText(
                                                  text: buildFormattedDate(
                                                      context,
                                                      data[index].createdAt),
                                                  color:
                                                      const Color(0xff777777),
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            SvgPicture.asset(
                                                "assets/images/order/truck.svg"),
                                            const SizedBox(width: 30),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10),
                                                CustomText(
                                                  text: data[index]
                                                      .description
                                                      .toString(),
                                                  //      "Being Sent by Courier",
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                ),
                                                CustomText(
                                                  text: buildFormattedDate(
                                                      context,
                                                      data[index].createdAt),
                                                  color:
                                                      const Color(0xff777777),
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                  data.length == 1
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 40,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                child: DottedLine(
                                                    direction: Axis.vertical,
                                                    dashLength: 2,
                                                    lineThickness: 2,
                                                    dashColor: primaryColor),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                    "assets/images/order/truck.svg"),
                                                const SizedBox(width: 30),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 10),
                                                    CustomText(
                                                      text: "",
                                                      //      "Being Sent by Courier",
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                    CustomText(
                                                      text: "",

                                                      //"Completed 15 min",
                                                      color: const Color(
                                                          0xff777777),
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : data.length > index + 1 && index == 0
                                          ? const SizedBox(
                                              height: 40,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                child: DottedLine(
                                                    direction: Axis.vertical,
                                                    dashLength: 2,
                                                    lineThickness: 2,
                                                    dashColor: primaryColor),
                                              ))
                                          : data.length > index + 1 &&
                                                  index != 0
                                              ? const SizedBox(
                                                  height: 40,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 0),
                                                    child: DottedLine(
                                                        direction:
                                                            Axis.vertical,
                                                        dashLength: 2,
                                                        lineThickness: 2,
                                                        dashColor:
                                                            Color(0xffF4B741)),
                                                  ))
                                              : const SizedBox()
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox();
                            },
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40)
          ],
        ));
  }
}

String buildFormattedDate(BuildContext context, DateTime? dateTime) {
  if (dateTime == null) return '';
  String month = DateFormat('MMM', isArabic ? 'ar' : 'en').format(dateTime);
  String day = DateFormat('dd', 'en').format(dateTime);
  String year = DateFormat('yyyy', 'en').format(dateTime);

  return '$month $day $year';
}
