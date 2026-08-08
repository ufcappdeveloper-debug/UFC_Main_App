part of 'get_question_cubit.dart';

sealed class GetQuestionState extends Equatable {
  const GetQuestionState();

  @override
  List<Object> get props => [];
}

final class GetQuestionInitial extends GetQuestionState {}

class QuestionLoading extends GetQuestionState {}

class QuestionLoaded extends GetQuestionState {
  final ReportQuestion question;
  const QuestionLoaded(this.question);

  @override
  List<Object> get props => [question];
}


class QuestionsError extends GetQuestionState {
  final String message;

  const QuestionsError(this.message);

  @override
  List<Object> get props => [message];
}
