import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/station/station_model.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../global/util/open_map_widget.dart';

class StationAbout extends StatefulWidget {
  final StationModel station;
  const StationAbout({super.key, required this.station});

  @override
  State<StationAbout> createState() => _StationAboutState();
}

class _StationAboutState extends State<StationAbout> {
  String formatTime(String inputTime) {
    final inputFormat = DateFormat('HH:mm:ss', 'en');
    final outputFormat = DateFormat(
        'hh:mm a',
        isArabic
            ? 'ar_SA'
            : isUrdu
                ? 'ur'
                : 'en_US');
    final time = inputFormat.parse(inputTime);
    return outputFormat.format(time);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        kHeight20,
        aboutTile(
            Icons.description,
            "Description",
            (isEnglish
                    ? widget.station.descriptionEn
                    : isArabic
                        ? widget.station.descriptionAr
                        : widget.station.descriptionUr) ??
                "No Description".tr()),
        const Divider(
          color: primaryGrey,
          indent: 27,
          endIndent: 27,
        ),
        kHeight20,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    color: primaryColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomText(
                    text: "Station timing",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              (widget.station.timings == null ||
                      widget.station.timings!.isEmpty)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60.0),
                      child: CustomText(
                        text: "No Timings Available",
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 15,
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.station.timings?.length ?? 0,
                      itemBuilder: (context, index) {
                        final timeData = widget.station.timings![index];
                        final String openTime = timeData.openingTime == null ||
                                timeData.openingTime!.isEmpty
                            ? ""
                            : formatTime(timeData.openingTime ?? "");
                        final String closeTime = timeData.closingTime == null ||
                                timeData.closingTime!.isEmpty
                            ? ""
                            : formatTime(timeData.closingTime ?? "");
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60.0),
                          child: Row(
                            children: [
                              CustomText(
                                text: (isEnglish
                                        ? timeData.dayInTheWeek
                                        : isArabic
                                            ? timeData.dayInTheWeekAr
                                            : timeData.dayInTheWeekUr)
                                    .toString(),
                                overflow: TextOverflow.ellipsis,
                                notTranslated: true,
                                fontSize: 15,
                              ),
                              CustomText(
                                text: " $openTime - $closeTime ",
                                overflow: TextOverflow.ellipsis,
                                notTranslated: true,
                                fontSize: 15,
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => kHeight10,
                    ),
              kHeight15,
            ],
          ),
        ),
        // TODO: until when we can change contact info from dashboard
        // const Divider(
        //   color: primaryGrey,
        //   indent: 27,
        //   endIndent: 27,
        // ),
        // kHeight20,
        // aboutTile(Icons.phone, "Contact",
        //     "${widget.station.contactName ?? ''} \n ${widget.station.contactDesignation ?? ''}"),
        kHeight20,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomButton(
              radius: 4,
              height: 45,
              width: 120,
              title: "E-mail",
              color: widget.station.contactEmail == null ||
                      widget.station.contactEmail!.isEmpty
                  ? Colors.grey
                  : null,
              onTap: widget.station.contactEmail == null ||
                      widget.station.contactEmail!.isEmpty
                  ? null
                  : () async {
                      String? encodeQueryParameters(
                          Map<String, String> params) {
                        return params.entries
                            .map((MapEntry<String, String> e) =>
                                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                            .join('&');
                      }

                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: widget.station.contactEmail ?? '',
                        query: encodeQueryParameters(<String, String>{
                          'subject': 'UFC Mobile',
                        }),
                      );

                      launchUrl(emailLaunchUri);
                    },
            ),
            CustomButton(
              radius: 4,
              height: 45,
              width: 120,
              title: "Call",
              color: widget.station.contactNumber == null ||
                      widget.station.contactNumber!.isEmpty
                  ? Colors.grey
                  : null,
              onTap: widget.station.contactNumber == null ||
                      widget.station.contactNumber!.isEmpty
                  ? null
                  : () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: widget.station.contactNumber,
                      );
                      await launchUrl(launchUri,
                          mode: Platform.isIOS
                              ? LaunchMode.externalApplication
                              : LaunchMode.externalNonBrowserApplication);
                    },
            ),
            CustomButton(
              radius: 4,
              height: 45,
              width: 120,
              title: "Open in Map",
              color: (widget.station.latitude == null ||
                      widget.station.longitude == null)
                  ? Colors.grey
                  : null,
              onTap: (widget.station.latitude == null ||
                      widget.station.longitude == null)
                  ? null
                  : () async {
                      openMapsWidget(widget.station, context);
                    },
            )
          ],
        ),
        kHeight30,
      ]),
    );
  }

  Widget aboutTile(
    IconData icon,
    String title,
    String body,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: primaryColor,
              ),
              const SizedBox(
                width: 10,
              ),
              CustomText(
                text: title,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: CustomText(
              text: body.trim().isEmpty ? 'No Info' : body,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
