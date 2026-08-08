import 'package:ufc_mobile/main.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/global/util/storage/local_storage.dart';

class AppStorage {
  static Future<bool> get clearStorage async => await preferences.clear();

  /*  Start - Auth Token Storage Management */
  static Future<bool> setToken(String? value) async {
    return !isStringEmpty(value)
        ? await preferences.setString(LocalStorage.token, value ?? '')
        : await removeToken;
  }

  static String? get getToken => preferences.getString(LocalStorage.token);

  static Future<bool> get removeToken async =>
      await preferences.remove(LocalStorage.token);

  /*  End - Auth Token Storage Management */
}
