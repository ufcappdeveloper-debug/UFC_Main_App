import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class CartItemCounter extends StatelessWidget {
  const CartItemCounter({
    super.key,
    this.quantity = 1,
    this.isLoading = false,
    required this.onDecrement,
    required this.onIncrement,
  });
  final int quantity;
  final bool isLoading;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  @override
  Widget build(BuildContext context) {
    int currentQuantity = quantity;
    return Container(
        width: 73,
        height: 24,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xffF4B741),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: onDecrement,
              child: Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.remove,
                  size: 15,
                  color: Color(0xffF4B741),
                ),
              ),
            ),
            isLoading
                ? Expanded(
                    child: Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        size: 17,
                        color: Colors.white,
                      ),
                    ),
                  )
                : SizedBox(
                    width: 25,
                    child: CustomText(
                      text: '$currentQuantity',
                      color: Colors.white,
                      textAlign: TextAlign.center,
                    ),
                  ),
            InkWell(
              onTap: onIncrement,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.add,
                  size: 15,
                  color: Color(0xffF4B741),
                ),
              ),
            ),
          ],
        ));
  }
}
