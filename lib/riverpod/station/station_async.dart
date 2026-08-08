import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/station_service.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/station/station_model.dart';
import 'package:ufc_mobile/riverpod/station/station_markers_state.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

part "station_async.g.dart";

@Riverpod(keepAlive: true)
class StationAsync extends _$StationAsync {
  @override
  FutureOr<List<StationModel>?> build() async {
    return null;
  }

  Future<void> getStations({
    final String? search,
  }) async {
    state = const AsyncValue.loading();
    final Map<String, dynamic> data = {
      "page": 1,
      "limit": 20,
      if (search != null) "search": search,
    };
    try {
      final response = await StationService().getStations(data);
      state = AsyncValue.data(response);

      for (final val in response) {
        ref.read(markerProvider).addMarkers(Marker(
              markerId: MarkerId(val.id.toString()),
              position: LatLng(val.latitude ?? 0.0, val.longitude ?? 0.0),
              icon: await BitmapDescriptor.fromAssetImage(
                  const ImageConfiguration(size: Size(12, 12)),
                  'assets/images/station/station_marker.png'),
            ));
      }
    } on DioException catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<String?> loadStations(final int page) async {
    final Map<String, dynamic> data = {
      "page": page,
      "limit": 20,
    };
    try {
      final response = await StationService().getStations(data);
      if (response.isEmpty) {
        return "empty";
      }
      for (final val in response) {
        ref.read(markerProvider).addMarkers(Marker(
              markerId: MarkerId(val.id.toString()),
              position: LatLng(val.latitude ?? 0.0, val.longitude ?? 0.0),
              icon: await BitmapDescriptor.fromAssetImage(
                  const ImageConfiguration(size: Size(12, 12)),
                  'assets/images/station/station_marker.png'),
            ));
      }

      state.value?.addAll(response);
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
    return null;
  }
}
