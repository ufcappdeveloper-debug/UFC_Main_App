import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/config/farm_session.dart';

import '../../domain/entities/member/farm_member_model.dart';
import '../../infrastructure/data_scourse/members/members_data_source.dart';

class FarmAccountState extends Equatable {
  /// Farms the user is a member of. Empty = owner only, no switcher.
  final List<MemberAccountModel> accounts;

  /// Owner of the farm being worked on; null = "My farm".
  final int? ownerId;

  /// Set when access to the selected farm was revoked (403).
  final String? revokedMessage;
  final int eventId;

  const FarmAccountState({
    this.accounts = const [],
    this.ownerId,
    this.revokedMessage,
    this.eventId = 0,
  });

  bool get isOnOwnerFarm => ownerId != null;

  MemberAccountModel? get selected =>
      accounts.where((a) => a.ownerUserId == ownerId).firstOrNull;

  /// Finance screens are shown on the own farm, or when allowed for the
  /// selected farm.
  bool get canViewFinance =>
      !isOnOwnerFarm ||
      (selected?.canViewFinance ??
          (FarmSession.account?['can_view_finance'] == true));

  @override
  List<Object?> get props =>
      [accounts.map((e) => e.ownerUserId).join(','), ownerId, eventId];
}

/// Farm switcher for members: "My farm" or an owner's farm.
class FarmAccountCubit extends Cubit<FarmAccountState> {
  final MembersRemoteDataSource dataSource;
  StreamSubscription<String>? _revokedSub;

  FarmAccountCubit(this.dataSource)
      : super(FarmAccountState(ownerId: FarmSession.ownerId)) {
    _revokedSub = FarmSession.onAccessRevoked.listen((message) {
      emit(FarmAccountState(
        accounts: state.accounts,
        ownerId: null,
        revokedMessage: message,
        eventId: state.eventId + 1,
      ));
      loadAccounts();
    });
  }

  Future<void> loadAccounts() async {
    try {
      final accounts = await dataSource.getAccounts();
      var ownerId = FarmSession.ownerId;
      // The selected farm is no longer in the list: back to "My farm".
      if (ownerId != null && !accounts.any((a) => a.ownerUserId == ownerId)) {
        await FarmSession.clear();
        ownerId = null;
      }
      emit(FarmAccountState(
          accounts: accounts, ownerId: ownerId, eventId: state.eventId));
    } catch (_) {
      // Keep the current selection when offline.
    }
  }

  /// Pass null for "My farm".
  Future<void> select(MemberAccountModel? account) async {
    if (account?.ownerUserId == null) {
      await FarmSession.clear();
    } else {
      await FarmSession.select(account!.ownerUserId!, account.toJson());
    }
    emit(FarmAccountState(
        accounts: state.accounts,
        ownerId: FarmSession.ownerId,
        eventId: state.eventId));
  }

  Future<void> reset() async {
    await FarmSession.clear();
    emit(const FarmAccountState());
  }

  @override
  Future<void> close() {
    _revokedSub?.cancel();
    return super.close();
  }
}
