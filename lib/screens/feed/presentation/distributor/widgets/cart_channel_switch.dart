import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/cart/cart_cubit.dart';
import '../../../application/cart/cart_state.dart';
import '../../../application/distributor/distributor_cart_cubit.dart';
import '../utils/distributor_style.dart';

/// "Station | Distributors" segmented switch (cart and favorites).
/// With [showCounts], each segment shows its cart count.
class CartChannelSwitch extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  final bool showCounts;

  const CartChannelSwitch({
    super.key,
    required this.selected,
    required this.onChanged,
    this.showCounts = true,
  });

  @override
  Widget build(BuildContext context) {
    final shopCount = showCounts
        ? context.select<CartCubit, int>((c) {
            final s = c.state;
            if (s is CartLoaded) return s.cartCount;
            if (s is CartCountLoaded) return s.count;
            return c.lastCount;
          })
        : 0;
    final distributorCount = showCounts
        ? context.select<DistributorCartCubit, int>((c) => c.state.count)
        : 0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(3),
        decoration: DistributorStyle.card(radius: 20),
        child: Row(
          children: [
            _segment('Station', shopCount, 0),
            _segment('Distributors', distributorCount, 1),
          ],
        ),
      ),
    );
  }

  Widget _segment(String label, int count, int index) {
    final isSelected = selected == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? DistributorStyle.green : Colors.transparent,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label.tr(),
                  style: DistributorStyle.style(
                      weight: FontWeight.w500,
                      color: isSelected ? Colors.white : DistributorStyle.text)),
              if (showCounts && count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : DistributorStyle.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('$count',
                      style: DistributorStyle.style(
                          size: 11,
                          color: isSelected
                              ? DistributorStyle.green
                              : Colors.white)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
