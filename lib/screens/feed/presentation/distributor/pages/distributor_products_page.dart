import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/shared/functions/url_launcher.dart';
import 'package:ufc_mobile/global/shared/widgets/app_image_place_holder.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/util/open_map_widget.dart';

import '../../../application/distributor/distributor_catalog_cubit.dart';
import '../../../application/feed_channel/feed_channel_cubit.dart';
import '../../../application/feed_channel/feed_channel_state.dart';
import '../../../domain/entities/distributor/distributor_model.dart';
import '../utils/distributor_style.dart';
import '../widgets/distributor_common_widgets.dart';
import '../widgets/distributor_filter_sheet.dart';
import '../widgets/distributor_list_sheet.dart';
import '../widgets/distributor_product_card.dart';
import 'distributor_product_details_page.dart';

/// Products tab when the channel is "distributor"
/// (design: "Feed - Distributor Products").
class DistributorProductsPage extends StatefulWidget {
  const DistributorProductsPage({super.key});

  @override
  State<DistributorProductsPage> createState() =>
      _DistributorProductsPageState();
}

class _DistributorProductsPageState extends State<DistributorProductsPage> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final channel = context.read<FeedChannelCubit>().state;
      if (channel.distributor != null) {
        context.read<DistributorCatalogCubit>().open(channel.distributor!);
      } else if (channel.pickRequest > 0) {
        // Opened from "Buy from Distributor" in this session. Never at app
        // start: the Products tab is built in the background then.
        showDistributorListSheet(context);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400),
        () => context.read<DistributorCatalogCubit>().search(value));
  }

  Future<void> _openFilter() async {
    final params = context.read<DistributorCatalogCubit>().state.params;
    if (params == null) return;
    final result = await showDistributorFilterSheet(context, params);
    if (result != null && mounted) {
      context.read<DistributorCatalogCubit>().applyFilter(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedChannelCubit, FeedChannelState>(
      listenWhen: (p, c) =>
          p.distributor?.id != c.distributor?.id ||
          p.pickRequest != c.pickRequest,
      listener: (context, state) {
        if (state.distributor != null) {
          _searchCtrl.clear();
          context.read<DistributorCatalogCubit>().open(state.distributor!);
        } else if (state.isDistributor) {
          // "Buy from Distributor" tapped again: show all distributors.
          _searchCtrl.clear();
          showDistributorListSheet(context);
        }
      },
      builder: (context, channel) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: DistributorSelectorPill(
                        distributor: channel.distributor,
                        onTap: () => showDistributorListSheet(context),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      flex: 5,
                      child: Container(
                        height: 40,
                        decoration: DistributorStyle.card(radius: 10),
                        child: TextField(
                          controller: _searchCtrl,
                          enabled: channel.distributor != null,
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
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: _openFilter,
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
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: channel.distributor == null
                      ? _NoDistributorSelected(
                          onSelect: () => showDistributorListSheet(context))
                      : const _Catalog(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NoDistributorSelected extends StatelessWidget {
  final VoidCallback onSelect;

  const _NoDistributorSelected({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TruckIcon(width: 60, height: 48),
            const SizedBox(height: 16),
            Text('Choose a distributor to see their products'.tr(),
                textAlign: TextAlign.center,
                style: DistributorStyle.style(
                    size: 14, color: DistributorStyle.textSecondary)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: DistributorStyle.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: onSelect,
              child: Text('Select Distributor'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

class _Catalog extends StatelessWidget {
  const _Catalog();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DistributorCatalogCubit, DistributorCatalogState>(
      builder: (context, state) {
        final cubit = context.read<DistributorCatalogCubit>();
        if (state.loading) {
          return const Center(
              child: CircularProgressIndicator(color: DistributorStyle.green));
        }
        if (state.error != null && state.products.isEmpty &&
            state.categories.isEmpty) {
          return CustomReloadProviderV2(
            error: state.error,
            height: 120,
            decoration: const BoxDecoration(color: Colors.transparent),
            onPressed: cubit.refresh,
          );
        }
        return Column(
          children: [
            if (state.distributor != null)
              _DistributorHeader(distributor: state.distributor!),
            _CategoryTabs(
              categories: [
                (id: null, name: 'All'.tr()),
                ...state.categories.map((c) => (id: c.id, name: c.name)),
              ],
              selectedId: state.selectedCategoryId,
              onSelect: cubit.selectCategory,
            ),
            Expanded(child: _ProductGrid(state: state)),
          ],
        );
      },
    );
  }
}

class _DistributorHeader extends StatelessWidget {
  final DistributorModel distributor;

  const _DistributorHeader({required this.distributor});

  @override
  Widget build(BuildContext context) {
    final phone = distributor.phone;
    final subtitle = [distributor.address, distributor.city?.name]
        .where((e) => e != null && e.isNotEmpty)
        .join(' · ');
    return Opacity(
      opacity: distributor.isOpen ? 1 : .6,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ImageWithPlaceHolder(
                imageUrl: distributor.logo,
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(distributor.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: DistributorStyle.style(
                                size: 14, weight: FontWeight.w500)),
                      ),
                      const SizedBox(width: 6),
                      OpenClosedChip(isOpen: distributor.isOpen),
                    ],
                  ),
                  if (subtitle.isNotEmpty)
                    Text(subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DistributorStyle.style(
                            size: 11,
                            weight: FontWeight.w300,
                            color: DistributorStyle.textSecondary)),
                ],
              ),
            ),
            if (distributor.hasLocation)
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.location_on_outlined,
                    color: DistributorStyle.green, size: 20),
                onPressed: () => openMapsAt(context,
                    latitude: distributor.latitude!,
                    longitude: distributor.longitude!,
                    title: distributor.name),
              ),
            if (phone != null && phone.isNotEmpty)
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.phone_outlined,
                    color: DistributorStyle.green, size: 20),
                onPressed: () => launchPhoneCall(phone),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  final List<({int? id, String name})> categories;
  final int? selectedId;
  final ValueChanged<int?> onSelect;

  const _CategoryTabs({
    required this.categories,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final c in categories)
            InkWell(
              onTap: () => onSelect(c.id),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    child: Text(
                      c.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: c.id == selectedId
                            ? DistributorStyle.tabGreen
                            : DistributorStyle.muted,
                      ),
                    ),
                  ),
                  if (c.id == selectedId)
                    Container(
                        width: 90, height: 3, color: DistributorStyle.tabGreen),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final DistributorCatalogState state;

  const _ProductGrid({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DistributorCatalogCubit>();
    if (state.loadingProducts) {
      return const Center(
          child: CircularProgressIndicator(color: DistributorStyle.green));
    }
    if (state.products.isEmpty) {
      return RefreshIndicator(
        color: DistributorStyle.green,
        onRefresh: cubit.refresh,
        child: ListView(
          children: [
            const SizedBox(height: 80),
            Center(
              child: Text('no_products_found'.tr(),
                  style: DistributorStyle.style(size: 15)),
            ),
          ],
        ),
      );
    }
    final width = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      color: DistributorStyle.green,
      onRefresh: cubit.refresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.extentAfter < 300) cubit.loadMore();
          return false;
        },
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 40),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: width >= 600 ? 3 : 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: .7,
          ),
          itemCount: state.products.length + (state.loadingMore ? 1 : 0),
          itemBuilder: (context, i) {
            if (i >= state.products.length) {
              return const Center(
                  child:
                      CircularProgressIndicator(color: DistributorStyle.green));
            }
            final product = state.products[i];
            return DistributorProductCard(
              product: product,
              onFavorite: () => cubit.toggleFavorite(product),
              onTap: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (_) => DistributorProductDetailsPage(
                    productId: product.id!,
                    initial: product,
                    distributor: state.distributor,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
