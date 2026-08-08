import '../../domain/entities/address/profile_address_model.dart';

abstract class AddressRemoteDataSource {
  Future<List<ProfileAddressModel>> getAddresses(Map<String, dynamic> params);
  Future<void> setDefaultAddress(int addressId);
  Future<void> deleteAddress(int addressId);
  Future<ProfileAddressModel> updateAddress(Map<String, dynamic> data, int id);
  Future<ProfileAddressModel> createAddress(Map<String, dynamic> data);
  Future<ProfileAddressModel?> getDefaultAddress();
}
