// data/data_sources/station_remote_data_source.dart
import '../../domain/entities/station/station_model.dart';

abstract class StationRemoteDataSource {
  Future<List<StationModel>> getStations(Map<String, dynamic> params);
  Future<void> updatePreferredShop(String shopId);
}
