

import '../entities/station/station_model.dart';
import '../entities/station/station_query_model.dart';
import '../repositories/station_repo.dart';

class GetStationsUseCase {
  final StationRepository repository;

  GetStationsUseCase(this.repository);

  Future<List<StationModel>> call(StationQueryParams params) {
    return repository.getStations(params);
  }
}
