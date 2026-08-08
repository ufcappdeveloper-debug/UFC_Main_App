import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_colors.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_fontstyles.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/widgets/custom_loyality_points_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_image.dart';

import '../components/carousel_indicator.dart';

class LoyalityPointsProductContainer extends StatefulWidget {
  const LoyalityPointsProductContainer({
    super.key,
    required this.onClaim,
    required this.quantity,
    required this.isClaimed,
    required this.onPressed,
    required this.points,
    required this.productImg,
    required this.productName,
    required this.productDescription,
    required this.isProductImageExist,
  });

  final bool isClaimed;
  final String quantity;
  final String points;
  final String productImg;
  final String productName;
  final VoidCallback onClaim;
  final VoidCallback onPressed;
  final bool isProductImageExist;
  final String productDescription;

  @override
  _LoyalityPointsProductContainerState createState() =>
      _LoyalityPointsProductContainerState();
}

class _LoyalityPointsProductContainerState
    extends State<LoyalityPointsProductContainer> {
  final CarouselController _carouselController = CarouselController();
  int _currentIndex = 0; // Track the current page index

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: widget.onPressed,
      splashColor: Colors.grey.withValues(alpha: 0.11),
      highlightColor: Colors.grey.withValues(alpha: 0.11),
      child: SizedBox(
        width: 171,
        height: 265,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 20,
                    offset: Offset(0, 4),
                    color: Color.fromRGBO(0, 0, 0, 0.06),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 6),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 102, // Set the height of the carousel
                      viewportFraction: 1.0, // Show one item fully at a time
                      enableInfiniteScroll: true, // Enable/Disable scrolling
                      enlargeCenterPage: false, // No zoom effect
                      autoPlay: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index; // Update the current index
                        });
                      }, // Disable autoplay
                    ),
                    // items:
                    //      images.map((imagePath) {
                    //         return Builder(
                    //           builder: (BuildContext context) {
                    //             return Container(
                    //               margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    //               child: ClipRRect(
                    //                 borderRadius: BorderRadius.circular(10),
                    //          child:  Image.asset(
                    //                 'assets/images/loyality_points/reward1.png',
                    //                 fit: BoxFit.cover,
                    //               ),
                    //               ),
                    //             );
                    //           },
                    //         );
                    //       }).toList()

                    items: [
                      Builder(
                        builder: (BuildContext context) {
                          // Replace this URL with the actual `product_image` value from your response
                          // String? productImage1 = "https://wom-app.s3.me-south-1.amazonaws.com/products/DGmYgIVu8tuZGggIpo6xkK2dOviFiqeds8WDYSAL.png";
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CustomImage(
                                imageUrl: widget.productImg,
                                fit: BoxFit.cover,
                                noImagePlaceholderWidget: Container(
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
                            ),
                          );
                        },
                      ),
                      Builder(
                        builder: (BuildContext context) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CustomImage(
                                imageUrl: widget.productImg,
                                fit: BoxFit.cover,
                                noImagePlaceholderWidget: Container(
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
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  CarouselIndicator(
                    carouselController: _carouselController,
                    itemCount: 2,
                    currentIndex: _currentIndex, // Number of images
                  ),
                  //                 const SizedBox(height: 3),
                  //                 // Image Carousel
                  //                 images.isNotEmpty
                  //                     ? Image.network(
                  //                         images.first,
                  //                         height: 102,
                  //                         fit: BoxFit.contain,
                  //                       )
                  //                     : Container(
                  //   color: Color.fromRGBO(235, 235, 235, 1), //rgba(235, 235, 235, 1)/ Fallback gray square
                  //   width: 120,
                  //   height: 120,
                  // ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(widget.productName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: LoyalityPointsFontstyles
                                  .lpProductTitleTextStyle
                                  .copyWith(
                                      color: LoyalityPointsColors
                                          .lpSubHeadingTextColor)),
                          SizedBox(
                            width: 4,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(
                                  8), // Slightly larger radius for smoothness
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'x',
                                  style: TextStyle(
                                    fontSize:
                                        8, // Smaller font size for a cleaner look
                                    fontWeight: FontWeight
                                        .w400, // Light weight for elegance
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                    width:
                                        2.5), // Minimal spacing for a compact feel
                                Text(
                                  widget.quantity,
                                  style: TextStyle(
                                    fontSize: 8, // Matching font size
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]),
                        const SizedBox(height: 5),
                        widget.isClaimed == true
                            ? SizedBox.shrink()
                            : Text(
                                '${'points'.tr()} ${widget.points}',
                                maxLines: 1,
                                style: LoyalityPointsFontstyles
                                    .lpProductDescTextStyle
                                    .copyWith(
                                  color: LoyalityPointsColors
                                      .lpProductDescTextColor,
                                ),
                              ),
                        Text(widget.productDescription,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: LoyalityPointsFontstyles
                                .lpProductDescTextStyle
                                .copyWith(
                                    color: LoyalityPointsColors
                                        .lpProductDescTextColor)),
                      ],
                    ),
                  ),
                  CustomLoyalityPointsButton(
                    text: widget.isClaimed ? 'UNCLAIM'.tr() : 'CLAIM'.tr(),
                    backgroundColor: widget.isClaimed
                        ? Colors.grey // Red background for unclaim
                        : LoyalityPointsColors
                            .lpCurrentPointsTextColor, // Original background for claim
                    textStyle: LoyalityPointsFontstyles.rewardScreenBtnTextStyle
                        .copyWith(color: Colors.white),
                    onTap: widget.onClaim,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
