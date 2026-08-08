import 'package:ufc_mobile/main.dart';

class CommunityTermsService {
  static const _prefix = "channel_terms_";

  /// Check if user already agreed for a given channel
  static Future<bool> hasAgreed(String channelId) async {
    return preferences.getBool("$_prefix$channelId") ?? false;
  }

  /// Save agreement for a channel
  static Future<void> setAgreed(String channelId) async {
    await preferences.setBool("$_prefix$channelId", true);
  }
}
