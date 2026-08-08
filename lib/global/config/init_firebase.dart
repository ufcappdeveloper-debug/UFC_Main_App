import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

class InitFirebase {
  static Future<void> call() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }

      // Always log analytics after Firebase is initialized
      FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      await analytics.logEvent(name: 'init_firebase');
    } catch (e) {
      debugPrint('Firebase init error: $e');
    }
  }
}
