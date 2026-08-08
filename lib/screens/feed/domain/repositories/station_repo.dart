
import '../entities/station/station_model.dart';
import '../entities/station/station_query_model.dart';


abstract class StationRepository {
  Future<List<StationModel>> getStations(StationQueryParams params);

  /// ✅ New: update preferred shop
  Future<void> updatePreferredShop(String shopId);
}
