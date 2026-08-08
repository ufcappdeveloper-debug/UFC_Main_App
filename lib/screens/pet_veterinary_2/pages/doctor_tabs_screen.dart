import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/global/extensions/lang_switcher.dart';
import 'package:ufc_mobile/global/shared/functions/is_network_error.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/no_internet.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';
import 'package:ufc_mobile/riverpod/schedule/schedule_riverpod.dart';
import 'package:ufc_mobile/screens/feed/presentation/authentication/widgets/guest_guard.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/widgets/try_again_button.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/utils/doctor_utils.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/utils/vet_date_time_formatters.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/booking_details_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/doctor_card_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/past_doctor_booking_card.dart';

class DoctorTabsScreen extends ConsumerStatefulWidget {
  final bool isFromFarm;
  const DoctorTabsScreen({
    super.key,
    this.isFromFarm = false,
  });

  @override
  ConsumerState<DoctorTabsScreen> createState() => _DoctorTabsScreenState();
}

class _DoctorTabsScreenState extends ConsumerState<DoctorTabsScreen> {
  final RefreshController _upcomingController =
      RefreshController(initialRefresh: false);
  final RefreshController _pastController =
      RefreshController(initialRefresh: false);
  bool showPresent = true;

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

  Widget content(
          AsyncValue<Map<String, List<AppointmentModel>>?> appointmentState) =>
      Scaffold(
        appBar: widget.isFromFarm
            ? PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Directionality(
                  textDirection: flutter.TextDirection.ltr,
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    centerTitle: true,
                    title: Text(
                      "Booked Appointments".tr(),
                      style:
                          PetVeterinaryFontstyles2.getMediumStyle(context, 17)
                              .copyWith(color: Colors.black),
                    ),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          size: 16, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              )
            : null,
        backgroundColor: Colors.transparent,
        body: GuestGuard(
          appType: AppType.veterinary,
          color: PetVeterinaryColors.newPetMainColorVeterinary,
          child: Column(
            children: [
              Padding(
                padding: widget.isFromFarm
                    ? EdgeInsets.fromLTRB(16, 20, 16, 12)
                    : EdgeInsets.fromLTRB(16, 6, 16, 12),
                child: Row(
                  children: [
                    _buildTabButton(context,
                        isFromFarm: widget.isFromFarm,
                        title: 'Present',
                        selected: !showPresent, onTap: () {
                      setState(() => showPresent = true);
                      _onRefresh('upcoming');
                    }),
                    const SizedBox(width: 24),
                    _buildTabButton(context,
                        isFromFarm: widget.isFromFarm,
                        title: 'Past',
                        selected: showPresent, onTap: () {
                      setState(() => showPresent = false);
                      _onRefresh('past');
                    }),
                  ],
                ),
              ),
              Expanded(
                child: appointmentState.when(
                  data: (appointments) => showPresent
                      ? _buildAppointmentList(
                          appointments?["upcoming"] ?? [],
                          _upcomingController,
                          "upcoming",
                          _upcomingScrollController,
                          widget.isFromFarm)
                      : _buildAppointmentList(
                          appointments?["past"] ?? [],
                          _pastController,
                          "past",
                          _pastScrollController,
                          widget.isFromFarm),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(
                    child: TryAgainButton(
                      styleType: TryAgainButtonStyle.newPet,
                      message: "Failed to load appointments. Please try again.",
                      onPressed: () {
                        _onRefresh(showPresent ? "upcoming" : "past");
                      },
                    ),
                  ),
                ),
              ),
              // Expanded(
              //   child: showPresent ? _buildPresentList() : _buildPastList(),
              // )
            ],
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    Future(() => _onRefresh('upcoming'));
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(appointmentAsyncProvider);
    return appointmentState.maybeWhen(
      error: (error, stackTrace) => isNetworkError(error.toString())
          ? NoInternet(
              type: AppType.veterinary,
              onTap: () => _onRefresh(showPresent ? "upcoming" : "past"),
            )
          : content(appointmentState),
      orElse: () => content(appointmentState),
    );
  }

  Widget _buildTabButton(BuildContext context,
      {required String title,
      required bool selected,
      required VoidCallback onTap,
      required bool isFromFarm}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isFromFarm
                ? selected
                    ? Colors.white
                    : Colors.transparent
                : selected
                    ? Colors.transparent
                    : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: isFromFarm
                ? selected
                    ? null
                    : Border.all(
                        color: PetVeterinaryColors.mainColorUFC,
                        width: 1,
                      )
                : selected
                    ? Border.all(
                        color: PetVeterinaryColors.newPetMainColorVeterinary,
                        width: 1,
                      )
                    : null,
            boxShadow: isFromFarm
                ? selected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : []
                : selected
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
          ),
          alignment: Alignment.center,
          child: Text(
            title.tr(),
            style: PetVeterinaryFontstyles2.getRegularStyle(
              context,
              15,
              color: isFromFarm
                  ? selected
                      ? PetVeterinaryColors.newPetDarkTeal
                      : PetVeterinaryColors.mainColorUFC
                  : selected
                      ? PetVeterinaryColors.newPetMainColorVeterinary
                      : PetVeterinaryColors.newPetDarkTeal,
            ),
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
      bool isFromFarm) {
    return SafeArea(
        bottom: true,
        child: SmartRefresher(
          controller: controller,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: () => _onRefresh(type),
          onLoading: () => _onLoadMore(type),
          header: ClassicHeader(
            idleText: 'Pull down Refresh'.tr(),
            releaseText: 'Release to refresh'.tr(),
          ),
          footer: ClassicFooter(
            loadingText: 'loading'.tr(),
            canLoadingText: 'Release to load more'.tr(),
            noDataText: 'No more data'.tr(),
          ),
          child: appointments.isEmpty
              ? Center(
                  child: Text(
                      type == "upcoming"
                          ? "You have no appointments booked yet".tr()
                          : "You don’t have any past bookings yet".tr(),
                      textAlign: TextAlign.center,
                      style:
                          PetVeterinaryFontstyles2.getRegularStyle(context, 13)
                              .copyWith(
                        color: PetVeterinaryColors.newPetDarkGray,
                      )))
              : ListView.builder(
                  controller: scrollController,
                  padding: showPresent
                      ? const EdgeInsets.only(
                          left: 16, right: 16, top: 16, bottom: 80)
                      : const EdgeInsets.only(
                          left: 16, right: 16, top: 16, bottom: 64),
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    final bookingId = appointment.id;

                    final doctor = appointment.doctor;
                    final doctorId = doctor?.id;
                    final doctorImg = doctor?.profileImage;
                    final rating = appointment.rating ?? 0.0;
                    final doctorName = drName(doctor!, context);
                    final specialty = drSpecialasation(doctor, context);
                    final startDateTime = DateTimeFormatters.parseLocalDateTime(
                        appointment.startTime);

                    final dateText =
                        DateTimeFormatters.getDateText(startDateTime);
                    final monthText =
                        DateTimeFormatters.getMonthText(startDateTime);
                    final timeText =
                        DateTimeFormatters.getTimeText(startDateTime);
                    final timeRange = DateTimeFormatters.getTimeRangeText(
                        startDateTime, appointment.duration);

                    return appointments[index].doctor == null
                        ? SizedBox()
                        : showPresent
                            ? GestureDetector(
                                onTap: () =>
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BookingDetailsScreen(
                                          doctorId: doctorId ?? 0,
                                          bookingId: bookingId ?? 0,
                                          doctorImage: doctorImg ?? '',
                                          doctorName: doctorName,
                                          specialization: specialty,
                                          rating: rating,
                                          notFromPastBooking: true,
                                        ),
                                      ),
                                    ),
                                child: DoctorCard2(
                                  doctorId: doctor.id,
                                  isNotAtHome: true,
                                  type: DoctorCardType.booked,
                                  doctorName: DoctorUtils.doctorName(doctor),
                                  specialty:
                                      DoctorUtils.doctorSpecialization(doctor),
                                  time: timeText,
                                  dateText: dateText,
                                  monthText: monthText,
                                  imageUrl: doctor.profileImage ?? '',
                                  rating: doctor.rating ?? 0.0,
                                  isAvailable: true,
                                  appointment: appointment,
                                  isFromFarm: isFromFarm,
                                ))
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: GestureDetector(
                                    onTap: () => Navigator.of(context,
                                                rootNavigator: true)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BookingDetailsScreen(
                                              bookingId: bookingId ?? 0,
                                              doctorId: doctorId ?? 0,
                                              doctorImage: doctorImg ?? '',
                                              doctorName: doctorName,
                                              specialization: specialty,
                                              rating: rating,
                                              notFromPastBooking: false,
                                            ),
                                          ),
                                        ),
                                    child: PastDoctorBookingCard(
                                      name: DoctorUtils.doctorName(doctor),
                                      timeRange: timeRange,
                                      imageUrl: doctor.profileImage ?? '',
                                      dateText: dateText,
                                      monthText: monthText,
                                      appointment: appointment,
                                      isFromFarm: isFromFarm,
                                    )),
                              );
                  },
                ),
        ));
  }
}
