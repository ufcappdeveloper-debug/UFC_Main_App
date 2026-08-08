import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/station/station_model.dart';
import '../../domain/entities/station/station_query_model.dart';
import '../../domain/usecases/station_usecase.dart';
import '../../domain/usecases/update_station_usecase.dart';
import '../authentication/auth_cubit.dart';
import 'station_state.dart';

class StationCubit extends Cubit<StationState> {
  final GetStationsUseCase getStationsUseCase;
  final UpdatePreferredShopUseCase updatePreferredShopUseCase;

  StationCubit(
    this.getStationsUseCase,
    this.updatePreferredShopUseCase,
  ) : super(StationInitial());

  Future<void> fetchStations(StationQueryParams params) async {
    emit(StationLoading());
    try {
      final stations = await getStationsUseCase(params);
      emit(StationLoaded(stations));
    } catch (e) {
      emit(StationError(e));
    }
  }

  Future<void> setPreferredShop(
      BuildContext context, StationModel station) async {
    try {
      // API call to update backend preferred shop
      await updatePreferredShopUseCase.call(station.id.toString());

      // ✅ Update AuthCubit with the full station
      context.read<AuthCubit>().updatePreferredShopInUser(station);

      emit(StationSuccess("preferred_shop_update_success".tr()));
    } catch (e) {
      emit(StationError("preferred_shop_update_failed".tr() + ": $e"));
    }
  }
}
