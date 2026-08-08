import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BarnDropdownShimmer extends StatelessWidget {
  const BarnDropdownShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 38,
        width: 140,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
