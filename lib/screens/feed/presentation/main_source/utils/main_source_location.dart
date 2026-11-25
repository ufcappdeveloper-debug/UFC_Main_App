import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ufc_mobile/global/config/app_location.dart';

import '../../../domain/entities/main_source/main_source_params.dart';

/// Riyadh: the map centre when there is no GPS position (plan §4.2).
const mainSourceDefaultLatitude = 24.774265;
const mainSourceDefaultLongitude = 46.738586;

/// Readable address and city for a point (same `placemarkFromCoordinates`
/// as the address map). Never throws; the coordinates are what matter.
Future<MainSourceLocation> reverseGeocode(double lat, double lng) async {
  try {
    final placemarks = await placemarkFromCoordinates(lat, lng);
    final p = placemarks.isEmpty ? null : placemarks.first;
    if (p == null) return MainSourceLocation(latitude: lat, longitude: lng);
    final parts = <String>[];
    void add(String? value) {
      final v = value?.trim();
      if (v != null && v.isNotEmpty && !parts.contains(v)) parts.add(v);
    }

    add(p.street ?? p.name);
    add(p.subLocality);
    add([p.locality, p.postalCode]
        .where((e) => e != null && e.trim().isNotEmpty)
        .join(' '));
    final city = (p.locality?.trim().isNotEmpty ?? false)
        ? p.locality
        : p.administrativeArea;
    return MainSourceLocation(
      latitude: lat,
      longitude: lng,
      address: parts.isEmpty ? null : parts.join(', '),
      city: city,
    );
  } catch (_) {
    return MainSourceLocation(latitude: lat, longitude: lng);
  }
}

/// Current GPS position with its address, or `null` when permission is
/// denied or GPS fails (the caller then opens the map picker).
Future<MainSourceLocation?> currentMainSourceLocation(
    BuildContext context) async {
  try {
    final data = await AppLocation().determinePosition(context);
    final lat = data?.latitude;
    final lng = data?.longitude;
    if (lat == null || lng == null) return null;
    return reverseGeocode(lat, lng);
  } catch (_) {
    return null;
  }
}
