import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/feed_old/home/pages/top_of_week_page.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/product_container.dart';

class HomeTopOfTheWeekSection extends StatelessWidget {
  const HomeTopOfTheWeekSection({
    super.key,
    required this.topOfWeek,
  });
  final List<ProductModel> topOfWeek;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              CustomText(
                text: 'Top of the Week',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopOfTheWeek(products: topOfWeek),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomText(
                      text: 'View all',
                      fontSize: 14,
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      size: 12,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        topOfWeek.isEmpty
            ? const SizedBox.shrink()
            : Container(
                height: 267,
                color: Colors.white,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: topOfWeek.length,
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  itemBuilder: (context, index) {
                    return ProductContainer(
                      productData: topOfWeek[index],
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 17),
                ),
              ),
      ],
    );
  }
}
