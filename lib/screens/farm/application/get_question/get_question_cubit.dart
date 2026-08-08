import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/screens/farm/domain/usecase/edit_answer_usecase.dart';

import '../../../feed/domain/failure/failure.dart';
import '../../domain/entities/report_category.dart';
import '../../domain/usecase/delete_answer.dart';
import '../../domain/usecase/delete_death_usecase.dart';
import '../../domain/usecase/delete_vaccine_usecase.dart';
import '../../domain/usecase/edit_vaccine_usecase.dart';
import '../../domain/usecase/get_question_usecase.dart';
import '../../domain/usecase/update_death_usecase.dart';

part 'get_question_state.dart';

class GetQuestionCubit extends Cubit<GetQuestionState> {
  final GetQuestionUsecase getQuestionUsecase;
  final EditAnswerUsecase editAnswerUsecase;
  final DeleteAnswer deleteAnswer;
  final EditVaccineUsecase editVaccineUsecase;
  final DeleteVaccineUsecase deleteVaccineUsecase;
  final DeleteDeathUseCase deleteDeathUseCase;
  final UpdateDeathUsecase updateDeathUsecase;
  GetQuestionCubit(this.getQuestionUsecase, this.editAnswerUsecase, this.deleteAnswer, this.editVaccineUsecase, this.deleteVaccineUsecase, this.deleteDeathUseCase, this.updateDeathUsecase) : super(GetQuestionInitial());

  Future<void> getQuestion(int reportId, int questionId) async {
    emit(QuestionLoading());
    try {
      final question = await getQuestionUsecase(reportId, questionId);
      emit(QuestionLoaded(question));
    } catch (e) {
      if (e is UnexpectedFailure) {
        emit(QuestionsError(e.message.toString()));
      } else {
        emit(QuestionsError(e.toString()));
      }
      rethrow;
    }
  }


  Future<String?> editAnswer(Map<String, dynamic> param, int answerId) async {
    try {
      await editAnswerUsecase(param, answerId);
      return null;
    } catch (e) {
      if (e is UnexpectedFailure) {
        return e.message.toString();
      }
      return e.toString();
    }
  }


  Future<String?> deleteAnswers(int answerId) async {
    try {
      await deleteAnswer(answerId);
      return null;
    } catch (e) {
      if (e is UnexpectedFailure) {
        return e.message.toString();
      }
      return e.toString();
    }
  }


  Future<String?> editVaccine(Map<String, dynamic> param) async {
    try {
      await editVaccineUsecase(param);
      return null;
    } catch (e) {
      if (e is UnexpectedFailure) {
        return e.message.toString();
      }
      return e.toString();
    }
  }


  Future<String?> deleteVaccine(int id) async {
    try {
      await deleteVaccineUsecase(id);
      return null;
    } catch (e) {
      if (e is UnexpectedFailure) {
        return e.message.toString();
      }
      return e.toString();
    }
  }


  Future<String?> deleteDeath(int id) async {
    try {
      await deleteDeathUseCase(id);
      return null;
    } catch (e) {
      if (e is UnexpectedFailure) {
        return e.message.toString();
      }
      return e.toString();
    }
  }


  Future<String?> updateDeath(Map<String, dynamic> param, int answerId) async {
    try {
      await updateDeathUsecase(param, answerId);
      return null;
    } catch (e) {
      if (e is UnexpectedFailure) {
        return e.message.toString();
      }
      return e.toString();
    }
  }


}
