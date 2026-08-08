import 'dart:convert';
import 'dart:ui' as ui;

import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/models/cart_item_model.dart';
import 'package:ufc_mobile/riverpod/app_bar/app_bar_riverpod.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/category/category_page_riverpod.dart';
import 'package:ufc_mobile/riverpod/currency/currency_riverpod.dart';
import 'package:ufc_mobile/riverpod/state.dart';
import 'package:ufc_mobile/screens/feed_old/cart/pages/cart_page.dart';
import 'package:ufc_mobile/screens/feed_old/categories/categories_page.dart';
import 'package:ufc_mobile/screens/feed_old/home_old/home_tab.dart';
import 'package:ufc_mobile/screens/feed_old/profile/pages/profile_page.dart';
import 'package:ufc_mobile/screens/navigation/utils/bottom_nav_utils.dart';
import 'package:ufc_mobile/screens/navigation/widgets/custom_tab_bar.dart';
import 'package:ufc_mobile/screens/pet_veterinary/pages/doctor_list_page.dart';

import '../../../../main.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
    this.tabController,
    this.scrollController,
    this.initialIndex = 0,
  });
  final TabController? tabController;
  final ScrollController? scrollController;
  final int initialIndex;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin, ScreenEngagementTracker {
  Color? color;
  static late TabController navTabController;
  ScrollController homeScrollController = ScrollController();
  ScrollController cartScrollController = ScrollController();
  ScrollController profileScrollController = ScrollController();
  ScrollController stationsScrollController = ScrollController();
  ScrollController categoriesScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final String? selectedCurrency = preferences.getString("currency");
    if (selectedCurrency != null) {
      Future(() => ref.read(currencyProvider.notifier).changeSelectedCurrency(
          Currency.from(json: json.decode(selectedCurrency))));
    } else {
      final Map<String, dynamic> defaultCurrency = {
        "code": "SAR",
        "name": "Saudi Arabia Riyal",
        "symbol": "﷼",
        "number": 682,
        "flag": "SAR",
        "decimal_digits": 2,
        "name_plural": "Saudi riyals",
        "symbol_on_left": true,
        "decimal_separator": ".",
        "thousands_separator": ",",
        "space_between_amount_and_symbol": true
      };
      Future(() => ref
          .read(currencyProvider.notifier)
          .changeSelectedCurrency(Currency.from(json: defaultCurrency)));
    }

    navTabController = TabController(
        vsync: this, length: 5, initialIndex: widget.initialIndex);
    navTabController.addListener(onTabChange);

    Future.microtask(_init);
  }

  @override
  void dispose() {
    navTabController.dispose();
    super.dispose();
  }

  void onTabChange() {
    setState(() {});
  }

  Future<void> _init() async {
    await ref.read(cartProvider).getCartItems();

    if (!mounted) return;
    BottomNavUtils.deepLinkNavigation(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;
    final cartItems = ref.watch(cartProvider).cartItems;
    final isAuthorized = ref.watch(authProvider.notifier).isAuthorized();
    final int selectedItem = ref.watch(selectedAppbarItem);
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: navTabController,
            children: [
              HomeTab(),
              CategoriesPage(
                  tabController: navTabController,
                  scrollController: categoriesScrollController),
              CartPage(
                  tabController: navTabController,
                  scrollController: cartScrollController),
              DoctorListPage(
                tabController: navTabController,
              ),
              ProfilePage(
                  tabController: navTabController,
                  scrollController: profileScrollController),
            ]),
        bottomNavigationBar: selectedItem == 0
            ? Directionality(
                textDirection: ui.TextDirection.ltr,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                    border: Border.all(
                      color: const Color(0xffDFDFDF),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                    child: BottomAppBar(
                      elevation: 8,
                      color: Colors.white,
                      height: kNavBarHeight,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          textTheme: TextTheme(
                            bodyMedium:
                                TextStyle(decoration: TextDecoration.none),
                          ),
                        ),
                        child: TabBar(
                          onTap: (value) {
                            Future(() => ref
                                .read(categoryPageProvider.notifier)
                                .changeCategoryId(null));

                            if (!isAuthorized) return;
                            if (navTabController.index == 1 &&
                                (user?.preferredShop == null ||
                                    user?.preferredShopDetails?.id == null)) {
                              CustomSnackBar.error(context,
                                  "Please choose a preferred shop. It's required.");
                              navTabController.animateTo(3);
                            }
                          },
                          indicatorWeight: 1,
                          indicator: BoxDecoration(),
                          labelColor: primaryColor,
                          dividerColor: Colors.white,
                          controller: navTabController,
                          // indicatorColor: primaryColor,
                          padding: const EdgeInsets.all(0),
                          unselectedLabelColor: Colors.grey,
                          labelPadding: const EdgeInsets.all(0),
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorPadding: EdgeInsets.only(
                            left: constraints.maxWidth > 500 ? 61 : 21,
                            right: constraints.maxWidth > 500 ? 61 : 21,
                            bottom: 25,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontSize: 10,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                          ),
                          labelStyle: const TextStyle(
                            fontSize: 10,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                          ),
                          overlayColor:
                              WidgetStatePropertyAll(Colors.transparent),
                          tabs: [
                            /// HOME TAB  BAR
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: CustomTab(
                                title: "Home",
                                asset: navTabController.index == 0
                                    ? "assets/images/navigation/home-filled.png"
                                    : "assets/images/navigation/home.png",
                                isSelected: navTabController.index == 0,
                              ),
                            ),

                            /// CATEGORIES TAB BAR
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: CustomTab(
                                title: "Categories",
                                asset: navTabController.index == 1
                                    ? "assets/images/navigation/categories-filled.png"
                                    : "assets/images/navigation/categories.png",
                                isSelected: navTabController.index == 1,
                              ),
                            ),

                            /// CART TAB BAR
                            cartTabBar(cartItems),

                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: CustomTab(
                                title: "Pet Veterinary",
                                asset: navTabController.index == 3
                                    ? "assets/images/navigation/veterinary-filled.png"
                                    : "assets/images/navigation/veterinary.svg",
                                isSelected: navTabController.index == 3,
                              ),
                            ),

                            /// ACCOUNT TAB BAR
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: CustomTab(
                                title: "My Account",
                                asset: navTabController.index == 4
                                    ? "assets/images/navigation/profile-filled.png"
                                    : "assets/images/navigation/profile.png",
                                isSelected: navTabController.index == 4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : null,
      );
    });
  }

  Widget cartTabBar(List<CartItemModel>? cartItems) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 5, right: 5),
          child: CustomTab(
            title: "Cart",
            asset: navTabController.index == 2
                ? "assets/images/navigation/cart-filled.png"
                : "assets/images/navigation/cart.png",
            isSelected: navTabController.index == 2,
          ),
        ),
        cartItems == null || cartItems.isEmpty == true
            ? const SizedBox.shrink()
            : Positioned(
                top: 7,
                right: cartItems.length > 10 ? -7 : 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: CustomText(
                    text: (cartItems.length).toString(),
                    fontSize: 9,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
      ],
    );
  }
}
