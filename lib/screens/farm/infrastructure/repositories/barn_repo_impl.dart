import 'package:ufc_mobile/screens/farm/domain/entities/barn/barn_details_res_model.dart';
import 'package:ufc_mobile/screens/farm/domain/repositories/barn_repo.dart';
import 'package:ufc_mobile/screens/farm/infrastructure/data_scourse/barn/barn_data_sourse.dart';

class BarnRepositoryImpl implements BarnRepository {
  final BarnRemoteDataSource remoteDataSource;

  BarnRepositoryImpl(this.remoteDataSource);

  @override
  Future<BarnDetailsModelRes> getBarnDetails(int barnId, Map<String, dynamic> param) async {
    final barnModel = await remoteDataSource.fetchBarnDetails(barnId, param);
    return barnModel;
  }

  @override
  Future<void> updateFeedQuantity(int barnId, int feedQuantity) async {
    await remoteDataSource.updateFeedQuantity(barnId, feedQuantity);
  }
}
