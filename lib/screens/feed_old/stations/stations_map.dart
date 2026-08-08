import 'dart:async';

import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ufc_mobile/riverpod/station/station_async.dart';
import 'package:ufc_mobile/riverpod/station/station_markers_state.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/app_location.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

import 'widget/expanded_stations_sheet.dart';

class StationMapScreen extends ConsumerStatefulWidget {
  const StationMapScreen({
    super.key,
    this.lat,
    this.long,
    this.fetchLocation = true,
    this.isFromSignUp = true,
    this.initialAppIndex = 0,
  });

  final double? lat;
  final double? long;
  final bool fetchLocation;
  final bool isFromSignUp;
  final int initialAppIndex;
  @override
  ConsumerState<StationMapScreen> createState() => _StationMapScreenState();
}

class _StationMapScreenState extends ConsumerState<StationMapScreen>
    with ScreenEngagementTracker {
  String? mapStyle;
  double lat = 21.4858;
  double long = 39.1925;
  bool isLoading = true;
  double searchPosition = -750;
  double filterPosition = 2000;
  GoogleMapController? mapController;
  LatLng? currentLocation;
  late CameraPosition _kLake;
  final Location _location = Location();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late PermissionStatus givenPermission;
  bool isSheetClosed = false;

  @override
  void initState() {
    Future(
      () => ref.read(stationAsyncProvider.notifier).getStations(),
    );
    DefaultAssetBundle.of(context)
        .loadString('assets/json/googleMapStyle1.json')
        .then((string) {
      mapStyle = string;
    }).catchError((error) {
      debugPrint(error.toString());
    });
    if (widget.lat != null && widget.long != null) {
      lat = widget.lat!;
      long = widget.long!;
    }
    _kLake = CameraPosition(
      target: LatLng(lat, long),
      zoom: 11,
    );
    Future.delayed(const Duration(seconds: 1), () {});
    if (widget.fetchLocation) {
      getLocation();
    }

    super.initState();
  }

  Future<void> getLocation() async {
    givenPermission = await _location.hasPermission();
    if (givenPermission == PermissionStatus.granted) {
      if (!mounted) return;
      currentLocation = await CurrentLocation()
          .getCurrentLocation(context, ref, fetchLocation: widget.fetchLocation)
          .catchError((onError) {
        debugPrint(onError);
        return null;
      });
      if (currentLocation == null) {
        if (!mounted) return;
        CustomSnackBar.error(context, "Location not found");
        return;
      }

      moveTo(currentLocation!.latitude, currentLocation!.longitude);
    }
  }

  Future<void> moveTo(double lat, double lng) async {
    mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 0,
        target: LatLng(lat, lng),
        tilt: 0.440717697143555,
        zoom: 11)));
  }

  void mapCreated(GoogleMapController controller) {
    // _customInfoWindowController.googleMapController = controller;
    setState(() {
      mapController = controller;
      if (mapStyle != null) {
        mapController!
            .setMapStyle(mapStyle)
            .then((value) {})
            // ignore: invalid_return_type_for_catch_error
            .catchError((error) {
          debugPrint("Error setting map style:$error");
          return null;
        });
      } else {
        debugPrint(
            "GoogleMapView:_onMapCreated: Map style could not be loaded.");
      }
      moveTo(lat, long);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: WillPopScope(
        onWillPop: () async => !widget.isFromSignUp,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              onTap: (LatLng latLng) {
                // _customInfoWindowController.hideInfoWindow!();
                setState(() {
                  searchPosition == 300
                      ? searchPosition = MediaQuery.of(context).size.height
                      : searchPosition = searchPosition;
                });
              },
              markers: Set.from(ref.watch(markerProvider).markers),
              zoomControlsEnabled: false,
              trafficEnabled: false,
              zoomGesturesEnabled: true,
              compassEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              buildingsEnabled: true,
              initialCameraPosition: _kLake,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              onCameraMove: (position) {
                // _customInfoWindowController.onCameraMove!();
              },
              onMapCreated: mapCreated,
            ),
            Positioned(
              child: DraggableBottomSheet(
                minExtent: 100,
                useSafeArea: false,
                curve: Curves.linear,
                collapsed: false,
                barrierDismissible: false,
                previewWidget: Container(
                    height: 100,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 15),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          height: 3,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: CustomText(
                            text: "Stations Nearest To You",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )),
                expandedWidget: ExpandedStationsWidget(
                  isFromSignUp: widget.isFromSignUp,
                  initialAppIndex: widget.initialAppIndex,
                ),
                backgroundWidget: Container(height: 0, color: Colors.blueGrey),
                maxExtent: 600,
                barrierColor: Colors.transparent,
                onDragging: (pos) {
                  debugPrint(pos.toString());
                  if (pos == 100) {
                    isSheetClosed = true;
                  } else {
                    isSheetClosed = false;
                  }
                  setState(() {});
                },
              ),
            ),
            if (!widget.isFromSignUp)
              PositionedDirectional(
                  top: 50,
                  start: 20,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                  )),
            if (widget.fetchLocation && isSheetClosed)
              Positioned(
                bottom: kBottomNavigationBarHeight + 20,
                right: 20,
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: FittedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () async {
                            try {
                              await getLocation();
                              if (currentLocation == null) {
                                if (!context.mounted) return;
                                CustomSnackBar.error(
                                    context, "Location not found");
                                return;
                              }
                              await moveTo(currentLocation!.latitude,
                                  currentLocation!.longitude);
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(17),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                      color:
                                          Colors.black.withValues(alpha: 0.3),
                                      offset: const Offset(0, 5))
                                ]),
                            child: const Icon(
                              Icons.my_location,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
