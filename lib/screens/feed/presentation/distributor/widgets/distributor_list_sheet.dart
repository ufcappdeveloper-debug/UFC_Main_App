import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/shared/init/injection.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';

import '../../../application/distributor/distributor_list_cubit.dart';
import '../../../application/feed_channel/feed_channel_cubit.dart';
import '../../../domain/entities/distributor/distributor_model.dart';
import '../utils/distributor_style.dart';
import 'distributor_common_widgets.dart';

/// "Feed Distributors" sheet (design: "Feed - Distributors").
/// Lists all distributors; picking one shows its products (not saved).
Future<DistributorModel?> showDistributorListSheet(BuildContext context) {
  final selectedId = context.read<FeedChannelCubit>().state.distributor?.id;
  return showModalBottomSheet<DistributorModel>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x8A000000),
    builder: (_) => BlocProvider(
      create: (_) => sl<DistributorListCubit>()..load(),
      child: _DistributorListSheet(selectedId: selectedId),
    ),
  ).then((picked) {
    if (picked != null && context.mounted) {
      context.read<FeedChannelCubit>().selectDistributor(picked);
    }
    return picked;
  });
}

class _DistributorListSheet extends StatefulWidget {
  final int? selectedId;

  const _DistributorListSheet({this.selectedId});

  @override
  State<_DistributorListSheet> createState() => _DistributorListSheetState();
}

class _DistributorListSheetState extends State<_DistributorListSheet> {
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
        () => context.read<DistributorListCubit>().load(search: value));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: (height * .7).clamp(400, 640),
      padding: EdgeInsets.fromLTRB(
          4, 10, 4, 24 + MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, size: 17, color: Color(0x8A000000)),
              ),
              Expanded(
                child: Text('Feed Distributors'.tr(),
                    textAlign: TextAlign.center,
                    style: DistributorStyle.style(
                        size: 15, weight: FontWeight.w500)),
              ),
              const SizedBox(width: 48),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
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
          Expanded(
            child: BlocBuilder<DistributorListCubit, DistributorListState>(
              builder: (context, state) {
                if (state.loading) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: DistributorStyle.green));
                }
                if (state.error != null && state.distributors.isEmpty) {
                  return CustomReloadProviderV2(
                    error: state.error!,
                    height: 120,
                    decoration:
                        const BoxDecoration(color: Colors.transparent),
                    onPressed: () =>
                        context.read<DistributorListCubit>().load(),
                  );
                }
                if (state.distributors.isEmpty) {
                  return Center(
                    child: Text('No distributors found'.tr(),
                        style: DistributorStyle.style(
                            size: 14, color: DistributorStyle.textSecondary)),
                  );
                }
                return NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n.metrics.extentAfter < 200) {
                      context.read<DistributorListCubit>().loadMore();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    itemCount:
                        state.distributors.length + (state.loadingMore ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i >= state.distributors.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                              child: CircularProgressIndicator(
                                  color: DistributorStyle.green)),
                        );
                      }
                      final d = state.distributors[i];
                      return _DistributorCard(
                        distributor: d,
                        selected: d.id == widget.selectedId,
                        onPick: () => Navigator.of(context).pop(d),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DistributorCard extends StatelessWidget {
  final DistributorModel distributor;
  final bool selected;
  final VoidCallback onPick;

  const _DistributorCard({
    required this.distributor,
    required this.selected,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      // Closed distributors are greyed out; they can still be browsed.
      opacity: distributor.isOpen ? 1 : .5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: GestureDetector(
          onTap: onPick,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: DistributorStyle.card(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? DistributorStyle.green
                                : Colors.transparent,
                            border: Border.all(
                                color: selected
                                    ? DistributorStyle.green
                                    : DistributorStyle.muted),
                          ),
                          child: selected
                              ? const Icon(Icons.check,
                                  size: 12, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          (selected ? 'Selected' : 'Select').tr(),
                          style: DistributorStyle.style(
                              color: DistributorStyle.green),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (distributor.hasLocation)
                      MapChip(
                        latitude: distributor.latitude!,
                        longitude: distributor.longitude!,
                        title: distributor.name,
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(distributor.name,
                                textAlign: TextAlign.end,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: DistributorStyle.style(
                                    weight: FontWeight.w500)),
                          ),
                          const SizedBox(width: 4),
                          const TruckIcon(width: 17, height: 14),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        alignment: WrapAlignment.end,
                        children: [
                          if (!distributor.isOpen)
                            const OpenClosedChip(isOpen: false),
                          if (distributor.supportsDelivery)
                            const OutlineChip(label: 'Delivery'),
                          if (distributor.supportsPickup)
                            const OutlineChip(label: 'Pickup'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (distributor.distance != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SvgPicture.asset('assets/svg/feed/layer1.svg',
                                width: 12, height: 12),
                            const SizedBox(width: 12),
                            Text(
                              '${distributor.distance!.toStringAsFixed(1)} ${'KM'.tr()}',
                              style: DistributorStyle.style(
                                  weight: FontWeight.w300),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
