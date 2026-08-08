import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../global/extensions/app_colors.dart';
import '../../../../global/shared/constants/constants.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';

class CustomFilePicker extends StatefulWidget {
  final bool onlyImage;
  const CustomFilePicker({super.key, this.onlyImage = false});

  @override
  State<CustomFilePicker> createState() => _CustomFilePickerState();
}

class _CustomFilePickerState extends State<CustomFilePicker> {
  List<PlatformFile> files = [];

  void pickFile({bool onlyImage = false}) async {
    final allowedExtensions = ['jpg', 'jpeg', 'png', 'pdf'];
    if (onlyImage) {
      allowedExtensions.removeLast();
    }
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        files.add(result.files.single);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        customContainer(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: widget.onlyImage
                      ? 'Upload/Attach Images'
                      : 'Upload/Attach Files',
                  color: AppColors.grey,
                  fontSize: 16,
                ),
                if (widget.onlyImage)
                  Icon(Icons.photo_outlined, color: Colors.black)
                else
                  SvgPicture.asset('assets/images/upload_image.svg')
              ],
            ),
            onTap: () => pickFile(onlyImage: widget.onlyImage)),
        kHeight10,
        if (files.isNotEmpty)
          customContainer(
            padding: EdgeInsets.only(left: 10, top: 10),
            width: double.infinity,
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: List.generate(
                files.length,
                (index) {
                  final fileName = files[index].name;
                  return Container(
                    margin: EdgeInsets.only(right: 10, bottom: 10),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.boxGray,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.onlyImage) ...{
                          Icon(Icons.photo_outlined, size: 12),
                          kWidth10,
                        },
                        CustomText(
                          text: fileName.length > 30
                              ? '${fileName.substring(0, 30)}...'
                              : fileName,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                        kWidth10,
                        GestureDetector(
                            onTap: () => setState(() {
                                  files.removeAt(index);
                                }),
                            child: Icon(Icons.close, size: 14)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  GestureDetector customContainer(Widget child,
      {double? width, EdgeInsetsGeometry? padding, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: padding ?? EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 1, color: AppColors.grey),
        ),
        child: child,
      ),
    );
  }
}
