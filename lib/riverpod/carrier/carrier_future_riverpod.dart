import 'package:ufc_mobile/data/carrier_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/models/shop_carrier_group_model.dart';

part "carrier_future_riverpod.g.dart";

@riverpod
Future<List<ShopCarrierGroupModel>> getCarrierGroups(
    GetCarrierGroupsRef ref) async {
  return await CarrierService().getCarrierGroups();
}
