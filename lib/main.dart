import 'dart:async';

import 'package:clarity_flutter/clarity_flutter.dart' as clarity;
import 'package:corextra/corextra.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ufc_mobile/app.dart';
import 'package:ufc_mobile/global/config/clarity_config.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/init/injection.dart';
import 'package:ufc_mobile/global/util/analytic/adjust_tracker.dart';
import 'package:ufc_mobile/global/util/analytic/sentry_tracker.dart';
import 'package:ufc_mobile/global/util/common/life_cycle_handler.dart';
import 'package:ufc_mobile/global/util/lang/langauge_manager.dart';
import 'package:ufc_mobile/global/util/storage/local_storage.dart';

import 'global/config/config.dart';
import 'global/config/init_firebase.dart';
import 'global/shared/constants/bloc_observer.dart';

int? savedLanguageIndex;
bool showOnBoard = false;
late SharedPreferences preferences;

void main() async {
  Bloc.observer = AppBlocObserver();
  runZonedGuarded(() async {
    // Ensure Flutter bindings are initialized and set up error handling
    WidgetsFlutterBinding.ensureInitialized();
    await init();

    // Initialize Trackers
    await SentryTracker.init();
    AdjustTracker.init();

    final config = clarity.ClarityConfig(
        projectId: ClarityConfig.clarityProjectId,
        logLevel: clarity.LogLevel
            .None // Note: Use "LogLevel.Verbose" value while testing to debug initialization issues.
        );

    // Initialize Firebase and localization
    await InitFirebase.call();

    await EasyLocalization.ensureInitialized();

    // Initialize shared preferences and app settings
    preferences = await SharedPreferences.getInstance();
    savedLanguageIndex = preferences.getInt(LocalStorage.language);
    debugPrint("Saved language in the main index: $savedLanguageIndex");
    showOnBoard = preferences.getString('no_onboard') == 'true' ? false : true;
    AppConfig.token = preferences.getString('token');

    // Ensure FCM is initialized
    final isFcmInitialized = preferences.getBool('init_fcm') ?? false;
    debugPrint("FCM initialized: $isFcmInitialized");

    if (!isFcmInitialized) {
      await preferences.setBool('init_fcm', true);
    }

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));
    if (Constants.navigatorKey.currentContext != null) {
      final initialLocale =
          EasyLocalization.of(Constants.navigatorKey.currentContext!)?.locale;

      LanguageManager.update(initialLocale?.toString());
    }
    final lifecycleHandler = AppLifecycleHandler();
    lifecycleHandler.startObserving();

    await SentryFlutter.init((options) {
      options.environment = AppConfig.server.toString();
      options.dsn = kDebugMode
          ? ''
          : 'https://145c5de21f4e452eda18227313c7947c@o4507516184821760.ingest.us.sentry.io/4508483304030208';
    }, appRunner: () {
      runApp(clarity.ClarityWidget(
        app: const MyApp(),
        clarityConfig: config,
      ));
      configLoading();
    });
  }, (error, stackTrace) {
    // Log the error using a custom logger
    AppLogger.logError(error.toString());

    // Handle errors by recording them with Sentry
    Sentry.captureException(error, stackTrace: stackTrace);
  });
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..userInteractions = true
    ..dismissOnTap = false;
}
