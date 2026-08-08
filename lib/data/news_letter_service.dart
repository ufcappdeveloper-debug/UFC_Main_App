import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import '../global/config/dio.dart';

class NewsLetterService {
  Future<void> updateNewsLetter(final data) async {
    Response response =
        await api.post("api/ufc/v1/update_newsletter", data: data);
    debugPrint(response.data);
  }
}
