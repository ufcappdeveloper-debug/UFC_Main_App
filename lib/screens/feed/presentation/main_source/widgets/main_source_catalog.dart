import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';

import '../../../application/main_source/main_source_home_cubit.dart';
import '../../../application/main_source/main_source_products_cubit.dart';
import '../../../domain/entities/main_source/main_source_model.dart';
import '../../../domain/entities/main_source/main_source_params.dart';
import '../../distributor/utils/distributor_style.dart';
import '../pages/main_source_product_details_page.dart';
import '../utils/main_source_errors.dart';
import 'main_source_product_card.dart';

/// Search, category tabs, sort and an infinite product grid
/// (`GET /main-source/products`). Needs a [MainSourceProductsCubit] and
/// the shared [MainSourceHomeCubit] (categories) above it. [header]
/// slivers scroll with the grid.
class MainSourceCatalog extends StatefulWidget {
  final List<Widget> header;

  const MainSourceCatalog({super.key, this.header = const []});

  @override
  State<MainSourceCatalog> createState() => _MainSourceCatalogState();
}

class _MainSourceCatalogState extends State<MainSourceCatalog> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400),
        () => context.read<MainSourceProductsCubit>().search(value));
  }

  Future<void> _refresh() async {
    await Future.wait([
      context.read<MainSourceProductsCubit>().refresh(),
      context.read<MainSourceHomeCubit>().load(silent: true),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MainSourceProductsCubit>();
    return RefreshIndicator(
      color: DistributorStyle.green,
      onRefresh: _refresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.extentAfter < 400) cubit.loadMore();
          return false;
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            ...widget.header,
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: DistributorStyle.card(radius: 10),
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: _onSearch,
                          textInputAction: TextInputAction.search,
                          style: DistributorStyle.style(size: 12),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search'.tr(),
                            hintStyle: DistributorStyle.style(
                                size: 12, color: DistributorStyle.muted),
                            prefixIcon: const Icon(Icons.search,
                                size: 18, color: DistributorStyle.muted),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => showMainSourceSortSheet(context, cubit),
                      child: Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(10),
                        decoration: DistributorStyle.card(radius: 10),
                        child: Image.asset(
                            'assets/new_design/icons/feed_slider.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: _CategoryTabs()),
            const _ProductsSliver(),
          ],
        ),
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs();

  @override
  Widget build(BuildContext context) {
    final categories = context.select<MainSourceHomeCubit,
        List<MainSourceCategoryModel>>((c) => c.state.categories);
    final selected = context.select<MainSourceProductsCubit, int?>(
        (c) => c.state.params.categoryId);
    if (categories.isEmpty) return const SizedBox(height: 8);
    final tabs = [
      (id: null as int?, name: 'All'.tr()),
      ...categories.map((c) => (id: c.id, name: c.name)),
    ];
    return SizedBox(
      height: 46,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        children: [
          for (final c in tabs)
            InkWell(
              onTap: () =>
                  context.read<MainSourceProductsCubit>().selectCategory(c.id),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    child: Text(
                      c.name,
                      style: DistributorStyle.style(
                        size: 12,
                        weight: FontWeight.w500,
                        color: c.id == selected
                            ? DistributorStyle.tabGreen
                            : DistributorStyle.muted,
                      ),
                    ),
                  ),
                  if (c.id == selected)
                    Container(
                        width: 60, height: 3, color: DistributorStyle.tabGreen),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductsSliver extends StatelessWidget {
  const _ProductsSliver();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainSourceProductsCubit, MainSourceProductsState>(
      builder: (context, state) {
        if (state.loading) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 60),
              child: Center(
                  child: CircularProgressIndicator(
                      color: DistributorStyle.green)),
            ),
          );
        }
        if (state.error != null && state.products.isEmpty) {
          return SliverToBoxAdapter(
            child: CustomReloadProviderV2(
              error: mainSourceErrorText(state.error!),
              height: 160,
              decoration: const BoxDecoration(color: Colors.transparent),
              onPressed: context.read<MainSourceProductsCubit>().refresh,
            ),
          );
        }
        if (state.products.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 60, bottom: 60),
              child: Center(
                child: Text('no_products_found'.tr(),
                    style: DistributorStyle.style(size: 15)),
              ),
            ),
          );
        }
        final width = MediaQuery.sizeOf(context).width;
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 40),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: width >= 600 ? 3 : 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: .68,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                if (i >= state.products.length) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: DistributorStyle.green));
                }
                final product = state.products[i];
                return MainSourceProductCard(
                  product: product,
                  onTap: () => openMainSourceProduct(context, product.id!,
                      initial: product),
                );
              },
              childCount: state.products.length + (state.loadingMore ? 1 : 0),
            ),
          ),
        );
      },
    );
  }
}

/// Sort options plus "In stock only".
Future<void> showMainSourceSortSheet(
    BuildContext context, MainSourceProductsCubit cubit) async {
  String? sort = cubit.state.params.sort;
  bool inStock = cubit.state.params.inStockOnly;
  const options = <(String?, String)>[
    (null, 'Recommended'),
    (MainSourceProductParams.sortNewest, 'Newest'),
    (MainSourceProductParams.sortPriceAsc, 'Price: low to high'),
    (MainSourceProductParams.sortPriceDesc, 'Price: high to low'),
    (MainSourceProductParams.sortName, 'Name'),
  ];
  final apply = await showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setSheet) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 16),
                child: Text('Sort by'.tr(),
                    style: DistributorStyle.style(
                        size: 16, weight: FontWeight.w600)),
              ),
              for (final o in options)
                RadioListTile<String?>(
                  value: o.$1,
                  groupValue: sort,
                  activeColor: DistributorStyle.green,
                  title: Text(o.$2.tr(), style: DistributorStyle.style(size: 14)),
                  onChanged: (v) => setSheet(() => sort = v),
                ),
              SwitchListTile(
                value: inStock,
                activeColor: DistributorStyle.green,
                title: Text('In stock only'.tr(),
                    style: DistributorStyle.style(size: 14)),
                onChanged: (v) => setSheet(() => inStock = v),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DistributorStyle.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23)),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: Text('Apply'.tr()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  if (apply == true) await cubit.setSort(sort, inStockOnly: inStock);
}
