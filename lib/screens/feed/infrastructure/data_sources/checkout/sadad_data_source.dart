import 'package:ufc_mobile/screens/feed/domain/entities/checkout/sadad/sadad_user_info.dart';

abstract class SadadRemoteDataSource {
  Future<SadadUserInfo?> getUserInfo();
  Future<SadadUserInfo?> updateUserInfo(Map<String, dynamic> data);
}
