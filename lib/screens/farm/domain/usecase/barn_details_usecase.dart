import 'package:ufc_mobile/screens/farm/domain/entities/barn/barn_details_res_model.dart';
import 'package:ufc_mobile/screens/farm/domain/repositories/barn_repo.dart';

class GetBarnDetailsUseCase {
  final BarnRepository repository;

  GetBarnDetailsUseCase(this.repository);

  Future<BarnDetailsModelRes> call(int barnId, Map<String, dynamic> param) {
    return repository.getBarnDetails(barnId, param);
  }
}
