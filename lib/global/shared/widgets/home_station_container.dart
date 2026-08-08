import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/station/station_model.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

import '../../../screens/feed_old/stations/station_detail_tab_screen.dart';
import '../../util/open_map_widget.dart';

class HomeStationContainer extends StatelessWidget {
  const HomeStationContainer({
    super.key,
    required this.lat,
    required this.long,
    required this.station,
    required this.constraints,
  });
  final double lat;
  final double long;
  final StationModel station;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StationDetailScreen(
              station: station,
            ),
          ),
        );
      },
      child: Container(
        width: 126,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 7.55, vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xffFBFBFB)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: (isEnglish
                      ? station.nameEn
                      : isArabic
                          ? station.nameAr
                          : station.nameUr) ??
                  "",
              fontWeight: FontWeight.w500,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            CustomText(text: station.address ?? " - "),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset('assets/images/home/location.png', height: 20),
                CustomText(
                  text: station.km.toString(),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                CustomText(text: ' km'),
              ],
            ),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(text: 'Order Now', color: primaryColor),
                const Spacer(),
                CustomText(
                  text: isEnglish ? '→' : '←',
                  fontSize: 16,
                  color: primaryColor,
                ),
              ],
            ),
            SizedBox(
              height: 30,
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  openMapsWidget(station, context);
                },
                child: Padding(
                  padding:
                      (Platform.isIOS) ? EdgeInsets.all(6) : EdgeInsets.all(0),
                  child: CustomText(
                    text:
                        constraints.maxWidth > 393 ? 'Open in Map' : 'Open Map',
                    fontSize: 11,
                    color: primaryColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
