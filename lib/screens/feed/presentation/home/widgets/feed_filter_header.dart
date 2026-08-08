import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/extensions/app_font_style.dart';
import 'package:ufc_mobile/global/extensions/app_png_images.dart';
import 'package:ufc_mobile/global/extensions/app_svg_images.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/global/shared/init/product_injtion.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_search_bar.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/global/util/station/station_utils.dart';
import 'package:ufc_mobile/screens/feed/application/bottom_bar_bloc/bottom_bar_bloc.dart';
import 'package:ufc_mobile/screens/feed/application/favorite/favorite_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/productList/filter_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/productList/product_list_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/favorite/favorite_query_params.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_list_params.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/add_product_to_fav.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/product_by_id_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/product_usecase.dart';
import 'package:ufc_mobile/screens/feed/presentation/category/widgets/feed_filter_bottom_sheet.dart';
import 'package:ufc_mobile/screens/feed/presentation/home/widgets/feed_home_helper.dart';
import 'package:ufc_mobile/screens/feed/presentation/home/widgets/feed_home_search.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

class StationFilter extends StatelessWidget {
  final bool fromFav;
  final UserModel? user;
  const StationFilter({super.key, this.fromFav = false, required this.user});

  String stationName(UserModel? user) {
    String name = StationUtils.stationName(user?.preferredShopDetails);
    if (isStringEmpty(name)) {
      return 'Select Station';
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    // UserModel? user = context.read<AuthCubit>().currentUser;

    return GestureDetector(
      onTap: () {
        //final selectedStationId = user?.preferredShopDetails?.id;
        feedHomeHelper.showStationBottomSheet(context,
            selectedStationId:
                user?.preferredShopDetails?.id //selectedStationId,
            );
      },
      child: Container(
        decoration: fromFav ? null : CommonUtils.feedDefaulBoxDecoration,
        height: 40,
        padding: ksymmetric(5, 0),
        child: Row(
          mainAxisAlignment:
              fromFav ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            /// station icon
            SvgPicture.asset(
              AppSvgImages.stationIcon,
              colorFilter: fromFav
                  ? ColorFilter.mode(primaryColor, BlendMode.srcIn)
                  : null,
            ),
            kWidth10,

            /// station name
            Flexible(
              child: Text(
                stationName(user).tr(),
                style: AppFontStyle.getRegularStyleV2(
                  fontSize: 11,
                  height: 1.2,
                ),
              ),
            ),
            kWidth10,
            // arrow icon
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: fromFav ? Colors.black : AppColors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

Widget searchBar(
        TextEditingController searchCtrl, BuildContext context, UserModel? user,
        {bool fromFav = false}) =>
    Expanded(
      flex: 5,
      child: GestureDetector(
        child: CustomSearchBar(
          onTap: () {
            final selectedStationId = user?.preferredShopDetails?.id;
            Navigator.of(context, rootNavigator: true)
                .push(
              MaterialPageRoute(
                builder: (context) => fromFav
                    ? BlocProvider(
                        create: (_) => FavoriteCubit(
                          sl<AddProductToFavoritesUseCase>(),
                          sl<GetFavoritesUseCase>(),
                        )..getFavProductList(
                            params: FavoriteQueryParams(
                              shopId: selectedStationId,
                            ),
                          ),
                        child: const FeedHomeSearch(
                          fromFav: true,
                        ),
                      )
                    : BlocProvider(
                        create: (_) => ProductListCubit(
                          sl<GetProductsUseCase>(),
                          sl<AddProductToFavoritesUseCase>(),
                          sl<GetProductByIdUseCase>(),
                        )..getProducts(
                            params: ProductListQueryParams(
                              categoryId: null,
                              shopId: selectedStationId,
                              userId: user?.id,
                            ),
                          ),
                        child: const FeedHomeSearch(),
                      ),
              ),
            )
                .then((_) {
              if (!fromFav) {
                context.read<FeedBottomNavCubit>().changeTab(1);
                context.read<ProductListCubit>().getProducts();
              } else {
                context.read<FavoriteCubit>().getFavProductList();
              }
            });
          },
          readOnly: true,
          controller: searchCtrl,
          hideBorder: true,
          contentPadding: ksymmetric(0, 15),
          height: 40,
          borderRadius: BorderRadius.circular(10),
          boxShadow: CommonUtils.feedDefaultBoxShadow,
        ),
      ),
    );

class FilterSection extends StatefulWidget {
  final bool fromFav;
  const FilterSection({super.key, this.fromFav = false});

  @override
  _FilterSectionState createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  late ProductListCubit pCubit;
  late FavoriteCubit fCubit;

  @override
  initState() {
    pCubit = context.read<ProductListCubit>();
    fCubit = context.read<FavoriteCubit>();
    super.initState();
  }

  bool _isFilterApplied(FilterState state) {
    // Check if any filter value is set
    final typeSelected = state.filterItems[0][0].isNotEmpty;
    final sizeSelected = state.filterItems[0][1].isNotEmpty;
    final priceSelected = state.filterPrice != 500; // default price in cubit
    return typeSelected || sizeSelected || priceSelected;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        final isFilterApplied = _isFilterApplied(state);

        return GestureDetector(
          onTap: () async {
            await showModalBottomSheet(
              useRootNavigator: true,
              scrollControlDisabledMaxHeightRatio: 0.9,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              context: context,
              builder: (context) {
                return FeedFilterBottomSheet();
              },
            ).then((v) {
              if (v != null) {
                if (widget.fromFav) {
                  fCubit.updateParams(
                      type: v['type'], size: v['size'], price: v['price']);
                } else {
                  pCubit.updateParams(
                      type: v['type'], size: v['size'], price: v['price']);
                }
              }
            });
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: CommonUtils.feedDefaulBoxDecoration,
                padding: const EdgeInsets.all(10),
                child: Image.asset(AppPngImages.feedSliderPngIcon),
              ),
              if (isFilterApplied)
                Positioned(
                  top: -2,
                  right: isEnglish ? null : -2,
                  left: isEnglish ? -2 : null,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: 1.0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: PetVeterinaryColors.backgroundRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
