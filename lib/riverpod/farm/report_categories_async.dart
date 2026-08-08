import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

import '../../data/farm_reports_service.dart';
import '../../screens/farm/domain/entities/report_category.dart';

part "report_categories_async.g.dart";

@Riverpod(keepAlive: true)
class ReportCategoriesAsync extends _$ReportCategoriesAsync {
  @override
  FutureOr<List<ReportCategory>?> build() async {
    return null;
  }

  Future<void> getReportCategories() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await FarmReportsService().getReportCategories());
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
