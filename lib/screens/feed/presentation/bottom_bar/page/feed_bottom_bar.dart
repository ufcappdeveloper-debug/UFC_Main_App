import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_images.dart';
import 'package:ufc_mobile/global/language_cubit/language_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/bottom_bar_bloc/bottom_bar_bloc.dart';
import 'package:ufc_mobile/screens/feed/application/productList/filter_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/productList/product_list_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_list_params.dart';
import 'package:ufc_mobile/screens/feed/presentation/bottom_bar/utils/feed_bottom_bar_utils.dart';
import 'package:ufc_mobile/screens/feed/presentation/bottom_bar/widget/feed_bottom_bar_item.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../../global/shared/widgets/show_confirmation_dailog.dart';
import '../../../application/cart/cart_cubit.dart';
import '../../../application/cart/cart_state.dart';
import '../../../application/business_config/business_config_cubit.dart';
import '../../../application/distributor/distributor_cart_cubit.dart';
import '../../../application/main_source/main_source_cart_cubit.dart';
import '../../../domain/entities/main_source/main_source_api_exception.dart';
import '../../main_source/pages/main_source_home_page.dart'
    show mainSourceHomeExpanded;
import '../../main_source/utils/main_source_errors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import '../../../application/navbar/app_bar_cubit.dart';
import '../../category/pages/category_screen.dart';

// Cubit to control bottom bar visibility
class BottomBarVisibilityCubit extends Cubit<bool> {
  BottomBarVisibilityCubit() : super(true);

  void show() => emit(true);
  void hide() => emit(false);
}

class FeedBottomBar extends StatefulWidget {
  final ProductListCubit prodCubit;
  const FeedBottomBar({
    super.key,
    required this.prodCubit,
  });

  @override
  State<FeedBottomBar> createState() => _FeedBottomBarState();
}

class _FeedBottomBarState extends State<FeedBottomBar>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Navigator keys for each tab
  final Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
    3: GlobalKey<NavigatorState>(),
  };

  @override
  void initState() {
    super.initState();

    // Main Source mode opens on the Products tab; marketplace mode keeps
    // opening on Home.
    if (context.read<BusinessConfigCubit>().state.isMainSource &&
        context.read<FeedBottomNavCubit>().state == 0) {
      context.read<FeedBottomNavCubit>().changeTab(1);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _syncAppBar(context.read<FeedBottomNavCubit>().state);
      });
    }

    final currentFeedTab = context.read<FeedBottomNavCubit>().state;
    final initialImage =
        currentFeedTab == 0 ? AppImages.feedBg : AppImages.feedSmallBg;

    context.read<FeedBackgroundCubit>().updateBackground(initialImage);
  }

  /// Small header on every tab but Home, and on the Main Source home
  /// while its sheet is lifted.
  bool _smallHeader(int index) =>
      index != 0 ||
      (mainSourceHomeExpanded.value &&
          context.read<BusinessConfigCubit>().state.isMainSource);

  void _syncAppBar(int index) {
    final small = _smallHeader(index);
    context.read<AppBarHeightCubit>().setHeight(small ? 31 : 74);
    context
        .read<AppBarCubit>()
        .setMode(small ? AppBarMode.channel : AppBarMode.normal);
    // context.read<BottomNavIndexCubit>().update(farm: index == 0);
  }

  void _onTabTapped(int index) {
    if (index == 0) {
      // Home tab
      final authState = context.read<AuthCubit>().state;
      if (authState is ProfileLoadedSuccess) {
        context.read<ProductListCubit>().getProducts(
              params: ProductListQueryParams(
                  shopId: authState.user.preferredShopDetails?.id ?? 0,
                  userId: authState.user.id),
            );
      }
    }
    context.read<FeedBottomNavCubit>().changeTab(index);
    _syncAppBar(index);
    final imagePath =
        _smallHeader(index) ? AppImages.feedSmallBg : AppImages.feedBg;
    context.read<FeedBackgroundCubit>().updateBackground(imagePath);
    if (index == 1) {
      // Category tab → reset UI tab, then fetch filtered products
      CategoryScreen.categoryKey.currentState?.resetTab();

      final filterState = context.read<FilterCubit>().state;

      context.read<ProductListCubit>().updateParams(
            type: filterState.filterItems[0][0].isNotEmpty
                ? filterState.filterItems[0][0]
                : null,
            size: filterState.filterItems[0][1].isNotEmpty
                ? double.tryParse(
                    filterState.filterItems[0][1].split(' ').first)
                : null,
            price: filterState.filterPrice,
          );
    }
  }

  /// `403 BUSINESS_MODE_DISABLED` (plan §1): show the message and go back
  /// to Home, which renders the new mode (the config is being refetched).
  Future<void> _onBusinessModeDisabled() async {
    // Let the screen that made the call close its loading dialog first.
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).popUntil((r) => r.isFirst);
    for (final key in navigatorKeys.values) {
      key.currentState?.popUntil((r) => r.isFirst);
    }
    context.read<BottomBarVisibilityCubit>().show();
    context.read<FeedBottomNavCubit>().changeTab(0);
    _syncAppBar(0);
    context.read<FeedBackgroundCubit>().updateBackground(AppImages.feedBg);
    CustomSnackBar.error(
        context, mainSourceCodeText(MainSourceErrorCode.businessModeDisabled)!);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<BusinessConfigCubit, BusinessConfigState>(
      listenWhen: (p, c) => p.modeDisabledEventId != c.modeDisabledEventId,
      listener: (_, __) => _onBusinessModeDisabled(),
      child: VisibilityDetector(
        key: const Key('feed-bottom-bar'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0) {
            final index = context.read<FeedBottomNavCubit>().state;
            _syncAppBar(index);
          }
        },
        child: BlocBuilder<LanguageCubit, Locale>(
          builder: (context, locale) {
            return BlocBuilder<FeedBottomNavCubit, int>(
              builder: (context, selectedIndex) {
                // return BlocBuilder<BottomNavCubit, BottomNavState>(
                // builder: (context, homeState) {
                return BlocBuilder<BottomBarVisibilityCubit, bool>(
                  builder: (context, isVisible) {
                    return WillPopScope(
                      onWillPop: () async {
                        final currentNavigatorState =
                            navigatorKeys[selectedIndex]?.currentState;

                        // 1️⃣ If current tab has navigation stack, pop it
                        if (currentNavigatorState != null &&
                            currentNavigatorState.canPop()) {
                          currentNavigatorState.pop();
                          return false;
                        }
                        if (selectedIndex != 0) {
                          context.read<FeedBottomNavCubit>().changeTab(0);
                          context
                              .read<FeedBackgroundCubit>()
                              .updateBackground(AppImages.feedBg);
                          context
                              .read<AppBarCubit>()
                              .setMode(AppBarMode.normal);
                          return false;
                        }
                        final shouldExit = await showConfirmationDialog(
                          context: context,
                          title: 'exit_app_title'.tr(),
                          content: 'exit_app_content'.tr(),
                        );

                        return shouldExit;
                      },
                      child: BlocProvider.value(
                        value: widget.prodCubit,
                        child: Scaffold(
                          backgroundColor: Colors.transparent,
                          body: IndexedStack(
                            index: selectedIndex,
                            children:
                                FeedBottomBarUtils.tabNames.asMap().entries.map(
                              (entry) {
                                final index = entry.key;
                                final name = entry.value;

                                return Navigator(
                                  key: navigatorKeys[index],
                                  onGenerateRoute: (_) => MaterialPageRoute(
                                    builder: (_) =>
                                        FeedBottomBarUtils.getPageForTab(
                                            name, context),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                          bottomNavigationBar: isVisible
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.10),
                                        offset: const Offset(0, -2),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                    child: SafeArea(
                                        child: BottomNavigationBar(
                                      backgroundColor: Colors.white,
                                      selectedItemColor:
                                          PetVeterinaryColors.mainColorUFC,
                                      unselectedItemColor:
                                          PetVeterinaryColors.newPetLightGray,
                                      showUnselectedLabels: true,
                                      showSelectedLabels: true,
                                      currentIndex: selectedIndex,
                                      onTap: (index) {
                                        context
                                            .read<FeedBottomNavCubit>()
                                            .changeTab(index);
                                        _onTabTapped(index);

                                        // Reset Category tab when selected
                                        if (index == 1) {
                                          CategoryScreen
                                              .categoryKey.currentState
                                              ?.resetTab();
                                        }
                                      },
                                      items: FeedBottomBarUtils.tabNames
                                          .map((name) {
                                        final index = FeedBottomBarUtils
                                            .tabNames
                                            .indexOf(name);
                                        final isSelected =
                                            selectedIndex == index;
                                        return FeedBottomBarItem(
                                          iconPath:
                                              FeedBottomBarUtils.getIconForTab(
                                            name,
                                            isSelected: isSelected,
                                          ),
                                          title: name,
                                          isSelected: isSelected,
                                          badgeCount: name == "Cart"
                                              ? _cartBadge(context)
                                              : 0,
                                          isFirst: index == 0,
                                          isLast: index ==
                                              FeedBottomBarUtils
                                                      .tabNames.length -
                                                  1,
                                        );
                                      }).toList(),
                                    )),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        )),
    );
  }
}

/// Shop cart + distributor cart (or the Main Source cart), shown on the
/// Cart tab.
int _cartBadge(BuildContext context) {
  final shop = context.select<CartCubit, int>((c) {
    final s = c.state;
    if (s is CartLoaded) return s.cartCount;
    if (s is CartCountLoaded) return s.count;
    return c.lastCount;
  });
  final distributor =
      context.select<DistributorCartCubit, int>((c) => c.state.count);
  // Main Source mode shows only the Main Source cart.
  final mainSource = context.select<BusinessConfigCubit, bool>(
      (c) => c.state.isMainSource);
  if (mainSource) {
    return context.select<MainSourceCartCubit, int>((c) => c.state.count);
  }
  return shop + distributor;
}

class FeedBackgroundCubit extends Cubit<String> {
  FeedBackgroundCubit() : super(AppImages.feedBg);

  void updateBackground(String imagePath) => emit(imagePath);
}
