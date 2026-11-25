import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';

import '../../../domain/entities/main_source/main_source_params.dart';
import '../../distributor/utils/distributor_style.dart';
import '../utils/main_source_location.dart';

/// Opens the full-screen pin picker; returns the chosen location or `null`.
Future<MainSourceLocation?> pickMainSourceLocation(BuildContext context,
        {MainSourceLocation? initial}) =>
    Navigator.of(context, rootNavigator: true).push<MainSourceLocation>(
      MaterialPageRoute(
        builder: (_) => MainSourceLocationPicker(initial: initial),
      ),
    );

/// Map with a centred pin: move the map to move the pin (plan §4.2).
/// Based on `FeedAddressMapScreen`, but it only returns the point
/// (`Navigator.pop`) and never saves an address.
class MainSourceLocationPicker extends StatefulWidget {
  final MainSourceLocation? initial;

  const MainSourceLocationPicker({super.key, this.initial});

  @override
  State<MainSourceLocationPicker> createState() =>
      _MainSourceLocationPickerState();
}

class _MainSourceLocationPickerState extends State<MainSourceLocationPicker> {
  GoogleMapController? _map;
  String? _mapStyle;
  late LatLng _target;
  MainSourceLocation? _resolved;
  bool _resolving = false;
  bool _locating = false;
  int _geocodeRequest = 0;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _target = i == null
        ? const LatLng(mainSourceDefaultLatitude, mainSourceDefaultLongitude)
        : LatLng(i.latitude, i.longitude);
    _resolved = i;
    if (i == null) _resolve();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        _mapStyle = await DefaultAssetBundle.of(context)
            .loadString('assets/json/googleMapStyle1.json');
      } catch (_) {}
    });
  }

  Future<void> _resolve() async {
    final id = ++_geocodeRequest;
    setState(() => _resolving = true);
    final result = await reverseGeocode(_target.latitude, _target.longitude);
    if (!mounted || id != _geocodeRequest) return;
    setState(() {
      _resolved = result;
      _resolving = false;
    });
  }

  Future<void> _goToCurrent() async {
    setState(() => _locating = true);
    final current = await currentMainSourceLocation(context);
    if (!mounted) return;
    setState(() => _locating = false);
    if (current == null) {
      CustomSnackBar.error(context, 'Could not fetch current location.');
      return;
    }
    _target = LatLng(current.latitude, current.longitude);
    _resolved = current;
    await _map?.animateCamera(CameraUpdate.newLatLng(_target));
    setState(() {});
  }

  void _confirm() {
    final r = _resolved;
    Navigator.of(context).pop(MainSourceLocation(
      latitude: _target.latitude,
      longitude: _target.longitude,
      address: r?.address,
      city: r?.city,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Pick the delivery location'.tr(),
            style: DistributorStyle.style(size: 15, weight: FontWeight.w500)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _target, zoom: 15),
                  onMapCreated: (c) {
                    _map = c;
                    if (_mapStyle != null) {
                      // ignore: deprecated_member_use
                      c.setMapStyle(_mapStyle).catchError((_) {});
                    }
                  },
                  onCameraMove: (p) => _target = p.target,
                  onCameraIdle: _resolve,
                  onTap: (latLng) =>
                      _map?.animateCamera(CameraUpdate.newLatLng(latLng)),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  compassEnabled: false,
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer()),
                  },
                ),
                // The pin's tip sits on the map centre.
                const Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Icon(Icons.location_on,
                      size: 44, color: DistributorStyle.error),
                ),
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: DistributorStyle.card(radius: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.place_outlined,
                            color: DistributorStyle.green, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _resolving
                                ? '...'
                                : (_resolved?.address ??
                                    '${_target.latitude.toStringAsFixed(5)}, ${_target.longitude.toStringAsFixed(5)}'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: DistributorStyle.style(size: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PositionedDirectional(
                  bottom: 20,
                  end: 20,
                  child: FloatingActionButton.small(
                    heroTag: 'ms_my_location',
                    backgroundColor: Colors.white,
                    onPressed: _locating ? null : _goToCurrent,
                    child: _locating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: DistributorStyle.green))
                        : const Icon(Icons.my_location,
                            color: DistributorStyle.green),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: CustomButton(
                title: 'Confirm location',
                width: double.infinity,
                height: 46,
                onTap: _confirm,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
