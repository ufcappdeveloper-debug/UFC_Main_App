import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// For NetWork Image
Widget loadingBuilder(
        BuildContext context, Widget child, ImageChunkEvent? loadingProgress) =>
    loadingProgress == null
        ? child
        : const Center(
            child: CupertinoActivityIndicator(),
          );

Widget errorBuilder(BuildContext context, Object error, StackTrace? stack) =>
    SvgPicture.asset(
      'assets/images/global/No-Image-Placeholder.svg',
      // 'assets/images/global/default_image.svg',
      fit: BoxFit.cover,
    );

// Placeholder for cached network image
Widget loadingPlaceholder(context, url) => const Center(
      child: CupertinoActivityIndicator(),
    );

// Error placeholder for cached network image (fit as cover)
Widget errorWidget(BuildContext context, String url, dynamic error) {
  return SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: Center(
      child: SvgPicture.asset(
        'assets/images/global/No-Image-Placeholder.svg',
        fit: BoxFit.contain, // ensures it fits without overflowing
        alignment: Alignment.center, // keep it centered
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.softLight,
        ),
      ),
    ),
  );
}

Widget newPlaceholder(context, url, error) => Image.asset(
      'assets/images/place-holder.png',
      fit: BoxFit.cover,
    );

// Error placeholder for cached network image (fit as contain)
Widget containErrorWidget(context, url, error) => SvgPicture.asset(
      'assets/images/global/No-Image-Placeholder.svg',
    );

/* ------ New Place Holders ------ */
// Placeholder for cached network image
// Error placeholder for cached network image (fit as contain)
Widget newErrorWidget({String? path, BoxFit fit = BoxFit.contain}) =>
    SvgPicture.asset(path ?? 'assets/images/global/No-Image-Placeholder.svg',
        fit: fit);
