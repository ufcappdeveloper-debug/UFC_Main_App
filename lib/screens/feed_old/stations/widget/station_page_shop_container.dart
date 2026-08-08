import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/station/station_model.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_image.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/station/station_utils.dart';

class StationPageShopContainer extends StatelessWidget {
  const StationPageShopContainer({
    super.key,
    required this.station,
  });
  final StationModel station;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: boxShadow,
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(10),
          bottomStart: Radius.circular(10),
          bottomEnd: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadiusDirectional.only(
              topStart: Radius.circular(10),
              bottomEnd: Radius.circular(10),
            ),
            child: SizedBox(
              height: 140,
              child: CustomImage(
                imageUrl: station.coverImage,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: StationUtils.stationName(station)),
                const SizedBox(height: 4),
                if (station.address != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: primaryColor,
                      ),
                      CustomText(
                        text: station.address ?? " - ",
                        color: primaryGrey,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
