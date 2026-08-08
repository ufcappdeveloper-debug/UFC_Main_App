import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_image_model.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/util/image_network_extension_method.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

class ProductImageFullScreen extends StatefulWidget {
  const ProductImageFullScreen(
      {super.key, required this.index, required this.images});
  final int index;
  final List<ProductImageModel>? images;

  @override
  State<ProductImageFullScreen> createState() => _ProductImageFullScreenState();
}

class _ProductImageFullScreenState extends State<ProductImageFullScreen>
    with ScreenEngagementTracker {
  int page = 0;

  @override
  void initState() {
    page = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                actions: [
                  Padding(
                      padding: const EdgeInsetsDirectional.only(end: 11),
                      child: productImageCloseButton()),
                ]),
            body: Center(
                child: GestureDetector(
                    onTap: () => Navigator.pop(context, page),
                    child: Hero(
                        tag: 'productImageSlider',
                        child: CarouselSlider(
                            disableGesture: true,
                            options: CarouselOptions(
                                height: size.height,
                                viewportFraction: 1,
                                initialPage: widget.index,
                                enableInfiniteScroll: canProductImageScroll,
                                onPageChanged: (index, reason) => page = index),
                            items: widget.images
                                ?.map((i) => Builder(
                                    builder: (BuildContext context) => PinchZoom(
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 3),
                                            child: (i.location == null || i.location!.isEmpty)
                                                ? SvgPicture.asset(
                                                    'assets/images/global/White-Bg-No-Image-Placeholder.svg',
                                                    fit: BoxFit.contain)
                                                : CachedNetworkImage(
                                                    imageUrl: i.location ?? "",
                                                    fit: BoxFit.contain,
                                                    errorWidget: errorWidget,
                                                    placeholder: loadingPlaceholder)))))
                                .toList()))))));
  }

  bool get canProductImageScroll {
    if ((widget.images?.length ?? 0) <= 1) return false;
    return true;
  }

  IconButton productImageCloseButton() => IconButton(
      highlightColor: Colors.transparent,
      splashColor: primaryColor.withValues(alpha: 0.23),
      icon: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                    color: Colors.black.withValues(alpha: 0.33)),
              ]),
          child: const Icon(Icons.close, color: Colors.black)),
      onPressed: () => Navigator.pop(context, page));
}
