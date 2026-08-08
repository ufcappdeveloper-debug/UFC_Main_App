// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ufc_mobile/riverpod/product/product_riverpod.dart';
// import 'package:ufc_mobile/shared/widgets/global/custom_snack_bar.dart';

// class CustomQtyContainer extends ConsumerWidget {
//   const CustomQtyContainer({super.key, required this.controller,     required this.availableStock,
//     required this.cartQuantity,});
//   final TextEditingController controller;
//     final int availableStock;
//   final int cartQuantity;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // controller.text = ref.watch(productProvider).qty.toString();
//       final productQty = ref.watch(productProvider).qty;

//     if (controller.text != productQty.toString()) {
//       controller.text = productQty.toString();
//       controller.selection = TextSelection.fromPosition(
//         TextPosition(offset: controller.text.length),
//       );
//     }

//     return Container(
//       height: 24,
//       width: 117,
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//           color: const Color(0xFFF4B741),
//           borderRadius: BorderRadius.circular(16)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           InkWell(
//             onTap: () => ref.watch(productProvider).decrementProductQty(),
//             child: Container(
//                 height: 16,
//                 width: 16,
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20)),
//                 child: const Icon(Icons.remove,
//                     size: 15, color: Color(0xffF4B741))),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4.5),
//               child: TextField(
//                 cursorHeight: 13,
//                 controller: controller,
//                 cursorColor: Colors.white,
//                 textAlign: TextAlign.center,
//                 keyboardType: TextInputType.number,
//                 style: const TextStyle(color: Colors.white),
//                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 onChanged: (value) {
//                   int? tempQty = int.tryParse(value);
//                   if (tempQty != null) {
//                     ref.read(productProvider).changeProductQty(tempQty);
//                   } else {
//                     CustomSnackBar.error(
//                         context, 'Something went wrong. Invalid Quantity.');
//                   }
//                 },
//                 decoration: const InputDecoration(
//                   isDense: true,
//                   isCollapsed: true,
//                   contentPadding: EdgeInsets.zero,
//                   border: UnderlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.white,
//                     ),
//                   ),
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.white,
//                     ),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           InkWell(
//             onTap: () => ref.watch(productProvider).incrementProductQty(),
//             child: Container(
//                 height: 16,
//                 width: 16,
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20)),
//                 child:
//                     const Icon(Icons.add, size: 15, color: Color(0xffF4B741))),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/models/cart_item_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/riverpod/state.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';

class CustomQtyContainer extends ConsumerStatefulWidget {
  const CustomQtyContainer({
    super.key,
    required this.controller,
    required this.productData,
  });

  final TextEditingController controller;
  final ProductModel productData;

  @override
  ConsumerState<CustomQtyContainer> createState() => _CustomQtyContainerState();
}

class _CustomQtyContainerState extends ConsumerState<CustomQtyContainer> {
  late int currentQty;

  @override
  void initState() {
    super.initState();
    currentQty = 1;
    widget.controller.text = currentQty.toString();
  }

  void updateQty(int newQty) {
    setState(() {
      currentQty = newQty;
      widget.controller.text = newQty.toString();
      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.controller.text.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final variant = widget.productData.variants!.first;
    final stock = variant.stock ?? 0;

    final existingItem = ref.watch(cartProvider).cartItems.firstWhere(
          (item) => item.variant?.id == variant.id,
          orElse: () => CartItemModel(quantity: 0),
        );

    final cartQuantity = existingItem.quantity ?? 0;
    final remainingStock = stock - cartQuantity;
    return Container(
      height: 24,
      width: 117,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4B741),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Decrement Button
          InkWell(
            onTap: () {
              if (currentQty > 1) {
                updateQty(currentQty - 1);
              }
            },
            child: Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child:
                  const Icon(Icons.remove, size: 15, color: Color(0xffF4B741)),
            ),
          ),

          // Quantity Input
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4.5),
              child: TextField(
                cursorHeight: 13,
                controller: widget.controller,
                cursorColor: Colors.white,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                // onChanged: (value) {
                //   int? tempQty = int.tryParse(value);

                //   if (tempQty == null || tempQty <= 0) {
                //     CustomSnackBar.error(context, 'Invalid quantity entered.');
                //     widget.controller.text = '1';
                //     widget.controller.selection = TextSelection.fromPosition(
                //       TextPosition(offset: widget.controller.text.length),
                //     );
                //     return;
                //   }

                //   if (tempQty > remainingStock) {
                //     CustomSnackBar.error(context,
                //         'You can order up to $remainingStock more of this product.');
                //     widget.controller.text = remainingStock.toString();
                //     widget.controller.selection = TextSelection.fromPosition(
                //       TextPosition(offset: widget.controller.text.length),
                //     );
                //   }
                // },
                onChanged: (value) {
                  if (value.isEmpty) return;

                  int? tempQty = int.tryParse(value);
                  if (tempQty == null || tempQty <= 0) {
                    CustomSnackBar.error(context, 'Invalid quantity entered');
                    widget.controller.text = '1';
                    widget.controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: widget.controller.text.length),
                    );
                    return;
                  }
                  if (tempQty > remainingStock) {
                    CustomSnackBar.error(context,
                        '${"You can order up to".tr()} $remainingStock');
                    widget.controller.text = '1';
                    widget.controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: widget.controller.text.length),
                    );
                  }
                },

                decoration: const InputDecoration(
                  isDense: true,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.zero,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),

          // Increment Button
          InkWell(
            onTap: () {
              if (currentQty < remainingStock) {
                updateQty(currentQty + 1);
              } else {
                CustomSnackBar.error(
                  context,
                  "Cannot add more. Stock limit reached",
                );
              }
            },
            child: Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.add, size: 15, color: Color(0xffF4B741)),
            ),
          ),
        ],
      ),
    );
  }
}
