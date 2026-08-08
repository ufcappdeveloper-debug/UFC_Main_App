import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/data/barn_service.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/dashboard/dashboard_resp_model.dart';
import 'package:ufc_mobile/screens/farm/infrastructure/data_scourse/dashboard/dashboard_datasource.dart';

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl();

  @override
  Future<DashboardResponseModel> getDashboardDetails({
    String? filterKey,
  }) async {
    try {
      final response = await FarmDio.api
          .get('/api/ufc-farm/v1/user/analytics2', queryParameters: {
        if (!isStringEmpty(filterKey)) ...{
          "filter_key": filterKey,
        },
      });

      if (response.statusCode == 200) {
        debugPrint('DashboardResponseModel: ${response.data['data']}');
        return DashboardResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load barn details');
      }
    } on DioException catch (e) {
      // Convert DioError to your custom Failure or simply throw
      throw Exception(e.error);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
