import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ufc_mobile/global/util/image_network_extension_method.dart';

class CustomCachedImage extends StatelessWidget {
  const CustomCachedImage({
    super.key,
    this.fit,
    this.width,
    this.height,
    this.imageUrl,
    this.placeholder,
    this.noImagePlaceholder,
    this.noImagePlaceholderWidget,
  });
  final BoxFit? fit;
  final double? width;
  final double? height;
  final String? imageUrl;
  final String? noImagePlaceholder;
  final Widget? noImagePlaceholderWidget;
  final Widget Function(BuildContext, String)? placeholder;

  @override
  Widget build(BuildContext context) {
    return imageUrl == null || imageUrl!.isEmpty
        ? noImagePlaceholderWidget ?? newErrorWidget(path: noImagePlaceholder)
        : CachedNetworkImage(
            imageUrl: imageUrl ?? "",
            placeholder: placeholder ?? loadingPlaceholder,
            errorWidget: (context, url, error) =>
                noImagePlaceholderWidget ??
                newErrorWidget(path: noImagePlaceholder),
            height: height,
            width: width,
            fit: fit,
          );
  }
}
