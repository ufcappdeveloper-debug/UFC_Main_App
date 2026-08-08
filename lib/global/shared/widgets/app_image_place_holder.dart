import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/util/image_network_extension_method.dart';

class ImageWithPlaceHolder extends StatelessWidget {
  const ImageWithPlaceHolder({
    super.key,
    this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
  });
  final String? imageUrl;
  final double height;
  final double width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return SizedBox(
        width: width,
        height: height,
        child: FittedBox(
          fit: fit,
          alignment: Alignment.center,
          child: SvgPicture.asset(
            "assets/images/global/White-Bg-No-Image-Placeholder.svg",
          ),
        ),
      );
    }
    return CachedNetworkImage(
        fit: fit,
        width: width,
        height: height,
        imageUrl: imageUrl!,
        placeholder: loadingPlaceholder,
        errorWidget: errorWidget);
  }
}
