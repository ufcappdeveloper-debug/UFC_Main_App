import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class ShimmerHomePage extends StatelessWidget {
  const ShimmerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.all(15),
                  // height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/home/notification.png',
                          height: 20),
                      const SizedBox(width: 15),
                      Expanded(
                          child: IgnorePointer(
                        ignoring: true,
                        child: Container(
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                width: 1,
                                color: const Color(0xffD9D9D9),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 9),
                                  child: Image.asset(
                                      'assets/images/home/search.png',
                                      height: 15,
                                      width: 15),
                                ),
                                CustomText(
                                  text: 'Search',
                                  fontSize: 12,
                                  color: const Color(0xffD9D9D9),
                                ),
                              ],
                            )),
                      )),
                      const SizedBox(width: 15),
                      Image.asset('assets/images/navigation/categories.png',
                          height: 20),
                    ],
                  )),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                height: 210,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              customProductDiscountBanner(),

              const SizedBox(height: 20),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomText(
                  text: 'Order Now',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    ...[1, 2, 3].map(
                      (item) => Container(
                        width: 220,
                        height: 105,
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: const Color(0xFFFFF9EA),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 8,
                                  color: Colors.grey.withValues(alpha: 0.2))
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    CustomText(
                      text: 'Top of the Week',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    const Spacer(),
                    CustomText(
                      text: 'View all→',
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                  height: 265,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 160,
                        height: 235,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 20,
                                  offset: Offset(0, 4),
                                  color: Color.fromRGBO(0, 0, 0, 0.06))
                            ]),
                      );
                    },
                  )),
              const SizedBox(height: 15),
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
                        CustomText(
                          text: 'View all→',
                          fontSize: 14,
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
              // const NearbyStationWidget(),
              const SizedBox(height: 15),
              Container(
                  height: kBottomNavigationBarHeight,
                  color: Colors.transparent),
            ]),
      ),
    );
  }

  Column customProductDiscountBanner() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(15),
          height: 120,
          // padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    blurRadius: 8, color: Colors.grey.withValues(alpha: 0.2))
              ]),
        ),

        // CircularCarouselIndicator(
        //   selectedIndex: selectedBannerIndex,
        //   carouselLength: [1, 2, 3, 4, 5].length,
        // ),
      ],
    );
  }
}

int categoryPage = 1;
