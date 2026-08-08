import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/product/widgets/product_details/product_details_widgets.dart';

class TabBarProductDetailsContainer extends StatelessWidget {
  const TabBarProductDetailsContainer(
      {super.key, required this.tabDetailsData});
  final List<Map<String, dynamic>> tabDetailsData;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GridView.builder(
        shrinkWrap: true,
        itemCount: tabDetailsData.length,
        padding: const EdgeInsets.only(
          top: 10,
          left: 57,
          right: 34,
          bottom: 28,
        ),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: 3,
          maxCrossAxisExtent: 180,
          crossAxisSpacing: constraints.maxWidth > 500 ? 25 : 5,
          mainAxisSpacing: constraints.maxWidth > 500 ? 10 : 0,
        ),
        itemBuilder: (context, index) => iconAndLabel(
            iconPath: tabDetailsData[index]["iconPath"],
            text: tabDetailsData[index]["text"]),
      );
    });
  }
}
