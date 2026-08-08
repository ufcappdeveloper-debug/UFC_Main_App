import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';
import 'package:ufc_mobile/riverpod/schedule/schedule_riverpod.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';
import 'package:ufc_mobile/screens/pet_veterinary/widgets/appointments_card.dart';
import 'package:ufc_mobile/screens/pet_veterinary/widgets/try_again_button.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/constants/widgets.dart';
import 'package:ufc_mobile/global/shared/widgets/common_back_app_bar.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key, this.tabController});
  final TabController? tabController;

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage>
    with ScreenEngagementTracker {
  final RefreshController _upcomingController =
      RefreshController(initialRefresh: false);
  final RefreshController _pastController =
      RefreshController(initialRefresh: false);
  TabController? _tabController;

  final ScrollController _upcomingScrollController = ScrollController();
  final ScrollController _pastScrollController = ScrollController();

  int upcomingPage = 1;
  int pastPage = 1;

  void _onRefresh(String type) async {
    final lastPages =
        await ref.read(appointmentAsyncProvider.notifier).getAppointments();

    if (type == "upcoming") {
      upcomingPage = lastPages["upcoming"] ?? 1;
      _upcomingController.resetNoData();
      _upcomingController.refreshCompleted();
    } else {
      pastPage = lastPages["past"] ?? 1;
      _pastController.resetNoData();
      _pastController.refreshCompleted();
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _onLoadMore(String type) async {
    int requestPage = type == "upcoming" ? upcomingPage + 1 : pastPage + 1;

    try {
      int? lastLoadedPage = await ref
          .read(appointmentAsyncProvider.notifier)
          .loadAppointments(requestPage, type);

      if (lastLoadedPage == null) {
        if (type == "upcoming") {
          _upcomingController.loadNoData();
        } else {
          _pastController.loadNoData();
        }
      } else {
        if (type == "upcoming") {
          upcomingPage = lastLoadedPage;
          _upcomingController.loadComplete();
        } else {
          pastPage = lastLoadedPage;
          _pastController.loadComplete();
        }
      }
    } catch (e) {
      if (type == "upcoming") {
        _upcomingController.loadFailed();
      } else {
        _pastController.loadFailed();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future(() => _onRefresh('upcoming'));
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(appointmentAsyncProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CommonBackAppBar(
          title: "Schedule".tr(),
          boxShadow: [appBarShadow],
          elevation: 2,
          bottom: TabBar(
            onTap: (index) {
              _onRefresh(index == 0 ? 'upcoming' : 'past');
            },
            indicatorColor: PetVeterinaryColors.borderLeftColor,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            labelStyle: PetVeterinaryFontstyles.poppinsMediumTextStyle15,
            unselectedLabelStyle:
                PetVeterinaryFontstyles.poppinsMediumTextStyle15,
            tabs: [
              Tab(text: "Upcoming".tr()),
              Tab(text: "Past".tr()),
            ],
          ),
        ),
        body: appointmentState.when(
          data: (appointments) => TabBarView(
            controller: _tabController,
            children: [
              _buildAppointmentList(
                appointments?["upcoming"] ?? [],
                _upcomingController,
                "upcoming",
                _upcomingScrollController,
              ),
              _buildAppointmentList(
                appointments?["past"] ?? [],
                _pastController,
                "past",
                _pastScrollController,
              ),
            ],
          ),
          loading: () => _buildShimmerList(),
          error: (error, _) => TryAgainButton(
            message: "We couldn't fetch the list. \nPlease try again",
            onPressed: () {
              final currentIndex = _tabController?.index ?? 0;
              final type = currentIndex == 0 ? "upcoming" : "past";
              _onRefresh(type);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentList(
    List<AppointmentModel> appointments,
    RefreshController controller,
    String type,
    ScrollController scrollController,
  ) {
    final List<GlobalKey> cardKeys =
        List.generate(appointments.length, (_) => GlobalKey());

    return SmartRefresher(
      controller: controller,
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: () => _onRefresh(type),
      onLoading: () => _onLoadMore(type),
      footer: CustomFooter(
        builder: (context, mode) {
          if (mode == LoadStatus.noMore) {
            return const SizedBox.shrink();
          } else if (mode == LoadStatus.loading) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      child: appointments.isEmpty
          ? Center(child: Text("No appointments available".tr()))
          : ListView.builder(
              controller: scrollController,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return appointments[index].doctor == null
                    ? SizedBox()
                    : AppointmentCard(
                        tabController: widget.tabController,
                        key: cardKeys[index],
                        appointment: appointments[index],
                        isPastAppointment: type == "past",
                        onTapOptions: () async {
                          final contextToScroll =
                              cardKeys[index].currentContext;
                          if (contextToScroll != null) {
                            await Scrollable.ensureVisible(
                              contextToScroll,
                              duration: const Duration(milliseconds: 300),
                              alignment: 0.3,
                            );
                          }
                        },
                      );
              },
            ),
    );
  }
}

Widget _buildShimmerList() {
  return ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    itemCount: 5,
    itemBuilder: (context, index) {
      return Container(
        margin: const EdgeInsets.only(bottom: 24, left: 6.5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: isArabic
              ? const Border(right: BorderSide(color: Colors.green, width: 1.5))
              : const Border(left: BorderSide(color: Colors.green, width: 1.5)),
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(height: 12, width: 100, color: Colors.white),
                  Container(height: 24, width: 24, color: Colors.white),
                ],
              ),
              const SizedBox(height: 12),
              // Doctor Row
              Row(
                children: [
                  const CircleAvatar(
                      radius: 20.5, backgroundColor: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 14, width: 120, color: Colors.white),
                        const SizedBox(height: 6),
                        Container(height: 12, width: 80, color: Colors.white),
                      ],
                    ),
                  ),
                  Container(height: 20, width: 20, color: Colors.white),
                ],
              ),
              const SizedBox(height: 12),
              Container(height: 1, width: double.infinity, color: Colors.white),
              const SizedBox(height: 12),
              // Time Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(height: 12, width: 100, color: Colors.white),
                  Container(height: 12, width: 20, color: Colors.white),
                  Container(height: 12, width: 60, color: Colors.white),
                ],
              ),
              const SizedBox(height: 12),
              Container(height: 1, width: double.infinity, color: Colors.white),
              const SizedBox(height: 12),
              // Duration & Sessions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(height: 12, width: 90, color: Colors.white),
                  Container(height: 12, width: 90, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
