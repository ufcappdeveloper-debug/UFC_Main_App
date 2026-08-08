import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';

class SupportService {
  Future<String> createTicket(final data) async {
    Response response = await api.post("api/ufc/v1/support/create", data: data);
    return response.data['message'];
  }
}
