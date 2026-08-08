import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_images.dart';
import 'package:ufc_mobile/screens/feed/application/bottom_bar_bloc/bottom_bar_bloc.dart';
import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/productList/product_list_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/bottom_bar/page/feed_bottom_bar.dart';
import 'package:ufc_mobile/screens/feed/presentation/category/pages/category_screen.dart';
import 'package:ufc_mobile/screens/feed/presentation/product/widgets/list_view/product_grid_view.dart';

import 'home_product_horizontal_vew.dart';

class HomeProductList extends StatefulWidget {
  final bool isCategory;
  final List<ProductModel> products;

  const HomeProductList(
      {super.key, this.isCategory = false, required this.products});

  @override
  State<HomeProductList> createState() => _HomeProductListState();
}

class _HomeProductListState extends State<HomeProductList> {
  @override
  Widget build(BuildContext context) {
    return widget.isCategory
        ? ProductGridView(
            products: widget.products,
            hasMore: (context
                        .watch<ProductListCubit>()
                        .pagination
                        ?.currentPage ??
                    1) <
                (context.watch<ProductListCubit>().pagination?.lastPage ?? 1),
            onRefresh: () async =>
                context.read<ProductListCubit>().getProducts(),
            onLoadMore: () async => context.read<ProductListCubit>().loadMore(),
          )
        : SizedBox(
            height: 239,
            child: ProductHorizontalListView(
              products: widget.products,
              onVerticalSwipeUp: () {
                if (context.mounted) {
                  context.read<FeedBottomNavCubit>().changeTab(1);
                  context.read<AppBarHeightCubit>().setHeight(31);
                  context.read<AppBarCubit>().setMode(AppBarMode.channel);
                  context
                      .read<FeedBackgroundCubit>()
                      .updateBackground(AppImages.feedSmallBg);
                  CategoryScreen.categoryKey.currentState?.resetTab();
                }
              },
            ),
          );
  }
}
