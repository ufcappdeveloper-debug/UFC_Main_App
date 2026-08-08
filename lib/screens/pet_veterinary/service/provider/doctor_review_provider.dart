import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/doctor_service.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_review_model.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

part 'doctor_review_provider.g.dart';

@Riverpod(keepAlive: true)
class DoctorReviewProvider extends _$DoctorReviewProvider {
  @override
  FutureOr<DoctorReviewResponse?> build() async {
    return null; // initial state: no review submitted yet
  }

  Future<void> submitReview(DoctorReviewRequest review) async {
    state = const AsyncValue.loading();

    try {
      final response = await DoctorService().addDoctorReview(review);
      state = AsyncValue.data(response);
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
