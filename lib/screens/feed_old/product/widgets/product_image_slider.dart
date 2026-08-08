import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_image_model.dart';
import 'package:ufc_mobile/screens/feed_old/product/pages/product_image_full_screen.dart';
import 'package:ufc_mobile/global/util/image_network_extension_method.dart';

class ProductImageSlider extends StatefulWidget {
  const ProductImageSlider({
    super.key,
    this.images,
    this.onPageChanged,
  });
  final List<ProductImageModel>? images;
  final dynamic Function(int, CarouselPageChangedReason)? onPageChanged;

  @override
  State<ProductImageSlider> createState() => _ProductImageSliderState();
}

class _ProductImageSliderState extends State<ProductImageSlider> {
  int page = 0;

  @override
  Widget build(BuildContext context) => Hero(
        tag: 'productImageSlider',
        child: CarouselSlider(
          options: CarouselOptions(
              height: 170,
              initialPage: page,
              viewportFraction: 1,
              enableInfiniteScroll: canProductImageScroll,
              onPageChanged: widget.onPageChanged),
          items: !isProductImageExist
              ? [
                  SvgPicture.asset(
                      'assets/images/global/White-Bg-No-Image-Placeholder.svg',
                      fit: BoxFit.contain),
                ]
              : List.generate(widget.images?.length ?? 0, (index) {
                  return GestureDetector(
                    onTap: () async {
                      if (widget.images != null && widget.images!.isNotEmpty) {
                        page = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductImageFullScreen(
                                    index: index, images: widget.images)));
                        setState(() {});
                      }
                    },
                    child: Builder(
                      builder: (BuildContext context) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Center(
                              child: (widget.images?[index].location == null ||
                                      widget.images![index].location!.isEmpty)
                                  ? SvgPicture.asset(
                                      'assets/images/global/White-Bg-No-Image-Placeholder.svg',
                                      fit: BoxFit.contain)
                                  : CachedNetworkImage(
                                      imageUrl:
                                          widget.images?[index].location ?? "",
                                      errorWidget: (context, url, error) =>
                                          SvgPicture.asset(
                                              'assets/images/global/White-Bg-No-Image-Placeholder.svg'),
                                      placeholder: loadingPlaceholder,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
        ),
      );
  bool get isProductImageExist {
    if (widget.images == null || widget.images!.isEmpty) {
      return false;
    }
    return true;
  }

  bool get canProductImageScroll {
    if (widget.images == null || widget.images!.isEmpty) {
      return false;
    }
    if (widget.images!.length <= 1) return false;
    return true;
  }
}
