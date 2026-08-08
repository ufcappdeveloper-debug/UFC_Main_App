import 'package:ufc_mobile/screens/farm/domain/entities/barn/barn_details_res_model.dart';

abstract class BarnRemoteDataSource {
  Future<BarnDetailsModelRes> fetchBarnDetails(int barnId, Map<String, dynamic> param);
  Future<void> updateFeedQuantity(int barnId, int feedQuantity);
}
