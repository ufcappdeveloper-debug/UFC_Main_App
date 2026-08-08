import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_image.dart';
import 'package:ufc_mobile/global/util/navigation/navigation.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/utils/download_utils.dart';
import 'package:ufc_mobile/screens/pet_veterinary/widgets/darg_down.dart';

// class PreviewImageScreen extends StatefulWidget {
//   const PreviewImageScreen({super.key, required this.tag, required this.image});
//   final Object tag;
//   final String image;

//   @override
//   State<PreviewImageScreen> createState() => _PreviewImageScreenState();
// }

// class _PreviewImageScreenState extends State<PreviewImageScreen> {
//   bool blockScroll = false;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return GestureDetector(
//           onTap: () => pop(context),
//           child: Scaffold(
//             extendBodyBehindAppBar: true,
//             backgroundColor: Colors.black.withValues(alpha: 0.7),
//             body: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Flexible(
//                   child: Hero(
//                     tag: widget.tag,
//                     child: DragDownPop(
//                       onDismiss: blockScroll ? null : () => pop(context),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 5),
//                         child: PinchZoomReleaseUnzoomWidget(
//                           twoFingersOn: () =>
//                               setState(() => blockScroll = true),
//                           twoFingersOff: () => Future.delayed(
//                             PinchZoomReleaseUnzoomWidget.defaultResetDuration,
//                             () => setState(() => blockScroll = false),
//                           ),
//                           child: CustomImage(assetImage: widget.image),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class PreviewImageScreen extends StatefulWidget {
//   const PreviewImageScreen({
//     super.key,
//     required this.tag,
//     required this.imageUrl,
//   });
//   final Object tag;
//   final String imageUrl;

//   @override
//   State<PreviewImageScreen> createState() => _PreviewImageScreenState();
// }

// class _PreviewImageScreenState extends State<PreviewImageScreen> {
//   bool blockScroll = false;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return GestureDetector(
//           onTap: () => pop(context),
//           child: Scaffold(
//             extendBodyBehindAppBar: true,
//             backgroundColor: Colors.black.withValues(alpha: 0.7),
//             body: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Flexible(
//                   child: Hero(
//                     tag: widget.tag,
//                     child: DragDownPop(
//                       onDismiss: blockScroll ? null : () => pop(context),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 5),
//                         child: PinchZoomReleaseUnzoomWidget(
//                           twoFingersOn: () =>
//                               setState(() => blockScroll = true),
//                           twoFingersOff: () => Future.delayed(
//                             PinchZoomReleaseUnzoomWidget.defaultResetDuration,
//                             () => setState(() => blockScroll = false),
//                           ),
//                           child: CustomImage(imageUrl: widget.imageUrl),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 kHeight20,
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       ValueListenableBuilder(
//                         valueListenable: DownloadUtils.isDownloading,
//                         builder: (context, value, _) {
//                           return InkResponse(
//                             onTap: () async {
//                               await DownloadUtils.downloadFile(
//                                 context,
//                                 url: widget.imageUrl,
//                               );
//                             },
//                             highlightColor: Colors.transparent,
//                             splashColor: Colors.grey.withValues(alpha: 0.11),
//                             child: Container(
//                               alignment: Alignment.center,
//                               padding: EdgeInsets.all(11),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: AppColors.primary,
//                               ),
//                               child: value
//                                   ? CupertinoActivityIndicator(
//                                       color: Colors.white,
//                                     )
//                                   : Icon(
//                                       Icons.download_rounded,
//                                       color: Colors.white,
//                                     ),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
class PreviewImageScreen extends StatefulWidget {
  const PreviewImageScreen({
    super.key,
    required this.tag,
    required this.imageUrl,
  });

  final Object tag;
  final String imageUrl;

  @override
  State<PreviewImageScreen> createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen>
    with SingleTickerProviderStateMixin {
  bool blockScroll = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClose(BuildContext context) async {
    await _controller.forward(); // play animation
    pop(context); // dismiss after animation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black.withValues(alpha: 0.7),
      body: Stack(
        children: [
          // Image in the center
          Center(
            child: Hero(
              tag: widget.tag,
              child: DragDownPop(
                onDismiss: blockScroll ? null : () => pop(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: PinchZoomReleaseUnzoomWidget(
                    twoFingersOn: () => setState(() => blockScroll = true),
                    twoFingersOff: () => Future.delayed(
                      PinchZoomReleaseUnzoomWidget.defaultResetDuration,
                      () => setState(() => blockScroll = false),
                    ),
                    child: CustomImage(imageUrl: widget.imageUrl),
                  ),
                ),
              ),
            ),
          ),

          // Close button (simple & animated)
          // Positioned(
          //   top: MediaQuery.of(context).padding.top + 12,
          //   right: 16,
          //   child: GestureDetector(
          //     onTap: () => _handleClose(context),
          //     child: RotationTransition(
          //       turns: Tween(begin: 0.0, end: 0.5) // 180° rotation
          //           .animate(CurvedAnimation(
          //         parent: _controller,
          //         curve: Curves.easeInOut,
          //       )),
          //       child: const Icon(
          //         Icons.close,
          //         color: Colors.white,
          //         size: 28,
          //       ),
          //     ),
          //   ),
          // ),
          // Close button (simple & animated with outline)
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: GestureDetector(
              onTap: () => _handleClose(context),
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: 0.5) // 180° rotation
                    .animate(CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeInOut,
                )),
                child: Stack(
                  alignment: Alignment.center,
                  children: const [
                    // Black outline (slightly bigger)
                    Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 32, // slightly larger to act as border
                    ),
                    // Foreground white icon
                    Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Download button (bottom-right corner)
          Positioned(
            bottom: 30,
            right: 20,
            child: ValueListenableBuilder(
              valueListenable: DownloadUtils.isDownloading,
              builder: (context, value, _) {
                return InkResponse(
                  onTap: () async {
                    await DownloadUtils.downloadFile(
                      context,
                      url: widget.imageUrl,
                    );
                  },
                  highlightColor: Colors.transparent,
                  splashColor: Colors.grey.withValues(alpha: 0.11),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(11),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: value
                        ? const CupertinoActivityIndicator(color: Colors.white)
                        : const Icon(Icons.download_rounded,
                            color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
