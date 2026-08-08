import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_review_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_timing_model.dart';

class DoctorService {
  Future<PaginatedDoctorsResponse> fetchDoctors({
    int page = 1,
    String? name,
    String? rankOrder,
    String? availability,
  }) async {
    final queryParams = <String, dynamic>{};

    if (name != null && name.isNotEmpty) {
      queryParams['name'] = name;
    } else {
      queryParams['page'] = page;
    }

    if (rankOrder != null && rankOrder.isNotEmpty) {
      queryParams['rank_order'] = rankOrder;
    }

    if (availability != null && availability.isNotEmpty) {
      queryParams['availability'] = availability.toLowerCase();
    }

    final response = await api.get(
      "/api/ufc/v1/doctor/get_doctors",
      queryParameters: queryParams,
    );

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      if (response.data is Map<String, dynamic>) {
        return PaginatedDoctorsResponse.fromJson(response.data['data']);
      } else {
        throw Exception("Invalid response format");
      }
    } else {
      throw Exception("Failed to fetch doctors: ${response.statusMessage}");
    }
  }

  Future<Doctor> fetchDoctorById(int id) async {
    final response = await api.get("/api/ufc/v1/doctor/get_doctor/$id");

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return Doctor.fromJson(response.data);
    } else {
      throw Exception("Failed to fetch doctor: ${response.statusMessage}");
    }
  }

  Future<DoctorTiming> fetchDoctorTiming(int id) async {
    final response = await api.get("/api/ufc/v1/doctor/get_doctor_timing/$id");

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return DoctorTiming.fromJson(response.data);
    } else {
      throw Exception(
          "Failed to fetch doctor timings: ${response.statusMessage}");
    }
  }

  Future<DoctorReviewResponse> addDoctorReview(
      DoctorReviewRequest review) async {
    final response = await api.post(
      "/api/ufc/v1/doctor/add_doctor_review",
      data: review.toJson(),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return DoctorReviewResponse.fromJson(response.data['data']);
    } else {
      throw Exception("Failed to add review: ${response.statusMessage}");
    }
  }
}
