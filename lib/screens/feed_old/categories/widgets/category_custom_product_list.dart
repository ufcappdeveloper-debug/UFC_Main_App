import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/models/animal_type_model.dart';
import 'package:ufc_mobile/riverpod/product/product_async_riverpod.dart';
import 'package:ufc_mobile/screens/feed_old/categories/categories_page.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_no_data.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_footer.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_header.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/product_container.dart';

class CategoryCustomProductList extends ConsumerStatefulWidget {
  const CategoryCustomProductList({
    super.key,
    required this.shopId,
    required this.categoryId,
    required this.animalTypeData,
    required this.scrollController,
  });
  final int? shopId;
  final int? categoryId;
  final ScrollController? scrollController;
  final List<AnimalTypeModel>? animalTypeData;

  @override
  ConsumerState<CategoryCustomProductList> createState() =>
      _CategoryCustomProductListState();
}

class _CategoryCustomProductListState
    extends ConsumerState<CategoryCustomProductList> {
  int page = 1;
  String? pageLimit;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    page = 1;
    pageLimit = null;
    Future(() => ref
        .read(productAsyncProvider(categoryId: widget.categoryId).notifier)
        .getProducts(widget.shopId, widget.categoryId,
            search: categorySearchController.text,
            sort: sortValue,
            productType: selectedProductType,
            size: selectedSize,
            minPrice: selectedMinPrice,
            maxPrice: selectedMaxPrice,
            createdWithin: selectedNewArrivals,
            isOffer: selectedSpecialOffer,
            animalType:
                widget.animalTypeData == null || widget.animalTypeData!.isEmpty
                    ? null
                    : List.generate(
                        selectedAnimalTypes.length,
                        (index) => widget
                            .animalTypeData![selectedAnimalTypes[index]].id!)));
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    page = 1;
    pageLimit = null;

    await ref
        .read(productAsyncProvider(categoryId: widget.categoryId).notifier)
        .getProducts(widget.shopId, widget.categoryId,
            search: categorySearchController.text,
            sort: sortValue,
            productType: selectedProductType,
            size: selectedSize,
            minPrice: selectedMinPrice,
            maxPrice: selectedMaxPrice,
            createdWithin: selectedNewArrivals,
            isOffer: selectedSpecialOffer,
            animalType:
                widget.animalTypeData == null || widget.animalTypeData!.isEmpty
                    ? null
                    : List.generate(
                        selectedAnimalTypes.length,
                        (index) => widget
                            .animalTypeData![selectedAnimalTypes[index]].id!));
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (pageLimit != "empty") {
      page++;
    }

    pageLimit = await ref
        .read(productAsyncProvider(categoryId: widget.categoryId).notifier)
        .loadProducts(page, widget.shopId, widget.categoryId,
            search: categorySearchController.text,
            sort: sortValue,
            productType: selectedProductType,
            size: selectedSize,
            minPrice: selectedMinPrice,
            maxPrice: selectedMaxPrice,
            createdWithin: selectedNewArrivals,
            isOffer: selectedSpecialOffer,
            animalType:
                widget.animalTypeData == null || widget.animalTypeData!.isEmpty
                    ? null
                    : List.generate(
                        selectedAnimalTypes.length,
                        (index) => widget
                            .animalTypeData![selectedAnimalTypes[index]].id!));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        ref.watch(productAsyncProvider(categoryId: widget.categoryId));
    return productProvider.when(
      data: (data) => SmartRefresher(
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        controller: _refreshController,
        scrollController: widget.scrollController,
        header: const CustomPaginationHeader(),
        footer: CustomPaginationFooter(
            pageLimit: pageLimit, emptyDataText: "No More Product Found"),
        physics: const BouncingScrollPhysics(),
        child: (data == null || data.isEmpty)
            ? const Column(
                children: [
                  CustomNoData(
                    height: 56,
                    text: "No Product Found",
                  ),
                ],
              )
            : GridView.builder(
                itemCount: data.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 17,
                    childAspectRatio: 0.62,
                    maxCrossAxisExtent: 171),
                itemBuilder: (context, index) {
                  return ProductContainer(productData: data[index]);
                },
              ),
      ),
      error: (error, stack) => Column(
        children: [
          CustomReloadProvider(
            height: 118,
            onPressed: () => ref
                .read(productAsyncProvider(categoryId: widget.categoryId)
                    .notifier)
                .getProducts(widget.shopId, widget.categoryId,
                    search: categorySearchController.text,
                    sort: sortValue,
                    productType: selectedProductType,
                    size: selectedSize,
                    minPrice: selectedMinPrice,
                    maxPrice: selectedMaxPrice,
                    createdWithin: selectedNewArrivals,
                    isOffer: selectedSpecialOffer,
                    animalType: widget.animalTypeData == null ||
                            widget.animalTypeData!.isEmpty
                        ? null
                        : List.generate(
                            selectedAnimalTypes.length,
                            (index) => widget
                                .animalTypeData![selectedAnimalTypes[index]]
                                .id!)),
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
    );
  }
}
