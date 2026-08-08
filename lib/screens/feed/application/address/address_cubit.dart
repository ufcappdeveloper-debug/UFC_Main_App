import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/address/profile_address_model.dart';

import '../../domain/entities/address/address_query_model.dart';
import '../../domain/usecases/address_usecase.dart';
import 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final GetAddressesUseCase getAddressesUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;
  final UpdateAddressUseCase updateAddressUseCase;
  final SetDefaultAddressUseCase setDefaultAddressUseCase;
  final GetDefaultAddressUseCase getDefaultAddressUseCase;
  final CreateAddressUseCase createAddressUseCase;
  ProfileAddressModel? defaultAddress;

  AddressCubit(
    this.getAddressesUseCase,
    this.deleteAddressUseCase,
    this.updateAddressUseCase,
    this.setDefaultAddressUseCase,
    this.createAddressUseCase,
    this.getDefaultAddressUseCase,
  ) : super(AddressInitial());

  Future<void> createAddress(Map<String, dynamic> data) async {
    try {
      final newAddress = await createAddressUseCase(data);

      if (state is AddressLoaded) {
        final current = (state as AddressLoaded).addresses;
        emit(AddressLoaded(addresses: [...?current, newAddress]));
      } else {
        emit(AddressLoaded(addresses: [newAddress]));
      }
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> fetchAddresses(AddressQueryParams params) async {
    emit(AddressLoading());
    try {
      final addresses = await getAddressesUseCase(params);
      emit(AddressLoaded(addresses: addresses));
    } catch (e) {
      emit(AddressError(e));
    }
  }

  Future<void> deleteAddress(int id) async {
    try {
      await deleteAddressUseCase(id);
      if (state is AddressLoaded) {
        final current = (state as AddressLoaded).addresses;
        final updated = current?.where((a) => a.id != id).toList();
        emit(AddressLoaded(addresses: updated));
      }
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> updateAddress(Map<String, dynamic> data, int id) async {
    try {
      final updatedAddress = await updateAddressUseCase(data, id);
      if (state is AddressLoaded) {
        final current = (state as AddressLoaded).addresses;
        final updated = current?.map((a) {
          return a.id == id ? updatedAddress : a;
        }).toList();
        emit(AddressLoaded(addresses: updated));
      }
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> setDefaultAddress(int id) async {
    try {
      await setDefaultAddressUseCase(id);
      if (state is AddressLoaded) {
        final current = (state as AddressLoaded).addresses;
        final updated = current?.map((a) {
          return a.copyWith(isDefault: a.id == id);
        }).toList();
        emit(AddressLoaded(addresses: updated));
      }
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  // Future<void> getDefaultAddress() async {
  //   try {
  //     final defaultAddress = await getDefaultAddressUseCase();
  //     if (state is AddressLoaded) {
  //       final current = (state as AddressLoaded).addresses;
  //       final updated = current.map((a) {
  //         return a.id == defaultAddress.id
  //             ? a.copyWith(isDefault: true)
  //             : a.copyWith(isDefault: false);
  //       }).toList();

  //       emit(AddressLoaded(
  //         updated,
  //         defaultAddress: defaultAddress,
  //       ));
  //     }
  //   } catch (e) {
  //     emit(AddressError(e.toString()));
  //   }
  // }
  // Future<void> getDefaultAddress() async {
  //   try {
  //     // final defaultAddress = await getDefaultAddressUseCase(); // can be null
  //     // final addresses = await getAddressesUseCase(AddressQueryParams()); // fetch all addresses

  //     // final updated = addresses.map((a) {
  //     //   return a.id == defaultAddress.id
  //     //       ? a.copyWith(isDefault: true)
  //     //       : a.copyWith(isDefault: false);
  //     // }).toList();

  //     final defaultAddress = await getDefaultAddressUseCase();
  //     final addresses = await getAddressesUseCase(AddressQueryParams());

  //     final updated = addresses.map((a) {
  //       if (a.id == defaultAddress.id) {
  //         return a.copyWith(isDefault: true);
  //       }
  //       return a.copyWith(isDefault: false);
  //     }).toList();

  //     emit(AddressLoaded(
  //       updated,
  //       defaultAddress: defaultAddress,
  //     ));
  //   } catch (e) {
  //     emit(AddressError(e.toString()));
  //   }
  // }
  Future<void> getDefaultAddress() async {
  
    emit(AddressLoading());
    try {
      final response = await getDefaultAddressUseCase();

      if (response == null) {
        emit(AddressLoaded(defaultAddress: null)); // no error, just null
      } else {
        emit(AddressLoaded(defaultAddress: response));
      }
    } catch (e) {
      emit(AddressError(e)); // only for real errors
    }
  }
}
