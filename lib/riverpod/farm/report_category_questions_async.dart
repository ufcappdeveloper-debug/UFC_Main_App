import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

import '../../data/farm_reports_service.dart';
import '../../global/shared/functions/dio.dart';
import '../../screens/farm/domain/entities/report_category.dart';

part "report_category_questions_async.g.dart";

@Riverpod(keepAlive: true)
class ReportCategoryQuestions extends _$ReportCategoryQuestions {
  @override
  FutureOr<List<ReportQuestion>?> build() async {
    return null;
  }

  /// Message from the API when the report doesn't apply to the selected
  /// animal (the form and Save are hidden then).
  String? unavailableReason;

  /// The animal the current questions were loaded for.
  String? loadedForAnimalKey;

  Future<void> getQuestions(int id, {String? animalKey}) async {
    state = const AsyncValue.loading();
    try {
      final result =
          await FarmReportsService().getQuestions(id, animalKey: animalKey);
      unavailableReason = result.unavailableReason;
      loadedForAnimalKey = animalKey;
      state = AsyncValue.data(result.questions);
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<String?> addContent(
      {int? reportId,
      int? questionId,
      required String txt,
      int? contentId,
      int? parentId}) async {
    final reportService = FarmReportsService();
    if (reportId == null || questionId == null) {
      return 'Report ID or Question ID is missing';
    }
    try {
      await reportService.addContents(
          categoryId: reportId, questionId: questionId, text: txt);
      ReportQuestion updatedQuestion = await reportService.getContents(
          categoryId: reportId,
          questionId: questionId,
          animalKey: loadedForAnimalKey);
      final currentState = state;
      if (currentState.value != null) {
        final questions = currentState.value!;

        if (contentId != null) {
          final index = questions.indexWhere((q) => q.id == parentId);
          if (index != -1) {
            var qs = questions[index];
            final contentIndex =
                qs.contents?.indexWhere((c) => c.id == contentId);
            if (contentIndex != -1 && contentIndex != null) {
              qs.contents?[contentIndex].followUpQuestion = updatedQuestion;
              state = AsyncValue.data(questions);
            }
          }
        } else {
          final index = questions.indexWhere((q) => q.id == questionId);

          if (index != -1) {
            questions[index] = updatedQuestion;
            state = AsyncValue.data(questions);
          }
        }
      }
      return null;
    } on DioException catch (e) {
      return e.dioMessage;
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  Future<String?> addAnswers(int? reportId, List<Map<String, dynamic>> data,
      String? animalRef, int? barnId,
      {String? animalKey}) async {
    final reportService = FarmReportsService();
    if (reportId == null) return 'Report ID is missing';
    try {
      for (Map<String, dynamic> i in data) {
        i['barn_id'] = barnId;
        i['animal_ref'] = animalRef;
        i['animal_unique_key'] = animalKey;
        if (i.containsKey('followup_id')) {
          i.remove('followup_id');
        }
        var contentKey = i['report_content_key'];
        if (contentKey == 'yes' || contentKey == 'no') {
          i['report_question_content_id'] = null;
        }
        if (contentKey == 'date') {
          final rawDate = i['answer'];
          if (rawDate != null && rawDate is String && rawDate.isNotEmpty) {
            // append dummy time
            i['answer'] = DateTime.tryParse(rawDate).toString();
          }
        }
      }
      await reportService.addAnswers(reportId, data);
      return null;
    } on DioException catch (e) {
      return extractErrorMessage(e.response?.data);
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  Future<String?> addDeath(Map<String, dynamic> data) async {
    try {
      await FarmReportsService().addDeath(data);
      return null;
    } on DioException catch (e) {
      return extractErrorMessage(e.response?.data);
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  void clearQuestions() {
    unavailableReason = null;
    loadedForAnimalKey = null;
    state = AsyncValue.data(null);
  }
}
