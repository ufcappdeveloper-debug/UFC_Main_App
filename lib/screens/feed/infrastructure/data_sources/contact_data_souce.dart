


import '../../domain/entities/contact/support_model.dart';

abstract class SupportRemoteDataSource {
  Future<String> createSupport(SupportRequest request);
}
