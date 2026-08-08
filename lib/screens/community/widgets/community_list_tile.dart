import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/image_network_extension_method.dart';
import 'package:ufc_mobile/global/util/navigation/navigation.dart';

class CustomCommunityTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool showArrow;
  final String? image;
  final bool fromChat;
  const CustomCommunityTile(
      {super.key,
      required this.title,
      required this.subTitle,
      this.showArrow = false,
      required this.image,
      this.fromChat = false});

  Widget profile() => Container(
        width: 31,
        height: 31,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xffD9D9D9),
        ),
        child: CachedNetworkImage(
          imageUrl: image ?? '',
          placeholder: loadingPlaceholder,
          errorWidget: newPlaceholder,
          fit: BoxFit.cover,
        ),
      );

  Widget navigationIcon(BuildContext context) => GestureDetector(
      onTap: () => pop(context),
      child: Icon(fromChat ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
          color: Colors.black, size: 20));

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: (isArOrUr) ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: ListTile(
        minLeadingWidth: 10,
        dense: true,
        leading: fromChat
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  navigationIcon(context),
                  kWidth15,
                  profile(),
                ],
              )
            : profile(),
        title: CustomText(
          text: title,
          // fontFamily: 'Graphik Arabic',
          fontFamily:
              isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        subtitle: CustomText(
          text: subTitle,
          fontWeight: FontWeight.w400,
          fontSize: 12,
          // fontFamily: 'Graphik Arabic',
          fontFamily:
              isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
        ),
        trailing: Visibility(
          visible: showArrow && !fromChat,
          child: navigationIcon(context),
        ),
      ),
    );
  }
}
