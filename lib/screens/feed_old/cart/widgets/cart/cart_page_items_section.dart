import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/product/fav_product_async_riverpod.dart';
import 'package:ufc_mobile/riverpod/state.dart';
import 'package:ufc_mobile/screens/feed_old/cart/widgets/cart/cart_page_product_container.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/provider/user_points.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/util/exception/error_handler.dart';

class CartPageItemsSection extends ConsumerStatefulWidget {
  const CartPageItemsSection({super.key});

  @override
  ConsumerState<CartPageItemsSection> createState() =>
      _CartPageItemsSectionState();
}

class _CartPageItemsSectionState extends ConsumerState<CartPageItemsSection> {
  List<bool> isFavorite = [];
  ScrollController? scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    isFavorite.clear();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;
    final cartItems = ref.watch(cartProvider).cartItems;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: cartItems.length,
      controller: scrollController,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      itemBuilder: (context, index) {
        final cartItem = cartItems[index];
        if (user != null &&
            user.favoriteProducts != null &&
            (user.favoriteProducts ?? []).isNotEmpty) {
          if (user.favoriteProducts!.contains(cartItem.productId)) {
            isFavorite.add(true);
          } else {
            isFavorite.add(false);
          }
          debugPrint("inside${cartItem.productId}$isFavorite");
        }
        debugPrint(cartItem.productId.toString() + isFavorite.toString());
        return CartPageProductContainer(
          item: cartItem,
          isFavorite: isFavorite.isNotEmpty && isFavorite[index],
          onIncrement: cartItem.quantity! < 99
              ? () async {
                  debugPrint('increment');
                  await ref.read(cartProvider).incrementItem(cartItem.id!);
                }
              : null,
          onDecrement: cartItem.quantity! > 1
              ? () async {
                  debugPrint('decrement');
                  await ref.read(cartProvider).decrementItem(cartItem.id!);
                }
              : cartItem.quantity == 1
                  ? () async {
                      await ref.read(cartProvider).deleteItem(cartItem.id!);
                    }
                  : null,
          onDelete: () async {
            debugPrint('delete');
            await ref.read(cartProvider).deleteItem(cartItem.id!);
            await Future.delayed(Duration(milliseconds: 500));
            isFavorite.removeAt(index);
            setState(() {});
          },
          unclaim: () async {
            await ref
                .read(userPointsProvider.notifier)
                .unclaimProduct(cartItem.id ?? 0, cartItem.productId ?? 0);
            await ref.read(cartProvider).removeRewardProductItem(cartItem.id!);
            await Future.delayed(Duration(milliseconds: 500));
            isFavorite.removeAt(index);
            setState(() {});
          },
          onFavorite: () async {
            if (cartItems.isEmpty || cartItem.productId == null) return;
            try {
              if (isFavorite.isEmpty) {
                isFavorite = List.generate(cartItems.length, (_) => false);
              }

              isFavorite[index] = await ref
                  .read(favProductAsyncProvider.notifier)
                  .addOrRemoveFavProduct(productId: cartItem.productId!);
              await Future.delayed(Duration(milliseconds: 500));

              if (isFavorite[index]) {
                if (!context.mounted) return;
                CustomSnackBar.success(context, "Favorite added successfully");
              } else {
                if (!context.mounted) return;
                CustomSnackBar.success(
                    context, "Favorite removed successfully");
              }
              ref
                  .read(authProvider.notifier)
                  .updateFavoriteShop(isFavorite[index], cartItem.productId!);
              setState(() {});
            } catch (e) {
              ErrorHandler.handleError(context, e);
            }
          },
        );
      },
    );
  }
}
