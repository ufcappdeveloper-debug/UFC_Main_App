import 'dart:async';
import 'dart:convert';

import 'package:ufc_mobile/main.dart';

/// Which farm the user is working on. A farm member works on an owner's
/// farm by sending `X-Owner-Id` on farm requests; null = the user's own farm.
/// Read synchronously by [AppInterceptor], so it lives outside any cubit.
class FarmSession {
  static const _ownerKey = 'farm_owner_id';
  static const _accountKey = 'farm_owner_account';

  static int? _ownerId;
  static Map<String, dynamic>? _account;

  static final _revoked = StreamController<String>.broadcast();

  /// Owner user id of the selected farm, or null for "My farm".
  static int? get ownerId {
    _restore();
    return _ownerId;
  }

  /// The selected membership (role, permissions, can_view_finance).
  static Map<String, dynamic>? get account {
    _restore();
    return _account;
  }

  static bool get isOnOwnerFarm => ownerId != null;

  /// Emits the API message when access to the selected farm is refused
  /// (403): the member was removed. The selection is already reset then.
  static Stream<String> get onAccessRevoked => _revoked.stream;

  static bool _restored = false;
  static void _restore() {
    if (_restored) return;
    _restored = true;
    try {
      _ownerId = preferences.getInt(_ownerKey);
      final raw = preferences.getString(_accountKey);
      _account = raw == null ? null : jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      _ownerId = null;
      _account = null;
    }
  }

  static Future<void> select(int ownerId, Map<String, dynamic> account) async {
    _restored = true;
    _ownerId = ownerId;
    _account = account;
    await preferences.setInt(_ownerKey, ownerId);
    await preferences.setString(_accountKey, jsonEncode(account));
  }

  static Future<void> clear() async {
    _restored = true;
    _ownerId = null;
    _account = null;
    await preferences.remove(_ownerKey);
    await preferences.remove(_accountKey);
  }

  static void reportAccessRevoked(String message) {
    clear();
    _revoked.add(message);
  }

  /// Farm requests that should carry `X-Owner-Id`. The members endpoints
  /// always act as the logged-in user.
  static bool appliesTo(String path) =>
      path.contains('/api/ufc-farm/') &&
      !path.contains('/api/ufc-farm/v1/user/members');
}
