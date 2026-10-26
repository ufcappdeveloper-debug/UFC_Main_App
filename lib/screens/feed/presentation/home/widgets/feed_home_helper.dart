import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/common/screen_width_utils.dart';
import 'package:ufc_mobile/global/util/exception/error_handler.dart';
import 'package:ufc_mobile/global/util/station/station_utils.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/widgets/station_widget.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_shadows.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../application/authentication/auth_cubit.dart';
import '../../../application/station/station_cubit.dart';
import '../../../application/station/station_state.dart';
import '../../../domain/entities/station/station_query_model.dart';

class FeedHomeHelper {
  /// Completes when the sheet closes. The StationCubit is in
  /// [StationSuccess] when a station was picked.
  Future<void> showStationBottomSheet(BuildContext context,
      {int? selectedStationId}) {
    final isWide = ScreenWidthUtils.isWide(context);
    final isWideLess = ScreenWidthUtils.isWideLess(context);
    final isWideMore = ScreenWidthUtils.isWideMore(context);

    return showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        context.read<StationCubit>().fetchStations(StationQueryParams());

        return BlocConsumer<StationCubit, StationState>(
          listener: (context, state) {
            if (state is StationSuccess) {
              Navigator.pop(context); // close sheet
              Fluttertoast.showToast(msg: state.message);

              /// ✅ Refresh profile after updating station
              if (!context.read<AuthCubit>().isGuest) {
                context.read<AuthCubit>().loadProfile();
              }
            } else if (state is StationError) {
              ErrorHandler.handleError(context, state.message);
            }
          },
          builder: (context, state) {
            return SizedBox(
              height:
                  MediaQuery.of(context).size.height * 0.7, // Set fixed height
              child: () {
                if (state is StationLoading) {
                  return Center(
                      child: CircularProgressIndicator(color: primaryColor));
                } else if (state is StationError) {
                  return CustomReloadProviderV2(
                    error: state.message,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    onPressed: () {
                      context
                          .read<StationCubit>()
                          .fetchStations(StationQueryParams());
                    },
                  );
                } else if (state is StationLoaded) {
                  if (state.stations.isEmpty) {
                    return Center(child: Text("no_stations".tr()));
                  }
                  int? selectedId = selectedStationId;

                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(4, 10, 4, 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 16),

                            // 🔹 Title + Close button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  iconSize: 17,
                                  icon: const Icon(Icons.close,
                                      color: Colors.black54),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                Expanded(
                                  child: Center(
                                    child: CustomText(
                                      text: "stations".tr(),
                                      fontSize: isWideMore ? 16 : 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 24),
                              ],
                            ),

                            const SizedBox(height: 4),

                            Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: state.stations.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final station = state.stations[index];
                                  final isSelected = station.id == selectedId;

                                  final topPadding = index == 0 ? 24.0 : 6.0;
                                  final bottomPadding =
                                      index == state.stations.length - 1
                                          ? 20.0
                                          : 6.0;

                                  return Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          12, topPadding, 12, bottomPadding),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16, horizontal: 18),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            boxShadow: PetVeterinaryShadows
                                                .standardLight),
                                        child: Row(
                                          children: [
                                            // Left side (radio + text + yellow button)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    final isGuest = context
                                                        .read<AuthCubit>()
                                                        .isGuest;

                                                    if (isGuest) {
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            'Please login to continue'
                                                                .tr(),
                                                        backgroundColor:
                                                            Colors.red,
                                                      );
                                                      return;
                                                    }

                                                    setState(() => selectedId =
                                                        station.id);

                                                    /// ✅ Pass full StationModel to StationCubit
                                                    context
                                                        .read<StationCubit>()
                                                        .setPreferredShop(
                                                            context, station);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      AnimatedContainer(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    100),
                                                        curve: Curves.easeInOut,
                                                        width: isWideMore
                                                            ? 20
                                                            : 18,
                                                        height: isWideMore
                                                            ? 20
                                                            : 18,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: isSelected
                                                              ? PetVeterinaryColors
                                                                  .mainColorUFC
                                                              : Colors
                                                                  .transparent,
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: isSelected
                                                                ? PetVeterinaryColors
                                                                    .mainColorUFC
                                                                : PetVeterinaryColors
                                                                    .newPetLightGray,
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: AnimatedSwitcher(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      100),
                                                          transitionBuilder: (child,
                                                                  animation) =>
                                                              ScaleTransition(
                                                            scale: animation,
                                                            child: child,
                                                          ),
                                                          child: isSelected
                                                              ? const Icon(
                                                                  Icons.check,
                                                                  key: ValueKey(
                                                                      'check'),
                                                                  color: Colors
                                                                      .white,
                                                                  size: 12,
                                                                )
                                                              : const SizedBox(
                                                                  key: ValueKey(
                                                                      'empty'),
                                                                ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width: isWideMore
                                                              ? 6
                                                              : 5),
                                                      CustomText(
                                                        fontSize: isWideMore
                                                            ? 14
                                                            : 13,
                                                        text: isSelected
                                                            ? "my_station".tr()
                                                            : "make_my_station"
                                                                .tr(),
                                                        color:
                                                            PetVeterinaryColors
                                                                .mainColorUFC,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 24),
                                                // Yellow map button
                                                GestureDetector(
                                                  onTap: () async {
                                                    final lat = double.tryParse(
                                                        station.latitude
                                                            .toString());
                                                    final lng = double.tryParse(
                                                        station.longitude
                                                            .toString());

                                                    if (lat == null ||
                                                        lng == null) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Invalid location data");
                                                      return;
                                                    }

                                                    final url =
                                                        "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
                                                    print(
                                                        "Google Maps URL: $url"); // 🔹 Debug print

                                                    if (await canLaunchUrl(
                                                        Uri.parse(url))) {
                                                      await launchUrl(
                                                          Uri.parse(url),
                                                          mode: LaunchMode
                                                              .externalApplication);
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "map_error".tr());
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 14,
                                                      vertical: 6,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .backgroundYellow,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: AppColors
                                                              .backgroundYellow
                                                              .withOpacity(0.5),
                                                          blurRadius: 15,
                                                          offset: const Offset(
                                                              0, 0),
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            'assets/svg/feed/map.svg'),
                                                        SizedBox(
                                                          width: 6,
                                                        ),
                                                        textWidget(
                                                          text: 'Map',
                                                          color: Colors.white,
                                                          fontSize: isWideMore
                                                              ? 14
                                                              : 13,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Spacer(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Transform.translate(
                                                  offset: const Offset(0,
                                                      -5), // move up by 2 pixels
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      FittedBox(
                                                        child: textWidget(
                                                          text: StationUtils
                                                              .stationName(
                                                                  station),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: isWideMore
                                                              ? 14
                                                              : isWideLess
                                                                  ? 13
                                                                  : 12,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 2),
                                                      SvgPicture.asset(
                                                        'assets/svg/feed/station_green.svg',
                                                        height: isWideMore
                                                            ? 15
                                                            : 14,
                                                        width: isWideMore
                                                            ? 15
                                                            : 14,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 24),
                                                FutureBuilder<double?>(
                                                  future: calculateDistance(
                                                      station.latitude,
                                                      station.longitude),
                                                  builder: (context, snapshot) {
                                                    String distanceText;
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      distanceText = '...';
                                                    } else if (snapshot
                                                            .hasData &&
                                                        snapshot.data != null) {
                                                      distanceText =
                                                          '${snapshot.data!.toStringAsFixed(1)} ${'KM'.tr()}';
                                                    } else {
                                                      distanceText = 'N/A';
                                                    }

                                                    return Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          'assets/svg/feed/layer1.svg',
                                                          width: isWideMore
                                                              ? 13
                                                              : 12,
                                                          height: isWideMore
                                                              ? 13
                                                              : 12,
                                                        ),
                                                        SizedBox(width: 12),
                                                        textWidget(
                                                          text: distanceText,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: isWideMore
                                                              ? 14
                                                              : 13,
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ));
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink(); // fallback
              }(),
            );
          },
        );
      },
    );
  }
}

Future<double?> calculateDistance(
    double? stationLat, double? stationLng) async {
  if (stationLat == null || stationLng == null) return null;

  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return null;

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }
  }

  Position userPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  return Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        stationLat,
        stationLng,
      ) /
      1000; // in KM
}

FeedHomeHelper feedHomeHelper = FeedHomeHelper();
