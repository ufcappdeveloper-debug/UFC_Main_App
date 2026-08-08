import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/saved_address_service.dart';
import 'package:ufc_mobile/models/address_model.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

part "default_address.g.dart";

@riverpod
class DefaultAddress extends _$DefaultAddress {
  @override
  FutureOr<AddressModel?> build() async {
    return null;
  }

  Future<void> getDefaultAddress() async {
    state = const AsyncValue.loading();
    try {
      final addressData = await SavedAddressService().getDefaultAddress();

      state = AsyncValue.data(addressData);
      debugPrint('state is ${state.value}');
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> setDefaultAddress(AddressModel selectedAddress) async {
    try {
      final updatedDefaultAddress =
          await SavedAddressService().makeDefaultAddress(selectedAddress.id!);
      state =
          AsyncValue.data(AddressModel.fromJson(updatedDefaultAddress['data']));
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
