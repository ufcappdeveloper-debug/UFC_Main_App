import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/util/exception/error_handler.dart';

class DownloadUtils {
  static final DownloadUtils _instance = DownloadUtils._internal();

  factory DownloadUtils() => _instance;

  DownloadUtils._internal();

  static final ValueNotifier<bool> _isDownloading = ValueNotifier<bool>(false);

  static ValueNotifier<bool> get isDownloading => _isDownloading;

  static Future<void> downloadFile(
    BuildContext context, {
    required String url,
  }) async {
    try {
      _isDownloading.value = true;

      // Set target directory
      final dir = Platform.isAndroid
          ? Directory('/storage/emulated/0/Download')
          : await getApplicationDocumentsDirectory();

      // Determine filename
      final String fileName = url.split('/').last;
      final String filePath = '${dir.path}/$fileName';

      // Download the file
      await Dio().download(url, filePath);

      if (!context.mounted) return;
      CustomSnackBar.success(
        context,
        '${'File downloaded to'.tr()} ${Platform.isAndroid ? "Downloads".tr() : "Documents".tr()} ${'folder as'.tr()} $fileName',
      );
    } catch (e) {
      if (!context.mounted) return;
      ErrorHandler.handleError(context, e);
    } finally {
      _isDownloading.value = false;
    }
  }
}
