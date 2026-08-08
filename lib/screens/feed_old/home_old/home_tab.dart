import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/data/appointment_service.dart';
import 'package:ufc_mobile/global/extensions/lang_switcher.dart';
import 'package:ufc_mobile/global/util/lang/langauge_manager.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';
import 'package:ufc_mobile/models/schedule/appointment_page_result.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/category/category_async_riverpod.dart';
import 'package:ufc_mobile/riverpod/home/home_async_riverpod.dart';
import 'package:ufc_mobile/screens/feed_old/home/widgets/home/home_banner_section.dart';
import 'package:ufc_mobile/screens/feed_old/home/widgets/home/home_order_now_section.dart';
import 'package:ufc_mobile/screens/feed_old/home/widgets/home/home_pickup_section.dart';
import 'package:ufc_mobile/screens/feed_old/home/widgets/home/home_top_of_the_week_section.dart';
import 'package:ufc_mobile/screens/feed_old/home/widgets/shimmer_home_page.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/provider/user_points_feature_access.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/widgets/loyality_points_reusable_progress_card.dart';
import 'package:ufc_mobile/screens/pet_veterinary/pages/schedule_page.dart';
import 'package:ufc_mobile/screens/pet_veterinary/widgets/appointment_homepage_card.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_header.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({
    super.key,
  });

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<HomeTab> {
  bool isLoading = false;
  RefreshController _homeRefreshController = RefreshController();
  late TabController _tabController;
  late ScrollController scrollController;
  @override
  bool get wantKeepAlive => true; // Keep the widget alive

  @override
  void initState() {
    super.initState();

    _homeRefreshController = RefreshController();
    scrollController = ScrollController();
    // 👇 Forces rebuild after frame render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
      _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
      _tabController.addListener(() {
        if (!_tabController.indexIsChanging) {
          setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    _homeRefreshController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    HomeOrderNowSection.homeCategoryPageLimit.value = null;

    Future(() => ref.read(homeAsyncProvider.notifier).getHomepage());
    Future(() => ref.read(categoryAsyncProvider.notifier).getCategories());
    if (mounted) setState(() {});
    _homeRefreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final homeProvider = ref.watch(homeAsyncProvider);
    final isAuthorized = ref.watch(authProvider.notifier).isAuthorized();
    final featureAccess =
        ref.watch(userPointsFeatureAccessProvider).asData?.value;
    debugPrint("Feature Access: $featureAccess");

    return Scaffold(
      extendBody: true,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: primaryColor),
            )
          : homeProvider.when(
              data: (data) => SmartRefresher(
                enablePullDown: true,
                onRefresh: _onRefresh,
                controller: _homeRefreshController,
                scrollController: scrollController,
                header: const CustomPaginationHeader(),
                physics: const BouncingScrollPhysics(),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //* Home Banner Section
                      HomeBannerSection(
                        homeData: data,
                        tabController: _tabController,
                      ),

                      //* Loyalty Progress Bar Card
                      if (isAuthorized && (featureAccess ?? true))
                        Padding(
                          padding: const EdgeInsets.only(top: 40, bottom: 20),
                          child: const LoyaltyProgressBarCard(
                            height: 104,
                            parentPaddingSize: 0,
                            isInCheckOutPage: false,
                          ),
                        ),

                      //* Home Order Now Section
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: HomeOrderNowSection(
                          tabController: _tabController,
                        ),
                      ),

                      //* Doctor Appointment Card
                      // if (!AppConfig.isProduction)
                      FutureBuilder<AppointmentPageResult>(
                        future:
                            AppointmentService().getAppointments("upcoming", 1),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                  "Error loading appointment: ${snapshot.error}"),
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data!.validAppointments.isNotEmpty) {
                            final validAppointments =
                                snapshot.data!.validAppointments;

                            AppointmentModel? appointmentWithDoctor;
                            for (final appt in validAppointments) {
                              if (appt.doctor != null) {
                                appointmentWithDoctor = appt;
                                break;
                              }
                            }

                            if (appointmentWithDoctor == null) {
                              return const SizedBox();
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: CustomText(
                                    text: 'Up Coming Appointment',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 24),
                                  child: AppointmentHomepageCard(
                                    doctorName:
                                        appointmentWithDoctor.doctor != null
                                            ? drName(
                                                appointmentWithDoctor.doctor!,
                                                context)
                                            : 'Unknown Doctor',
                                    specialty:
                                        appointmentWithDoctor.doctor != null
                                            ? drSpecialasation(
                                                appointmentWithDoctor.doctor!,
                                                context)
                                            : 'Unknown',
                                    appointmentTime: formatAppointmentDate(
                                      appointmentWithDoctor.startTime ?? '',
                                      context,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SchedulePage(),
                                        ),
                                      );
                                    },
                                    appointment: appointmentWithDoctor,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),

                      //* Home Top Of The Week Section
                      if (data?.topOfWeek?.isNotEmpty == true)
                        HomeTopOfTheWeekSection(
                          topOfWeek: data?.topOfWeek ?? [],
                        ),

                      //* Home Pickup Section
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: HomePickupSection(
                          tabController: _tabController,
                        ),
                      ),

                      // if (Platform.isIOS) const SizedBox(width: 28),
                      Container(
                        height: kBottomNavigationBarHeight * 1.5,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ),
              error: (error, stack) => CustomReloadProvider(
                height: 118,
                onPressed: () => ref.refresh(homeAsyncProvider),
              ),
              loading: () => const ShimmerHomePage(),
            ),
    );
  }

  String formatAppointmentDate(String utcDate, BuildContext context) {
    try {
      final date = DateTime.parse(utcDate).toLocal();

      final formatter =
          DateFormat('EEEE dd MMM h:mm a', LanguageManager.locale);
      return formatter.format(date);
    } catch (e) {
      return '';
    }
  }
}
