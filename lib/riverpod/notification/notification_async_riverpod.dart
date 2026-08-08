import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/notification_service.dart';
import 'package:ufc_mobile/models/notification_model.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

part "notification_async_riverpod.g.dart";

@Riverpod(keepAlive: true)
class NotificationAsync extends _$NotificationAsync {
  @override
  FutureOr<List<NotificationModel>?> build() async {
    return null;
  }

  Future<void> getNotifications({String? category}) async {
    state = const AsyncValue.loading();
    final Map<String, dynamic> data = {
      "page": 1,
      "limit": 10,
      "category": category
    };
    try {
      List<NotificationModel> result =
          await NotificationService().getNotifications(data);

      state = AsyncValue.data(result);
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<String?> loadNotifications(final int page) async {
    final Map<String, dynamic> data = {
      "page": page,
      "limit": 10,
    };
    try {
      List<NotificationModel> result =
          await NotificationService().getNotifications(data);
      if (result.isEmpty) {
        return "empty";
      }

      state.value?.addAll(result);
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
    return null;
  }
}
