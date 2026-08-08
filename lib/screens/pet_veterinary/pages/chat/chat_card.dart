import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_image.dart';
import 'package:ufc_mobile/global/util/exception/app_exception.dart';
import 'package:ufc_mobile/global/util/exception/error_handler.dart';
import 'package:ufc_mobile/global/util/navigation/navigation.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/utils/app_file_picker.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/utils/chat_file_utils.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/chat_message.dart';
import 'package:voice_message_package/voice_message_package.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.chat,
    required this.index,
    this.isCustomer = false,
  });

  final int index;
  final bool isCustomer;
  final ChatMessage chat;

  @override
  Widget build(BuildContext context) {
    final image =
        isCustomer ? chat.senderProfilePicture : chat.senderProfilePicture;
    final message = chat.text;
    final mediaUrl = chat.mediaUrl ?? '';
    final rawDate = chat.createdAt.toString();
    final locale = Localizations.localeOf(context);
    final createAt = formatChatDate(rawDate, locale);
    final mimeType = lookupMimeType(mediaUrl) ?? '';
    final isAudio = mimeType.startsWith('audio/');

    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: isCustomer
              ? AlignmentDirectional.centerEnd
              : AlignmentDirectional.centerStart,
          child: Container(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.85),
            child: Column(
              children: [
                Text(
                  createAt,
                  style: PetVeterinaryFontstyles.poppinsRegularTextStyle12,
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: isCustomer
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    if (!isCustomer)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(111),
                        child: CustomImage(
                          imageUrl: image ?? '',
                          width: 43,
                          height: 43,
                          noImagePlaceholderWidget: Container(
                            width: 43,
                            height: 43,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.gunmetalColor,
                            ),
                            child: Text(
                              "Name"[0],
                              style: TextStyles.textViewRegular16(
                                color: AppColors.platinumColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (!isCustomer) kWidth10,
                    Flexible(
                      child: Container(
                        padding: EdgeInsetsDirectional.only(
                          top: 11,
                          end: 10,
                          start: 12,
                          bottom: 9,
                        ),
                        decoration: BoxDecoration(
                          color: PetVeterinaryColors.lightGreen,
                          borderRadius: BorderRadius.circular(10.25),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (message.isNotEmpty)
                              Text(
                                message,
                                style: PetVeterinaryFontstyles
                                    .poppinsRegularTextStyle13,
                              ),
                            if (mediaUrl.isNotEmpty)
                              if (isAudio)
                                VoiceMessageView(
                                  controller: VoiceController(
                                    audioSrc: mediaUrl,
                                    isFile: false,
                                    maxDuration: const Duration(seconds: 10),
                                    onComplete: () {},
                                    onPause: () {},
                                    onPlaying: () {},
                                    onError: (err) {},
                                  ),
                                  innerPadding: 12,
                                  cornerRadius: 20,
                                  circlesColor:
                                      PetVeterinaryColors.borderLeftColor,
                                  activeSliderColor:
                                      AppColors.semiTransparentBlack,
                                )
                              else
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 209,
                                    maxHeight: 258,
                                  ),
                                  child: GestureDetector(
                                    // onTap: () {
                                    //   Navigator.push(
                                    //     context,
                                    //     opaquePage(
                                    //       PreviewImageScreen(
                                    //         image: mediaUrl,
                                    //         tag: 'mediaImage$index',
                                    //       ),
                                    //     ),
                                    //   );
                                    // },
                                    // child: Hero(
                                    //   tag: 'mediaImage$index',
                                    //   child: CachedNetworkImage(
                                    //     imageUrl: mediaUrl,
                                    //     width: 209,
                                    //     height: 258,
                                    //     fit: BoxFit.cover,
                                    //     placeholder: (context, url) =>
                                    //         Container(
                                    //       color: Colors.grey[300],
                                    //       child: Center(
                                    //           child:
                                    //               CircularProgressIndicator()),
                                    //     ),
                                    //     errorWidget: (context, url, error) =>
                                    //         Icon(Icons.error),
                                    //   ),
                                    // ),
                                    onTap: () {
                                      try {
                                        final screen =
                                            ChatFileUtils.getFileScreen(
                                          url: mediaUrl,
                                          index: index,
                                        );

                                        if (screen == null) {
                                          throw CustomException(
                                            message:
                                                'Unable to open the file. The file type may be unsupported or corrupted.',
                                          );
                                        }

                                        Navigator.push(
                                          context,
                                          opaquePage(screen),
                                        );
                                      } catch (e) {
                                        ErrorHandler.handleError(context, e);
                                      }
                                    },
                                    child: Hero(
                                      tag: 'mediaImage$index',
                                      child: ChatFileUtils.getFileThumbnail(
                                        url: mediaUrl,
                                        size: 40,
                                        color: AppColors.semiTransparentBlack,
                                      ),
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                    if (isCustomer) kWidth10,
                    if (isCustomer)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(111),
                        child: CustomImage(
                          imageUrl: image ?? '',
                          width: 43,
                          height: 43,
                          noImagePlaceholderWidget: Container(
                            width: 43,
                            height: 43,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.gunmetalColor,
                            ),
                            child: Text(
                              "Name"[0],
                              style: TextStyles.textViewRegular16(
                                color: AppColors.platinumColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String formatChatDate(String? rawDate, Locale locale) {
  if (rawDate == null || rawDate.isEmpty) return '';

  try {
    final utcDate = DateTime.parse(rawDate);
    final localDate = utcDate.toLocal();

    final dayName = DateFormat.EEEE(locale.languageCode).format(localDate);
    final time = DateFormat('hh:mm', 'en').format(localDate);

    return '$dayName $time';
  } catch (e) {
    return '';
  }
}
