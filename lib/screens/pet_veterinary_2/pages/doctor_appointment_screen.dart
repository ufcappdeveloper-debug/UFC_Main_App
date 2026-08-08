import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/data/appointment_service.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/constants/custom_loading_dialog.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/models/schedule/book_appoinment_model.dart';
import 'package:ufc_mobile/riverpod/farm/barn/barn_provider.dart';
import 'package:ufc_mobile/riverpod/farm/get_livestock_async.dart';
import 'package:ufc_mobile/screens/farm/application/barn_details/barn_details_cubit.dart';
import 'package:ufc_mobile/screens/farm/application/barn_details/barn_details_state.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/barn_drop_down.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_timing_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/provider/doctor_timing_details.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/utils/doctor_utils.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/utils/vet_date_time_formatters.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/booking_success_page.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/animal_selector.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/error_widget.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/livestock_dropdown.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/month_switcher.dart';

class DoctorAppointmentScreen extends ConsumerStatefulWidget {
  final int doctorId;
  final String doctorName;
  final String specialization;
  final String doctorImage;
  final double rating;
  final bool fromLiveStockDetails;
  final bool forEditBooking;
  final int? bookingId;
  const DoctorAppointmentScreen({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.doctorImage,
    required this.rating,
    this.fromLiveStockDetails = false,
    this.forEditBooking = false,
    this.bookingId,
  });

  @override
  ConsumerState<DoctorAppointmentScreen> createState() =>
      _DoctorAppointmentScreenState();
}

class _DoctorAppointmentScreenState
    extends ConsumerState<DoctorAppointmentScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _noteController = TextEditingController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int? _selectedBarn;
  String? _selectedCategory;
  int? _firstBarnId;
  DateTime? selectedDate;
  int selectedDuration = 30;
  String selectedTime = '';
  int? selectedTimeIndex;
  String? _selectedAnimalKey;
  int currentMonthOffset = 0;

  bool canProceed() {
    return selectedDate != null &&
        selectedTimeIndex != null &&
        selectedTimeIndex != -1;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void onTapOfBookNow() async {
    // Validation checks
    if (selectedDate == null) {
      CustomSnackBar.error(
          context, 'You need to select the booking date before proceeding');
      return;
    }
    if (selectedTimeIndex == null || selectedTimeIndex == -1) {
      CustomSnackBar.error(
          context, 'You need to select the booking time before proceeding');
      return;
    }

    try {
      Future<BookingResponse> bookingFuture() async {
        final model = BookAppoinmentModel(
          doctorId: widget.doctorId,
          startTime: startTime,
          duration: selectedDuration.toString(),
          animalUniqueKey: _selectedAnimalKey,
          notes: _noteController.text.trim(),
        );

        if (widget.forEditBooking) {
          return await AppointmentService.rescheduleAppointment(model);
        } else {
          return await AppointmentService.createAppoinment(model);
        }
      }

      final data =
          await LoadingDialog.show(context, bookingFuture(), isFromVet: true);

      if (!mounted) return;

      if (data.booking?.id != null) {
        final booking = data.booking!;
        final doctor = booking.doctor!;

        CustomSnackBar.success(
          context,
          widget.forEditBooking
              ? "Appointment rescheduled successfully"
              : (data.message ?? "Booking Successful"),
        );

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingSuccessPage(
              doctorName: DoctorUtils.doctorName(doctor),
              specialization: DoctorUtils.doctorSpecialization(doctor),
              doctorImage: doctor.profileImage ?? "",
              dateTime: booking.startTime ?? "",
              isFromReschedule: widget.forEditBooking,
            ),
          ),
        );
      } else {
        CustomSnackBar.error(
          context,
          widget.forEditBooking ? "Reschedule Failed" : "Booking Failed",
        );
      }
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.error(context, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final providerRef = ref.read;

      await providerRef(doctorTimingDetailsProvider.notifier)
          .fetchDoctorTiming(widget.doctorId);
      await providerRef(getLivestockProvider.notifier).getLiveStocks();

      await loadBarnData();
    });

    selectedTimeIndex = -1;
  }

  Future<void> loadBarnData() async {
    final barns = await ref.read(barnAsyncProvider.notifier).getBarn();
    context.read<BarnDetailsCubit>().filter = {};

    if (barns?.isNotEmpty ?? false) {
      _firstBarnId = barns?.firstOrNull?.id;
      if (_firstBarnId != null && mounted) {
        // Fetch details for all barns by default
        context
            .read<BarnDetailsCubit>()
            .fetchBarnDetails(_firstBarnId!, allBarn: true);
        _selectedBarn = null;
      }
    } else {
      context.read<BarnDetailsCubit>().clearState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final livestockAsync = ref.watch(getLivestockProvider);
    final barnAsync = ref.watch(barnAsyncProvider);
    final timingState = ref.watch(doctorTimingDetailsProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Directionality(
          textDirection: flutter.TextDirection.ltr,
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  size: 16, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 43,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: (widget.doctorImage.isNotEmpty)
                          ? NetworkImage(widget.doctorImage)
                          : null,
                      child: widget.doctorImage.isEmpty
                          ? Image.asset(
                              'assets/new_design/icons/chat_user.png',
                              width: 28,
                              height: 28,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Name
                  Center(
                    child: Text(
                      widget.doctorName,
                      style:
                          PetVeterinaryFontstyles2.getMediumStyle(context, 17),
                    ),
                  ),
                  const SizedBox(height: 4),

                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.specialization,
                            style: PetVeterinaryFontstyles2.getRegularStyle(
                                    context, 11)
                                .copyWith(
                                    color:
                                        PetVeterinaryColors.customBlackColor)),
                        SizedBox(width: 10),
                        Text(
                          widget.rating.toStringAsFixed(1),
                          style: PetVeterinaryFontstyles2.getRegularStyle(
                                  context, 11)
                              .copyWith(
                                  color: PetVeterinaryColors.newPetDarkGray),
                        ),
                        SizedBox(width: 2),
                        Icon(Icons.star,
                            color: PetVeterinaryColors.softYellow, size: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Choose a Date".tr(),
                        style: PetVeterinaryFontstyles2.getMediumStyle(
                            context, 14),
                      ),
                      MonthSwitcher(
                        onMonthChanged: (offset) {
                          setState(() {
                            currentMonthOffset = offset;
                          });
                        },
                      ),
                    ],
                  ),

                  kHeight18,

                  timingState.when(
                    loading: () => loadingWidget(),
                    error: (error, _) => errorWidget(context),
                    data: (doctorTiming) => timeSlotsWidget(
                      context,
                      doctorTiming,
                      selectedMonthOffset: currentMonthOffset,
                    ),
                  ),

                  const Divider(),
                  kHeight24,

                  Builder(builder: (context) {
                    final cubitState = context.watch<BarnDetailsCubit>().state;
                    final isCubitLoading = cubitState is BarnDetailsLoading;

                    if (barnAsync.isLoading || isCubitLoading) {
                      return SizedBox(
                        height: 300,
                        child: const Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      );
                    }

                    return barnAsync.when(
                      data: (data) {
                        return BlocConsumer<BarnDetailsCubit, BarnDetailsState>(
                            listener: (context, state) {
                          if (state is BarnDetailsLoaded) {
                            if (!state.hasMore) {
                              _refreshController.loadNoData();
                            } else {
                              _refreshController.loadComplete();
                            }
                          }
                        }, builder: (context, state) {
                          if (state is BarnDetailsLoaded) {
                            final cubit = context.read<BarnDetailsCubit>();
                            final availableCategories =
                                state.barnDetails?.availableCategories ?? [];

                            return availableCategories.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                        Text(
                                          "Livestock Number".tr(),
                                          style: PetVeterinaryFontstyles2
                                              .getMediumStyle(context, 14),
                                        ),
                                        const SizedBox(height: 18),
                                        AnimalSelector(
                                          availableCategories:
                                              availableCategories,
                                          selectedCategoryKey:
                                              _selectedCategory ??
                                                  availableCategories
                                                      .firstOrNull?.key,
                                          onCategoryChange: (String? key) {
                                            if (key == null) return;

                                            if (_selectedCategory == key)
                                              return;

                                            final bool allAnimals =
                                                key == 'all';
                                            _selectedCategory = key;
                                            context
                                                .read<BarnDetailsCubit>()
                                                .filter = {};

                                            if (_firstBarnId != null &&
                                                allAnimals &&
                                                _selectedBarn == null) {
                                              cubit.fetchBarnDetails(
                                                _firstBarnId!,
                                                animalCategory:
                                                    _selectedCategory,
                                                allBarn: true,
                                                loadMore: false,
                                              );
                                            }
                                            ref
                                                .read(getLivestockProvider
                                                    .notifier)
                                                .getLiveStocksByCategory(
                                                    allAnimals
                                                        ? null
                                                        : _selectedCategory,
                                                    _selectedBarn);
                                          },
                                        ),
                                        kHeight10,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            BarnDropdown(
                                              initBarn: _selectedBarn,
                                              onChangeBarn: (barnId) async {
                                                setState(() {
                                                  _selectedBarn = barnId;
                                                });

                                                if (_selectedBarn != null) {
                                                  await context
                                                      .read<BarnDetailsCubit>()
                                                      .fetchBarnDetails(
                                                        _selectedBarn!,
                                                        allBarn: false,
                                                        loadMore: false,
                                                      );
                                                }
                                                final bool allAnimals =
                                                    _selectedCategory == 'all';
                                                ref
                                                    .read(getLivestockProvider
                                                        .notifier)
                                                    .getLiveStocksByCategory(
                                                        allAnimals
                                                            ? null
                                                            : _selectedCategory,
                                                        _selectedBarn);
                                              },
                                            ),
                                          ],
                                        ),
                                        kHeight10,
                                        livestockAsync.when(
                                          data: (animalData) {
                                            final categories =
                                                animalData?.animals ?? [];

                                            if (categories.isEmpty) {
                                              return const SizedBox.shrink();
                                            }

                                            return LivestockDropdown(
                                              scrollController:
                                                  _scrollController,
                                              livestockList: categories,
                                              onLivestockSelected:
                                                  (selectedAnimal) {
                                                setState(() {
                                                  _selectedAnimalKey =
                                                      selectedAnimal
                                                          ?.animalUniqueKey;
                                                });
                                              },
                                            );
                                          },
                                          loading: () => Center(
                                              child:
                                                  CupertinoActivityIndicator()),
                                          error: (err, _) =>
                                              errorWidget(context),
                                        ),
                                        kHeight24,
                                      ])
                                : SizedBox.shrink();
                          }
                          return const SizedBox();
                        });
                      },
                      loading: () => const SizedBox(),
                      error: (error, stack) => errorWidget(context),
                    );
                  }),

                  Text(
                    "Note".tr(),
                    style: PetVeterinaryFontstyles2.getMediumStyle(context, 15),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _noteController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: 'Write your note here...'.tr(),
                      hintStyle: PetVeterinaryFontstyles2.getLightStyle(
                              context, 15)
                          .copyWith(color: PetVeterinaryColors.newPetLightGray),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: PetVeterinaryColors.newPetLightGray,
                          width: 1.25,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: PetVeterinaryColors.newPetLightGray,
                          width: 1.25,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: PetVeterinaryColors.newPetLightGray,
                          width: 1.25,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 1,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              offset: const Offset(0, -2),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Price Details
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      child: Column(
                        children: [
                          _keyValueRow("Consultation fees", "0 SAR"),
                          SizedBox(
                            height: 20,
                          ),
                          _keyValueRow(
                              "Consultation period", "30 ${'minutes'.tr()}"),
                          SizedBox(
                            height: 20,
                          ),
                          _keyValueRow("Total", "0 SAR", isBold: true),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                          onTapOfBookNow();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          height: 54,
                          decoration: BoxDecoration(
                            color: canProceed()
                                ? PetVeterinaryColors.newPetMainColorVeterinary
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Book an appointment".tr(),
                            style: PetVeterinaryFontstyles2.getRegularStyle(
                                    context, 15)
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget loadingWidget() {
    return const Column(
      children: [
        SizedBox(
          height: 157,
          child: Center(
              child: CustomIndicator(
            padding: 50,
            color: PetVeterinaryColors.mediumGray,
          )),
        ),
      ],
    );
  }

  Widget _keyValueRow(String key, String value, {bool isBold = false}) {
    final bool isSAR = value.trim().endsWith("SAR");
    final String amount = isSAR ? value.replaceAll("SAR", "").trim() : value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key.tr(),
          style: PetVeterinaryFontstyles2.getRegularStyle(context, 15).copyWith(
            color: PetVeterinaryColors.newPetDarkGray,
          ),
        ),
        isSAR
            ? Row(
                children: [
                  Text(
                    amount,
                    style: PetVeterinaryFontstyles2.getBoldStyle(context, 17),
                  ),
                  const SizedBox(width: 4),
                  SaudiRiyalIcon(
                    size: 16,
                    color: Colors.black,
                  ),
                ],
              )
            : Text(value,
                style: PetVeterinaryFontstyles2.getBoldStyle(context, 17)),
      ],
    );
  }

  List<Map<String, String>> dateList = List.generate(7, (index) {
    final date = DateTime.now().add(Duration(days: index));
    return {
      "date": date.toIso8601String(),
      "day": safeDateFormat('EEEE').format(date),
    };
  });

  Widget dateOption(String date, String day) {
    // DateTime? parsedDate = DateTime.tryParse(date) ?? selectedDate;
    DateTime? parsedDate = DateTime.tryParse(date)?.toLocal() ?? selectedDate;
    bool isSelected = selectedDate == parsedDate;
    String formattedDay =
        day.substring(0, 1).toUpperCase() + day.substring(1, 3).toLowerCase();

    return GestureDetector(
      onTap: () {
        debugPrint(selectedDate.toString());
        setState(() {
          selectedDate = parsedDate;
          selectedTime = '';
          selectedTimeIndex = -1;
        });
      },
      child: Container(
        height: 78,
        width: 70,
        decoration: BoxDecoration(
          color: isSelected
              ? PetVeterinaryColors.newPetMainColorVeterinary
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : PetVeterinaryColors.lightGrayBackground,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            kHeight10,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "${parsedDate?.day}",
                style:
                    PetVeterinaryFontstyles2.getBoldStyle(context, 15).copyWith(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
            if (isEnglish)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    formattedDay,
                    style: PetVeterinaryFontstyles2.getRegularStyle(context, 13)
                        .copyWith(
                      color: isSelected
                          ? Colors.white
                          : PetVeterinaryColors.newPetLightGray,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
              )
            else
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    day.toUpperCase().tr(),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: PetVeterinaryFontstyles.poppinsMedium10.copyWith(
                      color: isSelected
                          ? Colors.white
                          : PetVeterinaryColors.customLightBlueColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            kHeight10,
          ],
        ),
      ),
    );
  }

  Widget availableTimesSection(List<DoctorTimingDetail> doctorTimings) {
    String formattedDate =
        "${selectedDate?.year}-${selectedDate?.month.toString().padLeft(2, '0')}-${selectedDate?.day.toString().padLeft(2, '0')}";

    final selectedTiming = doctorTimings.firstWhere(
      (t) => t.date == formattedDate,
      orElse: () => DoctorTimingDetail(day: "", date: "", slots: []),
    );

    List<String> availableTimes = selectedTiming.slots;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Available Times".tr(),
          style: PetVeterinaryFontstyles2.getMediumStyle(context, 14),
        ),
        const SizedBox(height: 18),
        if (availableTimes.isEmpty && selectedDate != null)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "${"No available times for this slot.".tr()}\n${"Please select a different date.".tr()}",
                textAlign: TextAlign.center,
                maxLines: 2,
                style: PetVeterinaryFontstyles2.getRegularStyle(context, 13)
                    .copyWith(
                  color: PetVeterinaryColors.newPetDarkGray,
                ),
              ),
            ),
          )
        else if (doctorTimings.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "${"No available timings at the moment.".tr()}\n${"Please check back later.".tr()}",
                textAlign: TextAlign.center,
                maxLines: 2,
                style: PetVeterinaryFontstyles2.getRegularStyle(context, 13)
                    .copyWith(
                  color: PetVeterinaryColors.newPetDarkGray,
                ),
              ),
            ),
          )
        else if (doctorTimings.isNotEmpty && selectedDate == null)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Choose a date to check available slots".tr(),
                textAlign: TextAlign.center,
                style: PetVeterinaryFontstyles2.getRegularStyle(context, 13)
                    .copyWith(
                  color: PetVeterinaryColors.newPetDarkGray,
                ),
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 16.0,
              end: 16.0,
              top: 8.0,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = MediaQuery.of(context).size;
                final isTablet = size.shortestSide >= 600;
                final isLandscape = size.width > size.height;

                int crossAxisCount;
                if (isTablet && isLandscape) {
                  crossAxisCount = 10;
                } else if (isTablet) {
                  crossAxisCount = 8;
                } else if (constraints.maxWidth > 350) {
                  crossAxisCount = 4;
                } else {
                  crossAxisCount = 3;
                }

                // Calculate item width dynamically
                double totalSpacing =
                    (crossAxisCount - 1) * 8; // spacing between items
                double itemWidth =
                    (constraints.maxWidth - 16 * 2 - totalSpacing) /
                        crossAxisCount;

                // Dynamically calculate padding & font size
                double horizontalPadding = itemWidth * 0.2; // 20% of item width
                double verticalPadding =
                    8; // fixed or adjust dynamically if needed
                double fontSize =
                    itemWidth * 0.25; // scale text based on item width

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 8,
                    childAspectRatio: itemWidth / 40,
                  ),
                  itemCount: availableTimes.length,
                  itemBuilder: (context, index) {
                    return timeOption(
                      availableTimes[index],
                      formattedDate,
                      index,
                      horizontalPadding: horizontalPadding,
                      verticalPadding: verticalPadding,
                      fontSize: fontSize,
                    );
                  },
                );
              },
            ),
          )
      ],
    );
  }

  Widget timeSlotsWidget(
    BuildContext context,
    DoctorTiming? doctorTiming, {
    required int selectedMonthOffset,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: () {
            // If there are no timings at all
            if (doctorTiming == null || doctorTiming.doctorTimings.isEmpty) {
              return Center(
                child: Text(
                  "${"No available timings at the moment.".tr()}\n${"Please check back later.".tr()}",
                  textAlign: TextAlign.center,
                  style: PetVeterinaryFontstyles2.getRegularStyle(context, 13)
                      .copyWith(color: PetVeterinaryColors.newPetDarkGray),
                ),
              );
            }

            // Compute the selected month
            final DateTime now = DateTime.now();
            final DateTime selectedMonth =
                DateTime(now.year, now.month + selectedMonthOffset);

            // Filter timings for the selected month
            final List filteredTimings =
                doctorTiming.doctorTimings.where((timing) {
              final date = DateTime.parse(timing.date);
              return date.year == selectedMonth.year &&
                  date.month == selectedMonth.month;
            }).toList();

            // Sort by date ascending
            filteredTimings.sort((a, b) =>
                DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

            // If no timings for the selected month
            if (filteredTimings.isEmpty) {
              return Center(
                child: Text(
                  "${"No available timings at the moment.".tr()}\n${"Please check back later.".tr()}",
                  textAlign: TextAlign.center,
                  style: PetVeterinaryFontstyles2.getRegularStyle(context, 13)
                      .copyWith(color: PetVeterinaryColors.newPetDarkGray),
                ),
              );
            }

            // Display timings horizontally
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filteredTimings
                    .map(
                      (timing) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: dateOption(timing.date, timing.day),
                      ),
                    )
                    .toList(),
              ),
            );
          }(),
        ),
        kHeight5,
        const Divider(),
        kHeight16,
        // Available Time Slots Section
        availableTimesSection(doctorTiming != null
            ? doctorTiming.doctorTimings.where((timing) {
                final date = DateTime.parse(timing.date);
                final DateTime now = DateTime.now();
                final DateTime selectedMonth =
                    DateTime(now.year, now.month + selectedMonthOffset);
                return date.year == selectedMonth.year &&
                    date.month == selectedMonth.month;
              }).toList()
            : []),
      ],
    );
  }

  Widget timeOption(
    String time,
    String date,
    int index, {
    required double horizontalPadding,
    required double verticalPadding,
    required double fontSize,
  }) {
    bool isSelected = selectedTimeIndex == index;
    String fullDateTime = "$date $time";
    DateTime utcTime = DateTime.parse("${fullDateTime}Z");
    DateTime localTime = utcTime.toLocal();
    String localTimeString = safeDateFormat("HH:mm").format(localTime);
    String formattedTime = _convertTo12HourFormat(localTimeString);
    String formattedTime24Hour = safeDateFormat("HH:mm").format(localTime);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedTime = '';
            selectedTimeIndex = -1;
          } else {
            selectedTime = formattedTime24Hour;
            selectedTimeIndex = index;
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? PetVeterinaryColors.newPetMainColorVeterinary
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : PetVeterinaryColors.lightGrayBackground,
          ),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              formattedTime,
              textAlign: TextAlign.center,
              style: PetVeterinaryFontstyles2.getRegularStyle(
                      context, fontSize.toDouble())
                  .copyWith(
                color: isSelected
                    ? Colors.white
                    : PetVeterinaryColors.newPetDarkGray,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _convertTo12HourFormat(String time) {
    // convert digits first
    time = convertArabicDigitsToEnglish(time);

    int hour = int.parse(time.split(":")[0]);
    String minute = time.split(":")[1];

    String period = hour >= 12 ? "PM".tr() : "AM".tr();

    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    return "${hour.toString().padLeft(2, '0')}:$minute $period";
  }

  String get startTime {
    if (selectedDate == null || selectedTime.trim().isEmpty) return '';
    selectedDate = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      int.parse(selectedTime.split(":")[0]),
      int.parse(selectedTime.split(":")[1]),
    ).toUtc();
    return selectedDate!.toIso8601String();
  }
}

class LivestockInputField extends StatefulWidget {
  final Function(String)? onChanged;

  const LivestockInputField({super.key, this.onChanged});

  @override
  State<LivestockInputField> createState() => _LivestockInputFieldState();
}

class _LivestockInputFieldState extends State<LivestockInputField> {
  final TextEditingController _controller = TextEditingController();
  bool _isDropdownOpen = false;

  List<String> get _options =>
      List.generate(100, (index) => (index + 1).toString());
  final GlobalKey _dropdownKey = GlobalKey();

  void _showDropdownMenu() async {
    setState(() {
      _isDropdownOpen = true;
    });
    final RenderBox renderBox =
        _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        offset.dy,
      ),
      items: [
        PopupMenuItem<String>(
          enabled: false,
          child: SizedBox(
            height: 300,
            width: size.width,
            child: ListView(
              padding: EdgeInsets.zero,
              children: _options
                  .map((number) => ListTile(
                        dense: true,
                        title: Text(
                          number,
                          style: const TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          Navigator.pop(context, number);
                        },
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
    setState(() {
      _isDropdownOpen = false;
    });

    if (selected != null) {
      setState(() {
        _controller.text = selected;
        widget.onChanged?.call(selected);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Livestock number".tr(),
        style: PetVeterinaryFontstyles2.getMediumStyle(context, 15),
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "Enter or select number".tr(),
          hintStyle: PetVeterinaryFontstyles2.getLightStyle(context, 15)
              .copyWith(color: PetVeterinaryColors.newPetLightGray),
          suffixIcon: GestureDetector(
            key: _dropdownKey,
            onTap: _showDropdownMenu,
            child: _isDropdownOpen
                ? Icon(Icons.arrow_drop_up_rounded)
                : Icon(Icons.arrow_drop_down_rounded),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: PetVeterinaryColors.newPetLightGray,
              width: 1.25,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: PetVeterinaryColors.newPetLightGray,
              width: 1.25,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: PetVeterinaryColors.newPetLightGray,
              width: 1.25,
            ),
          ),
        ),
        onChanged: widget.onChanged,
      ),
      const SizedBox(height: 32),
    ]);
  }
}
