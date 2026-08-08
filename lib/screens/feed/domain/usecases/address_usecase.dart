import '../entities/address/address_query_model.dart';
import '../entities/address/profile_address_model.dart';
import '../repositories/address_repo.dart';

class GetAddressesUseCase {
  final AddressRepository repository;
  GetAddressesUseCase(this.repository);

  Future<List<ProfileAddressModel>> call(AddressQueryParams params) {
    return repository.getAddresses(params);
  }
}

class CreateAddressUseCase {
  final AddressRepository repository;
  CreateAddressUseCase(this.repository);

  Future<ProfileAddressModel> call(Map<String, dynamic> data) {
    return repository.createAddress(data);
  }
}

class SetDefaultAddressUseCase {
  final AddressRepository repository;
  SetDefaultAddressUseCase(this.repository);

  Future<void> call(int addressId) {
    return repository.setDefaultAddress(addressId);
  }
}

class DeleteAddressUseCase {
  final AddressRepository repository;
  DeleteAddressUseCase(this.repository);

  Future<void> call(int addressId) {
    return repository.deleteAddress(addressId);
  }
}

class UpdateAddressUseCase {
  final AddressRepository repository;
  UpdateAddressUseCase(this.repository);

  Future<ProfileAddressModel> call(Map<String, dynamic> data, int id) {
    return repository.updateAddress(data, id);
  }
}

class GetDefaultAddressUseCase {
  final AddressRepository repository;
  GetDefaultAddressUseCase(this.repository);

  Future<ProfileAddressModel?> call() {
    return repository.getDefaultAddress();
  }
}
