import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ufc_mobile/global/extensions/app_png_images.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

class EditableProfileImage extends StatelessWidget {
  final String? imageUrl;
  final String? localImagePath;
  final bool isEditable;
  final VoidCallback? onEditIconTap;
  final ValueChanged<String>? onImageSelected;

  const EditableProfileImage({
    super.key,
    this.imageUrl,
    this.localImagePath,
    this.isEditable = false,
    this.onEditIconTap,
    this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: isEditable
                ? () async {
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 85,
                    );
                    if (picked != null) {
                      onImageSelected?.call(picked.path);
                    }
                  }
                : null,
            child: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: isEditable
                  ? Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: (localImagePath != null ||
                                  (imageUrl?.isNotEmpty ?? false))
                              ? Colors.transparent
                              : PetVeterinaryColors.newPetLightGray,
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.transparent,
                            backgroundImage: localImagePath != null
                                ? FileImage(File(localImagePath!))
                                : (imageUrl?.isNotEmpty ?? false)
                                    ? NetworkImage(imageUrl!)
                                    : null as ImageProvider?,
                            child: localImagePath == null &&
                                    (imageUrl?.isEmpty ?? true)
                                ? Image.asset(
                                    AppPngImages.galleryPlaceholder,
                                    width: 22,
                                    height: 22,
                                    fit: BoxFit.contain,
                                  )
                                : null,
                          ),

//         AvatarWithLoader(
//   localImagePath: localImagePath,
//   imageUrl: imageUrl,
// ),
                          Positioned(
                            top: -1,
                            right: -1,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: PetVeterinaryColors.newPetLightGreyText,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: (localImagePath != null ||
                                  (imageUrl?.isNotEmpty ?? false))
                              ? Colors.transparent
                              : PetVeterinaryColors.newPetLightGray,
                          width: 1,
                        ),
                      ),

                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.transparent,
                        backgroundImage: localImagePath != null
                            ? FileImage(File(localImagePath!))
                            : (imageUrl?.isNotEmpty ?? false)
                                ? NetworkImage(imageUrl!)
                                : null as ImageProvider?,
                        child: localImagePath == null &&
                                (imageUrl?.isEmpty ?? true)
                            ? Image.asset(
                                AppPngImages.galleryPlaceholder,
                                width: 24,
                                height: 24,
                                fit: BoxFit.contain,
                              )
                            : null,
                      ),
//              AvatarWithLoader(
//   localImagePath: localImagePath,
//   imageUrl: imageUrl,
// )
                    ),
            ),
          ),
          Positioned(
            top: -1,
            right: -19,
            child: GestureDetector(
              onTap: onEditIconTap,
              child: Image.asset(
                AppPngImages.editProfileIcon,
                width: 19,
                height: 19,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AvatarWithLoader extends StatefulWidget {
  final String? localImagePath;
  final String? imageUrl;

  const AvatarWithLoader({
    super.key,
    this.localImagePath,
    this.imageUrl,
  });

  @override
  State<AvatarWithLoader> createState() => _AvatarWithLoaderState();
}

class _AvatarWithLoaderState extends State<AvatarWithLoader> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final hasLocal = widget.localImagePath != null;
    final hasNetwork = (widget.imageUrl?.isNotEmpty ?? false);

    return ClipOval(
      child: Container(
        width: 44,
        height: 44,
        color: Colors.transparent,
        child: hasLocal
            ? Image.file(
                File(widget.localImagePath!),
                fit: BoxFit.cover,
              )
            : hasNetwork
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        widget.imageUrl!,
                        fit: BoxFit.cover,
                        width: 44,
                        height: 44,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            _isLoading = false;
                            return child;
                          } else {
                            _isLoading = true;
                            return const SizedBox.shrink();
                          }
                        },
                        errorBuilder: (context, error, stack) {
                          return Image.asset(
                            AppPngImages.galleryPlaceholder,
                            fit: BoxFit.contain,
                          );
                        },
                      ),

                      /// Loading indicator
                      if (_isLoading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  )
                : Image.asset(
                    AppPngImages.galleryPlaceholder,
                    fit: BoxFit.contain,
                  ),
      ),
    );
  }
}
