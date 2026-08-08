import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/global/shared/functions/dio.dart';
import 'package:ufc_mobile/screens/feed/domain/failure/failure.dart';

import '../../../../global/config/config.dart';
import '../../domain/entities/contact/support_model.dart';
import 'contact_data_souce.dart';

class SupportRemoteDataSourceImpl implements SupportRemoteDataSource {
  final Dio dio;

  SupportRemoteDataSourceImpl(this.dio);

  @override
  Future<String> createSupport(SupportRequest request) async {
    try {
      final response = await api.post(
        "/api/ufc/v1/support/create",
        data: request.toJson(),
        options: Options(
          headers: {
            "Authorization": "Bearer ${AppConfig.token}",
          },
        ),
      );

      return response.data['message'] ?? "Success";
    } catch (e) {
      rethrow;
    }
    // } on DioException catch (e) {
    //   throw UnexpectedFailure(extractErrorMessage(e.response?.data));
    // } catch (e) {
    //   throw Exception('Unexpected error: $e');
    // }
  }
}
