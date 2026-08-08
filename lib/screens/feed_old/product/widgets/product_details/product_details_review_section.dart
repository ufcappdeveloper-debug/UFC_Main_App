import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/rating/rating_async_riverpod.dart';
import 'package:ufc_mobile/screens/feed_old/product/widgets/product_widgets.dart';
import 'package:ufc_mobile/screens/feed_old/review/add_review_page.dart';
import 'package:ufc_mobile/screens/feed_old/review/all_reviews_page.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class ProductDetailsReviewSection extends ConsumerStatefulWidget {
  const ProductDetailsReviewSection({
    super.key,
    required this.productData,
  });
  final ProductModel productData;

  @override
  ConsumerState<ProductDetailsReviewSection> createState() =>
      _ProductDetailsReviewSectionState();
}

class _ProductDetailsReviewSectionState
    extends ConsumerState<ProductDetailsReviewSection> {
  @override
  void initState() {
    super.initState();

    Future(() => ref
        .read(ratingAsyncProvider.notifier)
        .getProductRating(widget.productData.id));
  }

  @override
  Widget build(BuildContext context) {
    final productRatingsProvider = ref.watch(ratingAsyncProvider);
    final isAuthorized = ref.watch(authProvider.notifier).isAuthorized();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              CustomText(
                text: 'Reviews'.tr(),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(width: 8),
              if ((widget.productData.rating != null &&
                      widget.productData.rating! > 0) ||
                  (widget.productData.ratingCount != null &&
                      widget.productData.ratingCount! > 0))
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: Color(0xffF8E71C),
                    ),
                    const SizedBox(width: 3.5),
                    CustomText(
                      text:
                          (widget.productData.rating ?? 0.0).toStringAsFixed(1),
                      color: const Color(0xff8E8E93),
                    ),
                    const SizedBox(width: 5),
                    CustomText(
                        text: '(${widget.productData.ratingCount ?? 0})',
                        color: const Color(0xffD0D0D0)),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10),
          productRatingsProvider.when(
            data: (ratingData) => (ratingData == null || ratingData.isEmpty)
                ? const SizedBox.shrink()
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: ratingData.length > 2 ? 2 : ratingData.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => customerProductReview(
                        context,
                        ratingData: ratingData[index]),
                  ),
            error: (error, stack) => GestureDetector(
              onTap: () => ref
                  .read(ratingAsyncProvider.notifier)
                  .getProductRating(widget.productData.id),
              child: Container(
                height: 111,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Something Went Wrong'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        color: primaryColor.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    kWidth10,
                    Icon(
                      Icons.replay_rounded,
                      color: primaryColor.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
            loading: () => const SizedBox(
              height: 157,
              child: Center(child: CustomIndicator(padding: 50)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              children: [
                InkWell(
                  onTap: !isAuthorized
                      ? () => CustomSnackBar.error(
                          context, "Please sign in to continue")
                      : widget.productData.id == null
                          ? () {}
                          : () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddReviewPage(
                                      productId: widget.productData.id!),
                                ),
                              ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: CustomText(
                      text: 'Add a Review',
                      color: primaryColor,
                      fontWeight: FontWeight.w300),
                ),
                const SizedBox(width: 25),
                widget.productData.ratingCount == null ||
                        widget.productData.ratingCount == 0
                    ? const SizedBox()
                    : InkWell(
                        onTap: widget.productData.id == null
                            ? () {}
                            : () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllReviewsPage(
                                      productId: widget.productData.id!),
                                )),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: CustomText(
                            text: 'All Reviews',
                            color: primaryColor,
                            fontWeight: FontWeight.w300),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
