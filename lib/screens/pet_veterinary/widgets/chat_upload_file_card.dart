import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/utils/app_file_picker.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/utils/chat_file_utils.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/provider/upload_media_notifier.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

class ChatUploadedFileCard extends ConsumerWidget {
  const ChatUploadedFileCard({super.key, required this.selectedFile});

  final ValueNotifier<File?> selectedFile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder<File?>(
      valueListenable: selectedFile,
      builder: (context, value, _) {
        if (value == null) return const SizedBox.shrink();

        return Container(
          constraints: const BoxConstraints(maxWidth: 272),
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(left: 22, right: 22, bottom: 11),
          decoration: BoxDecoration(
            color: PetVeterinaryColors.lightGreen,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: AppColors.white.withOpacity(0.11),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ChatFileUtils.getFileThumbnail(
                    file: value,
                    size: 40,
                    width: 40,
                    height: 40,
                  ),
                ),
                kWidth10,
                Expanded(
                  child: Text(
                    value.path.split('/').last,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.textViewMedium12(
                      color: AppColors.semiTransparentBlack,
                    ).copyWith(fontFamily: 'Poppins'),
                  ),
                ),
                kWidth10,
                IconButton(
                  onPressed: () {
                    selectedFile.value = null;
                    ref.read(uploadMediaProvider.notifier).clear();
                  },
                  icon: const Icon(
                    Icons.delete_rounded,
                    color: AppColors.semiTransparentBlack,
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
