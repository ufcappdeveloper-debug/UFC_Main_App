import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/file/file_picker_utils.dart';

class ChatAttachmentPopUpMenuButton extends StatelessWidget {
  final Color? backgroundColor;
  final ValueChanged<AttachmentOption> onSelected;
  final List<AttachmentOption> options;
  final String? buttonIconPath;
  final Color? buttonColor;
  const ChatAttachmentPopUpMenuButton({
    super.key,
    this.backgroundColor,
    required this.onSelected,
    required this.options,
    this.buttonIconPath = "assets/svg/top_bar/top-plus.svg",
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: onSelected,
      offset: Offset(-15, 100),
      borderRadius: BorderRadius.circular(50),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: backgroundColor ?? cream,
        child: Center(
          child: SvgPicture.asset(
            buttonIconPath ?? 'assets/svg/top_bar/top-plus.svg',
            colorFilter: ColorFilter.mode(
              buttonColor ?? primaryColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      itemBuilder: (_) => options.map((option) {
        final iconPath = _getIconPath(option);
        final label = _getLabel(option);
        return PopupMenuItem<AttachmentOption>(
          value: option,
          padding: ksymmetric(20, 15),
          child: _buildMenuItem(iconPath, label, option),
        );
      }).toList(),
    );
  }

  Widget _buildMenuItem(String icon, String label, AttachmentOption option) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          height: isFileOption(option) ? 25 : 20,
          width: isFileOption(option) ? 25 : 20,
        ),
        kWidth10,
        CustomText(text: label),
      ],
    );
  }

  bool isFileOption(AttachmentOption option) {
    return option == AttachmentOption.file;
  }

  String _getIconPath(AttachmentOption option) {
    switch (option) {
      case AttachmentOption.camera:
        return 'assets/svg/top_bar/camera.svg';
      case AttachmentOption.gallery:
        return 'assets/svg/top_bar/gallery.svg';
      case AttachmentOption.file:
        return 'assets/svg/top_bar/attach.svg';
    }
  }

  String _getLabel(AttachmentOption option) {
    switch (option) {
      case AttachmentOption.camera:
        return 'Take a photo';
      case AttachmentOption.gallery:
        return 'Picture';
      case AttachmentOption.file:
        return 'File';
    }
  }
}
