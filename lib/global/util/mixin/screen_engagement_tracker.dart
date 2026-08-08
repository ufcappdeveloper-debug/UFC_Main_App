import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/util/analytic/adjust_tracker.dart';

/// Tracks how long a user stays on a screen using RouteAware.
mixin ScreenEngagementTracker<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();

    // Log screen view
    AdjustTracker.trackPageView(widget.runtimeType.toString());
  }
}
