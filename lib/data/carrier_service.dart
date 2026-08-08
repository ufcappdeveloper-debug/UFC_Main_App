import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/models/shop_carrier_group_model.dart';

class CarrierService {
  Future<List<ShopCarrierGroupModel>> getCarrierGroups() async {
    Response response = await api.get("api/ufc/v1/carrier/get_groups");
    return (response.data["shop_carrier_groups"] as List<dynamic>)
        .map((data) => ShopCarrierGroupModel.fromJson(data))
        .toList();
  }
}
