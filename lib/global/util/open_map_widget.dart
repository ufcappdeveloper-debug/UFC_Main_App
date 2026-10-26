import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:ufc_mobile/global/util/station/station_utils.dart';

import '../../screens/feed/domain/entities/station/station_model.dart';
import '../shared/widgets/custom_widgets/custom_text.dart';

Future<void> openMapsWidget(StationModel station, BuildContext context) =>
    openMapsAt(
      context,
      latitude: station.latitude ?? 0.0,
      longitude: station.longitude ?? 0.0,
      title: StationUtils.stationName(station),
    );

/// Shows the installed map apps and opens a marker at the given location.
Future<void> openMapsAt(
  BuildContext context, {
  required double latitude,
  required double longitude,
  required String title,
}) async {
  final availableMaps = await MapLauncher.installedMaps;
  if (!context.mounted) {
    return;
  }
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: CustomText(
                text: "Open with",
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            ListView(
              shrinkWrap: true,
              children: [
                Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...availableMaps.map(
                        (e) {
                          final index = availableMaps.indexOf(e);
                          return InkWell(
                            onTap: () {
                              availableMaps[index].showMarker(
                                coords: Coords(latitude, longitude),
                                title: title,
                              );
                              Navigator.of(ctx).pop();
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: ListTile(
                              leading: SizedBox(
                                width: 50,
                                height: 50,
                                child: SvgPicture.asset(
                                  e.icon,
                                ),
                              ),
                              title: Text(e.mapName),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
