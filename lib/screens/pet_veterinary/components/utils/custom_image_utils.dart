import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/extensions/app_svg.dart';

class CustomImageUtils {
  // For NetWork Image
  static Widget loadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) =>
      loadingProgress == null
          ? child
          : const Center(child: CupertinoActivityIndicator());

  static Widget errorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stack,
  ) =>
      SvgPicture.asset(AppSvgs.noImagePlaceholderSvg, fit: BoxFit.cover);

  // Placeholder for cached network image
  static Widget loadingPlaceholder() =>
      const Center(child: CupertinoActivityIndicator());

  // Error placeholder for cached network image (fit as contain)
  static Widget errorWidget({
    BoxFit? fit,
    String? path,
    double? width,
    double? height,
  }) =>
      SvgPicture.asset(
        path ?? AppSvgs.noImagePlaceholderSvg,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
      );
}
