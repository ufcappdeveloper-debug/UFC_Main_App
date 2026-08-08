import 'dart:math';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_grey_divider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_footer.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_header.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';
import 'package:ufc_mobile/global/util/station/station_utils.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/location/location_async.dart';
import 'package:ufc_mobile/riverpod/state.dart';
import 'package:ufc_mobile/riverpod/station/station_async.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/station/station_model.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/utils/smooth_nav_utils.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';

import 'station_widgets.dart';

class ExpandedStationsWidget extends ConsumerStatefulWidget {
  const ExpandedStationsWidget({
    super.key,
    this.isFromSignUp = true,
    this.initialAppIndex = 0,
  });

  final bool isFromSignUp;
  final int initialAppIndex;
  @override
  ConsumerState<ExpandedStationsWidget> createState() =>
      _ExpandedStationsWidgetState();
}

class _ExpandedStationsWidgetState
    extends ConsumerState<ExpandedStationsWidget> {
  int? selectedShop;
  int page = 1;
  String? pageLimit;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    page = 1;
    pageLimit = null;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    page = 1;
    pageLimit = null;

    await ref.read(stationAsyncProvider.notifier).getStations();
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (pageLimit != "empty") {
      page++;
    }

    pageLimit =
        await ref.read(stationAsyncProvider.notifier).loadStations(page);
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final stationData = ref.watch(stationAsyncProvider);
    final locationData = ref.watch(locationDataAsyncProvider).value;
    return Container(
        height: 600,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 3,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    CustomText(
                      text: "Stations Nearest To You",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    stationData.when(
                        error: (error, stackTrace) => Center(
                              child: CustomText(
                                text: "Something went wrong",
                              ),
                            ),
                        loading: () => const Expanded(
                            child: Center(child: CupertinoActivityIndicator())),
                        data: (data) {
                          final sortedStations = [...?data];
                          sortedStations.sort((stationA, stationB) {
                            final distanceA = calculateDistance(
                              locationData?.latitude,
                              locationData?.longitude,
                              stationA.latitude ?? 0.0,
                              stationA.longitude ?? 0.0,
                            );
                            final distanceB = calculateDistance(
                              locationData?.latitude,
                              locationData?.longitude,
                              stationB.latitude ?? 0.0,
                              stationB.longitude ?? 0.0,
                            );
                            return (distanceA ?? 0).compareTo(distanceB ?? 0);
                          });

                          return Expanded(
                            child: SmartRefresher(
                              enablePullUp: true,
                              enablePullDown: true,
                              onRefresh: _onRefresh,
                              onLoading: _onLoading,
                              controller: _refreshController,
                              scrollController: _scrollController,
                              header: const CustomPaginationHeader(),
                              footer: CustomPaginationFooter(
                                  pageLimit: pageLimit,
                                  emptyDataText: "No More Station Found"),
                              physics: const BouncingScrollPhysics(),
                              child: ListView.builder(
                                itemCount: data!.length,
                                padding: const EdgeInsets.only(top: 11.97),
                                itemBuilder: (context, index) {
                                  final station = sortedStations[index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: CustomText(
                                          text: StationUtils.stationName(
                                            station,
                                          ),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      ref.watch(locationDataAsyncProvider).when(
                                          data: (data) => (data == null)
                                              ? const SizedBox.shrink()
                                              : RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                      height: 1.3,
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            "${calculateDistance(data.latitude, data.longitude, station.latitude ?? 0.0, station.longitude ?? 0.0)} KM ",
                                                        style: const TextStyle(
                                                          height: 1.3,
                                                          fontSize: 11,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: "away".tr(),
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          error: (a, b) =>
                                              const SizedBox.shrink(),
                                          loading: () =>
                                              const SizedBox.shrink()),
                                      if (station.address != null &&
                                          station.address!.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: CustomText(
                                            text: station.address ?? "",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      Align(
                                        alignment:
                                            AlignmentDirectional.centerEnd,
                                        child: SizedBox(
                                          width: 210,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomButton(
                                                  height: 27,
                                                  width: 120,
                                                  radius: 20,
                                                  color: Colors.white,
                                                  textColor: primaryColor,
                                                  boxShadow: const [],
                                                  border: Border.all(
                                                      color: primaryGrey,
                                                      width: 0.8),
                                                  title: "Direction",
                                                  onTap: () {
                                                    openMapsWidget(station);
                                                  }),
                                              CustomButton(
                                                  height: 27,
                                                  width: 80,
                                                  radius: 20,
                                                  disabled: isDisabled(station),
                                                  title: titile(station),
                                                  onTap: () async {
                                                    selectedShop = station.id;
                                                    setState(() {});
                                                    debugPrint(station.nameEn
                                                        .toString());
                                                    try {
                                                      if (!widget
                                                          .isFromSignUp) {
                                                        final bool updatePref =
                                                            await showUpdateStationDialog(
                                                                context);
                                                        if (!updatePref) {
                                                          return;
                                                        }
                                                      }
                                                      final future = ref
                                                          .read(authProvider
                                                              .notifier)
                                                          .updatePreferredShop(
                                                              station.id
                                                                  .toString());
                                                      if (!context.mounted) {
                                                        return;
                                                      }
                                                      final result =
                                                          await LoadingDialog
                                                              .show(context,
                                                                  future);
                                                      if (mounted && result) {
                                                        if (widget
                                                            .isFromSignUp) {
                                                          if (!context
                                                              .mounted) {
                                                            return;
                                                          }
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pushAndRemoveUntil(
                                                            createSmoothRoute(
                                                              BottomBar(
                                                                  initialIndex:
                                                                      widget
                                                                          .initialAppIndex),
                                                              type: PageTransitionType
                                                                  .slideRight,
                                                            ),
                                                            (route) => false,
                                                          );
                                                        } else {
                                                          ref
                                                              .read(
                                                                  cartProvider)
                                                              .clear(); // clear cart provider after success
                                                          if (!context
                                                              .mounted) {
                                                            return;
                                                          }
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      }
                                                    } on DioException catch (e) {
                                                      if (context.mounted) {
                                                        CustomSnackBar.error(
                                                            context,
                                                            "Something went wrong + ${e.dioMessage}");
                                                      }
                                                    } catch (e) {
                                                      if (context.mounted) {
                                                        CustomSnackBar.error(
                                                            context,
                                                            "Something went wrong + ${e.toString()}");
                                                      }
                                                    }
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const CustomGreyDivider(),
                                    ],
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            )
          ],
        ));
  }

  String titile(StationModel? station) {
    if (ref.watch(authProvider).value != null) {
      return ref.watch(authProvider).value?.preferredShop != station?.id
          ? "Select"
          : "Current";
    }
    return 'Select';
  }

  bool isDisabled(StationModel? station) {
    if (ref.watch(authProvider).value != null) {
      return ref.watch(authProvider).value?.preferredShop == station?.id;
    }
    return false;
  }

  double? calculateDistance(
      double? lat1, double? lon1, double? lat2, double? lon2) {
    if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) {
      return null;
    }
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return (12742 * asin(sqrt(a))).truncateToDouble();
  }

  Future<void> openMapsWidget(StationModel station) async {
    final availableMaps = await MapLauncher.installedMaps;

    if (mounted) {
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
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
                                    coords: Coords(
                                      station.latitude ?? 0.0,
                                      station.longitude ?? 0.0,
                                    ),
                                    title: station.nameEn.toString(),
                                  );
                                  // Navigator.of(ctx).pop();
                                  setState(() {});
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
  }
}
