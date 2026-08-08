import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/util/navigation/navigation.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/utils/custom_camera.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';

class ChatFilePicker {
  static Future<double?> getFileSizeInMB(dynamic file) async {
    int fileSizeBytes;

    if (file is File) {
      // Get the size of the file in bytes
      fileSizeBytes = await file.length();
    } else if (file is Uint8List) {
      // Get the size of the Uint8List in bytes
      fileSizeBytes = file.lengthInBytes;
    } else {
      return null;
    }

    // Convert bytes to megabytes
    return fileSizeBytes / (1024 * 1024);
  }

  static Future<List<File>> getImages({bool allowMultiple = false}) async {
    final data = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: allowMultiple,
    );
    if (data != null && data.files.isNotEmpty) {
      return data.files.map((e) => File(e.path!)).toList();
    }
    return [];
  }

  static Future<List<File>> getFileAndDocs({
    bool allowMultiple = false,
    List<String>? allowedExtensions,
  }) async {
    final data = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: allowMultiple,
      allowedExtensions: allowedExtensions ?? ["pdf", "jpg", "png", "jpeg"],
    );
    if (data != null && data.files.isNotEmpty) {
      return data.files.map((e) => File(e.path!)).toList();
    }
    return [];
  }

  static Future<List<File>?> showFilePicker(
    BuildContext context, {
    bool showCamera = false,
    bool allowMultiple = false,
    BoxConstraints? constraints,
  }) async {
    return showCupertinoModalPopup<List<File>?>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        // title: CustomText(text: "Files"),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              List<File> files = [];
              var result = await push(context, const CustomCamera());

              if (result is List<File>) {
                files = result;
              } else if (result is File) {
                files.add(result);
              }

              if (!context.mounted) return;
              pop(context, result: files);
            },
            child: Text(
              "Camera".tr(),
              style: TextStyles.textViewMedium12().copyWith(
                fontFamily: 'Poppins',
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              var files = await getFileAndDocs(
                allowMultiple: allowMultiple,
                allowedExtensions: [
                  // image
                  'jpg', 'jpeg', 'png', 'gif', 'bmp',
                  'webp', 'tiff', 'heic', 'svg',

                  // video
                  'mp4', 'mov', 'avi', 'wmv', 'flv',
                  'webm', 'mkv', '3gp', 'mpeg',

                  // dudio
                  'mp3',
                  'wav',
                  'aac',
                  'ogg',
                  'm4a',
                  'flac',
                  'wma',
                  'amr',
                  'aiff',

                  // document
                  'pdf',
                ],
              );

              if (!context.mounted) return;
              pop(context, result: files);
            },
            child: Text(
              "Pick File".tr(),
              style: TextStyles.textViewMedium12().copyWith(
                fontFamily: 'Poppins',
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              var files = await getImages(
                allowMultiple: allowMultiple,
                // allowedExtensions: allowedExtensions,
              );

              if (!context.mounted) return;
              pop(context, result: files);
            },
            child: Text(
              "Pick Image".tr(),
              style: TextStyles.textViewMedium12().copyWith(
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            pop(context);
          },
          child: Text(
            "Cancel".tr(),
            style: TextStyles.textViewMedium12().copyWith(
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
    // return showCupertinoModalPopup<List<File>?>(
    //   context: context,
    //   builder: (BuildContext ctx) {
    //     return Material(
    //       color: Colors.transparent,
    //       child: ConstrainedBox(
    //         constraints: BoxConstraints(maxWidth: 333),
    //         child: Padding(
    //           padding: EdgeInsets.only(
    //             top: 20,
    //             left: 20,
    //             right: 20,
    //             bottom:
    //                 constraints == null ? 20 : (constraints.maxHeight * 0.1),
    //           ),
    //           child: Ink(
    //             width: double.infinity,
    //             decoration: BoxDecoration(
    //               color: Colors.grey.shade900,
    //               borderRadius: BorderRadius.circular(16),
    //             ),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 FilePickerCard(
    //                   onPressed: () async {
    //                     final files = await getImages(
    //                       allowMultiple: allowMultiple,
    //                     );
    //                     if (ctx.mounted) Navigator.pop(ctx, files);
    //                   },
    //                   title: "Photo Library",
    //                   borderRadius: BorderRadius.only(
    //                     topLeft: Radius.circular(16),
    //                     topRight: Radius.circular(16),
    //                   ),
    //                   icon: "assets/svgs/global/photo_library.svg",
    //                 ),
    //                 Divider(
    //                   height: 0,
    //                   thickness: 0.5,
    //                   color: Colors.grey.withValues(alpha: 0.5),
    //                 ),
    //                 FilePickerCard(
    //                   onPressed: () async {
    //                     final files = await getFileAndDocs(
    //                       allowMultiple: allowMultiple,
    //                       allowedExtensions: [
    //                         'jpg',
    //                         'jpeg',
    //                         'png',
    //                         'gif',
    //                         'bmp',
    //                         'webp',
    //                         'tiff',
    //                         'heic',
    //                         'svg',
    //                       ],
    //                     );
    //                     if (ctx.mounted) Navigator.pop(ctx, files);
    //                   },
    //                   title: "Choose Files",
    //                   borderRadius: BorderRadius.only(
    //                     bottomLeft: Radius.circular(16),
    //                     bottomRight: Radius.circular(16),
    //                   ),
    //                   icon: "assets/svgs/global/choose_file.svg",
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  static OverlayEntry? _overlayEntry;

  // static Future<void> showFilePickerFromButton(
  //   BuildContext context,
  //   GlobalKey buttonKey, {
  //   bool showCamera = false,
  //   bool allowMultiple = false,
  //   Function(List<File>)? onFilesPicked,
  // }) async {
  //   FocusScope.of(context).unfocus();
  //   await Future.delayed(const Duration(milliseconds: 100));
  //   final renderBox =
  //       buttonKey.currentContext?.findRenderObject() as RenderBox?;
  //   if (renderBox == null) return;

  //   final btnSize = renderBox.size;
  //   final btnOffset = renderBox.localToGlobal(Offset.zero);

  //   const double overlayW = 139;
  //   const double overlayH = 144;
  //   const double gap = 4;

  //   final screen = MediaQuery.of(context).size;
  //   final pad = MediaQuery.of(context).padding;

  //   double desiredLeft = math.max(
  //       8, math.min(btnOffset.dx + btnSize.width, screen.width - overlayW - 8));
  //   double desiredTop = math.max(pad.top + 8, btnOffset.dy - overlayH - gap);

  //   await showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     barrierColor: Colors.black54,
  //     builder: (dialogContext) {
  //       return Stack(
  //         children: [
  //           Positioned(
  //             left: desiredLeft,
  //             top: desiredTop,
  //             width: overlayW,
  //             height: overlayH,
  //             child: Material(
  //               borderRadius: BorderRadius.circular(16),
  //               color: CupertinoColors.systemBackground,
  //               child: Padding(
  //                 padding: const EdgeInsets.all(12),
  //                 child: _buildOverlayContent(
  //                   dialogContext,
  //                   showCamera,
  //                   allowMultiple,
  //                   (files) {
  //                     Navigator.of(dialogContext).pop();
  //                     if (onFilesPicked != null) {
  //                       onFilesPicked(files);
  //                     }
  //                   },
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  static Future<void> showFilePickerFromButton(
    BuildContext context,
    GlobalKey buttonKey, {
    bool showCamera = false,
    bool allowMultiple = false,
    FocusNode? focusNode,
    Function(List<File>)? onFilesPicked,
  }) async {
    focusNode?.unfocus();
    await showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        return _DynamicOverlay(
          buttonKey: buttonKey,
          showCamera: showCamera,
          allowMultiple: allowMultiple,
          onFilesPicked: (files) {
            Navigator.of(dialogContext).pop();
            if (onFilesPicked != null) {
              onFilesPicked(files);
            }
          },
        );
      },
    );
    focusNode?.unfocus();
  }

  static Widget buildOverlayContent(
    BuildContext context,
    bool showCamera,
    bool allowMultiple,
    Function(List<File>) onFilesPicked,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PickerOption(
          assetPath: 'assets/new_design/icons/Camera.png',
          label: "Camera".tr(),
          onTap: () async {
            List<File> files = [];
            var result = await push(context, const CustomCamera());
            if (result is List<File>) {
              files = result;
            } else if (result is File) {
              files.add(result);
            }
            onFilesPicked(files);
          },
        ),
        _PickerOption(
          assetPath: 'assets/new_design/icons/gallery.png',
          label: "Image".tr(),
          onTap: () async {
            var files = await getImages(allowMultiple: allowMultiple);
            onFilesPicked(files);
          },
        ),
        _PickerOption(
          assetPath: 'assets/new_design/icons/attach_file.png',
          label: "File".tr(),
          onTap: () async {
            var files = await getFileAndDocs(
              allowMultiple: allowMultiple,
              allowedExtensions: [
                'jpg',
                'jpeg',
                'png',
                'gif',
                'bmp',
                'webp',
                'tiff',
                'heic',
                'svg',
                'mp4',
                'mov',
                'avi',
                'wmv',
                'flv',
                'webm',
                'mkv',
                '3gp',
                'mpeg',
                'mp3',
                'wav',
                'aac',
                'ogg',
                'm4a',
                'flac',
                'wma',
                'amr',
                'aiff',
                'pdf',
              ],
            );
            onFilesPicked(files);
          },
        ),
      ],
    );
  }

  static void hide({List<File>? result, Function(List<File>)? onFilesPicked}) {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (result != null && onFilesPicked != null) {
      onFilesPicked(result);
    }
  }
}

abstract base class TextStyles {
  const TextStyles._();

  static const String fontFamily = 'Kanit';

  static TextStyle textViewMedium12({Color? color}) => TextStyle(
        fontSize: 12,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
        color: color ?? Colors.black,
      );

  static TextStyle textViewRegular16({Color? color}) => TextStyle(
        fontSize: 16,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w400,
        color: color ?? Colors.black,
      );

  static TextStyle textViewSemiBold15({Color? color}) => TextStyle(
        fontSize: 15,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.black,
      );

  static TextStyle textViewRegular14({Color? color}) => TextStyle(
        fontSize: 14,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w400,
        color: color ?? Colors.black,
      );

  static TextStyle textViewRegular15({Color? color}) => TextStyle(
        fontSize: 15,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w400,
        color: color ?? Colors.black,
      );
}

class _PickerOption extends StatelessWidget {
  final String assetPath;
  final String label;
  final VoidCallback onTap;

  const _PickerOption({
    required this.assetPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  style: PetVeterinaryFontstyles2.getRegularStyle(context, 14)),
            ),
            Image.asset(
              assetPath,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}

class _DynamicOverlay extends StatefulWidget {
  final GlobalKey buttonKey;
  final bool showCamera;
  final bool allowMultiple;
  final Function(List<File>) onFilesPicked;

  const _DynamicOverlay({
    required this.buttonKey,
    required this.showCamera,
    required this.allowMultiple,
    required this.onFilesPicked,
  });

  @override
  State<_DynamicOverlay> createState() => _DynamicOverlayState();
}

class _DynamicOverlayState extends State<_DynamicOverlay> {
  double left = 0;
  double top = 0;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updatePosition());
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _updatePosition() {
    if (!mounted || _isDisposed) return;

    final renderBox =
        widget.buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final btnSize = renderBox.size;
    final btnOffset = renderBox.localToGlobal(Offset.zero);

    const double overlayW = 139;
    const double overlayH = 144;
    const double gap = 4;

    final screen = MediaQuery.of(context).size;
    final pad = MediaQuery.of(context).padding;

    double desiredLeft = math.max(
        8, math.min(btnOffset.dx + btnSize.width, screen.width - overlayW - 8));
    double desiredTop = math.max(pad.top + 8, btnOffset.dy - overlayH - gap);

    setState(() {
      left = desiredLeft;
      top = desiredTop;
    });

    if (!_isDisposed) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _updatePosition());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: left,
          top: top,
          width: 139,
          height: 144,
          child: Material(
            borderRadius: BorderRadius.circular(16),
            color: CupertinoColors.systemBackground,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ChatFilePicker.buildOverlayContent(
                context,
                widget.showCamera,
                widget.allowMultiple,
                widget.onFilesPicked,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
