import 'package:ufc_mobile/global/config/config.dart';

class AgoraConfig {
  static String get appId {
    switch (AppConfig.server) {
      case Build.dev:
        return 'a7e41e1faf694785b8e80352e292e900';
      // return 'b8de50f5e3694d458285bfff46b50cc3';

      case Build.testing:
        return 'a7e41e1faf694785b8e80352e292e900';
      // return 'b8de50f5e3694d458285bfff46b50cc3';

      case Build.production:
        return 'a7e41e1faf694785b8e80352e292e900';
    }
  }
}
