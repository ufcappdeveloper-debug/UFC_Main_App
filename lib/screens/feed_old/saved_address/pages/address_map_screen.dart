import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/models/address_model.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/farm_appbar.dart';

import 'add_address_screen.dart';

class AddressMapScreen extends ConsumerStatefulWidget {
  final AddressModel? selectedAddressModel;
  final bool isEdit;
  const AddressMapScreen({
    super.key,
    this.isEdit = false,
    this.selectedAddressModel,
  });

  @override
  ConsumerState<AddressMapScreen> createState() => _AddressMapScreenState();
}

class _AddressMapScreenState extends ConsumerState<AddressMapScreen>
    with ScreenEngagementTracker {
  Set<Marker> marker = {};
  GoogleMapController? mapController;
  String? mapStyle;
  bool isLoading = true;
  LatLng currentLocation = const LatLng(0, 0);
  LatLng updatedLocation = const LatLng(0, 0);
  bool isFetchingLocation = false;
  late final CameraPosition _kLake;
  Map<String, String> locationDetail = {};
  @override
  void initState() {
    loadMap();
    super.initState();
  }

  Future<void> loadMap() async {
    try {
      if (widget.selectedAddressModel == null) {
        final loc.Location location = loc.Location();
        await location.requestPermission();
        loc.PermissionStatus givenPermission = await location.hasPermission();

        if (givenPermission == loc.PermissionStatus.granted) {
          final val = await location.getLocation();
          debugPrint(val.toString());
          currentLocation =
              LatLng(val.latitude ?? 24.774265, val.longitude ?? 46.738586);
        } else {
          if (mounted) {
            Navigator.pop(context);
            CustomSnackBar.error(context,
                "Allow the app to access your location to add address");
          }
        }
      } else {
        currentLocation = LatLng(widget.selectedAddressModel?.latitude ?? 0.0,
            widget.selectedAddressModel?.longitude ?? 0.0);
      }
      updatedLocation = currentLocation;
      await setUpMarker();
      if (!mounted) return;
      String style = await DefaultAssetBundle.of(context)
          .loadString('assets/json/googleMapStyle1.json');
      mapStyle = style;
      _kLake = CameraPosition(
        target: LatLng(updatedLocation.latitude, updatedLocation.longitude),
        zoom: 12,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
          updatedLocation.latitude, updatedLocation.longitude);
      locationDetail["name"] = placemarks.first.name ?? '';
      locationDetail["country"] = placemarks.first.country ?? '';
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomFarmAppBar(
          title: widget.isEdit ? "Edit Address" : "Add Address"),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor:
                    Platform.isIOS ? mediumGreenColor : Colors.transparent,
                valueColor: const AlwaysStoppedAnimation(mediumGreenColor),
              ),
            )
          : Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                        child: GoogleMap(
                      mapToolbarEnabled: false,
                      onTap: (LatLng latLng) async {
                        updatedLocation = latLng;
                        await moveTo(latLng.latitude, latLng.longitude);
                        await setUpMarker();
                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(
                                latLng.latitude, latLng.longitude);
                        locationDetail["name"] = placemarks.first.name ?? '';
                        locationDetail["country"] =
                            placemarks.first.country ?? '';
                        setState(() {});
                      },
                      markers: marker,
                      zoomControlsEnabled: false,
                      trafficEnabled: false,
                      zoomGesturesEnabled: true,
                      compassEnabled: false,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      buildingsEnabled: true,
                      initialCameraPosition: _kLake,
                      gestureRecognizers: <Factory<
                          OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },
                      onMapCreated: mapCreated,
                    )),
                    SizedBox(
                      height: 98,
                      width: double.infinity,
                      child: Center(
                        child: CustomButton(
                          title: "Confirm Location",
                          onTap: () {
                            debugPrint(updatedLocation.latitude.toString());
                            debugPrint(updatedLocation.longitude.toString());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddAddressScreen(
                                  isEdit: widget.isEdit,
                                  lat: updatedLocation.latitude,
                                  lng: updatedLocation.longitude,
                                  locationName: locationDetail["name"] ?? '',
                                  locationCountry:
                                      locationDetail["country"] ?? '',
                                  selectedAddressModel:
                                      widget.selectedAddressModel,
                                ),
                              ),
                            );
                          },
                          width: 287,
                          height: 42,
                        ),
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: 13,
                  left: 21,
                  right: 21,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          "assets/images/profile/address_map_marker_icon.svg",
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          width: 11,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: locationDetail["name"] ?? '',
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              CustomText(
                                text: locationDetail["country"] ?? '',
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xFF646464),
                                height: 1.3,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 120,
                    right: 20,
                    child: RawMaterialButton(
                      padding: const EdgeInsets.all(16),
                      fillColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(200),
                      ),
                      constraints:
                          const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
                      child: const Icon(
                        Icons.my_location,
                        color: primaryColor,
                        size: 28,
                      ),
                      // onPressed: () async {
                      //   updatedLocation = currentLocation;
                      //   await moveTo(updatedLocation.latitude,
                      //       updatedLocation.longitude);
                      //   await setUpMarker();
                      //   List<Placemark> placemarks =
                      //       await placemarkFromCoordinates(
                      //           updatedLocation.latitude,
                      //           updatedLocation.longitude);
                      //   locationDetail["name"] = placemarks.first.name ?? '';
                      //   locationDetail["country"] =
                      //       placemarks.first.country ?? '';
                      //   setState(() {});
                      // },
                      onPressed: () async {
                        setState(() {
                          isFetchingLocation = true;
                        });

                        try {
                          final loc.Location location = loc.Location();
                          final permissionStatus =
                              await location.hasPermission();
                          if (permissionStatus == loc.PermissionStatus.denied) {
                            await location.requestPermission();
                          }

                          final newLocation = await location.getLocation();

                          updatedLocation = LatLng(
                            newLocation.latitude ?? currentLocation.latitude,
                            newLocation.longitude ?? currentLocation.longitude,
                          );

                          await moveTo(updatedLocation.latitude,
                              updatedLocation.longitude);
                          await setUpMarker();

                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                            updatedLocation.latitude,
                            updatedLocation.longitude,
                          );

                          locationDetail["name"] = placemarks.first.name ?? '';
                          locationDetail["country"] =
                              placemarks.first.country ?? '';

                          setState(() {});
                        } catch (e) {
                          if (!context.mounted) return;
                          debugPrint("Error fetching current location: $e");
                          CustomSnackBar.error(
                              context, "Could not fetch current location.");
                        } finally {
                          setState(() {
                            isFetchingLocation = false;
                          });
                        }
                      },
                    )),
                if (isFetchingLocation)
                  Positioned.fill(
                    child: Stack(
                      children: [
                        // Dim background
                        Container(
                          color: Colors.black.withOpacity(0.3),
                        ),
                        const Center(
                          child: CustomIndicator(padding: 50),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }

  void mapCreated(GoogleMapController controller) {
    // _customInfoWindowController.googleMapController = controller;
    setState(() {
      mapController = controller;
      if (mapStyle != null) {
        mapController!
            .setMapStyle(mapStyle)
            .then((value) {})
            .catchError((error) {
          debugPrint("Error setting map style:$error");
          return null;
        });
      } else {
        debugPrint(
            "GoogleMapView:_onMapCreated: Map style could not be loaded.");
      }
    });
  }

  Future<void> moveTo(double lat, double lng) async {
    if (mapController == null) return;

    double currentZoom = await mapController!.getZoomLevel();

    mapController!.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(lat, lng),
        tilt: 0.440717697143555,
        zoom: currentZoom,
      ),
    ));
  }

  Future<void> setUpMarker() async {
    final Uint8List? markerIcon =
        await getBytesFromAsset('assets/images/profile/marker_icon.png', 120);
    marker = {
      Marker(
        markerId: const MarkerId("167889"),
        position: LatLng(updatedLocation.latitude, updatedLocation.longitude),
        flat: true,
        icon: BitmapDescriptor.fromBytes(
          markerIcon!,
        ),
      )
    };
  }

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }
}
