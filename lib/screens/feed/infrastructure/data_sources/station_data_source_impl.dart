import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/station_data_source.dart';
import '../../domain/entities/station/station_model.dart';
import '../../domain/failure/failure.dart';

class StationRemoteDataSourceImpl implements StationRemoteDataSource {
  final Dio dio;

  StationRemoteDataSourceImpl(this.dio);

  @override
  Future<List<StationModel>> getStations(Map<String, dynamic> params) async {
    debugPrint(
        "📡 [StationRemoteDataSource] Fetching stations with params: $params");

    try {
      final response = await api.get(
        "/api/ufc/v1/get_shops",
        queryParameters: params,
      );

      debugPrint(
          "✅ [StationRemoteDataSource] Response (${response.statusCode}): ${response.data}");

      if (response.statusCode == 200) {
        if (response.data is Map &&
            response.data["data"] is Map &&
            response.data["data"]["data"] is List) {
          final list = response.data["data"]["data"] as List;
          final stations =
              list.map((json) => StationModel.fromJson(json)).toList();
          debugPrint(
              "📦 [StationRemoteDataSource] Parsed ${stations.length} stations from 'data.data'");
          return stations;
        } else {
          debugPrint(
              "❌ [StationRemoteDataSource] Unexpected response format: ${response.data}");
          throw Exception("Unexpected response format");
        }
      } else {
        throw Exception("Failed to load stations");
      }
    } catch (e, stack) {
      debugPrint("💥 [StationRemoteDataSource] Exception: $e");
      debugPrint("📜 StackTrace: $stack");
      rethrow;
    }
  }

  @override
  Future<void> updatePreferredShop(String shopId) async {
   // debugPrint("📡 Updating preferred shop: $shopId");
    try {
      final response = await api.post(
        "/api/ufc/v1/update_preferred_shop",
        data: {"shop": shopId},
      );
      if (response.statusCode == 200) {
        //debugPrint("✅ Preferred shop updated: ${response.data}");
      } else {
        throw ServerFailure(
          "Server error: ${response.statusCode} - ${response.statusMessage}",
        );
      }
      // } on DioException catch (e) {
      //   debugPrint("❌ Dio error: ${e.response?.data}");
      //   throw NetworkFailure(
      //     e.response?.data.toString() ?? "Network error occurred",
      //   );
    } catch (e) {
      rethrow;
    }
  }
}
