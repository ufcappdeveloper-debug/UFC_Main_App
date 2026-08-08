import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/screens/feed_old/ticket/tickets_page.dart';
import 'package:ufc_mobile/screens/feed_old/ticket/widget/custom_ticket.dart';
import 'package:ufc_mobile/global/shared/widgets/common_back_app_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_header.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

import '../../../models/ticket_model/ticket_model.dart';
import '../../../riverpod/ticket/my_tickets.dart';
import '../../../global/shared/constants/app_colors.dart';
import '../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../saved_address/widget/refresh_footer.dart';
import 'ticket_details_page.dart';

class MyTicket extends ConsumerStatefulWidget {
  const MyTicket({super.key});

  @override
  ConsumerState<MyTicket> createState() => _MyTicketState();
}

class _MyTicketState extends ConsumerState<MyTicket>
    with ScreenEngagementTracker {
  int page = 1;
  String? pageLimit;
  late RefreshController controller;
  List<TicketModel> tickets = [];

  @override
  void initState() {
    super.initState();
    page = 1;
    pageLimit = null;
    Future(() => ref.read(ticketsProvider.notifier).getTickets());
    controller = RefreshController(initialRefresh: false);
    // _onRefresh();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    page = 1;
    pageLimit = null;

    await ref.read(ticketsProvider.notifier).getTickets();
    if (mounted) setState(() {});
    controller.refreshCompleted();
  }

  Future<void> _onLoading() async {
    bool loadMore = false;
    if (pageLimit != "empty") {
      page += 1;
    }

    // pageLimit = await ref.read(ticketsProvider.notifier).loadTickets(
    //       page,
    //     );

    loadMore = await ref.read(ticketsProvider.notifier).loadTickets(page);
    if (mounted) setState(() {});
    if (loadMore) {
      controller.loadComplete();
    } else {
      controller.loadNoData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ticketsList = ref.watch(ticketsProvider);

    ref.listen(ticketsProvider, (previous, next) {
      if (mounted && next.isLoading) {
        page = 1;
        controller.resetNoData();
      }
    });

    return Scaffold(
      appBar: const CommonBackAppBar(title: "My Tickets"),
      body: Column(
        children: [
          Expanded(
            child: SmartRefresher(
                enablePullUp: true,
                enablePullDown: true,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                controller: controller,
                header: const CustomPaginationHeader(),
                footer: const RefreshFooter(),
                physics: const BouncingScrollPhysics(),
                child: ticketsList.when(
                  error: (e, s) => Center(child: Text(e.toString())),
                  loading: () => Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: Platform.isIOS
                          ? mediumGreenColor
                          : Colors.transparent,
                      valueColor:
                          const AlwaysStoppedAnimation(mediumGreenColor),
                    ),
                  ),
                  data: (List<TicketModel> data) => data.isEmpty
                      ? Center(
                          child: CustomText(
                            text: "No Tickets Exist",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TicketDetailsPage(
                                          ticketDetails: data[index])),
                                );
                              },
                              child: CustomTicket(
                                ticketModel: data[index],
                              ),
                            );
                          }),
                )),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: CustomButton(
              title: 'New Ticket',
              onTap: () async {
                final newTicket = await Navigator.push<TicketModel>(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TicketPage(page: page)));
                if (newTicket != null) {
                  debugPrint("tickets: ${tickets.length}");
                  _onLoading();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
