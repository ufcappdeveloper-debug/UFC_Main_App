import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/dashboard/analytics_filter_model.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/dashboard/dashboard_resp_model.dart';
import 'package:ufc_mobile/screens/farm/domain/usecase/dashboard_usecase.dart';

part 'dashboard_state.dart';

class FarmDashboardCubit extends Cubit<DashboardState> {
  final GetDashboardDataUseCase getDashboardDataUseCase;
  FarmDashboardCubit(this.getDashboardDataUseCase) : super(DashboardInitial());
  DashboardResponseModel? dashboard;
  AnalyticsFilterModel? filter;
  Future<void> getDashboardDetails({bool hideLoading = false}) async {
    if (!hideLoading) {
      emit(DashboardLoading());
    }
    try {
      final barn = await getDashboardDataUseCase.call(
          filterKey: filter?.key != 'all' ? filter?.key : null);
      dashboard = barn;
      emit(DashboardLoaded(barn));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  void updateFilter(AnalyticsFilterModel? value) async {
    if (value == null) return;
    filter = value;
    await getDashboardDetails(hideLoading: true);
  }

  void clearFilter() async {
    filter = null;
    await getDashboardDetails(hideLoading: true);
  }
}
