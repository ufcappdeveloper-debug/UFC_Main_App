// import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart' as tr;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/riverpod/state.dart';
import 'package:ufc_mobile/screens/feed_old/favorite/pages/favorite_screen.dart';
import 'package:ufc_mobile/screens/feed_old/home/pages/home_page.dart';
import 'package:ufc_mobile/screens/feed_old/home/widgets/station_label_text.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, required this.widget, this.stationName});

  final HomePage widget;
  final String? stationName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider).cartItems;
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(children: [
          AppBar(
            automaticallyImplyLeading: true,
            shadowColor: Colors.black.withValues(alpha: 0.3),
            title: SizedBox(
                height: 50,
                child:
                    Image.asset('assets/images/home/UFlogo 1.png', height: 35)),
            elevation: 8,
            toolbarHeight: 80,
            backgroundColor: Colors.white,
            actions: [
              // if (!AppConfig.isProduction)
              InkWell(
                onTap: () => widget.tabController?.animateTo(3),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Image.asset(
                  'assets/images/home/pet.png',
                  height: 20,
                  width: 20,
                ),
              ),
              const SizedBox(width: 18),
              InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoriteScreen(),
                    )),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Image.asset(
                  'assets/images/home/heart.png',
                  height: 20,
                  width: 20,
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => widget.tabController?.animateTo(2),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/home/home_cart.png',
                        width: 20,
                        height: 20,
                      ),
                      if (cartItems.isNotEmpty)
                        Positioned(
                          top: 25,
                          right: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: CustomText(
                              text: cartItems.length.toString(),
                              fontSize: 9,
                              color: Colors.white,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          Positioned(
            bottom: 5,
            right: 10,
            child: StationLabelText(
                stationName: stationName ?? "Unknown Station".tr()),
          ),
        ]));
  }

  @override
  Size get preferredSize => const Size(double.infinity, 80);
}
