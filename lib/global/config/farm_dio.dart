import 'package:dio/dio.dart';

import '../util/dio/dio_intrepters.dart';
import 'config.dart';

class FarmDio {
  static final Dio farmDio = Dio(
    BaseOptions(
      baseUrl: AppConfig.farmBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  )..interceptors.add(AppInterceptor());

  static Dio get api => farmDio;
}
