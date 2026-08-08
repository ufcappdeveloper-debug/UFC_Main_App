import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/extensions/app_png_images.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/product/product_util.dart';
import 'package:ufc_mobile/screens/feed/application/cart/cart_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/cart/cart_state.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/enum/order_status_enum.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/pages/feed_order_details.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/utils/feed_order_utils.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/widgets/my_orders_page/status_step.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_shadows.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final OrderStatusEnum status;
  final String? image;

  const OrderCard({
    super.key,
    required this.status,
    this.image,
    required this.order,
  });

  int getStepIndex(OrderStatus status, String orderType) {
    final isPickup = orderType != 'DELIVERY';

    switch (status) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.processing:
        return 1;
      case OrderStatus.shipped:
        return isPickup ? -1 : 2; // shipped only exists for delivery
      case OrderStatus.scheduled:
        return isPickup ? 2 : -1; // scheduled only used for pickup
      case OrderStatus.completed:
        return 3;
      default:
        return -1;
    }
  }

  List<String> get steps {
    if (order.orderType != 'DELIVERY') {
      return const [
        "Order Placed",
        "Preparing",
        "Ready for Pickup",
        "Received",
      ];
    } else {
      return const [
        "Order Placed",
        "Preparing",
        "Shipped",
        "Delivered",
      ];
    }
  }

  String get _orderDescription {
    return ProductUtils.productName(product);
  }

  String get _iconPath {
    if (order.orderType == 'DELIVERY') {
      return AppPngImages.truckPng;
    }
    return AppPngImages.pickupPng;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeedOrderDetails(
              order: order,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
            boxShadow: PetVeterinaryShadows.standard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomText(
                      text: '${'Order Number'.tr()} #${order.id}',
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  if (status == OrderStatusEnum.pending)
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 20,
                            color: PetVeterinaryColors.borderLeftColor),
                        const SizedBox(
                          width: 5,
                        ),
                        CustomText(
                            text: order.createdAt != null
                                ? DateFormat('MMMdd-yyyy', 'en').format(
                                    DateTime.parse(order.createdAt.toString()))
                                : 'N/A',
                            fontSize: 13),
                      ],
                    ),
                  if (status == OrderStatusEnum.cancelled)
                    CustomText(
                        text: 'Order Cancelled'.tr(),
                        fontSize: 13,
                        color: redColor),
                ],
              ),
              subtitle: CustomText(
                text: _orderDescription,
                fontSize: 13,
                color: PetVeterinaryColors.newPetDarkGray,
              ),
              leading: status == OrderStatusEnum.pending
                  ? Container(
                      padding: EdgeInsets.all(
                          order.orderType == 'DELIVERY' ? 8 : 10),
                      decoration: BoxDecoration(
                          color:
                              PetVeterinaryColors.yellowColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6)),
                      height: 43,
                      width: 43,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(isArOrUr ? 0 : math.pi),
                        child: Image.asset(
                          _iconPath,
                          width: 29,
                          height: 29,
                        ),
                      ),
                    )
                  : status == OrderStatusEnum.completed
                      ? Container(
                          padding: EdgeInsets.all(
                              order.orderType == 'DELIVERY' ? 8 : 10),
                          decoration: BoxDecoration(
                              color: primaryColor.withAlpha(20),
                              borderRadius: BorderRadius.circular(6)),
                          height: 43,
                          width: 43,
                          child: Transform(
                            alignment: Alignment.center,
                            transform:
                                Matrix4.rotationY(isArOrUr ? 0 : math.pi),
                            child: Image.asset(
                              _iconPath,
                              width: 27,
                              height: 27,
                              color: primaryColor,
                            ),
                          ),
                        )
                      : status == OrderStatusEnum.cancelled
                          ? Container(
                              padding: EdgeInsets.all(
                                  order.orderType == 'DELIVERY' ? 8 : 10),
                              decoration: BoxDecoration(
                                  color: redColor.withAlpha(20),
                                  borderRadius: BorderRadius.circular(6)),
                              height: 43,
                              width: 43,
                              child: Transform(
                                alignment: Alignment.center,
                                transform:
                                    Matrix4.rotationY(isArOrUr ? 0 : math.pi),
                                child: Image.asset(
                                  _iconPath,
                                  width: 27,
                                  height: 27,
                                  color: redColor,
                                ),
                              ),
                            )
                          : const SizedBox(),
              trailing: status == OrderStatusEnum.completed
                  ? BlocConsumer<CartCubit, CartState>(
                      listener: (context, state) {
                      if (state is CartError) {
                        CustomSnackBar.error(context, state.message.toString());
                      } else if (state is CartLoaded) {
                        // close loading if you use dialog
                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(builder: (_) => const BottomBar(initialIndex: 0)),
                        //   (route) => false,
                        // );
                      }
                    }, builder: (context, state) {
                      final isLoading = state is CartLoading;

                      return GestureDetector(
                        onTap: () async {
                          await FeedOrderUtils.onOrderStatusPressed(context,
                              order: order);
                        },
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomText(
                            text: isLoading ? 'Loading...' : "Reorder",
                            color: primaryColor,
                          ),
                        ),
                      );
                    })
                  : null,
            ),
            if (status == OrderStatusEnum.pending) const SizedBox(height: 10),
            if (status == OrderStatusEnum.pending)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: steps.asMap().entries.map((entry) {
                  final currentStatus =
                      getOrderStatusFromString(order.orderStatus ?? "");

                  final index = entry.key;
                  final label = entry.value;
                  final isActive = index <=
                      getStepIndex(currentStatus, order.orderType ?? '');

                  return Expanded(
                    child: StatusStep(
                      label: label,
                      direction: Axis.horizontal,
                      isActive: isActive,
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  ProductModel? get product {
    if (order.orderItems == null || order.orderItems!.isEmpty) return null;
    return order.orderItems!.first.product;
  }
}
