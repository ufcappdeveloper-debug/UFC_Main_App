import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/station/station_model.dart';

class StationService {
  Future<List<StationModel>> getStations(final data) async {
    final Response response =
        await api.get('/api/ufc/v1/get_shops', data: data);
    return (response.data["data"]["data"] as List<dynamic>)
        .map((data) => StationModel.fromJson(data))
        .toList();
  }

  Future<List<StationModel>> getNearbyStations(final data) async {
    final Response response = await api.get(
        '/api/ufc/v1/get_shops_nearby?page=1&limit=20&latitude=${data["lat"]}&longitude=${data["long"]}');
    return (response.data["data"]["data"] as List<dynamic>)
        .map((data) => StationModel.fromJson(data))
        .toList();
  }
}
