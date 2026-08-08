import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/home/widgets/nearby_station_widget.dart';
import 'package:ufc_mobile/screens/feed_old/stations/stations_page.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class HomePickupSection extends StatelessWidget {
  const HomePickupSection({
    super.key,
    required this.tabController,
  });
  final TabController? tabController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomText(
                    text: 'Pickup',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      // tabController?.animateTo(3);
                      // if (AppConfig.isProduction) {
                      //   tabController?.animateTo(3);
                      // } else {
                      //   Navigator.of(context).push(
                      //     MaterialPageRoute(
                      //       builder: (context) => StationsPage(
                      //         tabController: tabController,
                      //         scrollController: ScrollController(),
                      //       ),
                      //     ),
                      //   );
                      // }

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StationsPage(
                            tabController: tabController,
                            scrollController: ScrollController(),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomText(
                          text: 'View all',
                          fontSize: 14,
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          size: 12,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              CustomText(
                text: "Select near by station",
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xffCFCFCF),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: (Platform.isIOS) ? 40 : 0),
          child: const NearbyStationWidget(),
        ),
      ],
    );
  }
}
