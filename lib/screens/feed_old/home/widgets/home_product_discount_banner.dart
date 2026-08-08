import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/models/banner_model.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/image_network_extension_method.dart';

class HomeProductDiscountBanner extends StatelessWidget {
  const HomeProductDiscountBanner({super.key, required this.banners});
  final List<BannerModel?> banners;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              height: 120,
              viewportFraction: 1,
              // autoPlay: banners.length > 1 ? true : false,
              enableInfiniteScroll: false),
          // items: dummyBannerItems.map((i) {
          // bool isEven = dummyBannerItems.indexOf(i).isEven;
          items: banners.map((i) {
            bool isEven = banners.indexOf(i).isEven;
            return Container(
                width: size.width,
                margin: const EdgeInsets.all(15),
                height: 120,
                // padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                    color: isEven ? const Color(0xffE8FFCF) : Colors.amber,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 8,
                          color: Colors.grey.withValues(alpha: 0.2))
                    ]),
                child: Stack(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        (isEnglish
                                    ? i!.imageUrlEn
                                    : isArabic
                                        ? i!.imageUrlAr
                                        : i!.imageUrlUr) ==
                                null
                            ? Center(
                                child: SvgPicture.asset(
                                    isEven
                                        ? "assets/images/global/Pattens-Blue-Bg-No-Image-Placeholder.svg"
                                        : "assets/images/global/Fluorescent-Orange-Bg-No-Image-Placeholder.svg",
                                    width: 150),
                              )
                            : Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: imageURL(i),
                                    fit: BoxFit.cover,
                                    // width: 150,
                                    placeholder: loadingPlaceholder,
                                    errorWidget: (context, url, error) =>
                                        Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.image_not_supported,
                                            size: 30,
                                          ),
                                          kWidth5,
                                          // CustomText(text: 'No Image Available')
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    // Expanded(
                    //   flex: 2,
                    //   child:
                    Positioned(
                      bottom: 25,
                      right: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (i.offerAmount != null &&
                              i.offerAmount != 'null' &&
                              i.offerAmount != 'undefined' &&
                              i.offerAmount != "0.00")
                            Container(
                              color: const Color(0xffE8FFCF),
                              child: CustomText(
                                text: i.offerAmount.toString(),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color:
                                    // isEven ?
                                    Colors.black,
                                // : Colors.white,
                              ),
                            ),
                          const SizedBox(height: 3),
                          if (i.offerTitle != null &&
                              i.offerTitle != 'null' &&
                              i.offerTitle != 'undefined' &&
                              i.offerTitle != "0.00")
                            Container(
                              color: const Color(0xffE8FFCF),
                              child: CustomText(
                                text: i.offerTitle.toString(),
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color:
                                    // isEven ?
                                    Colors.black,
                                // : Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // )
                  ],
                ));
          }).toList(),
        ),
        // CircularCarouselIndicator(
        //   selectedIndex: selectedBannerIndex,
        //   carouselLength: [1, 2, 3, 4, 5].length,
        // ),
      ],
    );
  }

  String imageURL(BannerModel? banner) {
    if (isArabic) {
      return banner?.imageUrlAr ??
          banner?.imageUrlEn ??
          banner?.imageUrlUr ??
          '';
    } else if (isUrdu) {
      return banner?.imageUrlUr ??
          banner?.imageUrlEn ??
          banner?.imageUrlAr ??
          '';
    } else {
      return banner?.imageUrlEn ??
          banner?.imageUrlAr ??
          banner?.imageUrlUr ??
          '';
    }
  }
}
