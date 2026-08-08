import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ufc_mobile/global/config/dio.dart';

import '../../../../global/config/config.dart';
import '../../domain/entities/address/profile_address_model.dart';
import 'address_data_source.dart';

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final Dio dio;
  AddressRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProfileAddressModel>> getAddresses(
      Map<String, dynamic> params) async {
    debugPrint("📡 Fetching addresses with params: $params");

    try {
      final response = await api.get(
        "/api/ufc/v1/address",
        queryParameters: params,
        options:
            Options(headers: {"Authorization": "Bearer ${AppConfig.token}"}),
      );

      if (response.statusCode == 200) {
        final list = response.data["data"]["data"] as List;
        return list.map((json) => ProfileAddressModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load addresses");
      }
    } catch (e) {
      debugPrint("💥 Exception: $e");
      rethrow;
    }
  }

  @override
  Future<void> setDefaultAddress(int addressId) async {
    try {
      final response = await dio.put(
        "/api/ufc/v1/update_default_address/$addressId/",
        data: {"is_default": true},
        options: Options(
          headers: {"Authorization": "Bearer ${AppConfig.token}"},
        ),
      );
      print("✅ setDefault response: ${response.data}");
    } on DioException catch (e) {
      print("❌ setDefault error: ${e.response?.data}");
      rethrow;
    }
  }

  @override
  Future<void> deleteAddress(int addressId) async {
    await dio.delete(
      "/api/ufc/v1/address/$addressId",
      options: Options(headers: {"Authorization": "Bearer ${AppConfig.token}"}),
    );
  }

  @override
  Future<ProfileAddressModel> updateAddress(final data, int id) async {
    final response = await dio.put(
      "/api/ufc/v1/update_address/$id/",
      data: data,
      options: Options(
        headers: {"Authorization": "Bearer ${AppConfig.token}"},
      ),
    );
    return ProfileAddressModel.fromJson(response.data['data']);
  }

  @override
  Future<ProfileAddressModel> createAddress(Map<String, dynamic> data) async {
    try {
      final response = await api.post(
        "/api/ufc/v1/address",
        data: data,
        options:
            Options(headers: {"Authorization": "Bearer ${AppConfig.token}"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProfileAddressModel.fromJson(response.data["data"]);
      } else {
        throw Exception("Failed to create address");
      }
    } on DioException catch (e) {
      debugPrint("💥 Create address error: $e");
      rethrow;
    }
  }

  @override
  Future<ProfileAddressModel?> getDefaultAddress() async {
    try {
      final response = await api.get(
        'api/ufc/v1/get_default_address',
        options: Options(
          headers: {"Authorization": "Bearer ${AppConfig.token}"},
        ),
      );

      final data = response.data;

      if (data == null || data['data'] == null) {
        return null;
      }

      return ProfileAddressModel.fromJson(data['data']);
      // return ProfileAddressModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }
}
