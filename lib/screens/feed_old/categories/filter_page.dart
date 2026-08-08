import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/product/product_async_riverpod.dart';
import 'package:ufc_mobile/riverpod/product/product_future_riverpod.dart';
import 'package:ufc_mobile/screens/feed_old/categories/categories_page.dart';

import 'widgets/custom_animated_filter_widget.dart';

class FilterPage extends ConsumerStatefulWidget {
  const FilterPage({super.key, required this.categoryId});
  final int? categoryId;

  @override
  ConsumerState<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends ConsumerState<FilterPage>
    with TickerProviderStateMixin, ScreenEngagementTracker {
  bool isFilter = true;

  @override
  Widget build(BuildContext context) {
    final animalTypeData = ref.watch(getProductSubtypesProvider);
    final shopId = ref.watch(authProvider).value?.preferredShopDetails?.id;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: const Color(0xffe5e5e5).withValues(alpha: 0.5),
          elevation: 1,
          title: CustomText(
            text: 'Filters',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child:
                const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          ),
          actions: [
            InkWell(
              onTap: () async {
                if (sortValue == null &&
                    selectedSize == null &&
                    selectedSorting == null &&
                    selectedMinPrice == null &&
                    selectedMaxPrice == null &&
                    selectedNewArrivals == null &&
                    selectedProductType == null &&
                    selectedAnimalTypes.isEmpty &&
                    selectedSpecialOffer == null) {
                  Navigator.pop(context);
                  return;
                }
                sortValue = null;
                selectedSize = null;
                selectedSorting = null;
                selectedMinPrice = null;
                selectedMaxPrice = null;
                selectedNewArrivals = null;
                selectedProductType = null;
                selectedAnimalTypes.clear();
                selectedSpecialOffer = null;
                final future = ref
                    .read(productAsyncProvider().notifier)
                    .getProducts(shopId, null,
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
                                    .value![selectedAnimalTypes[index]].id!));
                await LoadingDialog.show(context, future);

                if (!context.mounted) return;
                Navigator.pop(context);
              },
              radius: 11,
              highlightColor: Colors.transparent,
              splashColor: primaryColor.withValues(alpha: 0.5),
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                          color: const Color.fromRGBO(220, 221, 223, 1))),
                  child: CustomText(
                      text: 'Clear all',
                      color: const Color.fromRGBO(137, 137, 137, 1))),
            ),
            const SizedBox(width: 10),
          ],
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    actionButton(
                        onTap: () => setState(() {
                              isFilter = true;
                            }),
                        title: "Filter",
                        selected: isFilter == true),
                    const Spacer(),
                    actionButton(
                        onTap: () => setState(() {
                              isFilter = false;
                            }),
                        title: "Sort",
                        selected: isFilter == false),
                  ],
                ),
              )),
        ),
        body: isFilter == false
            ? Container(
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    ...List.generate(
                      sortValueList.length,
                      (index) => InkWell(
                        onTap: () => setState(() {
                          if (selectedSorting ==
                              sortValueList[index]["title"]) {
                            sortValue = null;
                            selectedSorting = null;
                          } else {
                            sortValue = index + 1;
                            selectedSorting = sortValueList[index]["title"];
                          }
                        }),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: sortItem(
                          title: sortValueList[index]["title"],
                          icon: Image.asset(
                            sortValueList[index]["icon"],
                            height: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    CustomButton(
                      title: 'Apply',
                      onTap: () async {
                        try {
                          final future = ref
                              .read(productAsyncProvider(
                                      categoryId: widget.categoryId)
                                  .notifier)
                              .getProducts(shopId, widget.categoryId,
                                  search: categorySearchController.text,
                                  sort: sortValue,
                                  productType: selectedProductType,
                                  size: selectedSize,
                                  minPrice: selectedMinPrice,
                                  maxPrice: selectedMaxPrice,
                                  createdWithin: selectedNewArrivals,
                                  isOffer: selectedSpecialOffer,
                                  animalType: animalTypeData.value == null
                                      ? null
                                      : List.generate(
                                          selectedAnimalTypes.length,
                                          (index) => animalTypeData
                                              .value![
                                                  selectedAnimalTypes[index]]
                                              .id!));
                          await LoadingDialog.show(context, future);

                          if (!context.mounted) return;
                          Navigator.pop(context);
                        } catch (e) {
                          CustomSnackBar.error(context, e.toString());
                        }
                      },
                      radius: 10,
                      height: 33,
                      width: 188,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    )
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 8,
                          color: Colors.grey.withValues(alpha: 0.3))
                    ],
                  ),
                  child: Column(
                    children: [
                      CustomAnimatedFilter(
                        index: 0,
                        hasDivider: true,
                        title: 'Product Type',
                        filterItems: productTypes,
                        selectedFilter: selectedProductType == null
                            ? null
                            : selectedProductType![0].toUpperCase() +
                                selectedProductType!.substring(1).toLowerCase(),
                      ),
                      CustomAnimatedFilter(
                        index: 1,
                        title: 'Size',
                        hasDivider: true,
                        filterItems: sizes,
                        selectedFilter: selectedSize == null
                            ? null
                            : selectedSize == 1000
                                ? "Ton"
                                : "$selectedSize Kg",
                        icon: Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Image.asset(
                              'assets/images/global/full_size.png',
                              height: 14),
                        ),
                      ),
                      CustomAnimatedFilter(
                        index: 2,
                        title: 'Price',
                        hasDivider: true,
                        filterItems: prices,
                        icon: Image.asset(
                            'assets/images/global/currency_exchange.png',
                            height: 18),
                        selectedFilter: selectedMinPrice == null ||
                                selectedMaxPrice == null
                            ? null
                            : selectedMinPrice == 0
                                ? 'Under $selectedMaxPrice SAR'
                                : '$selectedMinPrice SAR to $selectedMaxPrice SAR',
                      ),
                      CustomAnimatedFilter(
                        index: 3,
                        hasDivider: true,
                        title: 'New Arrivals',
                        filterItems: newArrivals,
                        icon: Image.asset('assets/images/global/flame.png',
                            height: 17),
                        selectedFilter: selectedNewArrivals == null
                            ? null
                            : convertNewArrivals(selectedNewArrivals),
                      ),
                      CustomAnimatedFilter(
                        index: 4,
                        hasDivider: !animalTypeData.isLoading &&
                                (animalTypeData.value == null ||
                                    animalTypeData.value!.isEmpty)
                            ? false
                            : true,
                        title: 'Special Offers',
                        filterItems: specialOffers,
                        selectedFilter: selectedSpecialOffer == null
                            ? null
                            : 'Discounted Only',
                        icon: Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Image.asset('assets/images/global/tag.png',
                              height: 16),
                        ),
                      ),
                      animalTypeData.when(
                        data: (data) => (data.isEmpty)
                            ? const SizedBox.shrink()
                            : CustomAnimatedFilter(
                                index: 5,
                                icon: Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Image.asset(
                                      'assets/images/global/paw.png',
                                      height: 14),
                                ),
                                filterItems: data,
                                title: 'Animal Type',
                                selectedFilterList: selectedAnimalTypes,
                              ),
                        error: (error, stack) => CustomReloadProvider(
                          height: 118,
                          onPressed: () =>
                              ref.refresh(getProductSubtypesProvider),
                        ),
                        loading: () => const SizedBox(
                          height: 157,
                          child: Center(child: CustomIndicator(padding: 50)),
                        ),
                      ),
                      const SizedBox(height: 50),
                      CustomButton(
                        title: 'Apply',
                        onTap: () async {
                          try {
                            final future = ref
                                .read(productAsyncProvider(
                                        categoryId: widget.categoryId)
                                    .notifier)
                                .getProducts(shopId, widget.categoryId,
                                    search: categorySearchController.text,
                                    sort: sortValue,
                                    productType: selectedProductType,
                                    size: selectedSize,
                                    minPrice: selectedMinPrice,
                                    maxPrice: selectedMaxPrice,
                                    createdWithin: selectedNewArrivals,
                                    isOffer: selectedSpecialOffer,
                                    animalType: animalTypeData.value == null
                                        ? null
                                        : List.generate(
                                            selectedAnimalTypes.length,
                                            (index) => animalTypeData
                                                .value![
                                                    selectedAnimalTypes[index]]
                                                .id!));
                            await LoadingDialog.show(context, future);

                            if (!context.mounted) return;
                            Navigator.pop(context);
                          } catch (e) {
                            CustomSnackBar.error(context, e.toString());
                          }
                        },
                        radius: 10,
                        height: 33,
                        width: 188,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ),
                ),
              ));
  }

  Widget sortItem({required String title, Widget? icon}) {
    return Column(
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: icon ??
                        Image.asset('assets/images/global/suggestion.png',
                            height: 18),
                  ),
                  const SizedBox(width: 5),
                  CustomText(
                    text: title.tr(),
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                  const Spacer(),
                  if (selectedSorting == title)
                    Image.asset('assets/images/global/check.png', height: 11),
                ],
              ),
            ),
            Divider(
              color: Colors.grey.withValues(alpha: 0.2),
              thickness: 1,
              height: 2,
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget actionButton({
    required String title,
    bool selected = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      radius: 11,
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor:
          selected ? Colors.transparent : primaryColor.withValues(alpha: 0.5),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: selected
                  ? Border.all(color: const Color.fromRGBO(239, 239, 239, 1))
                  : Border.all(color: const Color.fromRGBO(220, 221, 223, 1)),
              color: selected
                  ? const Color.fromRGBO(239, 239, 239, 1)
                  : Colors.transparent),
          child: Row(
            children: [
              CustomText(
                  text: title.tr(),
                  fontWeight: FontWeight.w300,
                  color: const Color.fromRGBO(137, 137, 137, 1)),
              const SizedBox(width: 5),
              RotatedBox(
                  quarterTurns: selected ? 1 : 3,
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 14,
                  )),
            ],
          )),
    );
  }
}

String? selectedSorting;
List<Map<String, dynamic>> sortValueList = [
  {
    "title": "Suggested",
    "icon": "assets/images/global/suggestion.png",
  },
  {
    "title": "New Arrivals",
    "icon": "assets/images/global/flame.png",
  },
  {
    "title": "Price High to Low",
    "icon": "assets/images/global/currency_exchange.png",
  },
  {
    "title": "Price Low to High",
    "icon": "assets/images/global/currency_exchange_up.png",
  },
  {
    "title": "Discount",
    "icon": "assets/images/global/tag.png",
  },
];

List<String> productTypes = ['Loose', 'Rolled', 'Flaked'];
List<String> sizes = ['40 Kg', '50 Kg', 'Ton'];
List<String> prices = [
  'Under 100 SAR',
  '100 SAR to 150 SAR',
  '150 SAR to 200 SAR',
  '200 SAR to 300 SAR',
  '300 SAR to 500 SAR',
  '500 SAR to 1000 SAR',
];
List<String> newArrivals = ['This week', 'Last week', 'This month'];
List<String> specialOffers = ['Discounted Only'];
List<String> animalTypes = ['Large Animals', 'Poultry'];
