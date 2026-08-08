import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ufc_mobile/global/util/exception/app_exception.dart';

class DioUtils {
  /// Handles Dio exceptions by throwing user-friendly error messages based on the exception type.
  /// [error] - The DioException to handle.
  static void handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        throw CustomException(message: 'connection_timeout'.tr());
      case DioExceptionType.sendTimeout:
        throw CustomException(message: 'send_timeout'.tr());
      case DioExceptionType.receiveTimeout:
        throw CustomException(message: 'receive_timeout'.tr());
      case DioExceptionType.badResponse:
        throw CustomException(message: 'bad_response'.tr());
      case DioExceptionType.cancel:
        throw CustomException(message: 'cancelled'.tr());
      case DioExceptionType.connectionError:
        throw CustomException(message: 'connection_error'.tr());
      case DioExceptionType.unknown:
      default:
        throw CustomException(message: 'something_wrong'.tr());
    }
  }
}
