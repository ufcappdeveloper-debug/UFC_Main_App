import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/product/widgets/item_card/product_grid_item.dart';

class ProductListView extends StatelessWidget {
  final List<ProductModel?> products; // Placeholder for product list
  const ProductListView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        // Placeholder for product item widget
        final product = products[index];
        return ProductGridItem(
          product: product,
          onTap: () {},
          onTapOfFavorite: () {},
        );
      },
    );
  }
}
