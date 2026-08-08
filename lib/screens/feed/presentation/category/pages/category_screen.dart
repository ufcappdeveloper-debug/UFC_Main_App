import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/shared/functions/is_network_error.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/no_internet.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/feed/application/productList/filter_cubit.dart';
import 'package:ufc_mobile/screens/feed/presentation/home/widgets/feed_home_indexed.dart';
import 'package:ufc_mobile/screens/feed/presentation/home/widgets/home_product_list.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

import '../../../application/authentication/auth_cubit.dart';
import '../../../application/category/category_cubit.dart';
import '../../../application/category/category_state.dart';
import '../../../application/productList/product_list_cubit.dart';
import '../../../application/productList/product_list_state.dart';
import '../../../domain/entities/product/product_list_params.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  // Expose a GlobalKey so parent can access state
  static final GlobalKey<_CategoryScreenState> categoryKey =
      GlobalKey<_CategoryScreenState>();

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TabController? _tabController;
  int? shopId;
  List<Map<String, dynamic>> tabs = [];
  bool hasInitializedTabs = false;

  // Reset to "All" tab
  void resetTab() {
    if (_tabController == null) return;

    if (_tabController!.index != 0) {
      // Remove listener temporarily to avoid double fetch
      _tabController!.removeListener(listener);

      // Animate to "All" tab
      _tabController!.animateTo(0);

      // Re-attach listener after frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tabController!.addListener(listener);
      });
    }
    _fetchProductsForSelectedTab(0);
  }

  void _fetchProductsForSelectedTab(int tabIndex) {
    final selected = tabs[tabIndex];
    final int? categoryId = selected["id"];

    final filterState = context.read<FilterCubit>().state;
    final String? type = filterState.filterItems[0][0].isNotEmpty
        ? filterState.filterItems[0][0]
        : null;
    final double? size = filterState.filterItems[0][1].isNotEmpty
        ? double.tryParse(filterState.filterItems[0][1].split(' ').first)
        : null;
    final double price = filterState.filterPrice;

    // Use updateParams which internally calls getProducts
    context.read<ProductListCubit>().updateParams(
          categoryId: categoryId,
          type: type,
          size: size,
          price: price,
        );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.read<AuthCubit>().isGuest) {
        context.read<AuthCubit>().loadProfile();
      }

      context.read<CategoryCubit>().fetchCategories();
    });
  }

  void listener() {
    if (_tabController!.indexIsChanging) return;

    _fetchProductsForSelectedTab(_tabController!.index);
  }

  void setupTabs(List<Map<String, dynamic>> categories) {
    // if (shopId == null || shopId == 0) return;

    tabs = [
      {"id": null, "nameEn": "All", "nameAr": "الكل"},
      ...categories,
    ];

    _tabController?.dispose();

    _tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: 0,
    );

    _tabController!.addListener(listener);

    setState(() => hasInitializedTabs = true);

    // Trigger initial "All"
    WidgetsBinding.instance.addPostFrameCallback((_) => resetTab());
  }

//   @override
//   Widget build(BuildContext context) {
//     // final isArabic = Localizations.localeOf(context).languageCode == "ar";

//     final filterState = context.read<FilterCubit>().state;

// // Check if any filter is applied
//     bool isFilterApplied = filterState.filterItems[0][0].isNotEmpty ||
//         filterState.filterItems[0][1].isNotEmpty ||
//         filterState.filterPrice != 500;

//     return Scaffold(
//         backgroundColor: Colors.transparent,
//         body: MultiBlocListener(
//           listeners: [
//             BlocListener<AuthCubit, AuthState>(
//               listener: (context, state) {
//                 if (state is ProfileLoadedSuccess) {
//                   shopId = state.user.preferredShopDetails?.id ?? 0;
//                   context.read<ProductListCubit>().getProducts(
//                         params: ProductListQueryParams(
//                             shopId: shopId, userId: state.user.id),
//                       );
//                   context.read<CategoryCubit>().fetchCategories();
//                 }
//               },
//             ),
//             BlocListener<CategoryCubit, CategoryState>(
//               listenWhen: (_, curr) => curr is CategoryLoaded,
//               listener: (context, state) {
//                 if (state is CategoryLoaded && shopId != 0) {
//                   final mapped = state.categories
//                       .map((c) => {
//                             "id": c.id,
//                             "nameEn": c.nameEn,
//                             "nameAr": c.nameAr,
//                           })
//                       .toList();
//                   setupTabs(mapped);
//                 }
//               },
//             ),
//           ],
//           child: hasInitializedTabs
//               ? Column(
//                   children: [
//                     Expanded(
//                       child: BlocBuilder<CategoryCubit, CategoryState>(
//                         builder: (context, state) {
//                           if (state is CategoryLoading) {
//                             return const Center(
//                                 child: CircularProgressIndicator(
//                                     color: primaryColor));
//                           } else if (state is CategoryLoaded &&
//                               hasInitializedTabs) {
//                             final isArabic =
//                                 Localizations.localeOf(context).languageCode ==
//                                     "ar";

//                             return Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 4.0),
//                               child: BlocConsumer<ProductListCubit,
//                                       ProductListState>(
//                                   listenWhen: (prev, curr) =>
//                                       curr is ProductListLoaded,
//                                   listener: (context, state) {
//                                     if (state is ProductListLoaded &&
//                                         state.toggleFavMsg != null) {
//                                       CustomSnackBar.success(
//                                           context, state.toggleFavMsg!);
//                                     }
//                                   },
//                                   builder: (context, prodState) {
//                                     if (prodState is ProductListLoading) {
//                                       return categoryProductListShimmer(
//                                           isArabic, tabs);
//                                     } else if (prodState is ProductListLoaded) {
//                                       return Column(
//                                         children: [
//                                           // Keep your feed header
//                                           Padding(
//                                             padding: EdgeInsets.only(top: 2),
//                                             child: buildFeedHeader(
//                                                 isCategoryScreen: true),
//                                           ),
//                                           const SizedBox(height: 16),

//                                           // Always show the TabBar + TabBarView container
//                                           Expanded(
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 12.0),
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   borderRadius:
//                                                       const BorderRadius.only(
//                                                     topLeft:
//                                                         Radius.circular(12),
//                                                     topRight:
//                                                         Radius.circular(12),
//                                                   ),
//                                                 ),
//                                                 child: Column(
//                                                   children: [
//                                                     Align(
//                                                       alignment: isArabic
//                                                           ? Alignment
//                                                               .centerRight
//                                                           : Alignment
//                                                               .centerLeft,
//                                                       child: TabBar(
//                                                         controller:
//                                                             _tabController,
//                                                         isScrollable: true,
//                                                         labelColor: const Color
//                                                             .fromRGBO(
//                                                             120, 185, 67, 1),
//                                                         unselectedLabelColor:
//                                                             const Color
//                                                                 .fromRGBO(207,
//                                                                 207, 207, 1),
//                                                         labelStyle:
//                                                             const TextStyle(
//                                                           fontSize: 12,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                         ),
//                                                         unselectedLabelStyle:
//                                                             const TextStyle(
//                                                           fontSize: 12,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                         ),
//                                                         indicator:
//                                                             const FixedWidthUnderline(
//                                                           width: 90,
//                                                           thickness: 3,
//                                                           color: Color.fromRGBO(
//                                                               120, 185, 67, 1),
//                                                           indicatorSize:
//                                                               FixedIndicatorSize
//                                                                   .tab,
//                                                         ),
//                                                         tabs: tabs
//                                                             .map((c) => Tab(
//                                                                   text: isArabic
//                                                                       ? (c["nameAr"] ??
//                                                                           "")
//                                                                       : (c["nameEn"] ??
//                                                                           ""),
//                                                                 ))
//                                                             .toList(),
//                                                       ),
//                                                     ),
//                                                     Expanded(
//                                                       child: TabBarView(
//                                                         controller:
//                                                             _tabController,
//                                                         children: tabs.map((c) {
//                                                           if (prodState.products
//                                                               .isEmpty) {
//                                                             // Show "no products found" inside TabBarView
//                                                             return Center(
//                                                               child: Column(
//                                                                 mainAxisSize:
//                                                                     MainAxisSize
//                                                                         .min,
//                                                                 children: [
//                                                                   CustomText(
//                                                                     text:
//                                                                         'no_products_found',
//                                                                     fontSize:
//                                                                         15,
//                                                                   ),
//                                                                   if (isFilterApplied) ...[
//                                                                     const SizedBox(
//                                                                         height:
//                                                                             4),
//                                                                     CustomText(
//                                                                       text:
//                                                                           '(no products match the applied filters)',
//                                                                       fontSize:
//                                                                           13,
//                                                                     ),
//                                                                   ],
//                                                                 ],
//                                                               ),
//                                                             );
//                                                           } else {
//                                                             return HomeProductList(
//                                                               isCategory: true,
//                                                               products:
//                                                                   prodState
//                                                                       .products,
//                                                             );
//                                                           }
//                                                         }).toList(),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       );
//                                     } else if (prodState is ProductListError) {
//                                       return isNetworkError(prodState.message)
//                                           ? NoInternet(
//                                               type: AppType.feed,
//                                               onTap: () => listener(),
//                                             )
//                                           : CustomReloadProviderV2(
//                                               error: prodState.message,
//                                               height: 120,
//                                               decoration: const BoxDecoration(
//                                                 color: Colors.transparent,
//                                               ),
//                                               onPressed: () {
//                                                 context
//                                                     .read<ProductListCubit>()
//                                                     .getProducts();
//                                               },
//                                             );
//                                     }
//                                     return const SizedBox.shrink();
//                                   }),
//                             );
//                           } else if (state is CategoryError) {
//                             return CustomReloadProviderV2(
//                               error: state.message,
//                               height: 120,
//                               decoration: const BoxDecoration(
//                                 color: Colors.transparent,
//                               ),
//                               onPressed: () {
//                                 // context.read<ProductListCubit>().getProducts();
//                               },
//                             );
//                           }

//                           return const Center(
//                               child: CircularProgressIndicator(
//                             color: primaryColor,
//                           ));
//                         },
//                       ),
//                     ),

//                   ],
//                 )
//               : const Center(child: CircularProgressIndicator()),
//         ));
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is ProfileLoadedSuccess) {
                shopId = state.user.preferredShopDetails?.id ?? 0;
                context.read<ProductListCubit>().getProducts(
                      params: ProductListQueryParams(
                          shopId: shopId, userId: state.user.id),
                    );
                context.read<CategoryCubit>().fetchCategories();
              }
            },
          ),
          BlocListener<CategoryCubit, CategoryState>(
            listenWhen: (_, curr) => curr is CategoryLoaded,
            listener: (context, state) {
              if (state is CategoryLoaded && shopId != 0) {
                final mapped = state.categories
                    .map((c) => {
                          "id": c.id,
                          "nameEn": c.nameEn,
                          "nameAr": c.nameAr,
                        })
                    .toList();
                setupTabs(mapped);
              }
            },
          ),
        ],
        child: hasInitializedTabs
            ? Column(
                children: [
                  Expanded(
                    child: BlocConsumer<ProductListCubit, ProductListState>(
                      listenWhen: (prev, curr) =>
                          curr is ProductListLoaded &&
                          curr.toggleFavMsg != null,
                      listener: (context, state) {
                        if (state is ProductListLoaded &&
                            state.toggleFavMsg != null) {
                          CustomSnackBar.success(context, state.toggleFavMsg!);
                        }
                      },
                      builder: (context, prodState) {
                        final isArabic =
                            Localizations.localeOf(context).languageCode ==
                                "ar";

                        return Column(
                          children: [
                            // Feed header
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: buildFeedHeader(isCategoryScreen: true),
                            ),
                            const SizedBox(height: 16),

                            // TabBar + TabBarView container
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: isArabic
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: TabBar(
                                          controller: _tabController,
                                          isScrollable: true,
                                          labelColor: const Color.fromRGBO(
                                              120, 185, 67, 1),
                                          unselectedLabelColor:
                                              const Color.fromRGBO(
                                                  207, 207, 207, 1),
                                          labelStyle: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          unselectedLabelStyle: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          indicator: const FixedWidthUnderline(
                                            width: 90,
                                            thickness: 3,
                                            color:
                                                Color.fromRGBO(120, 185, 67, 1),
                                            indicatorSize:
                                                FixedIndicatorSize.tab,
                                          ),
                                          tabs: tabs
                                              .map((c) => Tab(
                                                    text: isArabic
                                                        ? (c["nameAr"] ?? "")
                                                        : (c["nameEn"] ?? ""),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                      Expanded(
                                        child: TabBarView(
                                          controller: _tabController,
                                          children: tabs.map((c) {
                                            return BlocBuilder<ProductListCubit,
                                                ProductListState>(
                                              builder: (context, prodState) {
                                                final filterState = context
                                                    .read<FilterCubit>()
                                                    .state;
                                                final isFilterApplied =
                                                    filterState
                                                            .filterItems[0][0]
                                                            .isNotEmpty ||
                                                        filterState
                                                            .filterItems[0][1]
                                                            .isNotEmpty ||
                                                        filterState
                                                                .filterPrice !=
                                                            500;

                                                // 🔹 Show loading for initial or full loading state
                                                if (prodState
                                                        is ProductListInitial ||
                                                    prodState
                                                        is ProductListLoading) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: PetVeterinaryColors
                                                          .mainColorUFC,
                                                    ),
                                                  );
                                                }

                                                // 🔹 Partial loading while keeping existing products
                                                if (prodState
                                                    is ProductListLoadingPartial) {
                                                  if (prodState.existingProducts
                                                      .isEmpty) {
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color:
                                                            PetVeterinaryColors
                                                                .mainColorUFC,
                                                      ),
                                                    );
                                                  } else {
                                                    return HomeProductList(
                                                      isCategory: true,
                                                      products: prodState
                                                          .existingProducts,
                                                    );
                                                  }
                                                }

                                                // 🔹 Loaded products
                                                if (prodState
                                                    is ProductListLoaded) {
                                                  if (prodState
                                                      .products.isEmpty) {
                                                    return Center(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          CustomText(
                                                            text:
                                                                'no_products_found',
                                                            fontSize: 15,
                                                          ),
                                                          if (isFilterApplied) ...[
                                                            const SizedBox(
                                                                height: 4),
                                                            CustomText(
                                                              text:
                                                                  '(no products match the applied filters)',
                                                              fontSize: 13,
                                                              color: PetVeterinaryColors
                                                                  .newPetDarkGray,
                                                            ),
                                                          ],
                                                        ],
                                                      ),
                                                    );
                                                  } else {
                                                    return HomeProductList(
                                                      isCategory: true,
                                                      products:
                                                          prodState.products,
                                                    );
                                                  }
                                                }

                                                // 🔹 Error state
                                                if (prodState
                                                    is ProductListError) {
                                                  return isNetworkError(
                                                          prodState.message)
                                                      ? NoInternet(
                                                          type: AppType.feed,
                                                          onTap: () =>
                                                              listener(),
                                                        )
                                                      : CustomReloadProviderV2(
                                                          error:
                                                              prodState.message,
                                                          height: 120,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                          onPressed: () {
                                                            context
                                                                .read<
                                                                    ProductListCubit>()
                                                                .getProducts();
                                                          },
                                                        );
                                                }

                                                return const SizedBox.shrink();
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

// Fixed underline styling
enum FixedIndicatorSize { tab, label }

class FixedWidthUnderline extends Decoration {
  final double width;
  final double thickness;
  final Color color;
  final FixedIndicatorSize indicatorSize;

  const FixedWidthUnderline({
    required this.width,
    required this.thickness,
    required this.color,
    this.indicatorSize = FixedIndicatorSize.tab,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _FixedWidthUnderlinePainter(width, thickness, color, indicatorSize);
  }
}

class _FixedWidthUnderlinePainter extends BoxPainter {
  final double width;
  final double thickness;
  final Paint _paint;
  final FixedIndicatorSize indicatorSize;

  _FixedWidthUnderlinePainter(
      this.width, this.thickness, Color color, this.indicatorSize)
      : _paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    if (cfg.size == null) return;

    double indicatorWidth = width;
    if (indicatorSize == FixedIndicatorSize.tab) {
      indicatorWidth = cfg.size!.width < width ? cfg.size!.width : width;
    }

    final double xCenter = offset.dx + cfg.size!.width / 2;
    final double yBottom = offset.dy + cfg.size!.height;
    final Rect rect = Rect.fromCenter(
      center: Offset(xCenter, yBottom - thickness / 2),
      width: indicatorWidth,
      height: thickness,
    );
    canvas.drawRect(rect, _paint);
  }
}
