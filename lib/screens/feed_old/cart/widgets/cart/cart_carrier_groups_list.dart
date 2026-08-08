import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/riverpod/carrier/carrier_future_riverpod.dart';
import 'package:ufc_mobile/screens/feed_old/cart/widgets/cart/cart_carrier_group_card.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_no_data.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';

class CartCarrierGroupsList extends ConsumerStatefulWidget {
  const CartCarrierGroupsList({
    super.key,
    required this.ctx,
  });
  final BuildContext ctx;

  @override
  ConsumerState<CartCarrierGroupsList> createState() =>
      _CartCarrierGroupsListState();
}

class _CartCarrierGroupsListState extends ConsumerState<CartCarrierGroupsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final carrierGroupsProvider = ref.watch(getCarrierGroupsProvider);
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(width: 1, color: const Color(0xFFE2E2E2))),
          child: carrierGroupsProvider.when(
            data: (data) => data.isEmpty
                ? const CustomNoData(
                    height: 33,
                    decoration: BoxDecoration(),
                    text: "No Carrier Number Found")
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: data.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        CartCarrierGroupCard(shopCarrierGroupData: data[index]),
                    separatorBuilder: (context, index) => const Divider(
                        height: 0, thickness: 1, color: Color(0xFFE2E2E2)),
                  ),
            error: (error, stackTrace) => CustomReloadProvider(
              height: 33,
              decoration: const BoxDecoration(),
              onPressed: () => ref.refresh(getCarrierGroupsProvider),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 33),
              child: CupertinoActivityIndicator(),
            ),
          ));
    });
  }
}
