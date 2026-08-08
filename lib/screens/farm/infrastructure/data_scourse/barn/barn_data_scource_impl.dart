import 'package:dio/dio.dart';
import 'package:ufc_mobile/data/barn_service.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/barn/barn_details_res_model.dart';
import 'package:ufc_mobile/screens/farm/infrastructure/data_scourse/barn/barn_data_sourse.dart';

import '../../../../../global/shared/functions/dio.dart';
import '../../../../feed/domain/failure/failure.dart';

class BarnRemoteDataSourceImpl implements BarnRemoteDataSource {
  BarnRemoteDataSourceImpl();

  @override
  Future<BarnDetailsModelRes> fetchBarnDetails(int barnId, Map<String, dynamic> param) async {
    try {
      final response =
          await FarmDio.api.get('/api/ufc-farm/v1/user/barns/$barnId/details', queryParameters: param);

      if (response.statusCode == 200) {
        return BarnDetailsModelRes.fromJson(response.data);
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

  @override
  Future<void> updateFeedQuantity(int barnId, int feedQuantity) async {
    try {
      await FarmDio.api.post('/api/ufc-farm/v1/user/barns/$barnId/quantity',
          data: {"feed_quantity": feedQuantity});
    } on DioException catch (e) {
      throw NetworkFailure(extractErrorMessage(e.response?.data));
    } catch (e) {
      throw UnexpectedFailure("Unexpected error: ${e.toString()}");
    }
  }
}
