import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/functions/is_network_error.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/no_internet.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/favorite/favorite_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/favorite/favorite_state.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/favorite/favorite_query_params.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/home/widgets/feed_filter_header.dart';
import 'package:ufc_mobile/screens/feed/presentation/product/widgets/list_view/product_grid_view.dart';

class FeedFavoritePage extends StatefulWidget {
  const FeedFavoritePage({super.key});

  @override
  State<FeedFavoritePage> createState() => _FeedFavoritePageState();
}

class _FeedFavoritePageState extends State<FeedFavoritePage> {
  late TextEditingController searchController;
  List<ProductModel> prod = [];
  int? shopId;

  void callApi() {
    if (!mounted) return;

    final authUser = context.read<AuthCubit>().currentUser;
    shopId = authUser?.preferredShopDetails?.id ?? 0;
    context.read<FavoriteCubit>().getFavProductList(
          params: FavoriteQueryParams(shopId: shopId),
        );
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callApi();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
    if (isCurrent) {
      UserModel? user = context.read<AuthCubit>().currentUser;
      final shopId = user?.preferredShopDetails?.id ?? 0;
      context.read<FavoriteCubit>().getFavProductList(
            params: FavoriteQueryParams(shopId: shopId),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = context.watch<AuthCubit>().currentUser;
    return BlocConsumer<FavoriteCubit, FavoriteState>(
      listenWhen: (prev, curr) => curr is FavoriteLoaded,
      listener: (BuildContext context, FavoriteState state) { 
        if(state is FavoriteLoaded && state.toggleFavMsg!=null){
          CustomSnackBar.success(context, state.toggleFavMsg!);
        }
       },
      builder: (context, fState) {
        if (fState is FavoriteLoaded) prod = fState.products;
        return Scaffold(
            appBar: AppBar(
              title: CustomText(
                text: fState is FavoriteError && isNetworkError(fState.message)
                    ? ''
                    : 'Favorites',
                fontFamily:
                    isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
                fontSize: 18,
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is ProfileLoadedSuccess) {
                  context.read<FavoriteCubit>().getFavProductList(
                        params: FavoriteQueryParams(
                            shopId: user?.preferredShopDetails?.id),
                      );
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    if (fState is FavoriteError
                        ? !isNetworkError(fState.message)
                        : true)
                      Column(
                        children: [
                          Padding(
                            padding: khoriz(10),
                            child: StationFilter(
                              fromFav: true,
                              user: user,
                            ),
                          ),
                          Padding(
                            padding: khoriz(10),
                            child: Row(
                              children: [
                                searchBar(searchController, context, user,
                                    fromFav: true),
                                kWidth15,
                                FilterSection(fromFav: true)
                              ],
                            ),
                          ),
                        ],
                      ),
                    kHeight20,
                    if (fState is FavoriteLoading) ...{
                      const Center(child: CupertinoActivityIndicator())
                    } else if (fState is FavoriteLoaded ||
                        fState is FavoriteAddRemLoad) ...{
                      prod.isEmpty
                          ? Padding(
                              padding: konlyt(20),
                              child: Center(
                                  child: CustomText(
                                text: 'no_products_found',
                                fontSize: 16,
                                fontFamily: isEnglish
                                    ? AppFontsFamily.english
                                    : AppFontsFamily.arabic,
                              )),
                            )
                          : Expanded(
                              child: ProductGridView(
                                showFavoriteIcon: true,
                                fromFav: true,
                                products: prod,
                                hasMore: (context
                                            .watch<FavoriteCubit>()
                                            .pagination
                                            ?.currentPage ??
                                        1) <
                                    (context
                                            .watch<FavoriteCubit>()
                                            .pagination
                                            ?.lastPage ??
                                        1),
                                onRefresh: () async => context
                                    .read<FavoriteCubit>()
                                    .getFavProductList(),
                                onLoadMore: () async =>
                                    context.read<FavoriteCubit>().loadMore(),
                              ),
                            )
                    } else if (fState is FavoriteError) ...{
                      isNetworkError(fState.message)
                          ? NoInternet(
                              type: AppType.feed,
                              onTap: () => callApi(),
                            )
                          : Center(
                              child: CustomReloadProviderV2(
                                error: fState.message,
                                height: 120,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                onPressed: () {
                                  context
                                      .read<FavoriteCubit>()
                                      .getFavProductList(
                                        params:
                                            FavoriteQueryParams(shopId: shopId),
                                      );
                                },
                              ),
                            )
                    }
                  ],
                );
              },
            ));
      },
    );
  }
}
