import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCcbUNpXWeQfVDqogm5D7rmPFPCGZj9XX8',
    appId: '1:121184558555:android:bb158b3012a0f5c5b4dbfe',
    messagingSenderId: '121184558555',
    projectId: 'ufcecommerce-ac2e7',
    storageBucket: 'ufcecommerce-ac2e7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCOxC2Mz4hct7u3DLW4BSEsMesoT_vsxwU',
    appId: '1:121184558555:ios:565bd566467e840eb4dbfe',
    messagingSenderId: '121184558555',
    projectId: 'ufcecommerce-ac2e7',
    storageBucket: 'ufcecommerce-ac2e7.appspot.com',
    androidClientId:
        '121184558555-2rhfc9ff08e973vhopj2v9lfcm436lk3.apps.googleusercontent.com',
    iosClientId:
        '121184558555-3chie5v7d09outmo02p6924und263uqr.apps.googleusercontent.com',
    iosBundleId: 'sa.com.ufc.mobile',
  );
}
