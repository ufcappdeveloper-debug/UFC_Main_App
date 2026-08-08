import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/extensions/app_font_style.dart';
import 'package:ufc_mobile/global/extensions/app_images.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/functions/is_network_error.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/productList/product_list_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/productList/product_list_state.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/bottom_bar/page/feed_bottom_bar.dart';
import 'package:ufc_mobile/screens/feed/presentation/home/widgets/feed_home_indexed.dart';
import 'package:ufc_mobile/screens/feed/presentation/home/widgets/feed_home_shimmer.dart';
import 'package:ufc_mobile/screens/feed/presentation/home/widgets/home_product_list.dart';

import '../../../application/authentication/auth_cubit.dart';
import '../../../application/bottom_bar_bloc/bottom_bar_bloc.dart';
import '../../../domain/entities/product/product_list_params.dart';

class FeedHomePage extends ConsumerStatefulWidget {
  const FeedHomePage({super.key});

  @override
  ConsumerState<FeedHomePage> createState() => _FeedHomePageState();
}

class _FeedHomePageState extends ConsumerState<FeedHomePage> {
  int? shopId;

  @override
  void initState() {
    super.initState();

    final authCubit = context.read<AuthCubit>();

    final currentState = authCubit.state;
    if (currentState is ProfileLoadedSuccess) {
      _fetchProducts(currentState.user);
    } else if (!authCubit.isGuest) {
      authCubit.loadProfile();
    }
  }

  void _fetchProducts(UserModel updatedUser) {
    final shopId = updatedUser.preferredShopDetails?.id ?? 0;
    context.read<ProductListCubit>().getProducts(
          params:
              ProductListQueryParams(shopId: shopId, userId: updatedUser.id),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
        listenWhen: (prev, curr) => curr is ProfileLoadedSuccess,
        listener: (context, state) {
          if (state is ProfileLoadedSuccess) {
            _fetchProducts(state.user);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          body: BlocBuilder<ProductListCubit, ProductListState>(
            builder: (context, state) {
              final hasNetworkError =
                  state is ProductListError && isNetworkError(state.message);
              return Padding(
                  padding: ksymmetric(16, 0),
                  child: Column(children: [
                    if (!hasNetworkError) ...[
                      buildFeedHeader(),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Most Requested',
                            textStyle:
                                AppFontStyle.getMediumStyleV2(fontSize: 16),
                          ),
                          InkWell(
                            onTap: () {
                              context.read<FeedBottomNavCubit>().changeTab(1);
                              context.read<AppBarHeightCubit>().setHeight(31);
                              context
                                  .read<AppBarCubit>()
                                  .setMode(AppBarMode.channel);
                              context
                                  .read<FeedBackgroundCubit>()
                                  .updateBackground(AppImages.feedSmallBg);
                            },
                            child: CustomText(
                              text: 'View all',
                              textStyle: AppFontStyle.getRegularStyleV2(
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (state is ProductListLoading)
                      const FeedShimmerPage()
                    else if (state is ProductListLoaded)
                      state.products.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 80),
                              child: Center(
                                child: CustomText(
                                  text: 'no_products_found',
                                  fontSize: 15,
                                ),
                              ),
                            )
                          : Expanded(
                              child: HomeProductList(
                                isCategory: false,
                                products: state.products,
                              ),
                            )
                    else if (state is ProductListError) ...[
                      if (state.message is DioException) SizedBox.shrink(),
                      !isNetworkError(state.message)
                          ? CustomReloadProviderV2(
                              error: state.message,
                              height: 120,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              onPressed: () {
                                context.read<ProductListCubit>().getProducts();
                              },
                            )
                          : const SizedBox.shrink(),
                    ] else
                      const SizedBox.shrink(),
                  ]));
            },
          ),
        ));
  }
}
