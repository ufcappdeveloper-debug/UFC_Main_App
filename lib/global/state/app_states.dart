import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appStateProvider = ChangeNotifierProvider((ref) => AppState());

class AppState extends ChangeNotifier {
  bool dynamicLinkColdStart = false;

  void setColdStart(bool value) {
    dynamicLinkColdStart = value;
    notifyListeners();
  }
}
