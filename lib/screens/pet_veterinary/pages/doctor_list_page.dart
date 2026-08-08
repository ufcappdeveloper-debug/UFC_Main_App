import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/screens/pet_veterinary/pages/schedule_page.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/provider/doctor_service_provider.dart';
import 'package:ufc_mobile/screens/pet_veterinary/widgets/doctor_card.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

class DoctorListPage extends ConsumerStatefulWidget {
  const DoctorListPage({
    super.key,
    this.tabController,
  });
  final TabController? tabController;

  @override
  ConsumerState<DoctorListPage> createState() => _DoctorListPageState();
}

class _DoctorListPageState extends ConsumerState<DoctorListPage>
    with ScreenEngagementTracker {
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    Future(() => _fetchInitialDoctors());
    // _fetchInitialDoctors();
    _scrollController.addListener(_onScroll);
  }

  void _fetchInitialDoctors() {
    ref.read(doctorServiceProviderProvider.notifier).fetchInitialDoctors();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !isLoadingMore) {
      _loadMoreDoctors();
    }
  }

  Future<void> _loadMoreDoctors() async {
    if (isLoadingMore) return;
    setState(() {
      isLoadingMore = true;
    });

    await ref.read(doctorServiceProviderProvider.notifier).fetchMoreDoctors();

    setState(() {
      isLoadingMore = false;
    });
  }

  Future<void> _refreshDoctors() async {
    await ref
        .read(doctorServiceProviderProvider.notifier)
        .fetchInitialDoctors();
  }

  @override
  Widget build(BuildContext context) {
    final doctorState = ref.watch(doctorServiceProviderProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(boxShadow: boxShadow),
          child: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            title: CustomText(
              text: "Pet Veterinary".tr(),
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SchedulePage(tabController: widget.tabController)),
                  );
                },
                icon: Image.asset(
                  'assets/images/schedule_icon.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDoctors,
        child: doctorState.when(
          data: (paginatedResponse) {
            if (paginatedResponse == null ||
                paginatedResponse.doctors.isEmpty) {
              return Center(
                child: Text(
                  "No doctors available".tr(),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 24, bottom: 100.0),
              itemCount:
                  paginatedResponse.doctors.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == paginatedResponse.doctors.length) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ));
                }
                final doctor = paginatedResponse.doctors[index];
                return DoctorCard(doctor: doctor);
              },
            );
          },
          loading: () => const Column(
            children: [
              SizedBox(
                height: 157,
                child: Center(child: CustomIndicator(padding: 50)),
              ),
            ],
          ),
          error: (error, stackTrace) => Center(
            child: GestureDetector(
              onTap: () {
                _fetchInitialDoctors();
              },
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppConfig.isProduction
                          ? "Something went wrong".tr()
                          : "$error".tr(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    kHeight5,
                    Icon(
                      Icons.refresh,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
