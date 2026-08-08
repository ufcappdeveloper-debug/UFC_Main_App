import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/home/widgets/feed_home_header.dart';

Widget buildFeedHeader({bool isCategoryScreen = false}) {
  return BlocBuilder<AuthCubit, AuthState>(
    builder: (context, state) {
      final authCubit = context.read<AuthCubit>();
      final UserModel? user = authCubit.currentUser;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FeedHomeHeaderComponent(
          user: user,
          isCategoryScreen: isCategoryScreen,
        ),
      );
    },
  );
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
  final isArOrUr = Localizations.localeOf(context).languageCode == 'ar';

  double tabWidth = (MediaQuery.of(context).size.width - 56) / 4;
  final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

  return (index == 3 && isSelected && isChannelMode)
      ? AnimatedContainer(
          width: tabWidth,
          height: isChannelMode ? 35 : 74,
          duration: Duration(milliseconds: 450),
          curve: Curves.easeInOutCubic,
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
              width: tabWidth,
              height: isChannelMode ? 35 : 74,
              duration: Duration(milliseconds: 450),
              curve: Curves.easeInOutCubic,
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
              ? SizedBox(
                  width: tabWidth,
                  child: RotatedBox(
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
                        child: SizedBox.expand(
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
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        )),
                      ),
                    ),
                  ))
              : index == 3
                  ? SizedBox(
                      width: tabWidth,
                      child: RotatedBox(
                          quarterTurns: 1,
                          child: Transform(
                            alignment: Alignment.center,
                            transform:
                                Matrix4.rotationX(isArOrUr ? math.pi : 0),
                            child: ChatBubble(
                              clipper: ChatBubbleClipper4(
                                  type: BubbleType.sendBubble,
                                  offset: 10,
                                  radius: 5),
                              alignment: Alignment.center,
                              elevation: 0,
                              backGroundColor: Colors.white,
                              margin: const EdgeInsets.all(0),
                              child: SizedBox.expand(
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(
                                        isArOrUr ? math.pi : 0),
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
                                            fit: BoxFit.contain,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          )))
                  : AnimatedContainer(
                      width: tabWidth,
                      height: isChannelMode ? 35 : 74,
                      duration: Duration(milliseconds: 450),
                      curve: Curves.easeInOutCubic,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/svg/top_bar/background.svg")),
                        color: isSelected ? tabColors[0] : Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Stack(children: [
                        if (index == 2)
                          Image.asset(
                            "assets/svg/top_bar/backgrounds.png",
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        Center(
                            child: (index == 0 && isSelected)
                                ? Padding(
                                    padding: EdgeInsets.all(
                                        isChannelMode ? 8.0 : 14.0),
                                    child: isArOrUr
                                        ? Image.asset(
                                            isChannelMode
                                                ? 'assets/images/app_bar/ufc_arabic.png'
                                                : 'assets/svg/top_bar/ufc_new_white_ararabic.png',
                                            color: Colors.white,
                                          )
                                        : Image.asset(
                                            isChannelMode
                                                ? 'assets/images/app_bar/ufc_eng.png'
                                                : 'assets/svg/top_bar/ufc_new_white.png',
                                            color: Colors.white,
                                          ))
                                : (index == 0)
                                    ? Padding(
                                        padding: EdgeInsets.all(
                                            isChannelMode ? 8.0 : 14.0),
                                        child: isArOrUr
                                            ? Image.asset(
                                                isChannelMode
                                                    ? 'assets/images/app_bar/ufc_arabic.png'
                                                    : 'assets/svg/top_bar/ufc_new_arabic.png',
                                              )
                                            : Image.asset(
                                                isChannelMode
                                                    ? 'assets/images/app_bar/ufc_eng.png'
                                                    : 'assets/svg/top_bar/ufc_new.png',
                                              ))
                                    : (index == 1 && isSelected)
                                        ? Padding(
                                            padding: EdgeInsets.all((isTablet &&
                                                    isEnglish &&
                                                    !isChannelMode)
                                                ? 18.0
                                                : 10.0),
                                            child: isArOrUr
                                                ? Image.asset(
                                                    isChannelMode
                                                        ? 'assets/images/app_bar/vet_arabic.png'
                                                        : 'assets/svg/top_bar/newVetArabic.png',
                                                    color: Colors.white)
                                                : Image.asset(
                                                    isChannelMode
                                                        ? 'assets/images/app_bar/vet_eng.png'
                                                        : 'assets/svg/top_bar/vet_english.png',
                                                    color: Colors.white),
                                          )
                                        : (index == 1)
                                            ? Padding(
                                                padding: EdgeInsets.all(
                                                    (isTablet &&
                                                            isEnglish &&
                                                            !isChannelMode)
                                                        ? 18.0
                                                        : 10.0),
                                                child: isArOrUr
                                                    ? Image.asset(
                                                        isChannelMode
                                                            ? 'assets/images/app_bar/vet_arabic.png'
                                                            : 'assets/svg/top_bar/newVetArabic.png',
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
                                                        : isArOrUr
                                                            ? EdgeInsets.all(
                                                                isTablet
                                                                    ? 20.0
                                                                    : 8.0)
                                                            : const EdgeInsets
                                                                .all(20.0),
                                                    child: isArOrUr
                                                        ? Image.asset(
                                                            'assets/svg/top_bar/farm_topbar_big.png',
                                                            color: Colors.white,
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
                                                            : isArOrUr
                                                                ? EdgeInsets.all(
                                                                    isTablet
                                                                        ? 20.0
                                                                        : 8.0)
                                                                : const EdgeInsets
                                                                    .all(20.0),
                                                        child: isArOrUr
                                                            ? Image.asset(
                                                                'assets/svg/top_bar/farm_topbar_big.png',
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
