import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/components/carousel_indicator.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_colors.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_fontstyles.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/widgets/reusable_reward_price_text.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

Future<void> rewardClaimButtonAction(BuildContext context,
    {required VoidCallback onButtonPressed,
    required String productName,
    required String productDescription,
    required double originalPrice,
    required int quantity,
    required String productImg}) {
  return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (BuildContext context) {
        return SizedBox(
            height: 280,
            width: double.infinity,
            child: RewardClaimProductView(
              addToCart: onButtonPressed,
              productName: productName,
              productDes: productDescription,
              ogPrice: originalPrice.toString(),
              productImg: productImg,
              quantity: quantity.toString(),
            ));
      });
}

class RewardClaimProductView extends StatefulWidget {
  const RewardClaimProductView(
      {required this.addToCart,
      required this.productName,
      required this.productDes,
      required this.ogPrice,
      required this.productImg,
      required this.quantity,
      super.key});

  final VoidCallback addToCart;
  final String productName;
  final String productDes;
  final String ogPrice;
  final String productImg;
  final String quantity;

  @override
  _RewardClaimProductViewState createState() => _RewardClaimProductViewState();
}

class _RewardClaimProductViewState extends State<RewardClaimProductView> {
  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    bool isRTL = isArabic;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 6),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 102,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: true,
                        enlargeCenterPage: false,
                        autoPlay: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                      items: [
                        Builder(
                          builder: (BuildContext context) {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: widget.productImg.isNotEmpty
                                    ? Image.network(
                                        widget.productImg,
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace) {
                                          return Container(
                                            color: Colors.grey[200],
                                            child: Center(
                                              child: Icon(
                                                Icons.image_not_supported,
                                                size: 40,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: Icon(
                                            Icons
                                                .image_not_supported, // Minimal placeholder icon
                                            size: 40,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                        Builder(
                          builder: (BuildContext context) {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: widget.productImg.isNotEmpty
                                    ? Image.network(
                                        widget.productImg,
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace) {
                                          return Container(
                                            color: Colors.grey[200],
                                            child: Center(
                                              child: Icon(
                                                Icons.image_not_supported,
                                                size: 40,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 40,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    CarouselIndicator(
                      carouselController: _carouselController,
                      itemCount: 2,
                      currentIndex: _currentIndex,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 4,
                  ),
                  Row(children: [
                    Text(widget.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: LoyalityPointsFontstyles.lpProductTitleTextStyle
                            .copyWith(
                                color: LoyalityPointsColors
                                    .lpSubHeadingTextColor)),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'x',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 2),
                          Text(
                            widget.quantity,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                  const SizedBox(height: 5),
                  Text(widget.productDes,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: LoyalityPointsFontstyles.lpProductDescTextStyle
                          .copyWith(
                              color:
                                  LoyalityPointsColors.lpProductDescTextColor)),
                ],
              ),
            ),
            Padding(
              padding: isRTL
                  ? EdgeInsets.only(top: 50, left: 25)
                  : EdgeInsets.only(right: 25, top: 50),
              child: ReusableRewardPriceText(
                originalPrice: widget.ogPrice,
                discountedPrice: '0',
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
            widget.addToCart();
          },
          splashColor: Colors.green[300],
          borderRadius: BorderRadius.circular(9.0),
          child: Ink(
            height: 42,
            width: 260,
            decoration: BoxDecoration(
              color: const Color(0xff78B833),
              borderRadius: BorderRadius.circular(9.0),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ADD TO CART'.tr(),
                    style: LoyalityPointsFontstyles.bottomSheetButtonTextStyle
                        .copyWith(
                            color: LoyalityPointsColors.lpMainTitleTextColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/images/loyality_points/cart_img.png',
                    height: 13.5,
                    width: 14,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
