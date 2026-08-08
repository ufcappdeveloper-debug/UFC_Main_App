import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_shadows.dart';

class CartShimmer extends StatelessWidget {
  final bool isWide;

  const CartShimmer({super.key, this.isWide = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView.builder(
        itemCount: 3, // only 3 shimmer cards
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 120, // height of the card
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
                boxShadow: PetVeterinaryShadows.standardLight,
              ),
            ),
          );
        },
      ),
    );
  }
}
