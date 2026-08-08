import 'package:flutter/material.dart';

class CircularCarouselIndicator extends StatelessWidget {
  const CircularCarouselIndicator(
      {super.key, this.selectedIndex = 0, this.carouselLength = 3});
  final int selectedIndex;
  final int carouselLength;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          carouselLength, //10,
          (index) => Container(
            height: index == selectedIndex ? 8 : 5,
            width: index == selectedIndex ? 8 : 5,
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            decoration: BoxDecoration(
                color: index == selectedIndex
                    ? const Color.fromRGBO(242, 230, 202, 1)
                    : const Color(0xffE9E9E9),
                borderRadius: BorderRadius.circular(25)),
          ),
        ).toList(),
      ),
    );
  }
}
