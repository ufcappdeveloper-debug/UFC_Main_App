import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✅ Needed for ref
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_list_params.dart';

import '../../../application/navbar/app_bar_cubit.dart';
import '../../../application/productList/product_list_cubit.dart';
import '../../../application/productList/product_list_state.dart';
import '../../../domain/entities/product/product_model.dart';
import '../../bottom_bar/page/feed_bottom_bar.dart';
import '../../product/pages/feed_product_details_screen.dart';
import '../../product/widgets/item_card/product_grid_item.dart';

class ProductHorizontalListView extends ConsumerStatefulWidget {
  final List<ProductModel> products;
  final VoidCallback? onVerticalSwipeUp;

  const ProductHorizontalListView({
    super.key,
    required this.products,
    this.onVerticalSwipeUp,
  });

  @override
  ConsumerState<ProductHorizontalListView> createState() =>
      _ProductHorizontalListViewState();
}

class _ProductHorizontalListViewState
    extends ConsumerState<ProductHorizontalListView> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late ProductListCubit prodListCubit;
  late AuthCubit authCubit;

  Future<void> _onRefresh() async {
    await context.read<ProductListCubit>().getProducts();
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    final cubit = context.read<ProductListCubit>();
    cubit.loadMore();
    final pagination = cubit.pagination;
    final bool loadNoMoreData =
        (pagination?.currentPage ?? 1) >= (pagination?.lastPage ?? 1);
    if (loadNoMoreData) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
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
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta != null && details.primaryDelta! < -10) {
          widget.onVerticalSwipeUp?.call();
        }
      },
      child: SizedBox(
        height: 280, // 👈 enough to fit your ProductGridItem
        child: SmartRefresher(
          enablePullUp: true,
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          header: CustomHeader(
            builder: (context, mode) {
              Widget body;
              switch (mode) {
                case RefreshStatus.idle:
                  body = CustomText(text: "Pull to refresh"); // Pull to refresh
                  break;
                case RefreshStatus.canRefresh:
                  body = CustomText(
                      text: "Release to refresh"); // Release to refresh
                  break;
                case RefreshStatus.refreshing:
                  body = CustomText(text: "Refreshing"); // Refreshing
                  break;
                case RefreshStatus.completed:
                  body = CustomText(
                      text: "Refresh completed"); // Refresh completed
                  break;
                default:
                  body = CustomText(text: "Refresh");
              }
              return SizedBox(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          footer: CustomFooter(
            builder: (context, mode) {
              if (mode == LoadStatus.loading) {
                return const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            scrollDirection: Axis.horizontal,
            itemCount: widget.products.length,
            itemBuilder: (context, index) {
              final product = widget.products[index];

              return BlocBuilder<ProductListCubit, ProductListState>(
                buildWhen: (previous, current) {
                  if (previous is ProductListLoaded &&
                      current is ProductListLoaded &&
                      index < previous.products.length &&
                      index < current.products.length) {
                    return previous.products[index].isFavorite !=
                        current.products[index].isFavorite;
                  }
                  return false;
                },
                builder: (context, state) {
                  return Container(
                    margin: const EdgeInsets.only(
                        right: 12), // 👈 spacing between items
                    width: 173, // 👈 fixed width for each product card
                    child: ProductGridItem(
                      product: product,
                      onTap: () async {
                        final bool isOutOfStock = !(product.isInStock);
                        context.read<AppBarCubit>().setMode(AppBarMode.hidden);
                        context.read<BottomBarVisibilityCubit>().hide();

                        await Navigator.of(context, rootNavigator: true)
                            .push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    FeedProductDetailsScreen(
                              productId: product.id!,
                              canBuy: true,
                              isOutOfStock: isOutOfStock,
                            ),
                            transitionDuration:
                                Duration.zero, // disables animation
                            reverseTransitionDuration: Duration.zero,
                          ),
                        )
                            .then((_) {
                          Constants.navigatorKey.currentContext
                              ?.read<AppBarCubit>()
                              .setMode(AppBarMode.normal);
                          Constants.navigatorKey.currentContext
                              ?.read<BottomBarVisibilityCubit>()
                              .show();
                          final userId = authCubit.currentUser?.id;

                          prodListCubit.getProducts(
                            params: ProductListQueryParams(
                              shopId: product.shopId,
                              userId: userId,
                              // categoryId: product.categoryId,
                            ),
                          );
                        });
                      },
                      onTapOfFavorite: () {
                        context
                            .read<ProductListCubit>()
                            .toggleFavorite(product.id!);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
