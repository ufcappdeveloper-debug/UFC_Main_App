import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/extensions/app_svg_images.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/constants/shadows.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/community/community_utils.dart';
import 'package:ufc_mobile/models/community_models/chat_model/attachement_model.dart';
import 'package:ufc_mobile/screens/community/widgets/community_reply_tile.dart';
import 'package:ufc_mobile/screens/community/widgets/message_deleted.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/utils/chat_file_utils.dart';

enum ChatMessageAction {
  reply,
  report,
  edit,
  delete,
}

class CommunityChatTile extends StatelessWidget {
  final int? chatId;
  final Color primaryColorOfChat;
  final Color profileBgColor;

  final String senderName;
  final String message;
  final String? image;
  final String nameInitial;
  final String messageSendDate;
  final String? replyToUserName;
  final String? replyToMessage;

  final Function() onLongPress;
  final Function() onTap;

  final Function() onEditPress;
  final Function() onDeletePress;
  final Function() onReplyPress;
  final Function() onReportPress;
  final Function() onTapOfRepliedMessage;
  final bool visible;
  final bool isSelected;
  final bool isDeletedMessage;
  final bool isRepliedMessage;
  final bool isEdited;
  final ValueNotifier<int?> highlightedMessageId;

  final List<AttachedImageModel>? listOfImages;

  final List<AttachementModel>? listOfAttachments;
  final List<ChatMessageAction> actionList;

  const CommunityChatTile({
    super.key,
    required this.senderName,
    required this.message,
    this.image,
    required this.nameInitial,
    required this.messageSendDate,
    required this.primaryColorOfChat,
    required this.onLongPress,
    required this.onTap,
    required this.visible,
    required this.onEditPress,
    required this.onDeletePress,
    required this.onReplyPress,
    required this.isDeletedMessage,
    required this.isEdited,
    required this.isSelected,
    this.listOfImages,
    required this.onReportPress,
    required this.actionList,
    required this.isRepliedMessage,
    required this.replyToUserName,
    required this.replyToMessage,
    required this.profileBgColor,
    required this.onTapOfRepliedMessage,
    required this.highlightedMessageId,
    required this.chatId,
    required this.listOfAttachments,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: textDirection(context),
      child: Stack(
        children: [
          Padding(
            padding: ksymmetric(12, 15),
            child: InkWell(
              onLongPress: isDeletedMessage ? () {} : onLongPress,
              child: ValueListenableBuilder<int?>(
                builder: (context, value, child) {
                  final isHighlighted = (value == chatId);
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: boRadius(10),
                      color: isHighlighted
                          ? primaryColorOfChat.withOpacity(0.1)
                          : tileColor,
                    ),
                    child: messageWidget(),
                  );
                },
                valueListenable: highlightedMessageId,
              ),
            ),
          ),

          /// ACTIONS
          Positioned(
            right: 15,
            top: 0,
            child: messageActions(),
          )
        ],
      ),
    );
  }

  Widget messageWidget() {
    return Padding(
      padding: ksymmetric(10, 5),
      child: Column(
        children: [
          if (isRepliedMessage && (!isDeletedMessage)) ...[
            CommunityReplyTile(
              onTap: onTapOfRepliedMessage,
              senderName: replyToUserName,
              message: replyToMessage,
            ),
            kHeight2,
          ],
          ListTile(
            onLongPress: isDeletedMessage ? () {} : onLongPress,
            onTap: onTap,
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: profilePicture(),
            title: (isDeletedMessage)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      userNameAndDate(),
                      kHeight5,
                      messageDeleted(padding: ksymmetric(0, 5)),
                    ],
                  )
                : Row(
                    children: [
                      if (isRepliedMessage) ...[
                        Transform.rotate(
                          angle: isArOrUr ? 0 : math.pi,
                          child: SvgPicture.asset(
                            isArOrUr
                                ? AppSvgImages.chatRepliedMessage
                                : AppSvgImages.chatReply,
                            colorFilter: ColorFilter.mode(
                              primaryColorOfChat,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        kWidth10,
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            userNameAndDate(),
                            kHeight10,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Message text
                                messageText(),

                                /// List of documents
                                if (listOfImages != null &&
                                    listOfImages!.isNotEmpty) ...[
                                  kHeight5,
                                  listOfImageDocs()
                                ],

                                if (listOfAttachments != null &&
                                    (listOfAttachments ?? []).isNotEmpty) ...{
                                  listOfAttachmentWidget()
                                }
                              ],
                            ),
                            if (isEdited && !isDeletedMessage) editedText()
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  /// Tile color based on selection and visibility
  Color get tileColor {
    return (isSelected && visible)
        // ignore: deprecated_member_use
        ? primaryColorOfChat.withOpacity(0.1)
        : Colors.transparent;
  }

  /// Text direction based on locale
  ui.TextDirection textDirection(BuildContext context) {
    return (isArOrUr) ? ui.TextDirection.rtl : ui.TextDirection.ltr;
  }

  Widget listOfImageDocs() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: listOfImages!.length,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        String? type = listOfImages?[index].imageUrl?.split('.').lastOrNull;
        return Container(
          width: sWidth(context) * 0.4,
          height: 200,
          padding: kall(10),
          margin: ksymmetric(0, index != 0 ? 5 : 0),
          decoration: BoxDecoration(
            boxShadow: btmSmContainerShadow,
            color: Colors.white,
            borderRadius: boRadius(12),
          ),
          child: ClipRRect(
            borderRadius: boRadius(12),
            child: type == 'jpg' || type == 'jpeg' || type == 'png'
                ? CachedNetworkImage(
                    imageUrl: listOfImages![index].imageUrl!,
                    fit: BoxFit.cover,
                  )
                : Container(),
          ),
        );
      },
    );
  }

  Widget listOfAttachmentWidget() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: listOfAttachments!.length,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        String? fileURl = listOfAttachments?[index].fileUrl ?? '';
        return Container(
          width: sWidth(context) * 0.4,
          height: 200,
          padding: kall(10),
          margin: ksymmetric(0, index != 0 ? 5 : 0),
          decoration: BoxDecoration(
            boxShadow: btmSmContainerShadow,
            color: Colors.white,
            borderRadius: boRadius(12),
          ),
          child: ClipRRect(
            borderRadius: boRadius(12),
            child: ChatFileUtils.getFileScreen(url: fileURl, index: index),
          ),
        );
      },
    );
  }

  Widget messageText() {
    return CustomText(
      text: message,
      fontWeight: FontWeight.w400,
      fontSize: 12,
      // fontFamily: 'Graphik Arabic',
      fontFamily: isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
    );
  }

  /// Edit text
  Widget editedText() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: konlyt(3),
        child: CustomText(
          text: 'edited',
          color: Colors.grey,
          fontSize: 13,
          fontWeight: FontWeight.w300,
          // fontFamily: 'Graphik Arabic',
          fontFamily:
              isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
        ),
      ),
    );
  }

  /// User name and messageSendDate widget
  Widget userNameAndDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: senderName,
          // fontFamily: 'Graphik Arabic',
          fontFamily:
              isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: isRepliedMessage ? primaryColorOfChat : textGrey,
        ),
        CustomText(
          text: messageSendDate,
          // fontFamily: 'Graphik Arabic',
          fontFamily:
              isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
          fontWeight: FontWeight.w300,
          fontSize: 12,
          color: primaryGrey,
        ),
      ],
    );
  }

  /// Profile Picture
  Widget profilePicture() {
    return image != null
        ? CircleAvatar(
            radius: 18,
            backgroundImage: CachedNetworkImageProvider(image!),
          )
        : nameInitial.isNotEmpty
            ? CircleAvatar(
                radius: 18,
                backgroundColor: profileBgColor,
                child: Center(
                  child: CustomText(
                    text: nameInitial,
                    color: Colors.white,
                    fontSize: 20,
                    // fontFamily: 'Graphik Arabic',
                    fontFamily: isEnglish
                        ? AppFontsFamily.english
                        : AppFontsFamily.arabic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : CircleAvatar(
                radius: 18,
                backgroundColor: profileBgColor,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20,
                ),
              );
  }

  /// Message actions widget
  Visibility messageActions() {
    return Visibility(
      visible: (isSelected && visible) ? true : false,
      child: Container(
        padding: ksymmetric(10, 8),
        decoration: BoxDecoration(
          borderRadius: boRadius(25),
          color: primaryColorOfChat,
        ),
        child: Row(
          children:
              actionList.map((action) => actionButton(action: action)).toList(),
        ),
      ),
    );
  }

  Widget actionButton({required ChatMessageAction action}) {
    return Padding(
      padding: khoriz(4),
      child: SizedBox(
        height: 16,
        width: 16,
        child: GestureDetector(
          onTap: onPress(action),
          child: SvgPicture.asset(
            CommunityUtils.iconsForMessageAction(action),
            height: 16,
            width: 16,
          ),
        ),
      ),
    );
  }

  VoidCallback onPress(ChatMessageAction action) {
    switch (action) {
      case ChatMessageAction.reply:
        return onReplyPress;
      case ChatMessageAction.delete:
        return onDeletePress;
      case ChatMessageAction.report:
        return onReportPress;
      case ChatMessageAction.edit:
        return onEditPress;
    }
  }
}
