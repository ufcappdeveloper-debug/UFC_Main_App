import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/models/address_model.dart';

class SavedAddressService {
  Future<bool> createAddress(final data) async {
    Response response = await api.post("api/ufc/v1/address", data: data);
    return response.data['data'] != null;
  }

  Future<AddressModel> updateAddress(final data, int id) async {
    Response response =
        await api.put("api/ufc/v1/update_address/$id", data: data);
    final addressModel = AddressModel.fromJson(response.data['data']);
    return addressModel;
  }

  Future<List<AddressModel>> getAllSavedAddress(int page, int limit) async {
    Response response =
        await api.get("api/ufc/v1/address?page=$page&limit=$limit");
    return (response.data['data']['data'] as List<dynamic>)
        .map((e) => AddressModel.fromJson(e))
        .toList();
  }

  Future<bool> deleteAddress(int id) async {
    Response response = await api.delete("api/ufc/v1/address/$id");

    return response.data['message'] == "Address deleted successfully";
  }

  Future makeDefaultAddress(int addressId) async {
    Response response =
        await api.put("api/ufc/v1/update_default_address/$addressId");
    return response.data;
  }

  Future<AddressModel> getDefaultAddress() async {
    Response response = await api.get("api/ufc/v1/get_default_address");
    return AddressModel.fromJson(response.data['data']);
  }
}
