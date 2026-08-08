import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/station/station_model.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/frozen_glass_container.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/global/util/station/station_utils.dart';
import '../../../global/shared/widgets/custom_widgets/custom_text.dart';
import 'station_about.dart';
import 'station_products.dart';

class StationDetailScreen extends StatefulWidget {
  final StationModel station;
  const StationDetailScreen({super.key, required this.station});

  @override
  State<StationDetailScreen> createState() => _StationDetailScreenState();
}

class _StationDetailScreenState extends State<StationDetailScreen>
    with SingleTickerProviderStateMixin, ScreenEngagementTracker {
  int previousIndex = 0;
  late TabController _controller;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 80,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: const FrozenGlassContainer(
            icon: Icons.arrow_back_ios_rounded,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          SizedBox(
            height: 233,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                widget.station.coverImage != null
                    ? CachedNetworkImage(
                        imageUrl: widget.station.coverImage ?? "",
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return Image.asset(
                            'assets/images/station/station-1.png',
                            fit: BoxFit.cover,
                          );
                        },
                        placeholder: (context, url) {
                          return const Icon(
                            Icons.image,
                            color: primaryColor,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/station/station-1.png',
                        fit: BoxFit.cover,
                      ),
                Positioned(
                    child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                                colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                      Colors.transparent,
                    ])))),
                PositionedDirectional(
                    start: 18,
                    bottom: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: stationName.isEmpty ? " - " : stationName,
                          fontSize: 19,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          text: widget.station.address ?? " - ",
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ],
                    ))
              ],
            ),
          ),
          TabBar(
            controller: _controller,
            isScrollable: false,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: primaryColor,
            unselectedLabelColor: primaryGrey,
            onTap: (index) {
              previousIndex = index;
              _pageController.animateToPage(previousIndex,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn);
            },
            tabs: [
              Tab(
                  height: 50,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: CustomText(
                        text: "Products",
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  )),
              Tab(
                  height: 50,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: CustomText(
                        text: "About",
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  )),
            ],
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                _controller.index = page;
              },
              children: [
                StationProduct(
                  station: widget.station,
                ),
                StationAbout(
                  station: widget.station,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String get stationName {
    return StationUtils.stationName(widget.station);
  }
}
