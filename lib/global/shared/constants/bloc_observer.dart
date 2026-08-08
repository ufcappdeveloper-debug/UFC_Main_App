import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:ufc_mobile/global/util/log/log_utils.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    // Log error to console in debug
    if (kDebugMode) {
      debugPrint('Bloc Error in ${bloc.runtimeType}: $error');
    }

    // Log to your app logger
    AppErrorLogger.logError('Bloc Error in ${bloc.runtimeType}: $error');

    // Send to Sentry
    Sentry.captureException(error, stackTrace: stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (kDebugMode) {
      debugPrint('Bloc Transition in ${bloc.runtimeType}: $transition');
    }
  }
}
