import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';

class CartCarriersNumberCard extends StatelessWidget {
  const CartCarriersNumberCard({
    super.key,
    required this.number,
    required this.onPressed,
    required this.selectedNumber,
  });
  final String number;
  final String selectedNumber;
  final Function(TapDownDetails)? onPressed;

  @override
  Widget build(BuildContext context) => DecoratedBox(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: const Color(0xFFE2E2E2))),
      child: Material(
          color: Colors.white,
          child: InkWell(
              onTapDown: onPressed,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7.5),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.call,
                            size: 15, color: Color(0xFFBFBFBF)),
                        const SizedBox(width: 7.94),
                        Flexible(
                            child: CustomText(
                                text: number,
                                maxLines: 1,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: 7.94),
                        number == selectedNumber
                            ? Container(
                                width: 12,
                                height: 12,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 1, color: primaryColor)),
                                child: const Icon(Icons.done,
                                    size: 8, color: primaryColor),
                              )
                            : SvgPicture.asset("assets/images/cart/copy.svg"),
                      ])))));
}
