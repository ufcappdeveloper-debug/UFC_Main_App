import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:ufc_mobile/data/appointment_service.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/common_back_app_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/util/lang/langauge_manager.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/models/schedule/book_appoinment_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';
import 'package:ufc_mobile/screens/pet_veterinary/pages/appoinment_success_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary/pages/vet_policy_page.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_timing_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/provider/doctor_details_riverpod.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/provider/doctor_timing_details.dart';
import 'package:ufc_mobile/screens/pet_veterinary/widgets/doctor_title_and_subtitle_widget.dart';
import 'package:ufc_mobile/screens/pet_veterinary/widgets/try_again_button.dart';

class AppointmentScreen extends ConsumerStatefulWidget {
  final int doctorId;

  const AppointmentScreen({super.key, required this.doctorId});

  @override
  AppointmentScreenState createState() => AppointmentScreenState();
}

class AppointmentScreenState extends ConsumerState<AppointmentScreen>
    with ScreenEngagementTracker {
  DateTime? selectedDate = DateTime.now();
  int selectedDuration = 30;
  String selectedTime = '';
  int? selectedTimeIndex;
  bool termsAndCondtionAgreed = false;

  String selectedMonth = DateFormat('MMMM', 'en').format(DateTime.now());

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final providerRef = ref.read;

      await providerRef(doctorDetailsProvider.notifier)
          .fetchDoctorById(widget.doctorId);
      await providerRef(doctorTimingDetailsProvider.notifier)
          .fetchDoctorTiming(widget.doctorId);

      final doctorTimings =
          ref.read(doctorTimingDetailsProvider).value?.doctorTimings;

      if (doctorTimings?.isNotEmpty ?? false) {
        if (mounted) {
          setState(() {
            selectedDate =
                DateTime.tryParse(doctorTimings![0].date) ?? DateTime.now();
          });
        }
      }
    });
  }

  // ignore: unused_element // todo can use this in future
  void _showMonthPicker() async {
    DateTime? picked = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null) {
      setState(() {
        selectedMonth = DateFormat('MMMM', 'en').format(picked);
        selectedDate = picked;
      });

      ref
          .read(doctorTimingDetailsProvider.notifier)
          .fetchDoctorTiming(picked.month);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('doctor id is ${widget.doctorId}');
    final doctorDetails = ref.watch(doctorDetailsProvider);
    final timingState = ref.watch(doctorTimingDetailsProvider);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        ref.read(doctorDetailsProvider.notifier).clearData();
      },
      child: Scaffold(
        appBar: CommonBackAppBar(
          title: "Appointment".tr(),
          boxShadow: boxShadow,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: doctorDetails.when(
            loading: () => loadingWidget(), // shimmer or loader
            error: (error, _) => TryAgainButton(
              message: "We couldn't fetch doctor details.\nPlease try again.",
              onPressed: () {
                ref
                    .read(doctorDetailsProvider.notifier)
                    .fetchDoctorById(widget.doctorId);
                ref
                    .read(doctorTimingDetailsProvider.notifier)
                    .fetchDoctorTiming(widget.doctorId);
              },
            ),
            data: (doctor) => doctor == null
                ? Center(child: Text("No doctor data found."))
                : SingleChildScrollView(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Profile image
                            profileImage(doctorDetails),
                            kHeight10,

                            // Doctor name
                            Text(
                              doctorName(doctorDetails.value),
                              style: PetVeterinaryFontstyles.poppinsSemiBold20
                                  .copyWith(
                                color: Colors.black,
                              ),
                            ),
                            kHeight5,
                          ],
                        ),
                      ),

                      /// Doctor Specialization
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            doctorSpecialization(doctorDetails.value),
                            style: PetVeterinaryFontstyles
                                .poppinsRegularTextStyle12
                                .copyWith(
                              color: PetVeterinaryColors.customBlackColor,
                            ),
                          ),
                          kWidth6,
                          Icon(Icons.star, color: Colors.amber, size: 16),

                          /// Doctor rating
                          Text(
                            (doctorDetails.value?.rating ?? 0.0).toString(),
                            style: PetVeterinaryFontstyles
                                .poppinsRegularSmallTextStyle2
                                .copyWith(
                              color: PetVeterinaryColors.customMediumGrayColor,
                            ),
                          ),
                        ],
                      ),
                      kHeight20,

                      /// About doctor
                      Align(
                        alignment: isArabic
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Text(
                          "About Doctor".tr(),
                          style: PetVeterinaryFontstyles.poppinsSemiBold18
                              .copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      kHeight10,
                      Text(
                        aboutDoctor(doctorDetails.value),
                        textAlign: getTextAlignment(),
                        style: PetVeterinaryFontstyles.poppinsRegularTextStyle14
                            .copyWith(
                          color: PetVeterinaryColors.customDarkGrayColor,
                        ),
                      ),
                      Divider(),
                      kHeight10,

                      /// Session type
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          doctorTitleAndSubtitleWidget(
                            iconPath: "assets/images/payment/Group.svg",
                            title: "Session Type".tr(),
                            // value: doctorDetails.value?.sessionType ??
                            //     'Unavailable'.tr(),
                            value: 'Video & Chat'.tr(),
                          ),
                          doctorTitleAndSubtitleWidget(
                              iconPath:
                                  "assets/images/payment/reputation 1.svg",
                              title: "Experience".tr(),
                              value: limitExperience(getLocalizedExperience(
                                  context, doctorDetails.value!))),
                        ],
                      ),
                      kHeight20,

                      /// languages
                      doctorTitleAndSubtitleWidget(
                        iconPath: "assets/images/payment/language 1.svg",
                        title: "Language".tr(),
                        value: formatLanguages(
                            doctorDetails.value?.languages, context),
                      ),
                      Divider(),
                      kHeight5,

                      /// Duration
                      Align(
                        alignment: isArabic
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Text(
                          "Duration".tr(),
                          style: PetVeterinaryFontstyles.poppinsSemiBold18
                              .copyWith(
                            color: PetVeterinaryColors.customDarkBlueColor,
                          ),
                        ),
                      ),
                      kHeight10,

                      /// Duration options
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...[30].map(
                              (duration) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: durationOption(duration),
                              ),
                            ),
                          ],
                        ),
                      ),
                      kHeight5,
                      Divider(),
                      kHeight10,

                      /// Time slots
                      timingState.when(
                        loading: () => loadingWidget(),
                        error: (error, _) => errorWidget(),
                        data: (doctorTiming) => timeSlotsWidget(
                          context,
                          doctorTiming,
                        ),
                      ),
                      Divider(),
                      kHeight15,

                      /// Terms and conditions
                      termsAndConditions(context),
                      kHeight15,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Book now button
                          bookNowButton(context),
                          kWidth30,

                          /// Payment
                          if (Constants.freeDoctorAppoinment) ...[
                            Text(
                              "Free".tr(),
                              style: PetVeterinaryFontstyles.poppinsSemiBold18
                                  .copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ] else ...[
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "200",
                                    style: PetVeterinaryFontstyles
                                        .poppinsSemiBold18
                                        .copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " SAR/30minute",
                                    style: PetVeterinaryFontstyles
                                        .poppinsRegular15
                                        .copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]
                        ],
                      ),
                      kHeight50,
                    ],
                  )),
          ),
        ),
      ),
    );
  }

  Widget termsAndConditions(BuildContext context) => Row(
        children: [
          Checkbox(
            activeColor: PetVeterinaryColors.borderLeftColor,
            value: termsAndCondtionAgreed,
            onChanged: (value) {
              termsAndCondtionAgreed = !termsAndCondtionAgreed;
              setState(() {});
            },
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => VetPolicyPage()),
              );
            },
            child: Text(
              'Terms and conditions'.tr(),
              style: PetVeterinaryFontstyles.poppinsRegularTextStyle12.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      );

  Center errorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Oops something went wrong please try again later".tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }

  Widget bookNowButton(BuildContext context) {
    return CustomButton(
      title: "Book Now".tr(),
      fontFamily: "Poppins",
      fontSize: 20,
      radius: 16,
      onTap: () {
        onTapOfBookNow();
      },
      width: 150,
      color: canProceed() ? PetVeterinaryColors.borderLeftColor : Colors.grey,
    );
  }

  void onTapOfBookNow() async {
    if (selectedDate == null) {
      CustomSnackBar.error(
          context, 'You need to select the booking date before proceeding');
      return;
    }
    if (!(selectedDuration > 0 && selectedTimeIndex != null)) {
      CustomSnackBar.error(
          context, 'You need to select the booking time before proceeding');
      return;
    }
    if (!termsAndCondtionAgreed) {
      CustomSnackBar.error(
          context, 'Kindly accept the terms and conditions to continue');
      return;
    }

    try {
      EasyLoading.show();
      final future = AppointmentService.createAppoinment(
        BookAppoinmentModel(
          doctorId: widget.doctorId,
          startTime: startTime,
          duration: selectedDuration.toString(),
        ),
      );
      BookingResponse data = await future;
      // await LoadingDialog.show(context, future);
      if (!mounted) return;
      EasyLoading.dismiss();
      if (data.booking?.id != null) {
        CustomSnackBar.success(
          context,
          data.message ?? 'Booking Successful',
        );
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AppointmentSuccessScreen(),
          ),
        );
      } else {
        CustomSnackBar.error(
          context,
          'Booking Failed',
        );
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (!mounted) return;
      CustomSnackBar.error(context, errorMessage);
    } finally {
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }
    }
  }

  bool canProceed() {
    bool isFormValid = selectedDate != null &&
        selectedDuration > 0 &&
        selectedTimeIndex != null &&
        termsAndCondtionAgreed;
    return isFormValid;
  }

  Widget timeSlotsWidget(BuildContext context, DoctorTiming? doctorTiming) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Choose a Date".tr(),
              style: PetVeterinaryFontstyles.poppinsSemiBold18.copyWith(
                color: PetVeterinaryColors.customDarkBlueColor,
              ),
            ),
            // not using at the moment but will be including in upcoming releases
            Visibility(
              visible: false,
              child: GestureDetector(
                onTap: _showMonthPicker,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedMonth,
                      style: PetVeterinaryFontstyles.poppinsMediumTextStyle
                          .copyWith(
                              color: PetVeterinaryColors.customLightBlueColor),
                    ),
                    const SizedBox(width: 5),
                    Transform(
                      alignment: Alignment.center,
                      transform: isArabic
                          ? Matrix4.rotationY(3.14159)
                          : Matrix4.identity(),
                      child: Image.asset(
                        'assets/images/Arrow - Right.png',
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              formatedMonth.tr(),
              style: PetVeterinaryFontstyles.poppinsMediumTextStyle.copyWith(
                color: PetVeterinaryColors.customLightBlueColor,
              ),
            ),
          ],
        ),
        kHeight10,
        doctorTiming == null || doctorTiming.doctorTimings.isEmpty
            ? Center(
                child: Text(
                  "${"No available timings at the moment.".tr()}\n${"Please check back later.".tr()}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent,
                  ),
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: doctorTiming.doctorTimings
                      .map(
                        (timing) => Padding(
                          padding: const EdgeInsets.only(
                            right: 16,
                          ),
                          child: dateOption(
                            timing.date,
                            timing.day,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
        kHeight10,
        Divider(),
        kHeight10,
        availableTimesSection(
          doctorTiming?.doctorTimings ?? [],
        ),
        kHeight10,
      ],
    );
  }

  /// profile image
  Widget profileImage(AsyncValue<Doctor?> doctorDetails) {
    return CircleAvatar(
      radius: 45.5,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: doctorDetails.value?.profileImage != null &&
              doctorDetails.value?.profileImage?.isNotEmpty == true
          ? NetworkImage(doctorDetails.value!.profileImage!)
          : null,
      child: (doctorDetails.value?.profileImage == null ||
              doctorDetails.value?.profileImage?.isEmpty == true)
          ? const Icon(Icons.person, size: 45, color: Colors.grey)
          : null,
    );
  }

  Widget loadingWidget() {
    return const Column(
      children: [
        SizedBox(
          height: 157,
          child: Center(child: CustomIndicator(padding: 50)),
        ),
      ],
    );
  }

  String get formatedMonth {
    if (selectedMonth.isEmpty) return selectedMonth;
    return selectedMonth[0].toUpperCase() +
        selectedMonth.substring(1).toLowerCase();
  }

  String doctorSpecialization(Doctor? doctor) {
    if (doctor == null) {
      return 'Unavailable'.tr();
    }
    if (isEnglish) {
      return doctor.specializationEn ??
          doctor.specializationAr ??
          'Unavailable'.tr();
    }
    return doctor.specializationAr ??
        doctor.specializationEn ??
        'Unavailable'.tr();
  }

  String doctorName(Doctor? doctor) {
    if (doctor == null) {
      return '';
    }
    if (isEnglish) {
      return doctor.nameEn ?? doctor.nameAr ?? '';
    }
    return doctor.nameAr ?? doctor.nameEn ?? '';
  }

  String aboutDoctor(Doctor? doctor) {
    if (doctor == null) {
      return 'Unavailable'.tr();
    }
    if (isEnglish) {
      return doctor.aboutEn ?? doctor.aboutAr ?? 'Unavailable'.tr();
    }
    return doctor.aboutAr ?? doctor.aboutEn ?? 'Unavailable'.tr();
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

  Widget timeOption(String time, String date, int index) {
    bool isSelected = selectedTimeIndex == index;
    String fullDateTime = "$date $time";
    DateTime utcTime = DateTime.parse("${fullDateTime}Z");

    DateTime localTime = utcTime.toLocal();

    String localTimeString = DateFormat("HH:mm", 'en').format(localTime);
    String formattedTime = _convertTo12HourFormat(localTimeString);
    String formattedTime24Hour = DateFormat("HH:mm", 'en').format(localTime);

    return GestureDetector(
      onTap: () {
        debugPrint("Selected (12-hour): $formattedTime");
        debugPrint("Selected (24-hour): $formattedTime24Hour");

        setState(() {
          selectedTime = formattedTime24Hour;
          selectedTimeIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xff78B833) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : PetVeterinaryColors.customSmallBorderColor),
        ),
        child: Text(
          formattedTime,
          style: PetVeterinaryFontstyles.poppinsMediumTextStyle.copyWith(
              color: isSelected
                  ? Colors.white
                  : PetVeterinaryColors.customDarkBlueColor),
        ),
      ),
    );
  }

  String _convertTo12HourFormat(String time) {
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
        Text("Available Times".tr(),
            style: PetVeterinaryFontstyles.poppinsSemiBold18
                .copyWith(color: PetVeterinaryColors.customDarkBlueColor)),
        const SizedBox(height: 10),
        availableTimes.isEmpty
            ? Center(
                child: Text(
                  "No available times for this slot. Please select a different date."
                      .tr(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    availableTimes.length,
                    (index) => Padding(
                        padding: const EdgeInsets.only(right: 6, left: 2),
                        child: timeOption(
                            availableTimes[index], formattedDate, index)),
                  ),
                ),
              ),
      ],
    );
  }

  TextAlign getTextAlignment() {
    return isEnglish ? TextAlign.left : TextAlign.right;
  }

  Widget durationOption(int minutes) {
    bool isSelected = selectedDuration == minutes;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDuration = minutes;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xff78B833) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : PetVeterinaryColors.customSmallBorderColor),
        ),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$minutes ",
                style: PetVeterinaryFontstyles.poppinsSemiBold16.copyWith(
                  color: isSelected
                      ? Colors.white
                      : PetVeterinaryColors.customGrayColor,
                ),
              ),
              TextSpan(
                text: "minutes".tr(),
                style:
                    PetVeterinaryFontstyles.poppinsMediumTextStyle15.copyWith(
                  color: isSelected
                      ? Colors.white
                      : PetVeterinaryColors.customGrayColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
        });
      },
      child: Container(
        height: 70,
        width: 65,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xff78B833) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : PetVeterinaryColors.customSmallBorderColor),
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
                    PetVeterinaryFontstyles.poppinsSemiBoldTextStyle16.copyWith(
                  color: isSelected
                      ? Colors.white
                      : PetVeterinaryColors.customDarkBlueColor,
                ),
              ),
            ),
            if (isEnglish)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    formattedDay,
                    style: PetVeterinaryFontstyles.poppinsMedium14.copyWith(
                      color: isSelected
                          ? Colors.white
                          : PetVeterinaryColors.customLightBlueColor,
                    ),
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

  String getLocalizedExperience(BuildContext context, Doctor doctor) {
    if (isEnglish) {
      return doctor.experience ?? doctor.experienceAr ?? 'Unavailable'.tr();
    } else {
      return doctor.experienceAr ?? 'Unavailable'.tr();
    }
  }
}

Map<String, Map<String, String>> localizedLanguageMap = {
  'en': {
    'English': 'English',
    'Arabic': 'Arabic',
    'Urdu': 'Urdu',
    'Spanish': 'Spanish',
    'Hindi': 'Hindi',
    'French': 'French',
    'Russian': 'Russian',
    'Portuguese': 'Portuguese',
    'Bengali': 'Bengali',
    'Turkish': 'Turkish',
    'Japanese': 'Japanese',
  },
  'ar': {
    'English': 'الأنجليزية',
    'Arabic': 'العربية',
    'Urdu': 'الأردية',
    'Spanish': 'الإسبانية',
    'Hindi': 'الهندية',
    'French': 'الفرنسية',
    'Russian': 'الروسية',
    'Portuguese': 'البرتغالية',
    'Bengali': 'البنغالية',
    'Turkish': 'التركية',
    'Japanese': 'اليابانية',
  },
  // Add more locales if needed...
};

String formatLanguages(List<String>? languages, BuildContext context) {
  if (languages == null || languages.isEmpty) {
    return 'Unavailable'.tr();
  }

  final localeCode = LanguageManager.locale;

  // Use map if available, or fallback to raw name
  List<String> localizedLanguages = languages.map((lang) {
    return localizedLanguageMap[localeCode]?[lang] ?? lang;
  }).toList();

  // Use localized "and"
  final translatedAnd = 'and'.tr();

  if (localizedLanguages.length == 1) {
    return localizedLanguages.first;
  } else if (localizedLanguages.length == 2) {
    return '${localizedLanguages[0]} $translatedAnd ${localizedLanguages[1]}';
  } else {
    final allButLast =
        localizedLanguages.sublist(0, localizedLanguages.length - 1).join(', ');
    final last = localizedLanguages.last;
    return '$allButLast, $translatedAnd $last';
  }
}

String limitExperience(String? experience) {
  if (experience == null || experience.isEmpty) {
    return 'Unavailable'.tr();
  }

  final words = experience.trim().split(RegExp(r'\s+'));
  if (words.length <= 3) {
    return experience;
  } else {
    return '${words.sublist(0, 3).join(' ')}...';
  }
}
