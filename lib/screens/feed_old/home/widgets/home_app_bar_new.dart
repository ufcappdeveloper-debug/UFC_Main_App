import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/screens/feed_old/home/pages/home_page.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

class HomeAppBarNew extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBarNew(
      {super.key,
      this.widget,
      this.stationName,
      this.tabBarController,
      this.backgroundColors,
      this.showTabs = true,
      this.onTabSelected});

  final HomePage? widget;
  final String? stationName;
  final Function(int)? onTabSelected;

  final TabController? tabBarController;
  final List<Color>? backgroundColors;
  final bool showTabs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Directionality(
      textDirection: (isArOrUr) ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: backgroundColors != null && backgroundColors!.length >= 2
                ? backgroundColors!
                : [
                    const Color(0xFFD9F2CE),
                    const Color(0xFFF7FCF1),
                  ],
          ),
        ),
        child: Stack(children: [
          Image.asset("assets/svg/top_bar/backgrounds.png",
              width: double.infinity, fit: BoxFit.cover),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 100),
              if (showTabs && tabBarController != null)
                TabBar(
                  onTap: (int index) {
                    onTabSelected?.call(index); // trigger callback
                    tabBarController?.animateTo(index);
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                  unselectedLabelColor: Colors.amber,
                  isScrollable: false,
                  indicatorColor: Colors.transparent,
                  controller: tabBarController,
                  labelColor: Colors.black,
                  tabs: [
                    buildTab(
                        context,
                        "Green",
                        0,
                        tabBarController!,
                        [primaryColor],
                        'DM Sans',
                        FontWeight.w600,
                        18,
                        null,
                        null),
                    buildTab(context, "", 1, tabBarController!,
                        [Color(0xff0095FF)], null, null, null, "", ""),
                    buildTab(
                      context,
                      "farm",
                      2,
                      tabBarController!,
                      [Color(0xff2BB579)],
                      'Lobster',
                      FontWeight.w400,
                      25,
                      null,
                      null,
                    ),
                    buildTab(
                        context,
                        "Com\nmu\nnity",
                        3,
                        tabBarController!,
                        [Color(0xff9D4EDD)],
                        'Poppins',
                        FontWeight.w600,
                        16,
                        null,
                        null),
                  ],
                ),
            ],
          ),
        ]),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 140);
}

Widget buildTab(
  BuildContext context,
  String title,
  int index,
  TabController tabBarController,
  List<Color> tabColors,
  String? fontFamily,
  FontWeight? fontWeight,
  double? fontSize,
  String? imageEnglish,
  String? imageArabic,
) {
  bool isSelected = tabBarController.index == index;

  return index == 3 && isSelected
      ? RotatedBox(
          quarterTurns: 1,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationX((isArOrUr) ? math.pi : 0),
            child: ChatBubble(
              clipper: ChatBubbleClipper4(
                  type: BubbleType.sendBubble, offset: 10, radius: 5),
              alignment: Alignment.bottomLeft,
              elevation: 0,
              backGroundColor: Color(0XFF9D4EDD),
              margin: const EdgeInsets.all(0),
              child: Container(
                  height: 93,
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.115),
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY((isArOrUr) ? math.pi : 0),
                      child: (isArOrUr)
                          ? Image.asset(
                              'assets/svg/top_bar/community_arabic.png',
                              height: 50,
                              color: Colors.white,
                            )
                          : Image.asset(
                              'assets/svg/top_bar/community_english.png',
                              height: 50,
                              color: Colors.white,
                              fit: BoxFit.fitHeight,
                            ),
                    ),
                  )),
            ),
          ),
        )
      : index == 3
          ? RotatedBox(
              quarterTurns: 1,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationX((isArOrUr) ? math.pi : 0),
                child: ChatBubble(
                  clipper: ChatBubbleClipper4(
                      type: BubbleType.sendBubble, offset: 10, radius: 5),
                  alignment: Alignment.center,
                  elevation: 0,
                  backGroundColor: Colors.white,
                  margin: const EdgeInsets.all(0),
                  child: Container(
                    height: 93,
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.115),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY((isArOrUr) ? math.pi : 0),
                        child: (isArOrUr)
                            ? Image.asset(
                                'assets/svg/top_bar/community_arabic.png',
                                height: 50,
                              )
                            : Image.asset(
                                'assets/svg/top_bar/community_english.png',
                                height: 50,
                                fit: BoxFit.fitHeight,
                              ),
                      ),
                    ),
                  ),
                ),
              ))
          : AnimatedContainer(
              width: 120,
              height: 74,
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/svg/top_bar/background.svg")),
                color: isSelected ? tabColors[0] : Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(children: [
                index == 2 && isSelected
                    ? Image.asset(
                        "assets/svg/top_bar/backgrounds.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : index == 2
                        ? Image.asset(
                            "assets/svg/top_bar/backgrounds.png",
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : SizedBox(),
                Center(
                    child: (index == 0 && isSelected)
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: (isArOrUr)
                                ? Image.asset(
                                    'assets/svg/top_bar/ufc_arabic.png',
                                    color: Colors.white,
                                  )
                                : Image.asset(
                                    'assets/svg/top_bar/white_ufc.png',
                                    color: Colors.white,
                                  ))
                        : (index == 0)
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: (isArOrUr)
                                    ? Image.asset(
                                        'assets/svg/top_bar/ufc_arabic.png',
                                      )
                                    : Image.asset(
                                        'assets/svg/top_bar/ufc_logo_new.png',
                                      ))
                            : (index == 1 && isSelected)
                                ? Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: isArOrUr
                                        ? Image.asset(
                                            'assets/svg/top_bar/vet_arabic.png',
                                            color: Colors.white)
                                        : Image.asset(
                                            'assets/svg/top_bar/vet_english.png',
                                            color: Colors.white),
                                  )
                                : (index == 1)
                                    ? Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: isArOrUr
                                            ? Image.asset(
                                                'assets/svg/top_bar/vet_arabic.png',
                                              )
                                            : Image.asset(
                                                'assets/svg/top_bar/vet_english.png',
                                              ),
                                      )
                                    : (index == 2 && isSelected)
                                        ? Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: isArOrUr
                                                ? Image.asset(
                                                    'assets/svg/top_bar/farm_arabic.png',
                                                    color: Colors.white)
                                                : Image.asset(
                                                    'assets/svg/top_bar/farm_english.png',
                                                    color: Colors.white),
                                          )
                                        : (index == 2)
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: isArOrUr
                                                    ? Image.asset(
                                                        'assets/svg/top_bar/farm_arabic.png',
                                                      )
                                                    : Image.asset(
                                                        'assets/svg/top_bar/farm_english.png',
                                                      ),
                                              )
                                            : (index == 3 && isSelected)
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            top: 10,
                                                            bottom: 10),
                                                    child: isArOrUr
                                                        ? Image.asset(
                                                            'assets/svg/top_bar/community_arabic.png',
                                                            color: Colors.white)
                                                        : Row(
                                                            children: [
                                                              Image.asset(
                                                                  'assets/svg/top_bar/community_english.png',
                                                                  color: Colors
                                                                      .white),
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  SizedBox(
                                                                      height:
                                                                          24),
                                                                ],
                                                              )
                                                            ],
                                                          ))
                                                : (index == 3)
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: isArOrUr
                                                            ? Row(
                                                                children: [
                                                                  Image.asset(
                                                                    'assets/svg/top_bar/community_arabic.png',
                                                                  ),
                                                                ],
                                                              )
                                                            : Row(
                                                                children: [
                                                                  Image.asset(
                                                                    'assets/svg/top_bar/community_english.png',
                                                                  ),
                                                                ],
                                                              ))
                                                    : Text(
                                                        title,
                                                        style: TextStyle(
                                                            fontSize: fontSize,
                                                            color: isSelected
                                                                ? Colors.white
                                                                : tabColors[0],
                                                            fontWeight:
                                                                fontWeight,
                                                            fontFamily:
                                                                fontFamily),
                                                      )),
              ]));
}
