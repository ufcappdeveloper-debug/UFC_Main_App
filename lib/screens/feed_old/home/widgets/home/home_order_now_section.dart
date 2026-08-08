import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_category_model.dart';
import 'package:ufc_mobile/riverpod/category/category_async_riverpod.dart';
import 'package:ufc_mobile/riverpod/category/category_page_riverpod.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';
import 'package:ufc_mobile/screens/feed_old/home/widgets/home_custom_category.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/image_network_extension_method.dart';

class HomeOrderNowSection extends ConsumerStatefulWidget {
  const HomeOrderNowSection({
    super.key,
    required this.tabController,
  });
  final TabController? tabController;
  static final ValueNotifier<String?> homeCategoryPageLimit =
      ValueNotifier(null);

  @override
  ConsumerState<HomeOrderNowSection> createState() =>
      _HomeOrderNowSectionState();
}

class _HomeOrderNowSectionState extends ConsumerState<HomeOrderNowSection> {
  final RefreshController _homeCategoryRefreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    HomeOrderNowSection.homeCategoryPageLimit.value = null;
  }

  @override
  void dispose() {
    _homeCategoryRefreshController.dispose();

    super.dispose();
  }

  void _onHomeCategoryLoading() async {
    if (HomeOrderNowSection.homeCategoryPageLimit.value != "empty") {
      categoryPage++;
    }

    HomeOrderNowSection.homeCategoryPageLimit.value = await ref
        .read(categoryAsyncProvider.notifier)
        .loadCategories(categoryPage);
    if (mounted) setState(() {});
    _homeCategoryRefreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = ref.watch(categoryAsyncProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomText(
            text: 'Order Now',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        categoryProvider.when(
          data: (data) {
            final List<CategoryModel> tempCategoryData =
                data == null || data.isEmpty
                    ? []
                    : data.getRange(1, data.length).toList();

            return (tempCategoryData.isEmpty)
                ? const SizedBox()
                : HomeCustomCategory(
                    onLoading: _onHomeCategoryLoading,
                    controller: _homeCategoryRefreshController,
                    child: ListView.separated(
                      itemCount: tempCategoryData.length,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          // if (isAuthorized) {
                          ref
                              .read(categoryPageProvider.notifier)
                              .changeCategoryId(tempCategoryData[index].id);
                          widget.tabController?.animateTo(1);
                          // } else {
                          //   CustomSnackBar.error(
                          //     context,
                          //     "Please sign in to continue",
                          //   );
                          // }
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                            width: 220,
                            height: 105,
                            margin: const EdgeInsets.all(15),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF9EA),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 8,
                                  color: Colors.grey.withValues(alpha: 0.2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: SizedBox(
                                    width: 85,
                                    height: 85,
                                    child: (tempCategoryData[index].image ==
                                                null ||
                                            tempCategoryData[index]
                                                .image!
                                                .isEmpty)
                                        ? SvgPicture.asset(
                                            'assets/images/global/Floral-White-Bg-No-Image-Placeholder.svg',
                                            fit: BoxFit.contain)
                                        : CachedNetworkImage(
                                            imageUrl:
                                                tempCategoryData[index].image ??
                                                    "",
                                            placeholder: loadingPlaceholder,
                                            errorWidget: errorWidget,
                                            fit: BoxFit.contain,
                                          ),
                                  ),
                                ),
                                kWidth30,
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: categoryName(
                                          tempCategoryData[index],
                                        ),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                    ),
                  );
          },
          error: (error, stack) => CustomReloadProvider(
            height: 118,
            onPressed: () =>
                ref.read(categoryAsyncProvider.notifier).getCategories(),
          ),
          loading: () => const SizedBox(
            height: 157,
            child: Center(child: CustomIndicator(padding: 50)),
          ),
        )
      ],
    );
  }

  static String categoryName(CategoryModel? category) {
    if (isArabic) {
      return category?.nameAr ?? category?.nameEn ?? category?.nameUr ?? '';
    } else if (isUrdu) {
      return category?.nameUr ?? category?.nameEn ?? category?.nameAr ?? '';
    } else {
      return category?.nameEn ?? category?.nameAr ?? category?.nameUr ?? '';
    }
  }
}
