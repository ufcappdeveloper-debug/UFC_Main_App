import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_no_data.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/scroll_up_floating_btn.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/category/category_async_riverpod.dart';
import 'package:ufc_mobile/riverpod/category/category_page_riverpod.dart';
import 'package:ufc_mobile/riverpod/product/product_async_riverpod.dart';
import 'package:ufc_mobile/riverpod/product/product_future_riverpod.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/station/station_model.dart';
import 'package:ufc_mobile/screens/feed_old/categories/filter_page.dart';
import 'package:ufc_mobile/screens/feed_old/categories/widgets/category_custom_product_list.dart';
import 'package:ufc_mobile/screens/feed_old/categories/widgets/category_custom_search_app_bar.dart';
import 'package:ufc_mobile/screens/feed_old/categories/widgets/category_custom_tab_bar.dart';
import 'package:ufc_mobile/screens/feed_old/favorite/pages/favorite_screen.dart';
import 'package:ufc_mobile/screens/feed_old/profile/pages/notification_page.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({
    super.key,
    this.tabController,
    this.scrollController,
  });
  final TabController? tabController;
  final ScrollController? scrollController;

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage>
    with TickerProviderStateMixin, ScreenEngagementTracker {
  int? categoryId;
  String? pageLimit;
  String? dropdownValue;

  @override
  void initState() {
    super.initState();

    pageLimit = null;
    sortValue = null;
    selectedSize = null;
    selectedMinPrice = null;
    selectedMaxPrice = null;
    selectedNewArrivals = null;
    selectedProductType = null;
    selectedAnimalTypes.clear();
    selectedSpecialOffer = null;
    categoryId = ref.read(categoryPageProvider).categoryId;
    Future(() => ref.read(categoryAsyncProvider.notifier).getCategories());
  }

  void _scrollToTop() {
    widget.scrollController?.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  void _onLoading() async {
    if (pageLimit != "empty") {
      categoryPage++;
    }

    pageLimit = await ref
        .read(categoryAsyncProvider.notifier)
        .loadCategories(categoryPage);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = ref.watch(categoryAsyncProvider);
    final animalTypeData = ref.watch(getProductSubtypesProvider);
    final shopId = ref.watch(authProvider).value?.preferredShopDetails?.id;
    final selectedCategoryId = ref.watch(categoryPageProvider).categoryId;
    final shop = ref.watch(authProvider).value?.preferredShopDetails;
    final shopName = getShopName(context, shop);

    final isAuthorized = ref.watch(authProvider.notifier).isAuthorized();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CategoryCustomSearchAppBar(
        searchController: categorySearchController,
        onChanged: (value) => ref
            .read(productAsyncProvider().notifier)
            .getProducts(
                shopId!, null,
                sort: sortValue,
                search: categorySearchController.text,
                productType: selectedProductType,
                size: selectedSize,
                minPrice: selectedMinPrice,
                maxPrice: selectedMaxPrice,
                createdWithin: selectedNewArrivals,
                isOffer: selectedSpecialOffer,
                animalType: animalTypeData.value == null ||
                        animalTypeData.value!.isEmpty
                    ? null
                    : List.generate(
                        selectedAnimalTypes.length,
                        (index) => animalTypeData
                            .value![selectedAnimalTypes[index]].id!)),
        onHeartPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FavoriteScreen(),
          ),
        ),
        onHomeCartPressed: () => widget.tabController?.animateTo(2),
        onNotificationPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationPage(),
            ),
          );
        },
        stationName: shopName,
      ),
      floatingActionButtonLocation: (isArOrUr)
          ? FloatingActionButtonLocation.miniStartFloat
          : FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: ScrollUpFloatingBtn(
        heroTag: 'scroll-up-tab-categ',
        onPressed: () => _scrollToTop(),
      ),
      body: Column(
        children: [
          Expanded(
            child: categoryProvider.when(
              data: (data) {
                final indexWhere = selectedCategoryId == null
                    ? 0
                    : data?.indexWhere(
                        (element) => element.id == selectedCategoryId);
                return (data == null || data.isEmpty)
                    ? Column(
                        children: [
                          CustomNoData(
                            height: 56,
                            text: "No Category Found".tr(),
                          ),
                        ],
                      )
                    : DefaultTabController(
                        length: data.length,
                        initialIndex: indexWhere ?? 0,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 53,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.0),
                                  border: const Border(
                                      bottom: BorderSide(
                                          color: Color(0xFFDFDFDF), width: 1)),
                                ),
                                child: Row(
                                  children: [
                                    CategoryCustomTabBar(
                                      categoryData: data,
                                      onNotification: (notification) {
                                        if (notification
                                                is ScrollEndNotification &&
                                            notification.metrics.extentAfter ==
                                                0) {
                                          _onLoading();
                                        }
                                        return false;
                                      },
                                    ),
                                    const SizedBox(width: 14),
                                    Container(
                                      width: 1,
                                      height: 23,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFDFDFDF),
                                      ),
                                    ),
                                    const SizedBox(width: 19),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FilterPage(
                                                  categoryId: categoryId))),
                                      child: Row(
                                        children: [
                                          CustomText(
                                            text: "Filter".tr(),
                                            fontSize: 13,
                                            fontFamily: 'Kanit',
                                            color: const Color(0xFFA8A8A8),
                                            fontWeight: FontWeight.w300,
                                          ),
                                          const SizedBox(width: 5),
                                          const RotatedBox(
                                              quarterTurns: 3,
                                              child: Icon(
                                                  Icons.arrow_back_ios_rounded,
                                                  size: 10,
                                                  color: Color(0xFFA8A8A8))),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                children: isAuthorized && shopId == null
                                    ? [
                                        const CustomNoData(
                                          height: 56,
                                          text:
                                              "Please select a preferred shop",
                                        ),
                                      ]
                                    : data
                                        .map(
                                          (categoryData) =>
                                              CategoryCustomProductList(
                                            shopId: shopId,
                                            animalTypeData:
                                                animalTypeData.value,
                                            scrollController:
                                                widget.scrollController,
                                            categoryId: categoryData.id,
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          ],
                        ),
                      );
              },
              error: (error, stack) => Column(
                children: [
                  CustomReloadProvider(
                    height: 118,
                    onPressed: () => ref
                        .read(categoryAsyncProvider.notifier)
                        .getCategories(),
                  ),
                ],
              ),
              loading: () => const Column(
                children: [
                  SizedBox(
                    height: 157,
                    child: Center(child: CustomIndicator(padding: 50)),
                  ),
                ],
              ),
            ),
          ),
          Container(
              height: kBottomNavigationBarHeight, color: Colors.transparent),
        ],
      ),
    );
  }
}

int? sortValue;
String? selectedProductType;
int? selectedSize;
int? selectedMinPrice;
int? selectedMaxPrice;
int? selectedNewArrivals;
int? selectedSpecialOffer;
List<int> selectedAnimalTypes = [];

TextEditingController categorySearchController = TextEditingController();

String getShopName(BuildContext context, StationModel? shop) {
  if (shop == null) return 'No name'.tr();

  if (isEnglish) {
    return shop.nameEn ?? shop.nameAr ?? shop.nameUr ?? 'No name'.tr();
  } else if (isArabic) {
    return shop.nameAr ?? shop.nameEn ?? shop.nameUr ?? 'No name'.tr();
  } else if (isUrdu) {
    return shop.nameUr ?? shop.nameEn ?? shop.nameUr ?? 'No name'.tr();
  } else {
    return 'No name'.tr();
  }
}
