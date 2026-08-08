import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_no_data.dart';

class CartPageEmptySection extends StatelessWidget {
  const CartPageEmptySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/cart/empty_cart.png",
          width: 150,
          height: 150,
        ),
        const SizedBox(height: 20),
        const CustomNoData(
          height: 56,
          text: "Your Cart is Empty!",
        ),
      ],
    );
  }
}
