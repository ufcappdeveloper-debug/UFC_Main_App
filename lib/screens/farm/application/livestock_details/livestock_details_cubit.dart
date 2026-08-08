import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/livestock/live_stock_details_model.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/livestock/livestock_reports_model.dart';
import 'package:ufc_mobile/screens/farm/domain/usecase/livestock_details_usecase.dart';
import 'package:ufc_mobile/screens/farm/domain/usecase/livestock_reports_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/failure/failure.dart';

import '../../../feed/domain/entities/app_setting/app_settings_model.dart';
import '../../../feed/domain/usecases/app_setting_usecase.dart';
import '../../domain/usecase/delete_livestock_usecase.dart';

part 'livestock_details_state.dart';

class LiveStockDetailsCubit extends Cubit<LiveStockDetailsState> {
  final GetLiveStockDetailsUseCase detailsUseCase;
  final GetLiveSTockReportUseCase reportUseCase;
  final DeleteLivestockUsecase deleteLivestockUsecase;
  final GetAppSettingUseCase getAppSettingUseCase;
  LiveStockDetailsCubit(this.detailsUseCase, this.reportUseCase,
      this.deleteLivestockUsecase, this.getAppSettingUseCase)
      : super(LiveStockDetailsInitial());

  Future<void> getLivestockDetails(String animalRefId) async {
    emit(LiveStockDetailsLoading());
    try {
      final livestockDetails = await detailsUseCase(animalRefId);

      final value = await getLiveStockReports(animalRefId);
      final appSettings = await reportsKeyAndValue();
      emit(LiveStockDetailsLoaded(livestockDetails.data, value, appSettings));
    } catch (e) {
      emit(LiveStockDetailsError(e.toString()));
      rethrow;
    }
  }

  Future<ReportResponse> getLiveStockReports(String animalRefId) async {
    try {
      final livestockReportModel = await reportUseCase(animalRefId);
      return livestockReportModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AppSettingsKeyAndValue>> reportsKeyAndValue() async {
    try {
      final appSetting = await getAppSettingUseCase();
      return appSetting?.keyAndValues ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> deleteLivestock(String key) async {
    try {
      await deleteLivestockUsecase(key);
      return null;
    } catch (e) {
      if (e is UnexpectedFailure) {
        return e.message.toString();
      }
      return e.toString();
    }
  }
}
