import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/global/shared/widgets/auth/un_authorized_widget.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/state.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/pages/signin_page.dart';
import 'package:ufc_mobile/screens/feed_old/cart/widgets/cart/cart_page_bottom_btn_section.dart';
import 'package:ufc_mobile/screens/feed_old/cart/widgets/cart/cart_page_empty_section.dart';
import 'package:ufc_mobile/screens/feed_old/cart/widgets/cart/cart_page_items_section.dart';
import 'package:ufc_mobile/screens/feed_old/categories/widgets/signin_alert_sheet_for_guest_users.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({
    super.key,
    this.tabController,
    this.isPush = false,
    this.scrollController,
    this.isFromLoyalty = false,
  });
  final bool isPush;
  final bool isFromLoyalty;
  final TabController? tabController;
  final ScrollController? scrollController;

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage>
    with ScreenEngagementTracker {
  bool isCartEmpty = false;
  bool showBooking = false;
  bool hasShownBottomSheet = false;
  DateTime date = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();

    Future.microtask(_init);
  }

  Future<void> _init() async {
    await ref.read(cartProvider).getCartItems();
  }

  void _showUnauthorizedBottomSheet(BuildContext context) {
    showUnauthorizedBottomSheet(
      context,
      onSignInPressed: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
            (route) => false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider).cartItems;
    final isLoading = ref.watch(cartProvider).isCartLoading;
    final isCartFailed = ref.watch(cartProvider).isCartFailed;
    final isAuthorized = ref.read(authProvider.notifier).isAuthorized();

    if (!isAuthorized && !hasShownBottomSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showUnauthorizedBottomSheet(context);
        hasShownBottomSheet = true; // Mark bottom sheet as shown
      });
    }

    Widget child = CartPageEmptySection();

    if (isLoading) {
      child = SizedBox(
        height: 157,
        child: Center(child: CustomIndicator(padding: 50)),
      );
    } else if (isCartFailed) {
      child = CustomReloadProvider(
        height: 118,
        onPressed: _init,
      );
    } else if (!isListEmpty(cartItems)) {
      child = CartPageItemsSection();
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        Future.microtask(() {
          ref.read(cartProvider).clear();
        });
      },
      child: Scaffold(
      
        appBar: AppBar(
          title: CustomText(
            text: 'My Cart',
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: Colors.black.withValues(alpha: 0.3),
          leading: widget.isFromLoyalty
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                )
              : null,
        ),
        bottomNavigationBar: CartPageBottomBtnSection(),
        body: isAuthorized ? child : UnAuthorizedWidget(),
      ),
    );
  }
}
