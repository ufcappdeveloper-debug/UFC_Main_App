import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/riverpod/state.dart';
import 'package:ufc_mobile/screens/feed_old/home/widgets/station_label_text.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class CategoryCustomSearchAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  const CategoryCustomSearchAppBar({
    super.key,
    this.height = 80,
    this.stationName,
    required this.onChanged,
    required this.onHeartPressed,
    required this.searchController,
    required this.onHomeCartPressed,
    required this.onNotificationPressed,
  });

  final double height;
  final String? stationName;
  final Function(String)? onChanged;
  final VoidCallback onHeartPressed;
  final VoidCallback onHomeCartPressed;
  final VoidCallback onNotificationPressed;
  final TextEditingController searchController;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider).cartItems;
    return Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Stack(children: [
          AppBar(
              elevation: 8,
              leadingWidth: 40,
              toolbarHeight: 80,
              backgroundColor: Colors.white,
              shadowColor: const Color(0xffF5F5F5),
              leading: Padding(
                padding: const EdgeInsets.only(left: 18),
                child: InkWell(
                  onTap: onNotificationPressed,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: SvgPicture.asset(
                      "assets/images/global/notification_icon.svg",
                      width: 15.96,
                      height: 19),
                ),
              ),
              title: Container(
                  height: 27,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: const Color(0xFFD9D9D9),
                      ),
                      borderRadius: BorderRadius.circular(36)),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 9),
                        SvgPicture.asset(
                            "assets/images/global/search_icon.svg"),
                        const SizedBox(width: 7),
                        Expanded(
                            child: TextField(
                                maxLength: 35,
                                onChanged: onChanged,
                                controller: searchController,
                                // inputFormatters: <TextInputFormatter>[
                                //   FilteringTextInputFormatter.allow(
                                //       RegExp("[0-9a-zA-Z ]")),
                                // ],
                                decoration: InputDecoration(
                                    isDense: true,
                                    counterText: "",
                                    hintText: "Search".tr(),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(0),
                                    hintStyle: const TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Kanit',
                                        color: Color(0xFFD9D9D9),
                                        fontWeight: FontWeight.w300)))),
                        const SizedBox(width: 7),
                      ])),
              actions: [
                InkWell(
                    onTap: onHeartPressed,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Image.asset('assets/images/home/heart.png',
                        color: const Color(0xFFbdbdbd), height: 20, width: 20)),
                const SizedBox(width: 15),
                // InkWell(
                //     onTap: onHomeCartPressed,
                //     splashColor: Colors.transparent,
                //     highlightColor: Colors.transparent,
                //     child: Image.asset('assets/images/home/home_cart.png',
                //         color: const Color(0xFFbdbdbd), height: 20, width: 20)),
                InkWell(
                  onTap: onHomeCartPressed,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
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
              ]),
          Positioned(
            bottom: 5,
            right: 10,
            child: StationLabelText(
                stationName: stationName ?? "Unknown Station".tr()),
          ),
        ]));
  }
}
