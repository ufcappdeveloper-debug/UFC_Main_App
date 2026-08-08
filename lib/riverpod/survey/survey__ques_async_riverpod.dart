import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/survey_service.dart';
import 'package:ufc_mobile/models/survey/survey_quest_res_model.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';
part 'survey__ques_async_riverpod.g.dart';

@Riverpod(keepAlive: true)
class GetSurveyQuestionsAsync extends _$GetSurveyQuestionsAsync {
  @override
  FutureOr<SurveyQuestionsResModel?> build() async {
    return null;
  }

  Future<void> getSurveyQuestions() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await ServeyService().getQuestions());
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
