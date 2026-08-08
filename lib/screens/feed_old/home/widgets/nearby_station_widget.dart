import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

import '../../../../global/config/app_location.dart';
import '../../../../riverpod/station/nearby_station.dart';
import '../../../../global/shared/constants/app_colors.dart';
import '../../../../global/shared/widgets/custom_reload_provider.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../../../../global/shared/widgets/home_station_container.dart';

class NearbyStationWidget extends StatefulWidget {
  const NearbyStationWidget({super.key});

  @override
  State<NearbyStationWidget> createState() => _NearbyStationWidgetState();
}

class _NearbyStationWidgetState extends State<NearbyStationWidget> {
  late Future<LocationData?> futurePosition;

  @override
  void initState() {
    futurePosition = AppLocation().determinePosition(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
          height: 170,
          color: Colors.white,
          child: FutureBuilder<LocationData?>(
              future: futurePosition,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator.adaptive(
                    backgroundColor:
                        Platform.isIOS ? mediumGreenColor : Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation(mediumGreenColor),
                  ));
                }
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final location = {
                    "lat": snapshot.data?.latitude ?? 0.0,
                    "long": snapshot.data?.longitude ?? 0.0,
                  };
                  return Consumer(builder: (context, ref, _) {
                    final nearByStation =
                        ref.watch(NearByStationProvider(location));
                    return nearByStation.when(
                        data: (data) => data.isEmpty
                            ? Center(
                                child: CustomText(
                                  text: "No Nearby Station Available",
                                ),
                              )
                            : ListView.builder(
                                itemCount: data.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        HomeStationContainer(
                                  station: data[index],
                                  lat: location["lat"]!,
                                  long: location["long"]!,
                                  constraints: constraints,
                                ),
                              ),
                        error: (e, s) => CustomReloadProvider(
                              height: 118,
                              onPressed: () =>
                                  ref.refresh(NearByStationProvider(location)),
                            ),
                        loading: () => Center(
                                child: CircularProgressIndicator.adaptive(
                              backgroundColor: Platform.isIOS
                                  ? mediumGreenColor
                                  : Colors.transparent,
                              valueColor: const AlwaysStoppedAnimation(
                                  mediumGreenColor),
                            )));
                  });
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: CustomText(
                          text:
                              'Location is off. please turn it on and click \'refresh\' button',
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          futurePosition =
                              AppLocation().determinePosition(context);
                          setState(() {});
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                );
              }));
    });
  }
}
