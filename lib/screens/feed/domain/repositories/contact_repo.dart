

import '../entities/contact/support_model.dart';

abstract class SupportRepository {
  Future<String> createSupport(SupportRequest request);
}
