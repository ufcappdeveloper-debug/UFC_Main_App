import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/homepage_service.dart';
import 'package:ufc_mobile/models/home_model.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

part "home_async_riverpod.g.dart";

@Riverpod(keepAlive: true)
class HomeAsync extends _$HomeAsync {
  @override
  FutureOr<HomeModel?> build() async {
    return null;
  }

  Future<void> getHomepage() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await HomePageService().getHomePage(1, 10));
      log(state.toString());
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
