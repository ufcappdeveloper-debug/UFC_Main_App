import 'package:ufc_mobile/global/config/config.dart';

class ClarityConfig {
  static String get clarityProjectId {
    switch (AppConfig.server) {
      case Build.dev:
        return '';

      case Build.testing:
        return '';

      case Build.production:
        return 'txna0ga84y';
    }
  }
}
