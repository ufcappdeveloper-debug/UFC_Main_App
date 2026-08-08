import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/riverpod/station/station_async.dart';
import 'package:ufc_mobile/screens/feed_old/categories/widgets/category_custom_search_app_bar.dart';
import 'package:ufc_mobile/screens/feed_old/favorite/pages/favorite_screen.dart';
import 'package:ufc_mobile/screens/feed_old/profile/pages/notification_page.dart';
import 'package:ufc_mobile/screens/feed_old/stations/widget/station_page_shop_container.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_no_data.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_footer.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_header.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/scroll_up_floating_btn.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

import 'station_detail_tab_screen.dart';

class StationsPage extends ConsumerStatefulWidget {
  const StationsPage({super.key, this.tabController, this.scrollController});
  final TabController? tabController;
  final ScrollController? scrollController;

  @override
  ConsumerState<StationsPage> createState() => _StationsPageState();
}

class _StationsPageState extends ConsumerState<StationsPage>
    with ScreenEngagementTracker {
  int page = 1;
  String? pageLimit;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    page = 1;
    pageLimit = null;
    super.initState();
    Future(() => ref.read(stationAsyncProvider.notifier).getStations());
  }

  @override
  void dispose() {
    _scrollController.dispose();
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

    await ref.read(stationAsyncProvider.notifier).getStations();
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (pageLimit != "empty") {
      page++;
    }

    pageLimit =
        await ref.read(stationAsyncProvider.notifier).loadStations(page);
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final stationData = ref.watch(stationAsyncProvider);
    return Scaffold(
      appBar: CategoryCustomSearchAppBar(
        searchController: searchController,
        onChanged: (value) =>
            ref.read(stationAsyncProvider.notifier).getStations(
                  search: searchController.text,
                ),
        onHeartPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FavoriteScreen(),
          ),
        ),
        onHomeCartPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          widget.tabController?.animateTo(2);
        },
        onNotificationPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationPage(),
              ));
        },
      ),
      floatingActionButtonLocation: (isArOrUr)
          ? FloatingActionButtonLocation.miniStartFloat
          : FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: ScrollUpFloatingBtn(
        heroTag: 'scroll-up-tab-station',
        onPressed: () => _scrollToTop(),
      ),
      body: stationData.when(
        error: (error, stackTrace) => CustomText(
          text: "something went wrong",
        ),
        loading: () => const Center(child: CupertinoActivityIndicator()),
        data: (data) {
          return SmartRefresher(
            enablePullUp: true,
            enablePullDown: true,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            controller: _refreshController,
            scrollController: _scrollController,
            header: const CustomPaginationHeader(),
            footer: CustomPaginationFooter(
                pageLimit: pageLimit, emptyDataText: "No More Station Found"),
            physics: const BouncingScrollPhysics(),
            child: (data == null || data.isEmpty)
                ? const Column(
                    children: [
                      CustomNoData(
                        height: 56,
                        text: "No Station Found",
                      ),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: [
                      const SizedBox(
                        height: 23,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back, size: 18),
                          ),
                          SizedBox(width: 8),
                          CustomText(
                            text: 'Our Stations',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      const SizedBox(height: 23),
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                mainAxisSpacing: 17,
                                crossAxisSpacing: 17,
                                childAspectRatio: 0.65,
                                mainAxisExtent: 200,
                                maxCrossAxisExtent: 197),
                        // const SliverGridDelegateWithFixedCrossAxisCount(
                        //     mainAxisExtent: 200,
                        //     mainAxisSpacing: 18,
                        //     crossAxisSpacing: 10,
                        //     crossAxisCount: 2),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StationDetailScreen(
                                          station: data[index],
                                        )));
                          },
                          child: StationPageShopContainer(station: data[index]),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
