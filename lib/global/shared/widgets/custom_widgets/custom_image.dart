import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/global/util/common/custom_image_utils.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    this.fit,
    this.bytes,
    this.color,
    this.width,
    this.height,
    this.errFit,
    this.imageUrl,
    this.fileImage,
    this.assetImage,
    this.placeholder,
    this.colorFilter,
    this.errorListener,
    this.noImagePlaceholder,
    this.isAntiAlias = false,
    this.noImagePlaceholderWidget,
    this.alignment = Alignment.center,
  });
  final BoxFit? fit;
  final Color? color;
  final double? width;
  final BoxFit? errFit;
  final double? height;
  final File? fileImage;
  final String? imageUrl;
  final bool isAntiAlias;
  final Uint8List? bytes;
  final String? assetImage;
  final Widget? placeholder;
  final Alignment alignment;
  final ColorFilter? colorFilter;
  final String? noImagePlaceholder;
  final Function(Object)? errorListener;
  final Widget? noImagePlaceholderWidget;

  @override
  Widget build(BuildContext context) {
    if (bytes != null) {
      return Image.memory(
        bytes!,
        fit: fit,
        color: color,
        width: width,
        height: height,
        alignment: alignment,
        isAntiAlias: isAntiAlias,
      );
    } else if (fileImage != null) {
      return Image.file(
        fileImage!,
        fit: fit,
        color: color,
        width: width,
        height: height,
        alignment: alignment,
        isAntiAlias: isAntiAlias,
      );
    } else if (!isStringEmpty(assetImage)) {
      return Image.asset(
        assetImage!,
        fit: fit,
        color: color,
        width: width,
        height: height,
        alignment: alignment,
        isAntiAlias: isAntiAlias,
      );
    } else if (!isStringEmpty(imageUrl)) {
      if (imageUrl?.endsWith('.svg') ?? false) {
        return SvgPicture.network(
          imageUrl ?? '',
          width: width,
          height: height,
          alignment: alignment,
          fit: fit ?? BoxFit.contain,
          colorFilter: colorFilter ??
              ColorFilter.mode(color ?? Colors.black, BlendMode.srcIn),
          placeholderBuilder: (context) =>
              placeholder ?? CustomImageUtils.loadingPlaceholder(),
        );
      } else {
        return Directionality(
            textDirection: TextDirection.ltr,
            child: CachedNetworkImage(
                imageUrl: imageUrl ?? '',
                fit: fit,
                width: width,
                color: color,
                height: height,
                alignment: alignment,
                errorListener: errorListener,
                errorWidget: (context, url, error) =>
                    noImagePlaceholderWidget ??
                    CustomImageUtils.errorWidget(
                        width: width,
                        height: height,
                        fit: errFit ?? fit,
                        path: noImagePlaceholder),
                placeholder: (context, url) =>
                    placeholder ?? CustomImageUtils.loadingPlaceholder()));
      }
    } else {
      return noImagePlaceholderWidget ??
          CustomImageUtils.errorWidget(
              width: width,
              height: height,
              fit: errFit ?? fit,
              path: noImagePlaceholder);
    }
  }
}
