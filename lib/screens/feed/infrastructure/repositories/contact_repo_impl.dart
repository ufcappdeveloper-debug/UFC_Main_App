
import '../../domain/entities/contact/support_model.dart';
import '../../domain/repositories/contact_repo.dart';
import '../data_sources/contact_data_souce.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDataSource remoteDataSource;

  SupportRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> createSupport(SupportRequest request) {
    return remoteDataSource.createSupport(request);
  }
}
