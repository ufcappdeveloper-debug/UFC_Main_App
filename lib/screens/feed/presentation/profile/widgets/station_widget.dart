import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../global/shared/constants/app_colors.dart';
import '../../../../../global/shared/constants/constants.dart';
import '../../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../../../../../global/util/station/station_utils.dart';
import '../../../../farm/presentation/widgets/custome_container.dart';
import '../../../application/authentication/auth_cubit.dart';
import '../../../domain/entities/authentication/user_model.dart';
import '../../../domain/entities/station/station_model.dart';
import '../../home/widgets/feed_home_helper.dart';

Widget stationWidget(BuildContext context,
    {bool showEdit = true, bool showLocation = false, double? distance}) {
  return BlocBuilder<AuthCubit, AuthState>(
    builder: (context, state) {
      final authCubit = context.read<AuthCubit>();
      final UserModel? user = authCubit.currentUser;
      final StationModel? station = user?.preferredShopDetails;

      return CustomFarmContainer(
        customShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 0.5,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
        radius: 20,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/feed/station_green.svg',
                  width: 15,
                  height: 15,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: textWidget(
                    text: StationUtils.stationName(station),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (showEdit)
                  GestureDetector(
                    onTap: () {
                      final selectedStationId = user?.preferredShopDetails?.id;
                      feedHomeHelper.showStationBottomSheet(
                        context,
                        selectedStationId: selectedStationId,
                      );
                    },
                    child: textWidget(
                      text: 'Edit',
                      fontSize: 14,
                      color: primaryColor,
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //NOTE:  THE DISTANCE REQUIRES USER LOCATION TO BE ON

                FutureBuilder<double?>(
                  future:
                      calculateDistance(station?.latitude, station?.longitude),
                  builder: (context, snapshot) {
                    String distanceText;

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      distanceText = '...'; // Loading indicator
                    } else if (snapshot.hasData && snapshot.data != null) {
                      distanceText =
                          '${snapshot.data!.toStringAsFixed(2)} ${'KM'.tr()}';
                    } else {
                      distanceText =
                          '0 ${'KM'.tr()}'; // Default if location off or station has no coordinates
                    }

                    return Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/feed/layer1.svg',
                          width: 13,
                          height: 13,
                        ),
                        kWidth16,
                        textWidget(
                          text: distanceText,
                          fontWeight: FontWeight.w300,
                        ),
                      ],
                    );
                  },
                ),

                GestureDetector(
                  onTap: () async {
                    final lat =
                        double.tryParse((station?.latitude ?? '').toString());
                    final lng =
                        double.tryParse((station?.longitude ?? '').toString());

                    if (lat == null || lng == null) {
                      Fluttertoast.showToast(msg: "Invalid location data");
                      return;
                    }

                    final url =
                        "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url),
                          mode: LaunchMode.externalApplication);
                    } else {
                      Fluttertoast.showToast(msg: "map_error".tr());
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundYellow,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.backgroundYellow.withOpacity(0.5),
                          blurRadius: 15,
                          offset: const Offset(0, 0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/svg/feed/map.svg'),
                        // kWidth10,
                        SizedBox(
                          width: 6,
                        ),
                        textWidget(text: 'Map', color: Colors.white),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    },
  );
}

CustomText textWidget(
    {required String text,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color? color}) {
  return CustomText(
      color: color,
      text: text,
      fontWeight: fontWeight,
      fontFamily: isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
      fontSize: fontSize);
}
