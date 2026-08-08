import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/riverpod/location/location_async.dart';
import 'package:ufc_mobile/screens/feed_old/stations/stations_map.dart';

class CurrentLocation {
  final Location _location = Location();
  late bool _serviceEnabled;
  LatLng? currentLocation;

  Future<LatLng?> getCurrentLocation(BuildContext context, WidgetRef ref,
      {bool fetchLocation = true}) async {
    bool value = await checkForService(context);

    if (value) {
      // LocationData val = await _getCurrentLocation();
      currentLocation =
          await ref.read(locationDataAsyncProvider.notifier).getLocationData();

      // if (kDebugMode) {
      //   currentLocation = const LatLng(24.774265, 46.738586);
      // } else {
      // ref.watch(locationDataAsyncProvider).whenData((val) {
      //   return val;
      // });
      // }
    } else {}
    return currentLocation;
  }

  Future<bool> checkForService(BuildContext context) async {
    PermissionStatus permissionGranted = await _location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();

      if (permissionGranted == PermissionStatus.deniedForever) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LocationPermissionScreen(
              onPressed: () async {
                Navigator.of(context).pop();
                AppSettings.openAppSettings(type: AppSettingsType.location);
              },
            ),
          ),
        );
        return false;
      } else if (permissionGranted == PermissionStatus.denied) {
        return false;
      }
    }
    if (permissionGranted == PermissionStatus.granted) {
      _serviceEnabled = await _location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _location.requestService();

        if (!_serviceEnabled) {
          return false;
        }
      }
      if (_serviceEnabled) {
        return true;
      }
    } else {
      return false;
    }

    return false;
  }
}

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({
    super.key,
    required this.onPressed,
    this.isFromSignUp = true,
    this.initialAppIndex = 0,
  });
  final VoidCallback onPressed;
  final bool isFromSignUp;
  final int initialAppIndex;

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final Location location = Location();
      final future = location.hasPermission();

      final result = await LoadingDialog.show(context, future);

      if (mounted) {
        debugPrint(result.toString());
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (mounted) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StationMapScreen(
                        initialAppIndex: widget.initialAppIndex,
                        fetchLocation: result == PermissionStatus.granted)));
          }
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 53),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 159,
                width: 159,
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                    color: primaryColor, shape: BoxShape.circle),
                child: Image.asset(
                  'assets/images/on_boarding/navigation.png',
                  width: 90,
                ),
              ),
              const SizedBox(height: 36),
              CustomText(
                text:
                    "Allow the app to access your \n location to fetch the nearest station",
                textAlign: TextAlign.center,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
              const SizedBox(height: 55),
              Column(
                children: [
                  InkWell(
                    onTap: widget.onPressed,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: CustomText(
                        text: "Allow",
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 11),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StationMapScreen(
                                  fetchLocation: false,
                                  initialAppIndex: widget.initialAppIndex,
                                  isFromSignUp: widget.isFromSignUp)));
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(width: 1, color: primaryColor)),
                      child: CustomText(
                        text: "Not Now",
                        color: primaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
