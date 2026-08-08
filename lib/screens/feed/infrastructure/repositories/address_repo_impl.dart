import 'package:dio/dio.dart';

import '../../domain/entities/address/address_query_model.dart';
import '../../domain/entities/address/profile_address_model.dart';
import '../../domain/failure/failure.dart';
import '../../domain/repositories/address_repo.dart';
import '../data_sources/address_data_source.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;
  AddressRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ProfileAddressModel>> getAddresses(
      AddressQueryParams params) async {
    try {
      return await remoteDataSource.getAddresses(params.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> setDefaultAddress(int addressId) async {
    try {
      await remoteDataSource.setDefaultAddress(addressId);
    } on DioException catch (e) {
      throw NetworkFailure(e.response?.data.toString() ?? "Network error");
    }
  }

  @override
  Future<void> deleteAddress(int addressId) async {
    try {
      await remoteDataSource.deleteAddress(addressId);
    } on DioException catch (e) {
      throw NetworkFailure(e.response?.data.toString() ?? "Network error");
    }
  }

  @override
  Future<ProfileAddressModel> updateAddress(
      Map<String, dynamic> data, int id) async {
    try {
      return await remoteDataSource.updateAddress(data, id);
    } on DioException catch (e) {
      throw NetworkFailure(e.response?.data.toString() ?? "Network error");
    }
  }

  @override
  Future<ProfileAddressModel> createAddress(Map<String, dynamic> data) async {
    try {
      return await remoteDataSource.createAddress(data);
    } on DioException catch (e) {
      throw NetworkFailure(e.response?.data.toString() ?? "Network error");
    }
  }

  @override
  Future<ProfileAddressModel?> getDefaultAddress() async {
      try {
    final address = await remoteDataSource.getDefaultAddress();
    return address; 
  } catch (e) {
    rethrow;
  }
  }
}
