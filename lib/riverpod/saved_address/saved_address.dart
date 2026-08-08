import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/saved_address_service.dart';
import 'package:ufc_mobile/models/address_model.dart';
import 'package:ufc_mobile/riverpod/default_address/default_address.dart';
import 'package:ufc_mobile/screens/feed_old/saved_address/pages/saved_address_list.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

part "saved_address.g.dart";

@riverpod
class SavedAddress extends _$SavedAddress {
  late SavedAddressService _savedAddressService;
  @override
  FutureOr<List<AddressModel>> build() async {
    _savedAddressService = SavedAddressService();
    return [];
  }

  Future<void> initialLoad(int page, int limit) async {
    state = const AsyncValue.loading();
    try {
      final savedAddressList =
          await _savedAddressService.getAllSavedAddress(page, limit);
      state = AsyncValue.data(savedAddressList);
      if (state.value?.length == 1) {
        ref
            .read(defaultAddressProvider.notifier)
            .setDefaultAddress(state.value![0]);
      }
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<bool> loadMore(int page, int limit) async {
    try {
      final savedAddressList =
          await _savedAddressService.getAllSavedAddress(page, limit);
      if (savedAddressList.isEmpty || savedAddressList.length < limit) {
        return false;
      }

      state = AsyncValue.data([...state.value!, ...savedAddressList]);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
    return true;
  }

  Future<void> createAddress(final data) async {
    try {
      final result = await _savedAddressService.createAddress(data);
      if (result) {
        initialLoad(0, SavedAddressList.limit);
      } else {
        throw "Something went wrong, please contact to admin";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAddress(final data, int id) async {
    try {
      final updatedAddressModel =
          await _savedAddressService.updateAddress(data, id);
      final savedAddresses = state.value!;
      int index = savedAddresses.indexWhere((element) => element.id == id);
      savedAddresses[index] = updatedAddressModel;
      state = AsyncValue.data(savedAddresses.toList());
    } on DioException catch (e) {
      throw e.dioMessage;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAddress(int id) async {
    try {
      final result = await _savedAddressService.deleteAddress(id);
      if (!result) {
        throw "Something went wrong, please contact to admin";
      } else {
        final savedAddressList = state.value!;
        savedAddressList.removeWhere((element) => element.id == id);
        state = AsyncValue.data([...savedAddressList]);
      }
    } on DioException catch (e) {
      throw e.dioMessage;
    } catch (e) {
      rethrow;
    }
  }
}
