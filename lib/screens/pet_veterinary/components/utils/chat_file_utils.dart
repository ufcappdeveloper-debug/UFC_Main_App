import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mime/mime.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/pages/chat/preview_image.dart';
import 'package:ufc_mobile/screens/pet_veterinary/widgets/preview_pdf_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary/widgets/preview_video_screen.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_image.dart';

class ChatFileUtils {
  static Widget getFileThumbnail({
    File? file,
    String? url,
    double? size,
    double? width,
    double? height,
    Color color = AppColors.semiTransparentBlack,
  }) {
    final path = url ?? file?.path ?? '';
    final mimeType = lookupMimeType(path) ?? '';

    if (mimeType.startsWith('image/')) {
      // It's an image
      if (file != null) {
        return Image.file(
          file,
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      } else if (url != null && url.isNotEmpty) {
        return CustomImage(
          imageUrl: url,
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      }
    } else if (mimeType.startsWith('audio/')) {
      // It's an audio file
      return Icon(Icons.audiotrack, color: color, size: size);
    } else if (mimeType == 'application/pdf') {
      // It's a PDF document
      return Icon(FontAwesomeIcons.filePdf, color: color, size: size);
    } else if (mimeType.startsWith('video/')) {
      // It's a video
      return Icon(Icons.videocam, color: color, size: size);
    }

    // Unknown file type
    return Icon(Icons.insert_drive_file, color: color, size: size);
  }

  static Widget? getFileScreen({required String url, required int index}) {
    final mimeType = lookupMimeType(url) ?? '';

    if (mimeType.startsWith('image/')) {
      // It's an image
      return PreviewImageScreen(imageUrl: url, tag: 'prescriptionFile$index');
    } else if (mimeType == 'application/pdf') {
      // It's a PDF document
      return PreviewPdfScreen(pdfUrl: url, tag: 'prescriptionFile$index');
    } else if (mimeType.startsWith('video/')) {
      // It's a video
      return PreviewVideoScreen(videoUrl: url, tag: 'prescriptionFile$index');
    }

    // Unknown file type
    return null;
  }
}
