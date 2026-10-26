import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/farm_dio.dart';
import 'package:ufc_mobile/global/shared/functions/dio.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

import '../../../domain/entities/member/farm_member_model.dart';

/// Farm members (`/api/ufc-farm/v1/user/members`). These always act as the
/// logged-in user; `X-Owner-Id` is never sent here.
abstract class MembersRemoteDataSource {
  Future<List<FarmMemberModel>> getMembers();
  Future<FarmMemberModel> addMember({
    required String name,
    required String phoneNumber,
    String countryCode = '+966',
    String? email,
    bool canViewFinance = false,
  });
  Future<FarmMemberModel> editMember(
    int id, {
    String? name,
    String? email,
    bool? canViewFinance,
  });
  Future<void> deleteMember(int id);
  Future<List<MemberAccountModel>> getAccounts();
}

class MembersRemoteDataSourceImpl implements MembersRemoteDataSource {
  static const _base = '/api/ufc-farm/v1/user/members';

  Dio get _dio => FarmDio.api;

  /// Farm errors are `{ message, data: { field: ["Arabic - English"] } }`.
  Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      final data = e.response?.data;
      throw Exception(data is Map<String, dynamic>
          ? extractErrorMessage(data)
          : e.dioMessage);
    }
  }

  List<T> _list<T>(dynamic data, T Function(Map<String, dynamic>) parse) =>
      data is List ? data.whereType<Map<String, dynamic>>().map(parse).toList() : <T>[];

  @override
  Future<List<FarmMemberModel>> getMembers() => _guard(() async {
        final response = await _dio.get(_base);
        return _list(response.data['data'], FarmMemberModel.fromJson);
      });

  @override
  Future<FarmMemberModel> addMember({
    required String name,
    required String phoneNumber,
    String countryCode = '+966',
    String? email,
    bool canViewFinance = false,
  }) =>
      _guard(() async {
        final response = await _dio.post(_base, data: {
          'name': name,
          'phone_number': phoneNumber,
          'country_code': countryCode,
          if (email != null && email.isNotEmpty) 'email': email,
          'can_view_finance': canViewFinance,
        });
        return FarmMemberModel.fromJson(response.data['data']);
      });

  @override
  Future<FarmMemberModel> editMember(
    int id, {
    String? name,
    String? email,
    bool? canViewFinance,
  }) =>
      _guard(() async {
        final response = await _dio.post('$_base/$id/edit', data: {
          if (name != null) 'name': name,
          if (email != null) 'email': email,
          if (canViewFinance != null) 'can_view_finance': canViewFinance,
        });
        return FarmMemberModel.fromJson(response.data['data']);
      });

  @override
  Future<void> deleteMember(int id) => _guard(() async {
        await _dio.delete('$_base/$id');
      });

  @override
  Future<List<MemberAccountModel>> getAccounts() => _guard(() async {
        final response = await _dio.get('$_base/accounts');
        return _list(response.data['data'], MemberAccountModel.fromJson);
      });
}
