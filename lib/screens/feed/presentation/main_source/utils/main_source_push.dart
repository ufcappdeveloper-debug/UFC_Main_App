import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';

import '../pages/main_source_order_details_page.dart';

/// Main Source push notifications (plan §5): `data.type` starts with
/// `main_source_` and `data.main_source_order_id` is the order.
class MainSourcePush {
  MainSourcePush._();

  static const typePrefix = 'main_source_';

  static final _received = StreamController<int>.broadcast();

  /// Order ids of Main Source pushes received while the app is open; an
  /// open order details screen reloads itself.
  static Stream<int> get received => _received.stream;

  static bool isMainSource(Map data) =>
      (data['type']?.toString() ?? '').startsWith(typePrefix);

  static int? orderIdOf(Map data) =>
      int.tryParse(data['main_source_order_id']?.toString() ?? '');

  /// Foreground push.
  static void onReceived(Map data) {
    if (!isMainSource(data)) return;
    final id = orderIdOf(data);
    if (id != null) _received.add(id);
  }

  /// Tap on the notification: Home underneath, the order on top (same
  /// pattern as the chat / call notifications).
  static bool onTap(BuildContext? context, Map data) {
    if (!isMainSource(data)) return false;
    final id = orderIdOf(data);
    if (context == null || id == null) return true;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => BottomBar(),
        settings: RouteSettings(name: BottomBar.routeName),
      ),
      (route) => false,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => MainSourceOrderDetailsPage(orderId: id)),
    );
    return true;
  }
}
