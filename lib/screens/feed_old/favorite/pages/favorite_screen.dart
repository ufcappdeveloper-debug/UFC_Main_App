import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/product/fav_product_async_riverpod.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/pages/signin_page.dart';
import 'package:ufc_mobile/screens/feed_old/categories/widgets/signin_alert_sheet_for_guest_users.dart';
import 'package:ufc_mobile/screens/feed_old/favorite/widgets/empty_favorite_widget.dart';
import 'package:ufc_mobile/screens/feed_old/favorite/widgets/fav_filter_container.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/constants/widgets.dart';
import 'package:ufc_mobile/global/shared/widgets/auth/un_authorized_widget.dart';
import 'package:ufc_mobile/global/shared/widgets/common_back_app_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_footer.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_header.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/product_container.dart';
import 'package:ufc_mobile/global/shared/widgets/scroll_up_floating_btn.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen>
    with ScreenEngagementTracker {
  int page = 1;
  String? pageLimit;
  bool hasShownBottomSheet = false;
  String favSelectedFilter = "In Stock";
  List<String> favFilterData = ["In Stock", "Out of Stock"];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    page = 1;
    pageLimit = null;
    Future(() => ref
        .read(favProductAsyncProvider.notifier)
        .getFavProductList(favSelectedFilter));
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
    ).whenComplete(() {
      // This is triggered when the bottom sheet is dismissed.
      setState(() {
        hasShownBottomSheet = true;
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    _refreshController.dispose();

    super.dispose();
  }

  void _scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  void _onRefresh() async {
    page = 1;
    pageLimit = null;

    await ref
        .read(favProductAsyncProvider.notifier)
        .getFavProductList(favSelectedFilter);
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (pageLimit != "empty") {
      page++;
    }

    pageLimit = await ref
        .read(favProductAsyncProvider.notifier)
        .loadFavProductList(page, favSelectedFilter);
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).asData?.value;
    final favoriteProductProvider = ref.watch(favProductAsyncProvider);
    final isAuthorized = ref.watch(authProvider.notifier).isAuthorized();

    if (!isAuthorized && !hasShownBottomSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showUnauthorizedBottomSheet(context);
        setState(() {
          hasShownBottomSheet = true; // Mark bottom sheet as shown
        });
      });
    }
    return Scaffold(
      appBar: const CommonBackAppBar(
        title: "Favorites",
        boxShadow: [appBarShadow],
      ),
      floatingActionButtonLocation: (isArOrUr)
          ? FloatingActionButtonLocation.miniStartFloat
          : FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: favoriteProductProvider.value == null ||
              favoriteProductProvider.value!.isEmpty
          ? null
          : ScrollUpFloatingBtn(
              heroTag: 'scroll-up-tab-fav',
              margin: EdgeInsets.zero,
              onPressed: () => _scrollToTop(),
            ),
      body: isAuthorized
          ? favoriteProductProvider.when(
              data: (data) => Column(
                children: [
                  kHeight20,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: favFilterData
                          .map(
                            (e) => InkWell(
                              onTap: () {
                                favSelectedFilter = e;
                                ref
                                    .read(favProductAsyncProvider.notifier)
                                    .getFavProductList(favSelectedFilter);
                                setState(() {});
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: FavFilterContainer(
                                  data: e,
                                  favSelectedFilter: favSelectedFilter),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 9.5),
                  Expanded(
                    child: SmartRefresher(
                      enablePullUp: true,
                      enablePullDown: true,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      controller: _refreshController,
                      scrollController: scrollController,
                      header: const CustomPaginationHeader(),
                      footer: CustomPaginationFooter(
                          pageLimit: pageLimit,
                          emptyDataText: "No More Product Found"),
                      physics: const BouncingScrollPhysics(),
                      child: data == null || data.isEmpty
                          ? const EmptyFavoriteWidget()
                          : GridView.builder(
                              itemCount: data.length,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 17,
                                      childAspectRatio: 0.65,
                                      maxCrossAxisExtent: 197),
                              itemBuilder: (context, index) {
                                return ProductContainer(
                                    productData: data[index],
                                    showFavoriteIcon: true,
                                    canBuy: user?.preferredShopDetails !=
                                                null &&
                                            data[index].shopId !=
                                                user?.preferredShopDetails?.id
                                        ? false
                                        : true);
                              },
                            ),
                    ),
                  ),
                ],
              ),
              error: (error, stack) => CustomReloadProvider(
                height: 118,
                onPressed: () => ref
                    .read(favProductAsyncProvider.notifier)
                    .getFavProductList(favSelectedFilter),
              ),
              loading: () => const SizedBox(
                height: 157,
                child: Center(child: CustomIndicator(padding: 50)),
              ),
            )
          : UnAuthorizedWidget(),
    );
  }
}
