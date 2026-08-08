import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/take_a_photo.dart';

class AppFilePicker {
  Future<List<File>> getImageAndVideo({bool allowMultiple = false}) async {
    final data = await FilePicker.platform
        .pickFiles(type: FileType.media, allowMultiple: allowMultiple);
    if (data != null && data.files.isNotEmpty) {
      return data.files.map((e) => File(e.path!)).toList();
    }
    return [];
  }

  Future<List<File>> getImages({
    bool allowMultiple = false,
  }) async {
    final data = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: allowMultiple,
    );
    if (data != null && data.files.isNotEmpty) {
      return data.files.map((e) => File(e.path!)).toList();
    }
    return [];
  }

  // Future<void> get() async {
  //   List<File> imageFileList = [];
  //   bool allowMultiple = false;
  //   void selectImage() async {
  //     final FilePickerResult? selectedImages = await FilePicker.platform
  //         .pickFiles(type: FileType.image, allowMultiple: allowMultiple);
  //     if (imageFileList.length > 4) {
  //       print('too many');
  //     }
  //     if (selectedImages!.files.isNotEmpty) {
  //       imageFileList.addAll(selectedImages.files.map((e) => File(e.path!)));
  //     }
  //     //  setState(() {});
  //   }
  // }
  // Future<List<File>> getLimitedImages({
  //   bool allowMultiple = false,
  //   List<Asset> selectedAssets = const [],
  // }) async {
  //   final data = await MultiImagePicker

  //   pickImages(
  //       maxImages: 4, selectedAssets: selectedAssets);
  //   if (data.isNotEmpty) {
  //     return data.map((e) => File(e.toString())).toList();
  //   }
  //   return [];
  // }

  Future<List<File>> getFileAndDocs({bool allowMultiple = false}) async {
    final data = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: allowMultiple,
        allowedExtensions: ["txt", "docx", "pdf", "jpg", "png", "jpeg"]);
    if (data != null && data.files.isNotEmpty) {
      return data.files.map((e) => File(e.path!)).toList();
    }
    return [];
  }

  Future<List<File>> getTextDocuments() async {
    final data = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ["txt", "docx", "pdf"]);
    if (data != null && data.files.isNotEmpty) {
      return data.files.map((e) => File(e.path!)).toList();
    }
    return [];
  }

  Future<List<File>> getPDFDocuments() async {
    final data = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["pdf"]);
    if (data != null && data.files.isNotEmpty) {
      return data.files.map((e) => File(e.path!)).toList();
    }
    return [];
  }

  Future<List<File>> getImge(BuildContext context, [String? purpose]) async {
    final image = await Navigator.of(context).push<File?>(MaterialPageRoute(
      builder: (context) => TakeAPhoto(purpose: purpose),
    ));
    if (image == null) {
      return [];
    }
    return [image];
  }

  Future<List<File>?> showFilePicker(
    BuildContext context, {
    bool allowMultiple = false,
    FileType type = FileType.custom,
    List<String>? allowedExtensions,
  }) async {
    return showCupertinoModalPopup<List<File>?>(
      context: context,
      builder: (BuildContext c) => CupertinoActionSheet(
        title: CustomText(text: "Files"),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.of(c).pop(await getImge(c));
            },
            child: CustomText(text: "Camera"),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              var files = await getFileAndDocs(
                allowMultiple: allowMultiple,
              );
              if (!context.mounted) return;
              Navigator.of(c).pop(files);
            },
            child: CustomText(text: "Pick File"),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              var files = await getImages(allowMultiple: allowMultiple);
              if (!context.mounted) return;
              Navigator.of(c).pop(files);
            },
            child: CustomText(text: "Pick Image"),
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(c).pop();
          },
          child: CustomText(text: "Cancel"),
        ),
      ),
    );
  }
}
