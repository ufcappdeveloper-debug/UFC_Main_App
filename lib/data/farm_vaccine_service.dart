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

  Future<void> addVaccine(VaccineParam data) async {
    log('addVaccine data: ${data.toJson()}');
    await FarmDio.api
        .post("/api/ufc-farm/v1/user/vaccine/animals/add", data: data.toJson());
  }
}
