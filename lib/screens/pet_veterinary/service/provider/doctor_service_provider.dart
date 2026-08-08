import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/doctor_service.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_model.dart';

part 'doctor_service_provider.g.dart';

@Riverpod(keepAlive: true)
class DoctorServiceProvider extends _$DoctorServiceProvider {
  String? _currentSearchQuery;
  String? _currentRankOrder;
  String? _currentAvailability;

  String? get currentRankOrder => _currentRankOrder;
  String? get currentAvailability => _currentAvailability;

  bool get isFilterActive {
    return _currentRankOrder != null || _currentAvailability != null;
  }

  @override
  FutureOr<PaginatedDoctorsResponse?> build() async {
    return null;
  }

  // Future<void> fetchInitialDoctors() async {
  //   try {
  //     state = const AsyncValue.loading();

  //     final response = await DoctorService().fetchDoctors(page: 1);

  //     state = AsyncValue.data(PaginatedDoctorsResponse(
  //       doctors: response.doctors,
  //       currentPage: response.currentPage,
  //       lastPage: response.lastPage,
  //       nextPageUrl: response.nextPageUrl,
  //     ));
  //   } on DioException catch (e) {
  //     state = AsyncValue.error(e.dioMessage, StackTrace.current);
  //   } catch (e) {
  //     log(e.toString());
  //     state = AsyncValue.error(e.toString(), StackTrace.current);
  //   }
  // }

  Future<void> fetchInitialDoctors({
    String? searchName,
    String? rankOrder,
    String? availability,
  }) async {
    try {
      _currentSearchQuery = searchName;
      _currentRankOrder = rankOrder;
      _currentAvailability = availability;
      state = const AsyncValue.loading();

      final response = await DoctorService().fetchDoctors(
        page: 1,
        name: searchName,
        rankOrder: rankOrder,
        availability: availability,
      );

      state = AsyncValue.data(PaginatedDoctorsResponse(
        doctors: response.doctors,
        currentPage: response.currentPage,
        lastPage: response.lastPage,
        nextPageUrl: response.nextPageUrl,
      ));
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> fetchMoreDoctors() async {
    if (_currentSearchQuery != null && _currentSearchQuery!.isNotEmpty) return;
    final currentData = state.value?.doctors ?? <Doctor>[];
    final currentPage = (state.value?.currentPage ?? 0) + 1;
    final lastPage = state.value?.lastPage ?? 1;

    if (currentPage > lastPage) return;

    try {
      final response = await DoctorService().fetchDoctors(
        page: currentPage,
        rankOrder: _currentRankOrder,
        availability: _currentAvailability,
      );

      state = AsyncValue.data(PaginatedDoctorsResponse(
        doctors: [...currentData, ...response.doctors],
        currentPage: response.currentPage,
        lastPage: response.lastPage,
        nextPageUrl: response.nextPageUrl,
      ));
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
