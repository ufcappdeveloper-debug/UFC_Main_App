import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/models/schedule/prescription_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/utils/download_utils.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';

class FileDownloader {
  static Future<void> show(BuildContext context, List<FileModel> files) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Prescription Files".tr(),
                style: PetVeterinaryFontstyles2.getMediumStyle(context, 16),
              ),
              const SizedBox(height: 12),
              ...files.map((file) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.description_outlined),
                    title: Text(
                      file.file?.split('/').last ?? "Unknown file".tr(),
                      style:
                          PetVeterinaryFontstyles2.getRegularStyle(context, 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: GestureDetector(
                      onTap: () =>
                          _downloadFile(context, bottomSheetContext, file),
                      child: Image.asset(
                        "assets/new_design/icons/download_prescription.png",
                        width: 24,
                        height: 24,
                        color: Colors.grey,
                      ),
                    ),
                  )),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  static Future<void> _downloadFile(BuildContext context,
      BuildContext bottomSheetContext, FileModel file) async {
    if (file.file == null || file.file!.isEmpty) {
      Navigator.pop(bottomSheetContext);
      _showSnack(context, "Invalid file URL".tr());
      return;
    }

    Navigator.pop(bottomSheetContext);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                "Downloading file...".tr(),
                style: PetVeterinaryFontstyles2.getRegularStyle(context, 14),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      // Use DownloadUtils for actual download
      await DownloadUtils.downloadFile(
        context,
        url: file.file!,
      );

      Navigator.of(context, rootNavigator: true).pop();
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      _showSnack(context, "Failed to download file".tr());
    }
  }

  static void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
