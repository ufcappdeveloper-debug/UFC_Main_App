import 'package:flutter/foundation.dart';

enum Build { dev, testing, production }

class AppConfig {
  static String? token;
  static final Build server = _getServerFromEnv();

  static Build _getServerFromEnv() {
    const env = String.fromEnvironment('ENV', defaultValue: 'testing');

    switch (env.toLowerCase()) {
      case 'dev':
        return Build.dev;

      case 'testing':
        return Build.testing;

      case 'production':
      default:
        return Build.production;
    }
  }

  static bool get isProduction => server == Build.production;

  static String get chatBaseUrl {
    switch (server) {
      case Build.testing:
        return 'https://node-chat.ufc-app.com';

      case Build.production:
        return 'https://node-chat.ufc-app.com';
      case Build.dev:
        return 'https://node-chat.ufc-app.com';
    }
  }

  static String get baseUrl {
    switch (server) {
      case Build.dev:
        return 'https://api.ufc-app.com/';

      case Build.testing:
        return 'https://api.ufc-app.com/';

      case Build.production:
        return 'https://api.ufc-app.com/';
    }
  }

  static String get baseUrlForLogistics {
    switch (server) {
      case Build.dev:
        return 'https://logistics-api.ufc-app.com/';

      case Build.testing:
        return 'https://logistics-api.ufc-app.com/';

      case Build.production:
        return 'https://logistics-api.ufc-app.com/';
    }
  }

  static String get farmBaseUrl {
    switch (server) {
      case Build.testing:
        return 'https://medical-api.ufc-app.com';
      case Build.production:
        return "https://medical-api.ufc-app.com";
      case Build.dev:
        return 'https://medical-api.ufc-app.com';
    }
  }

  /// Constants for New Relic app tokens
  static String get newRelicIOSAppToken {
    if (kDebugMode) {
      return 'eu01xxbe8a5af8075b9c0532b2414c8f888c5866f0-NRMA';
    } else {
      return 'AA3bc78150d9722f3ccc9d6a39dd56627fc810739b-NRMA';
    }
  }

  static String get newRelicAndroidAppToken {
    if (kDebugMode) {
      return 'eu01xxe42cce99d4d76ac0d713f2bfea13fb96a405-NRMA';
    } else {
      return 'AAd004a01714e23f819ff0f4816b97f7fe12e4f23f-NRMA';
    }
  }

  static String get paytabProfileId {
    switch (server) {
      case Build.production:
        return '115272';
      default:
        return '115250';
    }
  }

  static String get paytabServerKey {
    switch (server) {
      case Build.production:
        return 'S2JNK2NNH2-JKGHWBW9MZ-LRZNNDGNHM';
      default:
        return 'SDJNK2NNZD-JKG669LKNN-GL2MN2N6T6';
    }
  }

  static String get paytabClientKey {
    switch (server) {
      case Build.production:
        return 'CHKM7B-2BHM6K-THV2VP-T22BVQ';
      default:
        return 'C6KM7B-2BMV6K-TGGPBK-H9NDQK';
    }
  }
}
