import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/util/image_network_extension_method.dart';

class EditProfileImageContainer extends StatelessWidget {
  const EditProfileImageContainer(
      {super.key,
      this.imageUrl,
      this.editProfile = false,
      required this.pickedImage,
      required this.onPressed});
  final String? imageUrl;
  final bool editProfile;
  final String pickedImage;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: onPressed,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: SizedBox(
          height: 95,
          width: 92.87,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                  width: 85.45,
                  height: 85.45,
                  child: pickedImage.isEmpty
                      ? imageUrl == null || imageUrl!.isEmpty
                          ? Container(
                              color: const Color(0xFFD9D9D9),
                              child: const Icon(
                                size: 44,
                                Icons.person,
                                color: Colors.white,
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: imageUrl ?? "",
                              placeholder: loadingPlaceholder,
                              errorWidget: errorWidget,
                              fit: BoxFit.cover,
                            )
                      : Image.file(
                          File(pickedImage.toString()),
                          errorBuilder: errorBuilder,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              if (editProfile)
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: SvgPicture.asset(
                    "assets/images/profile/camera-icon.svg",
                    height: 22.62,
                    width: 25.13,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
