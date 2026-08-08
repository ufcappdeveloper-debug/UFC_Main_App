import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/models/survey/save_quest_model.dart';
import 'package:ufc_mobile/models/survey/save_quest_resp_model.dart';
import 'package:ufc_mobile/models/survey/survey_quest_res_model.dart';

class ServeyService {
  Future<SurveyQuestionsResModel?> getQuestions() async {
    Response res = await api.get("/api/ufc/v1/survey/get_order_survey");
    SurveyQuestionsResModel model =
        SurveyQuestionsResModel.fromJson(res.data["data"]);
    return model;
  }

  Future<SaveQuestResponseMOdel?> postQuestionAnswers(
      SaveSurveyQuestionModel questionAnswer) async {
    Response res = await api.post(
      "/api/ufc/v1/survey/submit_answer",
      data: questionAnswer.toJson(),
    );
    SaveQuestResponseMOdel model =
        SaveQuestResponseMOdel.fromJson(res.data["data"]);
    return model;
  }
}
