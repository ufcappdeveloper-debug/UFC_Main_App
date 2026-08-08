import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_review_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_timing_model.dart';

abstract class IDoctorService {
  Future<PaginatedDoctorsResponse> fetchDoctors({int page = 1});
  Future<Doctor> fetchDoctorById(int id);
  Future<DoctorTiming> fetchDoctorTiming(int id);
  Future<DoctorReviewResponse> addDoctorReview(DoctorReviewRequest review);
}
