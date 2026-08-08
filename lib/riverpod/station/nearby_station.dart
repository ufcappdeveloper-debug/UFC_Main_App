import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/station_service.dart';

import '../../screens/feed/domain/entities/station/station_model.dart';

part "nearby_station.g.dart";

@riverpod
Future<List<StationModel>> nearByStation(
    NearByStationRef ref, final data) async {
  List<StationModel> stations = await StationService().getNearbyStations(data);
  if (stations.isNotEmpty) {
    stations = stations
        .map((station) => station.copyWith(
            km: calculateDistance(data["lat"] as double, data["long"] as double,
                station.latitude!, station.longitude!)))
        .toList();
    stations.sort((a, b) => a.km!.compareTo(b.km!));
  }
  return stations;
}

double calculateDistance(double lat, double long, double dLat, double dLong) {
  const Distance distance = Distance();
  final double km =
      distance.as(LengthUnit.Kilometer, LatLng(lat, long), LatLng(dLat, dLong));
  return double.parse(km.toStringAsFixed(0));
}
