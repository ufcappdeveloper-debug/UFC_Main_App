import 'package:flutter/material.dart';

class ProductCarouselIndicator extends StatelessWidget {

  const ProductCarouselIndicator({
    super.key,
    this.selectedIndex = 0,
    this.carouselLength = 3,
    this.indicatorSize = 4,
  });
  final double indicatorSize;
  final int selectedIndex;
  final int carouselLength;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 30, vertical: indicatorSize > 4 ? 15 : 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          carouselLength, //10,
          (index) => Container(
            height: indicatorSize,
            width: indicatorSize,
            margin:
                EdgeInsets.symmetric(horizontal: indicatorSize > 4 ? 2.5 : 1.5),
            decoration: BoxDecoration(
                color: index == selectedIndex
                    ? const Color(0xff78B833)
                    : const Color(0xffEBEBEB),
                borderRadius: BorderRadius.circular(25)),
          ),
        ).toList(),
      ),
    );
  }
}
