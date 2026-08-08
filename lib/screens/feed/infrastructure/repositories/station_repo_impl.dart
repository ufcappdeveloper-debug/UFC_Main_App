// data/repositories/station_repository_impl.dart
import 'package:dio/dio.dart';
import '../../domain/entities/station/station_model.dart';
import '../../domain/entities/station/station_query_model.dart';
import '../../domain/failure/failure.dart';
import '../../domain/repositories/station_repo.dart';
import '../data_sources/station_data_source.dart';

class StationRepositoryImpl implements StationRepository {
  final StationRemoteDataSource remoteDataSource;

  StationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<StationModel>> getStations(StationQueryParams params) async {
    try {
      final result = await remoteDataSource.getStations(params.toJson());
      return result;
    } catch (e) {
      rethrow;
    }
  }

  /// ✅ New method: Update Preferred Shop
  Future<void> updatePreferredShop(String shopId) async {
    try {
      await remoteDataSource.updatePreferredShop(shopId);
    } catch (e) {
      rethrow;
    }
  }
}
