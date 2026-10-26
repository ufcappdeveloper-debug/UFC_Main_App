import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/member/farm_member_model.dart';
import '../../infrastructure/data_scourse/members/members_data_source.dart';

class MembersState extends Equatable {
  final List<FarmMemberModel> members;
  final bool loading;
  final String? error;

  const MembersState({this.members = const [], this.loading = false, this.error});

  @override
  List<Object?> get props =>
      [members.map((e) => '${e.id}${e.name}${e.canViewFinance}').join(), loading, error];
}

/// The owner's farm members (list, add, edit, delete).
class MembersCubit extends Cubit<MembersState> {
  final MembersRemoteDataSource dataSource;

  MembersCubit(this.dataSource) : super(const MembersState());

  String _message(Object e) => e.toString().replaceFirst('Exception: ', '');

  Future<void> load() async {
    emit(MembersState(members: state.members, loading: true));
    try {
      emit(MembersState(members: await dataSource.getMembers()));
    } catch (e) {
      emit(MembersState(members: state.members, error: _message(e)));
    }
  }

  /// Returns null on success, else the API message.
  Future<String?> save({
    FarmMemberModel? existing,
    required String name,
    required String phoneNumber,
    String countryCode = '+966',
    String? email,
    required bool canViewFinance,
  }) async {
    try {
      if (existing?.id != null) {
        // The phone can't be edited (delete and add instead).
        await dataSource.editMember(existing!.id!,
            name: name,
            email: (email?.isEmpty ?? true) ? null : email,
            canViewFinance: canViewFinance);
      } else {
        await dataSource.addMember(
          name: name,
          phoneNumber: phoneNumber,
          countryCode: countryCode,
          email: email,
          canViewFinance: canViewFinance,
        );
      }
      return null;
    } catch (e) {
      return _message(e);
    }
  }

  /// Returns null on success, else the API message.
  Future<String?> delete(FarmMemberModel member) async {
    if (member.id == null) return null;
    try {
      await dataSource.deleteMember(member.id!);
      emit(MembersState(
          members: state.members.where((m) => m.id != member.id).toList()));
      return null;
    } catch (e) {
      return _message(e);
    }
  }
}
