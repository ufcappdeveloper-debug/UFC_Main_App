import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/station/station_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_grey_divider.dart';
import 'package:ufc_mobile/global/util/station/station_utils.dart';

class EditProfileChangePreferredStationSection extends StatelessWidget {
  const EditProfileChangePreferredStationSection({
    super.key,
    required this.preferredShopDetails,
    required this.onEditPreferredStationPressed,
  });
  final StationModel? preferredShopDetails;
  final VoidCallback onEditPreferredStationPressed;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CustomText(
                text: "Preferred Station".tr(),
                fontSize: 16,
                fontWeight: FontWeight.w500),
            InkWell(
                onTap: onEditPreferredStationPressed,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: SvgPicture.asset(
                    "assets/images/profile/edit_profile_icon.svg")),
          ]),
          const CustomGreyDivider(),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: CustomText(
                  text: "Store:".tr(),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF898989),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: CustomText(
                    text: StationUtils.stationName(preferredShopDetails),
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.03),
        ],
      );
}
