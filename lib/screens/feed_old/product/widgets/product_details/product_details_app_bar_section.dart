import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/shared/widgets/product_carousel_indicator.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/product/fav_product_async_riverpod.dart';
import 'package:ufc_mobile/riverpod/product/product_riverpod.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/feed_old/product/widgets/product_image_slider.dart';


// class ProductDetailsAppBarSection extends StatefulWidget {
//   final int productId;
//   final ProductModel product;

//   const ProductDetailsAppBarSection({
//     super.key,
//     required this.productId,
//     required this.product,
//   });

//   @override
//   State<ProductDetailsAppBarSection> createState() =>
//       _ProductDetailsAppBarSectionState();
// }

// class _ProductDetailsAppBarSectionState
//     extends State<ProductDetailsAppBarSection> {
//   int selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 10),
//         Stack(
//           children: [
//             /// ✅ Image slider
//             ProductImageSlider(
//               images: widget.product.images,
//               onPageChanged: (index, reason) =>
//                   setState(() => selectedIndex = index),
//             ),

//             /// ✅ Top bar (back + fav + share)
//             Positioned(
//               top: 20,
//               left: 10,
//               right: 10,
//               child: Row(
//                 children: [
//                   /// Back button
//                   IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: const Icon(Icons.arrow_back_ios_rounded),
//                   ),
//                   const Spacer(),

//                   /// Favorite button
//                   BlocBuilder<ProductListCubit, ProductListState>(
//                     builder: (context, state) {
//                       final isFavorite =
//                           widget.product.isFavorite ?? false;

//                       return IconButton(
//                         icon: Icon(
//                           isFavorite
//                               ? Icons.favorite
//                               : Icons.favorite_border,
//                           color: primaryColor,
//                         ),
//                         onPressed: () {
//                           final authCubit = context.read<AuthCubit>();
//                           if (authCubit.currentUser == null) {
//                             CustomSnackBar.error(context,
//                                 "Please login to add to favorites");
//                             return;
//                           }

//                           context
//                               .read<ProductListCubit>()
//                               .toggleFavorite(widget.productId);

//                           final newState = !isFavorite;
//                           CustomSnackBar.success(
//                             context,
//                             newState
//                                 ? "Added to favorites"
//                                 : "Removed from favorites",
//                           );
//                         },
//                       );
//                     },
//                   ),

//                   const SizedBox(width: 8),

//                   /// Share button
//                   IconButton(
//                     icon: const Icon(Icons.share),
//                     onPressed: () {
//                       Share.share(
//                         'https://www.ufc.mvp-apps.ae/productdetails/${widget.product.id}',
//                         subject: widget.product.nameEn ?? "Product",
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),

//         /// ✅ Carousel indicator (dots)
//         ProductCarouselIndicator(
//           indicatorSize: 6,
//           selectedIndex: selectedIndex,
//           carouselLength: widget.product.images?.length ?? 0,
//         ),
//       ],
//     );
//   }
// }


class ProductDetailsAppBarSection extends ConsumerStatefulWidget {
  const ProductDetailsAppBarSection({
    super.key,
    required this.product,
    required this.productId,
  });
  final int productId;
  final ProductModel product;

  @override
  ConsumerState<ProductDetailsAppBarSection> createState() =>
      _ProductDetailsAppBarSectionState();
}

class _ProductDetailsAppBarSectionState
    extends ConsumerState<ProductDetailsAppBarSection> {
  int selectedIndex = 0;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    final user = ref.read(authProvider).value;
    if (user != null && user.favoriteProducts!.contains(widget.productId)) {
      isFavorite = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAuthorized = ref.watch(authProvider.notifier).isAuthorized();
    return Column(
      children: [
        kHeight20,
        Stack(
          children: [
            ProductImageSlider(
                images: widget.product.images,
                onPageChanged: (index, reason) =>
                    setState(() => selectedIndex = index)),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      ref.read(productProvider).changeProductQty(1);
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Icon(Icons.arrow_back_ios_rounded))),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Theme(
                          data: Theme.of(context).copyWith(
                              splashColor: primaryColor.withValues(alpha: 0.23),
                              highlightColor: Colors.transparent),
                          child: IconButton(
                              splashRadius: 25,
                              padding: const EdgeInsets.all(0),
                              constraints: const BoxConstraints(
                                  minWidth: 19, maxWidth: 19),
                              icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: primaryColor),
                              onPressed: () async {
                                if (!isAuthorized) {
                                  CustomSnackBar.error(context,
                                      "Please signin to add items to cart");
                                  return;
                                }

                                try {
                                  final future = ref
                                      .read(favProductAsyncProvider.notifier)
                                      .addOrRemoveFavProduct(
                                          productData: widget.product);
                                  isFavorite =
                                      await LoadingDialog.show(context, future);
                                  if (isFavorite && context.mounted) {
                                    CustomSnackBar.success(
                                        context, "Favorite added successfully");
                                  } else {
                                    if (context.mounted) {
                                      CustomSnackBar.success(context,
                                          "Favorite removed successfully");
                                    }
                                  }
                                  ref
                                      .read(authProvider.notifier)
                                      .updateFavoriteShop(
                                          isFavorite, widget.productId);
                                  setState(() {});
                                } catch (e) {
                                  if (!context.mounted) return;
                                  CustomSnackBar.error(context, e.toString());
                                }
                              })),
                      const SizedBox(width: 10),
                      Theme(
                        data: Theme.of(context).copyWith(
                            splashColor: primaryColor.withValues(alpha: 0.23),
                            highlightColor: Colors.transparent),
                        child: IconButton(
                          splashRadius: 25,
                          padding: const EdgeInsets.all(0),
                          constraints:
                              const BoxConstraints(minWidth: 17, maxWidth: 17),
                          icon: Image.asset('assets/images/product/share.png',
                              height: 18),
                          onPressed: () => Share.share(
                            'https://www.ufc.mvp-apps.ae/productdetails/${widget.product.id}',
                            subject: context.locale.languageCode == "en"
                                ? widget.product.nameEn
                                : context.locale.languageCode == "ar"
                                    ? widget.product.nameAr
                                    : widget.product.nameUr,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        ProductCarouselIndicator(
            indicatorSize: 5,
            selectedIndex: selectedIndex,
            carouselLength: widget.product.images?.length ?? 0),
      ],
    );
  }
}
