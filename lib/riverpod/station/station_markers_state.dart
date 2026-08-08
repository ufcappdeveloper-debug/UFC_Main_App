import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StationMarkerState extends ChangeNotifier {
  List<Marker> markers = [];

  void addMarkers(Marker m) {
    markers.add(m);
    notifyListeners();
  }
}

final markerProvider = ChangeNotifierProvider<StationMarkerState>((ref) {
  return StationMarkerState();
});
