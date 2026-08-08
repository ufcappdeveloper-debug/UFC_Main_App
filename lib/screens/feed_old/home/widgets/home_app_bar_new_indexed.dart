import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/extensions/app_images.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/riverpod/app_bar/app_bar_mode_riverpod.dart';
import 'package:ufc_mobile/riverpod/app_bar/app_bar_riverpod.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

class HomeAppBarNewIndexed extends ConsumerWidget
    implements PreferredSizeWidget {
  const HomeAppBarNewIndexed({
    super.key,
    this.stationName,
    this.tabBarController,
    this.showTabs = true,
    this.onTabSelected,
    this.currentTabIndex,
    this.appBarHeight = 140,
  });

  final String? stationName;
  final Function(int)? onTabSelected;
  final int? currentTabIndex;
  final TabController? tabBarController;

  final bool showTabs;
  final double appBarHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarMode = ref.watch(appBarModeProvider);
    final home = ref.watch(isHome);
    final isChannelMode = appBarMode == AppBarModeRiverpod.channel;
    if (appBarMode == AppBarModeRiverpod.hidden) {
      return const SizedBox.shrink(); // 👈 nothing rendered
    }

    return Directionality(
      textDirection: (isArOrUr) ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            top: 0,
            left: 0,
            right: 0,
            child: buildBackground(currentTabIndex ?? 0, appBarMode),
          ),

          /// ✅ Overlay text only when index == 0
          if (isHomeIndex && appBarMode == AppBarModeRiverpod.normal)
            Positioned(
              bottom: 80,
              left: 16,
              right: 16,
              child: Text(
                "banner_text".tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 4,
                      color: Colors.black54,
                    )
                  ],
                ),
              ),
            ),

          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                  height: appBarMode == AppBarModeRiverpod.channel ? 70 : 70),
              if (showTabs && tabBarController != null)
                TabBar(
                  onTap: (int index) {
                    onTabSelected?.call(index);
                    tabBarController?.animateTo(index);

                    double height = 300;
                    AppBarModeRiverpod mode = AppBarModeRiverpod.normal;

                    if (index == 0) {
                      final isFeedInHome = home.feed;
                      height = 380;
                      mode = isFeedInHome
                          ? AppBarModeRiverpod.normal
                          : AppBarModeRiverpod.channel;
                    } else if (index == 1) {
                      height = 158;
                      mode = AppBarModeRiverpod.normal;
                    } else if (index == 2) {
                      final isFarmInHome = home.farm;
                      height = isFarmInHome ? 160 : 100;
                      mode = isFarmInHome
                          ? AppBarModeRiverpod.normal
                          : AppBarModeRiverpod.channel;
                    } else if (index == 3) {
                      final isCommunityInHome = home.community;
                      height = isCommunityInHome ? 160 : 100;
                      mode = isCommunityInHome
                          ? AppBarModeRiverpod.normal
                          : AppBarModeRiverpod.channel;
                    } else {
                      return;
                    }

                    ref.read(appBarHeightProvider.notifier).state = height;
                    ref.read(appBarModeProvider.notifier).state = mode;
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                  unselectedLabelColor: Colors.amber,
                  isScrollable: false,
                  indicatorColor: Colors.transparent,
                  controller: tabBarController,
                  labelColor: Colors.black,
                  tabs: [
                    buildTab(context, 0, tabBarController!, [primaryColor],
                        null, null, isChannelMode, 'United Feeds', 'Kanit'),
                    buildTab(
                        context,
                        1,
                        tabBarController!,
                        [PetVeterinaryColors.newPetMainColorVeterinary],
                        null,
                        null,
                        isChannelMode,
                        'Veterinary',
                        'DM Sans'),
                    buildTab(
                        context,
                        2,
                        tabBarController!,
                        [AppColors.farmColor],
                        null,
                        null,
                        isChannelMode,
                        'Farm',
                        'Lobster'),
                    buildTab(context, 3, tabBarController!, [Color(0xff9D4EDD)],
                        null, null, isChannelMode, 'Community', 'Poppins'),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  bool get isHomeIndex {
    return currentTabIndex == 0;
  }

  @override
  Size get preferredSize => Size(double.infinity, appBarHeight);

  Widget buildBackground(int index, AppBarModeRiverpod appBarMode) {
    if (index == 0 && appBarMode == AppBarModeRiverpod.normal) {
      return Image.asset(
        AppImages.feedBackBg,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (index == 0 && appBarMode == AppBarModeRiverpod.channel) {
      return Stack(
        children: [
          Image.asset(
            AppImages.feedBackBg,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.9),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.9],
              ),
            ),
          ),
        ],
      );
    }
    final tabColors = [
      [primaryColor], // Feeds
      [PetVeterinaryColors.newPetMainColorVeterinary], // Vet
      [AppColors.farmColor], // Farm
      [Color(0xff9D4EDD)], // Community
    ];

    final color = tabColors[index][0];

    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.25),
        image: DecorationImage(
          image: const AssetImage("assets/svg/top_bar/backgrounds.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

Widget buildTab(
  BuildContext context,
  int index,
  TabController tabBarController,
  List<Color> tabColors,
  String? imageEnglish,
  String? imageArabic,
  bool isChannelMode,
  String text,
  String? fontFamily,
) {
  bool isSelected = tabBarController.index == index;

  return (index == 3 && isSelected && isChannelMode)
      ? AnimatedContainer(
          width: 120,
          height: isChannelMode ? 35 : 74,
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/svg/top_bar/background.svg")),
            color: isSelected ? tabColors[0] : Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: isChannelMode
                ? const EdgeInsets.all(8.0)
                : const EdgeInsets.all(20.0),
            child: isArOrUr
                ? Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.asset('assets/images/app_bar/com_arabic.png',
                        color: Colors.white),
                  )
                : Image.asset('assets/images/app_bar/com_eng.png',
                    color: Colors.white),
          ),
        )
      : (index == 3 && isChannelMode)
          ? AnimatedContainer(
              width: 120,
              height: isChannelMode ? 35 : 74,
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/svg/top_bar/background.svg")),
                color: isSelected ? tabColors[0] : Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: isChannelMode
                    ? const EdgeInsets.all(8.0)
                    : const EdgeInsets.all(20.0),
                child: isArOrUr
                    ? Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset(
                          imageArabic ?? 'assets/images/app_bar/com_arabic.png',
                        ),
                      )
                    : Image.asset(
                        imageEnglish ?? 'assets/images/app_bar/com_eng.png',
                      ),
              ),
            )
          : index == 3 && isSelected
              ? RotatedBox(
                  quarterTurns: 1,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationX(isArOrUr ? math.pi : 0),
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
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.115),
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Transform(
                              alignment: Alignment.center,
                              transform:
                                  Matrix4.rotationY(isArOrUr ? math.pi : 0),
                              child: isArOrUr
                                  ? Image.asset(
                                      imageArabic ??
                                          'assets/svg/top_bar/community_arabic.png',
                                      height: 50,
                                      color: Colors.white,
                                    )
                                  : Image.asset(
                                      imageEnglish ??
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
                        transform: Matrix4.rotationX(isArOrUr ? math.pi : 0),
                        child: ChatBubble(
                          clipper: ChatBubbleClipper4(
                              type: BubbleType.sendBubble,
                              offset: 10,
                              radius: 5),
                          alignment: Alignment.center,
                          elevation: 0,
                          backGroundColor: Colors.white,
                          margin: const EdgeInsets.all(0),
                          child: Container(
                            height: 93,
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.115),
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Transform(
                                alignment: Alignment.center,
                                transform:
                                    Matrix4.rotationY(isArOrUr ? math.pi : 0),
                                child: isArOrUr
                                    ? Image.asset(
                                        imageArabic ??
                                            'assets/svg/top_bar/community_arabic.png',
                                        height: 50,
                                      )
                                    : Image.asset(
                                        imageEnglish ??
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
                      height: isChannelMode ? 35 : 74,
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/svg/top_bar/background.svg")),
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
                                    child: isArOrUr
                                        ? Image.asset(
                                            isChannelMode
                                                ? 'assets/images/app_bar/ufc_arabic.png'
                                                : 'assets/svg/top_bar/ufc_arabic.png',
                                            color: Colors.white,
                                          )
                                        : Image.asset(
                                            isChannelMode
                                                ? 'assets/images/app_bar/ufc_eng.png'
                                                : 'assets/svg/top_bar/white_ufc.png',
                                            color: Colors.white,
                                          ))
                                : (index == 0)
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: isArOrUr
                                            ? Image.asset(
                                                isChannelMode
                                                    ? 'assets/images/app_bar/ufc_arabic.png'
                                                    : 'assets/svg/top_bar/ufc_arabic.png',
                                              )
                                            : Image.asset(
                                                isChannelMode
                                                    ? 'assets/images/app_bar/ufc_eng.png'
                                                    : 'assets/svg/top_bar/ufc_logo_new.png',
                                              ))
                                    : (index == 1 && isSelected)
                                        ? Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: isArOrUr
                                                ? Image.asset(
                                                    isChannelMode
                                                        ? 'assets/images/app_bar/vet_arabic.png'
                                                        : 'assets/svg/top_bar/vet_arabic.png',
                                                    color: Colors.white)
                                                : Image.asset(
                                                    isChannelMode
                                                        ? 'assets/images/app_bar/vet_eng.png'
                                                        : 'assets/svg/top_bar/vet_english.png',
                                                    color: Colors.white),
                                          )
                                        : (index == 1)
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: isArOrUr
                                                    ? Image.asset(
                                                        isChannelMode
                                                            ? 'assets/images/app_bar/vet_arabic.png'
                                                            : 'assets/svg/top_bar/vet_arabic.png',
                                                      )
                                                    : Image.asset(
                                                        isChannelMode
                                                            ? 'assets/images/app_bar/vet_eng.png'
                                                            : 'assets/svg/top_bar/vet_english.png',
                                                      ),
                                              )
                                            : (index == 2 && isSelected)
                                                ? Padding(
                                                    padding: isChannelMode
                                                        ? const EdgeInsets.all(
                                                            8.0)
                                                        : const EdgeInsets.all(
                                                            20.0),
                                                    child: isArOrUr
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: Image.asset(
                                                                'assets/svg/top_bar/farm_arabic.png',
                                                                color: Colors
                                                                    .white),
                                                          )
                                                        : Image.asset(
                                                            'assets/svg/top_bar/farm_english.png',
                                                            color:
                                                                Colors.white),
                                                  )
                                                : (index == 2)
                                                    ? Padding(
                                                        padding: isChannelMode
                                                            ? const EdgeInsets
                                                                .all(8.0)
                                                            : const EdgeInsets
                                                                .all(20.0),
                                                        child: isArOrUr
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        2.0),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/svg/top_bar/farm_arabic.png',
                                                                ),
                                                              )
                                                            : Image.asset(
                                                                'assets/svg/top_bar/farm_english.png',
                                                              ),
                                                      )
                                                    : Text(
                                                        '',
                                                        style: TextStyle(
                                                          color: isSelected
                                                              ? Colors.white
                                                              : tabColors[0],
                                                        ),
                                                      )),
                      ]));
}
