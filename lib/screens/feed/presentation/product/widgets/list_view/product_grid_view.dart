import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✅ Needed for ref
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_footer.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_header.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/favorite/favorite_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/productList/product_list_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_list_params.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/product/widgets/item_card/product_grid_item.dart';

import '../../pages/feed_product_details_screen.dart';

class ProductGridView extends ConsumerStatefulWidget {
  final bool? showOnly1Row;
  final List<ProductModel> products;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final bool hasMore;
  final bool showFavoriteIcon;
  final bool fromFav;

  const ProductGridView(
      {super.key,
      required this.products,
      this.showOnly1Row = false,
      this.onRefresh,
      this.onLoadMore,
      this.hasMore = true,
      this.showFavoriteIcon = false,
      this.fromFav = false});

  @override
  ConsumerState<ProductGridView> createState() => _ProductGridViewState();
}

class _ProductGridViewState extends ConsumerState<ProductGridView> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late ProductListCubit prodListCubit;
  late AuthCubit authCubit;
  String? _pageLimit;

  Future<void> _handleRefresh() async {
    _pageLimit = null;
    if (widget.onRefresh != null) {
      await widget.onRefresh!();
    }
    _refreshController.refreshCompleted();
    _refreshController.resetNoData();
  }

  Future<void> _handleLoading() async {
    if (widget.onLoadMore != null) {
      await widget.onLoadMore!();
    }
    if (widget.hasMore) {
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }

  @override
  initState() {
    prodListCubit = context.read<ProductListCubit>();
    authCubit = context.read<AuthCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullUp: true,
      enablePullDown: true,
      controller: _refreshController,
      onRefresh: _handleRefresh,
      onLoading: _handleLoading,
      header: CustomPaginationHeader(),
      footer: CustomPaginationFooter(
        height: 30,
        pageLimit: _pageLimit,
        emptyDataText: "No More Product Found",
      ),
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 40, left: 8, right: 8, top: 8),
        itemCount: widget.products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getCrossAxisCount(
              context, widget.showOnly1Row, widget.products.length),
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          final product = widget.products[index];
          return ProductGridItem(
            showFavoriteIcon: widget.showFavoriteIcon,
            product: product,
            onTap: () async {
              final bool isOutOfStock = !(product.isInStock);
              await Navigator.of(context, rootNavigator: true)
                  .push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      FeedProductDetailsScreen(
                    productId: product.id!,
                    canBuy: true,
                    isOutOfStock: isOutOfStock,
                  ),
                  transitionDuration: Duration.zero, // disables animation
                  reverseTransitionDuration: Duration.zero,
                ),
              )
                  .then((_) {
                final userId = authCubit.currentUser?.id;
                prodListCubit.getProducts(
                  params: ProductListQueryParams(
                    shopId: product.shopId,
                    userId: userId,
                    //  categoryId: product.categoryId,
                  ),
                );
              });
            },
            onTapOfFavorite: () {
              widget.fromFav
                  ? context
                      .read<FavoriteCubit>()
                      .toggleFavorite(product.id!, context)
                  : context
                      .read<ProductListCubit>()
                      .toggleFavorite(product.id!);
            },
          );
        },
      ),
    );
  }
}

int _getCrossAxisCount(
    BuildContext context, bool? showOnly1Row, int productCount) {
  final size = MediaQuery.of(context).size;
  final shortestSide = size.shortestSide;
  final isTablet = shortestSide >= 600;
  final isLandscape = size.width > size.height;

  if (showOnly1Row ?? false) {
    if (productCount > 2) {
      return 4;
    } else {
      return 2;
    }
  } else {
    if (isTablet) {
      return isLandscape ? 6 : 4;
    } else {
      return 2;
    }
  }
}
