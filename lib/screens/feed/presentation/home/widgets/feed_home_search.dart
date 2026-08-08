import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_no_data.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_footer.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_header.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/favorite/favorite_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/favorite/favorite_state.dart';
import 'package:ufc_mobile/screens/feed/application/productList/product_list_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/productList/product_list_state.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/favorite/favorite_list_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/favorite/favorite_query_params.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_list_params.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_list_res_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/product/widgets/item_card/product_grid_item.dart';

import '../../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../../../application/navbar/app_bar_cubit.dart';
import '../../product/pages/feed_product_details_screen.dart';

class FeedHomeSearch extends StatefulWidget {
  final bool fromCategory;
  final bool fromFav;
  const FeedHomeSearch(
      {super.key, this.fromFav = false, this.fromCategory = false});

  @override
  State<FeedHomeSearch> createState() => _FeedHomeSearchState();
}

class _FeedHomeSearchState extends State<FeedHomeSearch> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final RefreshController _refreshController = RefreshController();
  late int shopId;
  late int? userId;
  String? _pageLimit;

  void callApi(
    String? search,
  ) {
    widget.fromFav
        ? context.read<FavoriteCubit>().getFavProductList(
              params: FavoriteQueryParams(
                shopId: shopId,
                search: search,
                page: 1,
              ),
            )
        : context.read<ProductListCubit>().getProducts(
              params: ProductListQueryParams(
                  shopId: shopId, search: search, page: 1, userId: userId),
            );
    _refreshController.refreshCompleted();
    _refreshController.resetNoData();
  }

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().currentUser;
    shopId = authState?.preferredShopDetails?.id ?? 0;
    userId = authState?.id;

    callApi(null);

    Future.delayed(Duration.zero, () {
      _searchFocusNode.requestFocus();
    });
  }

  Widget loadingWidget() => const Center(child: CustomIndicator(padding: 50));

  Widget errorWidget(Object? msg) => Center(
        child: CustomReloadProviderV2(
          error: msg,
          height: 120,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          onPressed: () {
            callApi(null);
          },
        ),
      );

  Widget successWidget(List<ProductModel> products,
          {bool showFavoriteIcon = false}) =>
      SmartRefresher(
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        controller: _refreshController,
        header: const CustomPaginationHeader(),
        footer: CustomPaginationFooter(
          pageLimit: _pageLimit,
          emptyDataText: "No More Product Found",
        ),
        child: GridView.builder(
          itemCount: products.length,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisSpacing: 8,
            crossAxisSpacing: 17,
            childAspectRatio: 0.65,
            maxCrossAxisExtent: 197,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductGridItem(
              product: product,
              showFavoriteIcon: showFavoriteIcon,
              onTap: () {
                // Hide AppBar before navigation
                final bool isOutOfStock = !(product.isInStock);

                context.read<AppBarCubit>().setMode(AppBarMode.hidden);

                Navigator.of(context, rootNavigator: true)
                    .push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        FeedProductDetailsScreen(
                      productId: products[index].id!,
                      canBuy: true,
                      isOutOfStock: isOutOfStock,
                    ),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                )
                    .then((_) {
                  // Restore AppBar mode when returning
                  context.read<AppBarCubit>().setMode(AppBarMode.normal);
                });
              },
              onTapOfFavorite: () {
                if (products[index].id != null) {
                  if (widget.fromFav) {
                    context
                        .read<FavoriteCubit>()
                        .toggleFavorite(products[index].id!, context);
                  } else {
                    context
                        .read<ProductListCubit>()
                        .toggleFavorite(products[index].id!);
                  }
                }
              },
            );
          },
        ),
      );

  void _onRefresh() {
    _searchController.clear();
    _pageLimit = null;

    callApi(null);
  }

  void _onLoading() {
    bool loadNoMoreData;
    if (widget.fromFav) {
      final cubit = context.read<FavoriteCubit>();
      cubit.loadMore();
      final FavoriteListModel? pagination = cubit.pagination;
      loadNoMoreData =
          (pagination?.currentPage ?? 1) >= (pagination?.lastPage ?? 1);
    } else {
      final cubit = context.read<ProductListCubit>();
      cubit.loadMore();
      final ProductsListModel? pagination = cubit.pagination;
      loadNoMoreData =
          (pagination?.currentPage ?? 1) >= (pagination?.lastPage ?? 1);
    }

    if (loadNoMoreData) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
  }

  void _onSearchChanged(String value) {
    _refreshController.resetNoData();
    callApi(value);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Directionality(
                textDirection: flutter.TextDirection.ltr,
                child: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 2,
                  shadowColor: Colors.black12,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        size: 16, color: Colors.black),
                    onPressed: () {
                      if (widget.fromCategory) {
                        context.read<AppBarCubit>().setMode(AppBarMode.channel);
                        context.read<AppBarHeightCubit>().setHeight(160);
                      }
                      Navigator.pop(context);
                    },
                  ),
                  title: Directionality(
                    textDirection: Directionality.of(context),
                    child: _buildSearchField(),
                  ),
                ))),
        body: widget.fromFav
            ? BlocConsumer<FavoriteCubit, FavoriteState>(
                listenWhen: (prev, curr) => curr is FavoriteLoaded,
                listener: (context, state) {
                  if (state is FavoriteLoaded && state.toggleFavMsg != null) {
                    CustomSnackBar.success(context, state.toggleFavMsg!);
                  }
                },
                builder: (context, state) {
                  if (state is FavoriteLoading) {
                    return loadingWidget();
                  } else if (state is FavoriteError) {
                    return errorWidget(state.message);
                  } else if (state is FavoriteLoaded) {
                    final products = state.products;

                    if (products.isEmpty) {
                      return const CustomNoData(
                          height: 56, text: "No Product Found");
                    }

                    return successWidget(products, showFavoriteIcon: true);
                  }

                  return const SizedBox.shrink();
                },
              )
            : BlocConsumer<ProductListCubit, ProductListState>(
                listenWhen: (prev, curr) => curr is ProductListLoaded,
                listener: (context, state) {
                  if (state is ProductListLoaded &&
                      state.toggleFavMsg != null) {
                    CustomSnackBar.success(context, state.toggleFavMsg!);
                  }
                },
                builder: (context, state) {
                  if (state is ProductListLoading) {
                    return loadingWidget();
                  } else if (state is ProductListError) {
                    return errorWidget(state.message);
                  } else if (state is ProductListLoaded) {
                    final products = state.products;

                    if (products.isEmpty) {
                      return const CustomNoData(
                          height: 56, text: "No Product Found");
                    }

                    return successWidget(products);
                  }

                  return const SizedBox.shrink();
                },
              ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: const Color(0xFFD9D9D9)),
        borderRadius: BorderRadius.circular(36),
      ),
      child: Row(
        children: [
          const SizedBox(width: 9),
          SvgPicture.asset("assets/images/global/search_icon.svg"),
          const SizedBox(width: 7),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              cursorColor: primaryColor,
              onChanged: _onSearchChanged,
              maxLength: 35,
              decoration: InputDecoration(
                isDense: true,
                counterText: "",
                contentPadding: EdgeInsets.all(0),
                hint: CustomText(
                  text: 'search_product',
                  fontSize: 12,
                  color: const Color(0xFFD9D9D9),
                  fontWeight: FontWeight.w300,
                  fontFamily: isEnglish
                      ? AppFontsFamily.english
                      : AppFontsFamily.arabic,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 7),
        ],
      ),
    );
  }
}
