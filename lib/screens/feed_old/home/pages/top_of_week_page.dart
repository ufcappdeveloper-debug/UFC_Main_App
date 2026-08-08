import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_no_data.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

import '../../../../global/shared/widgets/product_container.dart';

// ignore: must_be_immutable
class TopOfTheWeek extends StatefulWidget {
  TopOfTheWeek({super.key, required this.products});
  List<ProductModel> products;

  @override
  State<TopOfTheWeek> createState() => _TopOfTheWeekState();
}

class _TopOfTheWeekState extends State<TopOfTheWeek>
    with ScreenEngagementTracker {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: CustomText(
            text: 'Top of the Week',
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: Colors.black.withValues(alpha: 0.3),
          leading: const BackButton(
            color: Colors.black,
          )),
      body: Column(
        children: [
          (widget.products.isEmpty)
              ? const Column(
                  children: [
                    CustomNoData(
                      height: 56,
                      text: "No Product Found",
                    ),
                  ],
                )
              : Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: widget.products.length,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 17,
                            childAspectRatio: 0.62,
                            maxCrossAxisExtent: 197),
                    itemBuilder: (context, index) {
                      return ProductContainer(
                          productData: widget.products[index]);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
