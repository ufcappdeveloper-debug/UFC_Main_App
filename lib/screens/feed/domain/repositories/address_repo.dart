import '../entities/address/address_query_model.dart';
import '../entities/address/profile_address_model.dart';

abstract class AddressRepository {
  Future<List<ProfileAddressModel>> getAddresses(AddressQueryParams params);
  Future<void> setDefaultAddress(int addressId);
  Future<void> deleteAddress(int addressId);
  Future<ProfileAddressModel> updateAddress(Map<String, dynamic> data, int id);
  Future<ProfileAddressModel> createAddress(Map<String, dynamic> data);
  Future<ProfileAddressModel?> getDefaultAddress();
}
