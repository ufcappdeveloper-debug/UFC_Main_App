import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/data/appointment_service.dart';
import 'package:ufc_mobile/global/extensions/lang_switcher.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/functions/is_network_error.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/no_internet.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';
import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';
import 'package:ufc_mobile/screens/feed/presentation/authentication/widgets/guest_guard.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/provider/doctor_service_provider.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/utils/doctor_utils.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/utils/vet_date_time_formatters.dart'
    show DateTimeFormatters;
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/booking_details_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/doctor_details_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/pet_vet_bottom_bar.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/top_rated_doctors_page.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/doctor_card_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/filter_bottom_sheet.dart';

class DoctorListPage2 extends ConsumerStatefulWidget {
  const DoctorListPage2({
    super.key,
  });

  @override
  ConsumerState<DoctorListPage2> createState() => _DoctorListPage2State();
}

class _DoctorListPage2State extends ConsumerState<DoctorListPage2> {
  final ScrollController _scrollController = ScrollController();
  Future<AppointmentModel?>? _appointmentsFuture;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    Future(() => _fetchInitialDoctors());
    // _fetchInitialDoctors();
    _scrollController.addListener(_onScroll);
    _appointmentsFuture = _fetchFirstValidAppointment();
  }

  void _fetchInitialDoctors() {
    ref.read(doctorServiceProviderProvider.notifier).fetchInitialDoctors();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    double newHeight = 74 - offset.clamp(0, 43);
    context.read<AppBarHeightCubit>().setHeight(newHeight);

    if (offset > 20) {
      context.read<AppBarCubit>().setMode(AppBarMode.channel);
    } else {
      context.read<AppBarCubit>().setMode(AppBarMode.normal);
    }

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !isLoadingMore) {
      _loadMoreDoctors();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
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

  void _refreshAppointments() {
    setState(() {
      _appointmentsFuture = _fetchFirstValidAppointment();
    });
  }

  Future<void> _refreshDoctors() async {
    await ref
        .read(doctorServiceProviderProvider.notifier)
        .fetchInitialDoctors();
  }

  Future<AppointmentModel?> _fetchFirstValidAppointment() async {
    int currentPage = 1;

    while (true) {
      final result =
          await AppointmentService().getAppointments("upcoming", currentPage);

      for (final appt in result.validAppointments) {
        if (appt.doctor != null) {
          return appt;
        }
      }

      if (result.dataWasEmpty) {
        break;
      }

      currentPage++;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final doctorState = ref.watch(doctorServiceProviderProvider);
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<AppBarHeightCubit, double>(
            builder: (context, appBarHeight) {
          // Conditional values
          final topPadding = appBarHeight == 74 ? 6.0 : 2.0;
          final sizedBoxHeight = appBarHeight == 74 ? 12.0 : 16.0;

          return FutureBuilder<AppointmentModel?>(
              future: _appointmentsFuture,
              builder: (context, snapshot) {
                AppointmentModel? appointmentWithDoctor;
                Doctor? doctor;
                int? doctorId;
                String? doctorImg;
                int? bookingId;
                String? doctorName;
                String? specialty;
                DateTime? startDateTime;
                String? monthText;
                String? dateText;
                String? time;
                String? imageUrl;
                double? rating;
                if (snapshot.hasData && snapshot.data != null) {
                  appointmentWithDoctor = snapshot.data!;

                  doctor = appointmentWithDoctor.doctor!;
                  doctorId = doctor.id;
                  doctorImg = doctor.profileImage;
                  bookingId = appointmentWithDoctor.id;
                  doctorName = drName(doctor, context);
                  specialty = drSpecialasation(doctor, context);
                  startDateTime = DateTimeFormatters.parseLocalDateTime(
                      appointmentWithDoctor.startTime);

                  monthText = DateTimeFormatters.getMonthText(startDateTime);
                  dateText = DateTimeFormatters.getDateText(startDateTime);
                  time = DateTimeFormatters.getTimeText(startDateTime);

                  imageUrl = doctor.profileImage ?? '';
                  rating = appointmentWithDoctor.rating ?? 0.0;
                }
                bool isNetError = snapshot.hasError &&
                    isNetworkError(snapshot.error.toString());
                return isNetError
                    ? NoInternet(
                        type: AppType.veterinary,
                        onTap: () => _fetchFirstValidAppointment(),
                      )
                    : GuestGuard(
                        appType: AppType.veterinary,
                        color: PetVeterinaryColors.newPetMainColorVeterinary,
                        child: Column(children: [
                          Padding(
                              padding:
                                  EdgeInsets.fromLTRB(16, topPadding, 16, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.08),
                                            blurRadius: 8,
                                            spreadRadius: 0.5,
                                            offset: Offset(0, 2),
                                          ),
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.04),
                                            blurRadius: 12,
                                            spreadRadius: 1,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: TextField(
                                        readOnly: true,
                                        onTap: () {
                                          ref
                                              .read(topRatedFocusProvider
                                                  .notifier)
                                              .state = true;
                                          ref
                                              .read(petVetTabIndexProvider
                                                  .notifier)
                                              .state = 1;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Find the doctor'.tr(),
                                          hintStyle: PetVeterinaryFontstyles2
                                              .getRegularStyle(
                                            context,
                                            11,
                                            color: PetVeterinaryColors
                                                .newPetLightGray,
                                          ),
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Image.asset(
                                              'assets/new_design/icons/search_icon.png',
                                              width: 16,
                                              height: 16,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 6,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: IconButton(
                                          onPressed: () async {
                                            final result =
                                                await FilterBottomSheet.show(
                                              context,
                                              ref,
                                              currentRankOrder: ref
                                                  .read(
                                                      doctorServiceProviderProvider
                                                          .notifier)
                                                  .currentRankOrder,
                                              currentAvailability: ref
                                                  .read(
                                                      doctorServiceProviderProvider
                                                          .notifier)
                                                  .currentAvailability,
                                            );

                                            if (result != null) {
                                              ref
                                                  .read(
                                                      doctorServiceProviderProvider
                                                          .notifier)
                                                  .fetchInitialDoctors(
                                                    rankOrder:
                                                        result["rankOrder"],
                                                    availability:
                                                        result["availability"],
                                                  );
                                            }
                                          },
                                          padding: EdgeInsets.zero,
                                          icon: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              'assets/new_design/icons/filter_icon.png',
                                              width: 20,
                                              height: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -2,
                                        left: isEnglish ? -2 : null,
                                        right: isEnglish ? null : -2,
                                        child: AnimatedOpacity(
                                          duration: Duration(milliseconds: 300),
                                          opacity: ref
                                                  .watch(
                                                      doctorServiceProviderProvider
                                                          .notifier)
                                                  .isFilterActive
                                              ? 1.0
                                              : 0.0,
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: PetVeterinaryColors
                                                  .backgroundRed,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                          SizedBox(height: sizedBoxHeight),
                          Expanded(
                              child: RefreshIndicator(
                                  onRefresh: _refreshDoctors,
                                  child: ListView(
                                    controller: _scrollController,
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 0, 16, 120),
                                    children: [
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) ...{
                                        const Padding(
                                            padding: EdgeInsets.only(top: 16),
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ))
                                      } else if (snapshot.hasError) ...{
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 32.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Oops, something happened!"
                                                    .tr(),
                                                style: PetVeterinaryFontstyles2
                                                    .getRegularStyle(
                                                  context,
                                                  13,
                                                  color: PetVeterinaryColors
                                                      .newPetLightGray,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 12),
                                              CustomPetButton(
                                                  text: "Retry".tr(),
                                                  backgroundColor:
                                                      PetVeterinaryColors
                                                          .newPetMainColorVeterinary,
                                                  borderRadius: 12,
                                                  horizontalPadding: 20,
                                                  verticalPadding: 10,
                                                  onPressed:
                                                      _refreshAppointments),
                                            ],
                                          ),
                                        )
                                      } else if (snapshot.hasData &&
                                          snapshot.data != null) ...{
                                        // final validAppointments = snapshot.data!.validAppointments;

                                        // AppointmentModel? appointmentWithDoctor;
                                        // for (final appt in validAppointments) {
                                        //   if (appt.doctor != null) {
                                        //     appointmentWithDoctor = appt;
                                        //     break;
                                        //   }
                                        // }

                                        // if (appointmentWithDoctor == null) {
                                        //   return const SizedBox();
                                        // }

                                        GestureDetector(
                                            onTap: () => Navigator.of(context,
                                                        rootNavigator: true)
                                                    .push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        BookingDetailsScreen(
                                                      bookingId: bookingId ?? 0,
                                                      doctorId: doctorId ?? 0,
                                                      doctorImage:
                                                          doctorImg ?? '',
                                                      doctorName:
                                                          doctorName ?? '',
                                                      specialization:
                                                          specialty ?? '',
                                                      rating: rating ?? 0,
                                                      notFromPastBooking: true,
                                                      isFromHome: true,
                                                    ),
                                                  ),
                                                ),
                                            child: DoctorCard2(
                                              type: DoctorCardType.booked,
                                              doctorId: doctorId,
                                              monthText: monthText ?? '',
                                              doctorName: doctorName ?? '',
                                              specialty: specialty ?? '',
                                              time: time ?? '',
                                              dateText: dateText ?? '',
                                              imageUrl: imageUrl ?? '',
                                              rating: rating ?? 0,
                                              isAvailable: true,
                                              appointment:
                                                  appointmentWithDoctor,
                                            ))
                                      } else ...{
                                        const SizedBox()
                                      },
                                      // const SizedBox(height: 4),
                                      // Container(
                                      //   margin: const EdgeInsets.symmetric(vertical: 8),
                                      //   decoration: BoxDecoration(
                                      //     color: Colors.white,
                                      //     borderRadius: BorderRadius.circular(12),
                                      //     boxShadow: [
                                      //       BoxShadow(
                                      //         color: Colors.black.withOpacity(0.08),
                                      //         blurRadius: 8,
                                      //         spreadRadius: 0.5,
                                      //         offset: Offset(0, 2),
                                      //       ),
                                      //       BoxShadow(
                                      //         color: Colors.black.withOpacity(0.04),
                                      //         blurRadius: 12,
                                      //         spreadRadius: 1,
                                      //         offset: Offset(0, 4),
                                      //       ),
                                      //     ],
                                      //   ),
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.only(
                                      //         left: 12, right: 24, top: 16, bottom: 16),
                                      //     child: Row(
                                      //       children: [
                                      //         Container(
                                      //           width: 38,
                                      //           height: 38,
                                      //           decoration: BoxDecoration(
                                      //             shape: BoxShape.circle,
                                      //             color: Colors.white,
                                      //             boxShadow: [
                                      //               BoxShadow(
                                      //                 color: Colors.black.withOpacity(0.08),
                                      //                 blurRadius: 8,
                                      //                 spreadRadius: 0.5,
                                      //                 offset: Offset(0, 2),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //           child: Center(
                                      //             child: Image.asset(
                                      //               'assets/new_design/icons/chat_icon.png',
                                      //               width: 20,
                                      //               height: 20,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //         const SizedBox(width: 12),
                                      //         Expanded(
                                      //           child: Column(
                                      //             crossAxisAlignment: CrossAxisAlignment.start,
                                      //             children: [
                                      //               Text(
                                      //                 'You got a new message.'.tr(),
                                      //                 style: PetVeterinaryFontstyles2.getMediumStyle(
                                      //                     context, 14),
                                      //               ),
                                      //               const SizedBox(height: 4),
                                      //               Text(
                                      //                 'Open your inbox to read the latest updates or instructions for you.'
                                      //                     .tr(),
                                      //                 style: PetVeterinaryFontstyles2.getRegularStyle(
                                      //                     context, 11),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      const SizedBox(height: 32),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Top rated doctor'.tr(),
                                            style: PetVeterinaryFontstyles2
                                                .getMediumStyle(context, 15),
                                          ),
                                          Text(
                                            'everyone'.tr(),
                                            style: PetVeterinaryFontstyles2
                                                    .getLightStyle(context, 12)
                                                .copyWith(
                                              color: PetVeterinaryColors
                                                  .newPetDarkTeal,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      doctorState.when(
                                        data: (paginatedResponse) {
                                          if (paginatedResponse == null ||
                                              paginatedResponse
                                                  .doctors.isEmpty) {
                                            return Text(
                                                "No doctors available".tr(),
                                                style: PetVeterinaryFontstyles2
                                                        .getRegularStyle(
                                                            context, 13)
                                                    .copyWith(
                                                  color: PetVeterinaryColors
                                                      .newPetDarkGray,
                                                ));
                                          }
                                          return Column(
                                            children: List.generate(
                                              paginatedResponse.doctors.length,
                                              (index) {
                                                final doctor = paginatedResponse
                                                    .doctors[index];
                                                return GestureDetector(
                                                  onTap: () => Navigator.of(
                                                          context,
                                                          rootNavigator: true)
                                                      .push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DoctorDetailsScreen(
                                                        doctorId:
                                                            doctor.id ?? 0,
                                                      ),
                                                    ),
                                                  ),
                                                  child: DoctorCard2(
                                                    doctorId: doctor.id,
                                                    monthText: '',
                                                    type: DoctorCardType
                                                        .available,
                                                    doctorName:
                                                        DoctorUtils.doctorName(
                                                            doctor),
                                                    specialty: DoctorUtils
                                                        .doctorSpecialization(
                                                            doctor),
                                                    time: doctor.bookingTime ??
                                                        '',
                                                    dateText:
                                                        doctor.bookingDate ??
                                                            '',
                                                    imageUrl:
                                                        doctor.profileImage ??
                                                            '',
                                                    rating: doctor.rating ?? 0,
                                                    isAvailable: doctor
                                                            .nearestAvailabletime !=
                                                        null,
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        loading: () => const Center(
                                            child: CircularProgressIndicator()),
                                        error: (error, stackTrace) => Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              _fetchInitialDoctors();
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 40),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Something went wrong".tr(),
                                                    style:
                                                        PetVeterinaryFontstyles2
                                                            .getRegularStyle(
                                                      context,
                                                      14,
                                                      color: PetVeterinaryColors
                                                          .newPetLightGray,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  kHeight5,
                                                  Icon(
                                                    Icons.refresh,
                                                    color: PetVeterinaryColors
                                                        .newPetLightGray,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )))
                        ]),
                      );
              });
        }));
  }
}
