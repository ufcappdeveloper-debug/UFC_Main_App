import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/barn/animal_model.dart';

import 'livestock_box.dart';

class LivestockGrid extends StatelessWidget {
  final List<AnimalModel?>? animals;
  final double? bootomPadding;
  final ScrollPhysics? scrollPhysics;
  final bool isFromDeath;
  final bool fromBarn;
  final String? category;
  const LivestockGrid(
      {super.key,
      this.bootomPadding,
      required this.animals,
      this.scrollPhysics,
      this.isFromDeath = false,
      this.fromBarn = false,
      this.category});

  @override
  Widget build(BuildContext context) {
    return (animals ?? []).isEmpty
        ? Center(
            child: CustomText(text: 'No Animals Available'),
          )
        : GridView.builder(
            padding: EdgeInsets.only(bottom: bootomPadding ?? 0),
            shrinkWrap: true,
            physics: scrollPhysics,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.7,
            ),
            itemCount: animals?.length,
            itemBuilder: (context, index) {
              return LiveStockBox(
                fromBarn: fromBarn,
                category: category,
                isFromDeath: isFromDeath,
                isMale: index.isEven,
                animal: animals?[index],
              );
            },
          );
  }
}
