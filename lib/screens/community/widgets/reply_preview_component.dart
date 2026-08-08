import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/models/community_models/chat_model/community_chat_model.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/community/community_utils.dart';

class ReplyPreviewComponent extends StatefulWidget {
  final CommunityChatModel? chat;
  final List<List<String>> paths;
  final int selectedInd;
  final VoidCallback onClose;
  final Color primaryColor;
  const ReplyPreviewComponent({
    super.key,
    required this.chat,
    required this.paths,
    required this.selectedInd,
    required this.onClose,
    required this.primaryColor,
  });

  @override
  State<ReplyPreviewComponent> createState() => _ReplyPreviewComponentState();
}

class _ReplyPreviewComponentState extends State<ReplyPreviewComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: sWidth(context),
      padding: kall(10),
      child: Container(
        padding: ksymmetric(10, 5),
        decoration: BoxDecoration(
          borderRadius: boRadius(12),
          color: cream,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: CommunityUtils.senderName(widget.chat),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                InkWell(
                  onTap: widget.onClose,
                  child: Icon(
                    Icons.close,
                    color: textGrey,
                    size: 16,
                    weight: 8,
                  ),
                )
              ],
            ),
            kHeight15,
            widget.chat?.message != null
                ? CustomText(
                    text: widget.chat?.message ?? '',
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: textGrey,
                  )
                : isPathAvailable()
                    ? widget.paths[widget.selectedInd][1] == 'png' ||
                            widget.paths[widget.selectedInd][1] == 'jpeg' ||
                            widget.paths[widget.selectedInd][1] == 'jpg'
                        ? CachedNetworkImage(
                            imageUrl: widget.paths[widget.selectedInd][0],
                            width: 40,
                            height: 40,
                          )
                        : Padding(
                            padding: konlyt(5),
                            child: SvgPicture.asset(
                              'assets/svg/global/file.svg',
                              color: widget.primaryColor,
                            ),
                          )
                    : SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  bool isPathAvailable() {
    return widget.paths.isNotEmpty;
  }
}
