import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/utils/custome_video_player.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/utils/download_utils.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/util/navigation/navigation.dart';

class PreviewVideoScreen extends StatefulWidget {
  const PreviewVideoScreen({
    super.key,
    required this.tag,
    required this.videoUrl,
  });
  final Object tag;
  final String videoUrl;

  @override
  State<PreviewVideoScreen> createState() => _PreviewVideoScreenState();
}

class _PreviewVideoScreenState extends State<PreviewVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () => pop(context),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.black.withValues(alpha: 0.7),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Hero(
                    tag: widget.tag,
                    child: CustomVideoPlayer(
                      hidePadding: true,
                      videoUrl: widget.videoUrl,
                    ),
                  ),
                ),
                kHeight20,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: DownloadUtils.isDownloading,
                        builder: (context, value, _) {
                          return InkResponse(
                            onTap: () async {
                              await DownloadUtils.downloadFile(
                                context,
                                url: widget.videoUrl,
                              );
                            },
                            highlightColor: Colors.transparent,
                            splashColor: Colors.grey.withValues(alpha: 0.11),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(11),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                              child: value
                                  ? CupertinoActivityIndicator(
                                      color: Colors.white,
                                    )
                                  : Icon(
                                      Icons.download_rounded,
                                      color: Colors.white,
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
