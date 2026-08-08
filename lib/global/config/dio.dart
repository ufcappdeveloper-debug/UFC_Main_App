import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

import 'config.dart';

final _dio = Dio(
  BaseOptions(
    baseUrl: AppConfig.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ),
)..interceptors.addAll([
    AppInterceptor(),
  ]);

Dio get api => _dio;
