import 'package:flutter/material.dart';

class CircularPageStepIndicator extends StatelessWidget {
  const CircularPageStepIndicator({super.key, this.selectedIndex = 0});
  final int selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3, //10,
          (index) => Container(
            height: 5,
            width: index == selectedIndex ? 25 : 5,
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            decoration: BoxDecoration(
                color: index == selectedIndex
                    ? const Color(0xff78B833)
                    : const Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(25)),
          ),
        ).toList(),
      ),
    );
  }
}
