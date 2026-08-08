import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/riverpod/rating/rating_async_riverpod.dart';
import 'package:ufc_mobile/screens/feed_old/product/widgets/product_widgets.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/common_back_app_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_no_data.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_footer.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_header.dart';
import 'package:ufc_mobile/global/shared/widgets/scroll_up_floating_btn.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

class AllReviewsPage extends ConsumerStatefulWidget {
  const AllReviewsPage({super.key, required this.productId});
  final int productId;

  @override
  ConsumerState<AllReviewsPage> createState() => _AllReviewsPageState();
}

class _AllReviewsPageState extends ConsumerState<AllReviewsPage>
    with ScreenEngagementTracker {
  int page = 1;
  String? pageLimit;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    page = 1;
    pageLimit = null;
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  void _onRefresh() async {
    page = 1;
    pageLimit = null;

    await ref
        .read(ratingAsyncProvider.notifier)
        .getProductRating(widget.productId);
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (pageLimit != "empty") {
      page++;
    }

    pageLimit = await ref
        .read(ratingAsyncProvider.notifier)
        .loadProductRating(page, widget.productId);
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final productRatingsProvider = ref.watch(ratingAsyncProvider);
    return Scaffold(
      appBar: CommonBackAppBar(title: "All review".tr()),
      floatingActionButtonLocation: (isArOrUr)
          ? FloatingActionButtonLocation.miniStartFloat
          : FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: productRatingsProvider.value == null ||
              productRatingsProvider.value!.isEmpty
          ? null
          : ScrollUpFloatingBtn(
              margin: EdgeInsets.zero,
              heroTag: 'scroll-up-tab-review',
              onPressed: () => _scrollToTop(),
            ),
      body: productRatingsProvider.when(
        data: (data) => SmartRefresher(
          enablePullUp: true,
          enablePullDown: true,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          controller: _refreshController,
          scrollController: _scrollController,
          header: const CustomPaginationHeader(),
          footer: CustomPaginationFooter(
              pageLimit: pageLimit, emptyDataText: "No More Review Found"),
          physics: const BouncingScrollPhysics(),
          child: (data == null || data.isEmpty)
              ? Column(
                  children: [
                    CustomNoData(
                      height: 56,
                      text: "No Review Found".tr(),
                    ),
                  ],
                )
              : ListView.builder(
                  itemCount: data.length,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  itemBuilder: (context, index) =>
                      customerProductReview(context, ratingData: data[index]),
                ),
        ),
        error: (error, stack) => GestureDetector(
          onTap: () => ref
              .read(ratingAsyncProvider.notifier)
              .getProductRating(widget.productId),
          child: Container(
            height: 157,
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
                  'Something Went Wrong',
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
        loading: () => const Column(
          children: [
            SizedBox(
              height: 157,
              child: Center(child: CustomIndicator(padding: 50)),
            ),
          ],
        ),
      ),
    );
  }
}
