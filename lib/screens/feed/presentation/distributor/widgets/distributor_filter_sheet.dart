import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/distributor/distributor_query_params.dart';
import '../utils/distributor_style.dart';

/// Sort / filter sheet for the distributor product grid
/// (`sort`, `is_offer`, `in_stock`, `min_price`, `max_price`).
Future<DistributorProductParams?> showDistributorFilterSheet(
    BuildContext context, DistributorProductParams current) {
  return showModalBottomSheet<DistributorProductParams>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _FilterSheet(current: current),
  );
}

class _FilterSheet extends StatefulWidget {
  final DistributorProductParams current;

  const _FilterSheet({required this.current});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  static const _sorts = {
    2: 'Newest',
    3: 'Price: high to low',
    4: 'Price: low to high',
    5: 'Biggest discount',
  };

  late int _sort = widget.current.sort ?? 2;
  late bool _offers = widget.current.isOffer;
  late bool _inStock = widget.current.inStock;
  late final _min = TextEditingController(
      text: widget.current.minPrice?.toStringAsFixed(0) ?? '');
  late final _max = TextEditingController(
      text: widget.current.maxPrice?.toStringAsFixed(0) ?? '');

  @override
  void dispose() {
    _min.dispose();
    _max.dispose();
    super.dispose();
  }

  DistributorProductParams _build({bool reset = false}) {
    final c = widget.current;
    return DistributorProductParams(
      distributorId: c.distributorId,
      categoryId: c.categoryId,
      search: c.search,
      sort: reset ? null : _sort,
      isOffer: reset ? false : _offers,
      inStock: reset ? false : _inStock,
      minPrice: reset ? null : double.tryParse(_min.text),
      maxPrice: reset ? null : double.tryParse(_max.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration priceDecoration(String hint) => InputDecoration(
          hintText: hint.tr(),
          hintStyle:
              DistributorStyle.style(size: 13, color: DistributorStyle.muted),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: DistributorStyle.muted),
          ),
        );
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, 24 + MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text('Filter'.tr(),
                  style: DistributorStyle.style(
                      size: 15, weight: FontWeight.w500)),
            ),
            const SizedBox(height: 16),
            Text('Sort by'.tr(),
                style:
                    DistributorStyle.style(size: 14, weight: FontWeight.w500)),
            for (final e in _sorts.entries)
              RadioListTile<int>(
                dense: true,
                contentPadding: EdgeInsets.zero,
                activeColor: DistributorStyle.green,
                value: e.key,
                groupValue: _sort,
                onChanged: (v) => setState(() => _sort = v ?? 2),
                title: Text(e.value.tr(), style: DistributorStyle.style()),
              ),
            SwitchListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              activeColor: DistributorStyle.green,
              value: _offers,
              onChanged: (v) => setState(() => _offers = v),
              title: Text('Offers only'.tr(), style: DistributorStyle.style()),
            ),
            SwitchListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              activeColor: DistributorStyle.green,
              value: _inStock,
              onChanged: (v) => setState(() => _inStock = v),
              title: Text('In stock only'.tr(), style: DistributorStyle.style()),
            ),
            const SizedBox(height: 8),
            Text('Price'.tr(),
                style:
                    DistributorStyle.style(size: 14, weight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _min,
                    keyboardType: TextInputType.number,
                    decoration: priceDecoration('Min'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _max,
                    keyboardType: TextInputType.number,
                    decoration: priceDecoration('Max'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: DistributorStyle.green,
                      side: const BorderSide(color: DistributorStyle.green),
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () =>
                        Navigator.of(context).pop(_build(reset: true)),
                    child: Text('Reset'.tr()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DistributorStyle.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.of(context).pop(_build()),
                    child: Text('Apply'.tr()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
