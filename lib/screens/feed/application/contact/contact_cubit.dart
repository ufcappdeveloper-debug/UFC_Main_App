import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/contact/support_model.dart';
import '../../domain/repositories/contact_repo.dart';
import 'contact_state.dart';

class SupportCubit extends Cubit<SupportState> {
  final SupportRepository repository;

  SupportCubit(this.repository) : super(SupportInitial());

  Future<void> createSupport(SupportRequest request) async {
    emit(SupportLoading());

    try {
      final message = await repository.createSupport(request);
      emit(SupportSuccess(message));
    } catch (e) {
      emit(SupportError(e));
    }
  }
}
