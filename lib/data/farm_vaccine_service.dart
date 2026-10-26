import 'dart:developer';

import 'package:dio/dio.dart';

import '../screens/farm/domain/entities/barn/vaccine_model.dart';
import 'farm_reports_service.dart';

class FarmVaccineService {
  Future<List<VaccineModel>> getVaccinTypes() async {
    Response response =
        await FarmDio.api.get("/api/ufc-farm/v1/user/vaccine/types");
    return (response.data["data"] as List<dynamic>)
        .map((data) => VaccineModel.fromJson(data))
        .toList();
  }

  /// Returns how many records were added and skipped. Animals not born yet,
  /// already dead or already vaccinated that day are skipped by the API.
  Future<({int? added, int skipped})> addVaccine(VaccineParam data) async {
    log('addVaccine data: ${data.toJson()}');
    final response = await FarmDio.api
        .post("/api/ufc-farm/v1/user/vaccine/animals/add", data: data.toJson());
    final body = response.data is Map ? response.data['data'] : null;
    int? toInt(dynamic v) => v is int ? v : int.tryParse('${v ?? ''}');
    return (
      added: body is Map
          ? toInt(body['num_records_added'] ?? body['num_records'])
          : null,
      skipped: body is Map ? toInt(body['num_records_skipped']) ?? 0 : 0,
    );
  }
}
