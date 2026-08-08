import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/riverpod/product/product_future_riverpod.dart';
import 'package:ufc_mobile/riverpod/product/product_riverpod.dart';
import 'package:ufc_mobile/screens/feed_old/product/widgets/product_details/product_details_app_bar_section.dart';
import 'package:ufc_mobile/screens/feed_old/product/widgets/product_details/product_details_bottom_bar.dart';
import 'package:ufc_mobile/screens/feed_old/product/widgets/product_details/product_details_info_section.dart';
import 'package:ufc_mobile/screens/feed_old/product/widgets/product_details/product_details_review_section.dart';
import 'package:ufc_mobile/screens/feed_old/product/widgets/product_details/product_details_tab_bar_section.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  const ProductDetailsPage({
    super.key,
    this.canBuy = false,
    required this.productId,
    this.isLoyaltyProduct = false,
    this.onLoyalityProductClaimPressed,
  });
  final bool canBuy;
  final int productId;
  final bool isLoyaltyProduct;
  final VoidCallback? onLoyalityProductClaimPressed;

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage>
    with ScreenEngagementTracker {
  int productQty = 1;
  DateTime date = DateTime.now().add(const Duration(days: 1));
  TextEditingController qtyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ignore: unused_result
      ref.refresh(getProductDetailsProvider(widget.productId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final productDetailsProvider =
        ref.watch(getProductDetailsProvider(widget.productId));

    return WillPopScope(
      onWillPop: () async {
        ref.read(productProvider).changeProductQty(1);
        return true;
      },
      child: LayoutBuilder(
        builder: (context, constraints) => Scaffold(
          //* Product Details Bottom Bar
          bottomNavigationBar: ProductDetailsBottomBar(
            canBuy: widget.canBuy,
            productId: widget.productId,
            qtyController: qtyController,
            isLoyaltyProduct: widget.isLoyaltyProduct,
            onLoyalityProductClaimPressed: widget.onLoyalityProductClaimPressed,
          ),
          //* Product Details Body
          body: SafeArea(
            child: productDetailsProvider.when(
              data: (data) {
                var children2 = [
                  //* Product Details AppBar Section
                  ProductDetailsAppBarSection(
                    product: data,
                    productId: widget.productId,
                  ),

                  //* Product Details Info Section
                  ProductDetailsInfoSection(
                    product: data,
                    canBuy: widget.canBuy,
                    qtyController: qtyController,
                    isLoyaltyProduct: widget.isLoyaltyProduct,
                  ),

                  //* Product Details TabBar with details Section
                  ProductDetailsTabBarSection(
                    productData: data,
                    length: tabBarSectionLength(data),
                  ),

                  //* Product Details Reviews Section
                  ProductDetailsReviewSection(productData: data),
                ];
                return ListView(children: children2);
              },
              error: (error, stack) => CustomReloadProvider(
                height: 118,
                onPressed: () => ref.refresh(
                  getProductDetailsProvider(widget.productId),
                ),
              ),
              loading: () => const SizedBox(
                height: 157,
                child: Center(
                  child: CustomIndicator(padding: 50),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  int tabBarSectionLength(ProductModel data) {
    final isArabicEmpty = isArabic && (data.descriptionAr?.isEmpty ?? true);
    final isUrduEmpty = isUrdu && (data.descriptionUr?.isEmpty ?? true);
    final isEnglishEmpty = data.descriptionEn?.isEmpty ?? true;

    return (isArabicEmpty || isUrduEmpty) ? 1 : (isEnglishEmpty ? 1 : 2);
  }
}

List<Map<String, dynamic>> tabDetailsData = [
  {
    "iconPath": "assets/images/product/award.png",
    "text": '100% Genuine',
  },
  {
    "iconPath": "assets/images/product/COD.png",
    "text": 'Cash on Pickup',
  },
  // {
  //   "iconPath": "assets/images/product/14-day.png",
  //   "text": 'Free 14-Day Exchanges',
  // },
  // {
  //   "iconPath": "assets/images/product/fast-time.png",
  //   "text": 'Fash Delivery',
  // }
];
