import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/util/open_map_widget.dart';

import '../../../domain/entities/distributor/distributor_model.dart';
import '../utils/distributor_style.dart';

/// Formats a price with 2 decimals, e.g. 115 -> "115.00".
String formatPrice(num? value) => (value ?? 0).toStringAsFixed(2);

/// Green truck icon, mirrored so it faces the reading direction.
class TruckIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const TruckIcon({
    super.key,
    this.width = 21,
    this.height = 17,
    this.color = DistributorStyle.green,
  });

  @override
  Widget build(BuildContext context) {
    final icon = SvgPicture.asset(
      'assets/svg/feed/truck.svg',
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
    return isArOrUr ? icon : Transform.flip(flipX: true, child: icon);
  }
}

/// Yellow "Map" chip from the design. Opens the installed map apps.
class MapChip extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String title;
  final String label;

  const MapChip({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.title,
    this.label = 'Map',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openMapsAt(context,
          latitude: latitude, longitude: longitude, title: title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: DistributorStyle.yellow,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Color(0x80F7D66D), blurRadius: 15),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/svg/feed/map.svg'),
            const SizedBox(width: 6),
            Text(label.tr(),
                style: DistributorStyle.style(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

/// Riyal amount: "﷼ 115.00" with the SaudiRiyal glyph.
class RiyalAmount extends StatelessWidget {
  final num? amount;
  final double size;
  final FontWeight weight;
  final Color color;
  final bool strike;

  const RiyalAmount(
    this.amount, {
    super.key,
    this.size = 14,
    this.weight = FontWeight.w500,
    this.color = Colors.black,
    this.strike = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SaudiRiyalIcon(size: size - 1, color: color),
        Text(
          formatPrice(amount),
          style: DistributorStyle.style(size: size, weight: weight, color: color)
              .copyWith(
                  decoration: strike ? TextDecoration.lineThrough : null),
        ),
      ],
    );
  }
}

/// "Open" / "Closed" chip.
class OpenClosedChip extends StatelessWidget {
  final bool isOpen;

  const OpenClosedChip({super.key, required this.isOpen});

  @override
  Widget build(BuildContext context) {
    final color = isOpen ? DistributorStyle.green : DistributorStyle.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text((isOpen ? 'Open' : 'Closed').tr(),
          style: DistributorStyle.style(size: 11, color: color)),
    );
  }
}

/// Small outlined chip ("Delivery", "Pickup", "Distributor").
class OutlineChip extends StatelessWidget {
  final String label;
  final Color color;

  const OutlineChip(
      {super.key, required this.label, this.color = DistributorStyle.green});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label.tr(),
          style: DistributorStyle.style(size: 11, color: color)),
    );
  }
}

/// The "Select Distributor" pill in the products header (design:
/// "Feed - Distributor Products"). Grey until a distributor is chosen.
class DistributorSelectorPill extends StatelessWidget {
  final DistributorModel? distributor;
  final VoidCallback onTap;

  const DistributorSelectorPill(
      {super.key, required this.distributor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final selected = distributor != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: DistributorStyle.card(radius: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TruckIcon(
                color:
                    selected ? DistributorStyle.green : DistributorStyle.muted),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                selected ? distributor!.name : 'Select Distributor'.tr(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: DistributorStyle.style(size: 11).copyWith(height: 1.2),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded,
                size: 20, color: DistributorStyle.muted),
          ],
        ),
      ),
    );
  }
}

/// −/+ quantity stepper (same look as the cart's quantity selector).
class QtyStepper extends StatelessWidget {
  final int qty;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  final bool busy;
  final String? label;

  const QtyStepper({
    super.key,
    required this.qty,
    this.onDecrement,
    this.onIncrement,
    this.busy = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    Widget button(IconData icon, VoidCallback? onTap) => GestureDetector(
          onTap: busy ? null : onTap,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: onTap == null
                  ? const Color(0xFF9E9E9E)
                  : DistributorStyle.tabGreen,
            ),
            child: Icon(icon, size: 16, color: Colors.white),
          ),
        );
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 6,
              spreadRadius: .2,
              offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          button(Icons.remove, onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: busy
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: DistributorStyle.green))
                : Text(label ?? '$qty',
                    style: DistributorStyle.style(size: 14)),
          ),
          button(Icons.add, onIncrement),
        ],
      ),
    );
  }
}
