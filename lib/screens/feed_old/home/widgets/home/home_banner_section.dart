import 'package:flutter/material.dart';
import 'package:ufc_mobile/models/home_model.dart';
import 'package:ufc_mobile/screens/feed_old/home/pages/home_page_search.dart';
import 'package:ufc_mobile/screens/feed_old/home/widgets/home_banner_with_indicator.dart';
import 'package:ufc_mobile/screens/feed_old/home/widgets/home_product_discount_banner.dart';
import 'package:ufc_mobile/screens/feed_old/profile/pages/notification_page.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_search_bar.dart';

class HomeBannerSection extends StatelessWidget {
  const HomeBannerSection({
    super.key,
    required this.homeData,
    required this.tabController,
  });
  final HomeModel? homeData;
  final TabController? tabController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //* Home Search Section
        Container(
          padding: const EdgeInsets.all(15),
          // height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationPage(),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/home/notification.png',
                  height: 20,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePageSearch(),
                      ),
                    );
                  },
                  child: IgnorePointer(
                    ignoring: true,
                    child: CustomSearchBar(
                      readOnly: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              InkWell(
                onTap: () {
                  tabController?.animateTo(1);
                },
                child: Image.asset('assets/images/navigation/categories.png',
                    height: 20),
              ),
            ],
          ),
        ),

        //* Home Main Banner Section
        HomeBannerWithIndicator(bannerBig: homeData?.bannerBig),

        //* Home Product Discount Banner Section
        HomeProductDiscountBanner(banners: homeData?.bannerMini ?? [])
      ],
    );
  }
}
