import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/survey_service.dart';
import 'package:ufc_mobile/models/survey/save_quest_model.dart';
import 'package:ufc_mobile/models/survey/save_quest_resp_model.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';
part 'save_ques_ans_async_riverpod.g.dart';

@Riverpod(keepAlive: true)
class SurveyAsync extends _$SurveyAsync {
  @override
  FutureOr<SaveQuestResponseMOdel?> build() async {
    return null;
  }

  Future<void> saveQuestion(SaveSurveyQuestionModel answer) async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(
        await ServeyService().postQuestionAnswers(answer),
      );
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
      rethrow;
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      rethrow;
    }
  }
}
