import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/models/notification_model.dart';
import 'package:ufc_mobile/riverpod/notification/notification_async_riverpod.dart';
import 'package:ufc_mobile/screens/feed_old/profile/pages/notification_page.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_footer.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_header.dart';

class NotificationList extends ConsumerStatefulWidget {
  const NotificationList(
      {super.key, required this.data, required this.category});

  final List<NotificationModel> data;
  final String category;

  @override
  ConsumerState<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends ConsumerState<NotificationList> {
  int page = 1;
  String? pageLimit;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void _onLoading() async {
    if (pageLimit != "empty") {
      page++;
    }
    pageLimit = await ref
        .read(notificationAsyncProvider.notifier)
        .loadNotifications(page);
    if (mounted) setState(() {});
    refreshController.loadComplete();
  }

  void _onRefresh() async {
    page = 1;
    pageLimit = null;

    await ref.read(notificationAsyncProvider.notifier).getNotifications();
    if (mounted) setState(() {});
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SmartRefresher(
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        controller: refreshController,
        header: const CustomPaginationHeader(),
        footer: CustomPaginationFooter(
            pageLimit: pageLimit, emptyDataText: "No More Notifications Found"),
        physics: const BouncingScrollPhysics(),
        child: ListView.builder(
            itemCount: widget.data.length,
            itemBuilder: (context, index) {
              return NotificationTile(notification: widget.data[index]);
            }),
      ),
    );
  }
}
