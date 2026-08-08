import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/riverpod/station/station_markers_state.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

part "location_async.g.dart";

@Riverpod(keepAlive: true)
class LocationDataAsync extends _$LocationDataAsync {
  final Location _location = Location();
  @override
  FutureOr<LatLng?> build() async {
    return null;
  }

  Future<LatLng?> getLocationData() async {
    state = const AsyncValue.loading();
    try {
      final LocationData value = (await _location.getLocation());
      if (value.latitude == null || value.longitude == null) {
        throw "Location not found";
      }
      state = AsyncValue.data(LatLng(value.latitude!, value.longitude!));
      ref.read(markerProvider).addMarkers(
            Marker(
              markerId: const MarkerId("167889"),
              position: LatLng(value.latitude!, value.longitude!),
              flat: true,
              icon: await BitmapDescriptor.fromAssetImage(
                const ImageConfiguration(size: Size(4, 4)),
                'assets/images/navigation/home-filled.png',
              ),
            ),
          );
      return state.value;
    } on DioException catch (e) {
      throw e.dioMessage;
    } catch (e) {
      log(e.toString());
      throw 'Something went wrong. Contact with Admin';
    }
  }
}
