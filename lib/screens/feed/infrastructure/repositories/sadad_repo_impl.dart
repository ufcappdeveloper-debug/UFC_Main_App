import 'package:ufc_mobile/screens/feed/domain/entities/checkout/sadad/sadad_user_info.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/sadad_repo.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/checkout/sadad_data_source.dart';

class SadadRepositoryImpl implements SadadRepository {
  final SadadRemoteDataSource remoteDataSource;
  SadadRepositoryImpl(this.remoteDataSource);

  @override
  Future<SadadUserInfo?> getUserInfo() {
    return remoteDataSource.getUserInfo();
  }

  @override
  Future<SadadUserInfo?> updateUserInfo(Map<String, dynamic> data) {
    return remoteDataSource.updateUserInfo(data);
  }
}
