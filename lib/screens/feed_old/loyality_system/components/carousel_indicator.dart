import 'package:flutter/material.dart';

class CarouselIndicator extends StatelessWidget {
  final CarouselController carouselController;
  final int itemCount;
  final int currentIndex;

  const CarouselIndicator({
    super.key,
    required this.carouselController,
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(itemCount, (index) {
          return GestureDetector(
              onTap: () {
                carouselController
                    .jumpTo(index.toDouble()); // Navigate to the selected page
              },
              child: Container(
                width: 6.0,
                height: 6.0,
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == index
                      ? Colors.green
                      : Colors.grey[400], // Default color
                ),
              ));
        }));
  }
}
