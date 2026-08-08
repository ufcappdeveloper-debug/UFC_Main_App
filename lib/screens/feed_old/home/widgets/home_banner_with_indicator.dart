import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/models/banner_model.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/circular_carousel_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/image_network_extension_method.dart';

class HomeBannerWithIndicator extends StatefulWidget {
  const HomeBannerWithIndicator({super.key, required this.bannerBig});
  final List<BannerModel>? bannerBig;

  @override
  State<HomeBannerWithIndicator> createState() =>
      _HomeBannerWithIndicatorState();
}

class _HomeBannerWithIndicatorState extends State<HomeBannerWithIndicator> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              height: 210,
              viewportFraction: 1,
              // autoPlay: ((widget.bannerBig?.length ?? 1) > 1) ? true : false,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  selectedIndex = index;
                });
              }),
          // items: [1, 2, 3].map((i) {
          items: widget.bannerBig?.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Stack(
                    children: (isEnglish
                                ? i.imageUrlEn
                                : isArabic
                                    ? i.imageUrlAr
                                    : i.imageUrlUr) ==
                            null
                        ? [
                            Center(
                              child: SvgPicture.asset(
                                "assets/images/global/White-Bg-No-Image-Placeholder.svg",
                                fit: BoxFit.contain,
                              ),
                            )
                          ]
                        : [
                            // Image.asset(
                            //     'assets/images/home/banner_sample.png'),
                            Center(
                              child: CachedNetworkImage(
                                imageUrl: (isEnglish
                                    ? i.imageUrlEn
                                    : isArabic
                                        ? i.imageUrlAr
                                        : i.imageUrlUr)!,
                                fit: BoxFit.cover,
                                placeholder: loadingPlaceholder,
                                errorWidget: (context, url, error) => Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.image_not_supported),
                                      kWidth5,
                                      // CustomText(text: 'No Image Available')
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (i.offerAmount != null &&
                                          i.offerAmount != 'null' &&
                                          i.offerAmount != 'undefined' &&
                                          i.offerAmount != "0.00")
                                        Container(
                                          color: Colors.orange[100],
                                          child: CustomText(
                                            text: i.offerAmount.toString(),
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      if (i.offerTitle != null &&
                                          i.offerTitle != 'null' &&
                                          i.offerTitle != 'undefined' &&
                                          i.offerTitle != '0.00')
                                        Container(
                                          color: Colors.orange[100],
                                          child: CustomText(
                                            text: i.offerTitle.toString(),
                                            fontSize: 20,
                                          ),
                                        ),
                                    ],
                                  ),
                                ))
                          ],
                  ),
                );
              },
            );
          }).toList(),
        ),
        CircularCarouselIndicator(
          selectedIndex: selectedIndex,
          carouselLength: widget.bannerBig?.length ?? 0,
        ),
      ],
    );
  }
}
