import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/screens/feed/application/productList/product_list_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/productList/product_list_state.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/product/widgets/item_card/product_grid_item.dart';

class HomeListViewAllList extends StatefulWidget {
  const HomeListViewAllList({
    super.key,
  });

  @override
  State<HomeListViewAllList> createState() => _HomeListViewAllListState();
}

class _HomeListViewAllListState extends State<HomeListViewAllList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ProductListCubit, ProductListState>(
        builder: (context, state) {
          final cubit = context.read<ProductListCubit>();
          List<ProductModel?> products = cubit.products;
          return SizedBox(
            height: 232,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length > 4 ? 4 : products.length,
              itemBuilder: (context, index) {
                ProductModel? product = products[index];
                return product != null
                    ? ProductGridItem(
                        product: product,
                        onTap: () {},
                        onTapOfFavorite: () {},
                      )
                    : SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
