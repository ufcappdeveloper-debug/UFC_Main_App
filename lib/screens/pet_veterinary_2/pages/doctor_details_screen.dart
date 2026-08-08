import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readmore/readmore.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/util/lang/langauge_manager.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/pages/appoinment_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary/pages/vet_policy_page.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/provider/doctor_details_riverpod.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/utils/doctor_utils.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/doctor_appointment_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/review_list.dart';

class DoctorDetailsScreen extends ConsumerStatefulWidget {
  final int doctorId;

  const DoctorDetailsScreen({super.key, required this.doctorId});

  @override
  ConsumerState<DoctorDetailsScreen> createState() =>
      _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends ConsumerState<DoctorDetailsScreen> {
  bool termsAndConditionAgreed = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final providerRef = ref.read;

      await providerRef(doctorDetailsProvider.notifier)
          .fetchDoctorById(widget.doctorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorDetails = ref.watch(doctorDetailsProvider);

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
      body: doctorDetails.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(doctorDetailsProvider.notifier)
                        .fetchDoctorById(widget.doctorId);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Something went wrong".tr(),
                          style: PetVeterinaryFontstyles2.getRegularStyle(
                            context,
                            14,
                            color: PetVeterinaryColors.newPetLightGray,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        const Icon(
                          Icons.refresh,
                          color: PetVeterinaryColors.newPetLightGray,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          data: (doctor) {
            final aboutText = DoctorUtils.aboutDoctor(doctor);
            final isArabic = DoctorUtils.isArabicText(aboutText);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Apply padding only to upper content
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 43,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: (doctor?.profileImage != null &&
                                    doctor!.profileImage!.isNotEmpty)
                                ? NetworkImage(doctor.profileImage!)
                                : null,
                            child: (doctor?.profileImage == null ||
                                    doctor!.profileImage!.isEmpty)
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
                            DoctorUtils.doctorName(doctor),
                            style: PetVeterinaryFontstyles2.getMediumStyle(
                                context, 17),
                          ),
                        ),
                        const SizedBox(height: 4),

                        /// Speciality and Rating
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(DoctorUtils.doctorSpecialization(doctor),
                                  style:
                                      PetVeterinaryFontstyles2.getRegularStyle(
                                              context, 11)
                                          .copyWith(
                                              color: PetVeterinaryColors
                                                  .customBlackColor)),
                              SizedBox(width: 10),
                              Text(
                                (doctor?.rating ?? 0.0).toStringAsFixed(1),
                                style: PetVeterinaryFontstyles2.getRegularStyle(
                                        context, 11)
                                    .copyWith(
                                        color:
                                            PetVeterinaryColors.newPetDarkGray),
                              ),
                              SizedBox(width: 2),
                              Icon(Icons.star,
                                  color: PetVeterinaryColors.softYellow,
                                  size: 10),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        /// About Doctor
                        Text(
                          "About Doctor".tr(),
                          style: PetVeterinaryFontstyles2.getMediumStyle(
                              context, 14),
                        ),
                        const SizedBox(height: 16),

                        Directionality(
                            textDirection: isArabic
                                ? flutter.TextDirection.rtl
                                : flutter.TextDirection.ltr,
                            child: ReadMoreText(
                              aboutText,
                              style: PetVeterinaryFontstyles2.getRegularStyle(
                                context,
                                13,
                              ).copyWith(
                                  color: PetVeterinaryColors.newPetDarkGray),
                              trimLines: 4,
                              colorClickableText: Colors.black,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: ' Read more...'.tr(),
                              trimExpandedText: ' Show less'.tr(),
                              moreStyle:
                                  PetVeterinaryFontstyles2.getRegularStyle(
                                          context, 10)
                                      .copyWith(color: Colors.black),
                              lessStyle:
                                  PetVeterinaryFontstyles2.getRegularStyle(
                                          context, 10)
                                      .copyWith(color: Colors.black),
                            )),

                        kHeight16,
                        Divider(
                          color: PetVeterinaryColors.lightGrayBackground,
                          thickness: 1,
                        ),
                        kHeight16,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _InfoIconBox(
                                assetPath:
                                    'assets/new_design/icons/vet_experience_icon.png',
                                title: 'Experience'.tr(),
                                value: DoctorUtils.doctorExp(doctor)),
                            _InfoIconBox(
                                assetPath:
                                    'assets/new_design/icons/vet_specialization_icon2.png',
                                title: "Expertise".tr(),
                                value:
                                    DoctorUtils.doctorSpecialization(doctor)),
                            _InfoIconBox(
                              isLanguage: true,
                              assetPath:
                                  'assets/new_design/icons/vet_language_icon.png',
                              title: "Language".tr(),
                              value: formatLanguages(
                                  doctorDetails.value?.languages, context),
                            ),
                          ],
                        ),
                        kHeight12,
                        Divider(
                          color: PetVeterinaryColors.lightGrayBackground,
                          thickness: 1,
                        ),
                        kHeight16,

                        /// Feedbacks
                        Text("Feedbacks".tr(),
                            style: PetVeterinaryFontstyles2.getMediumStyle(
                                context, 15)),
                        const SizedBox(height: 12),
                        ReviewList(reviews: doctor?.reviews ?? []),

                        kHeight15,
                        Divider(
                          color: PetVeterinaryColors.lightGrayBackground,
                          thickness: 1,
                        ),
                        kHeight20,

                        /// Consultation Fees
                        Text("Consultation Fees".tr(),
                            style: PetVeterinaryFontstyles2.getMediumStyle(
                                context, 15)),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: PetVeterinaryFontstyles2.getRegularStyle(
                                    context, 15)
                                .copyWith(color: Colors.black),
                            children: [
                              TextSpan(
                                  text: "30 minutes veterinary consultation for"
                                      .tr()),
                              TextSpan(text: "  "),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "0",
                                      style: PetVeterinaryFontstyles2
                                              .getMediumStyle(context, 13)
                                          .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    SaudiRiyalIcon(
                                      size: 14,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),

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
                  termsAndConditions(context),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (!termsAndConditionAgreed) {
                          CustomSnackBar.error(
                              context,
                              'Kindly accept the terms and conditions to continue'
                                  .tr());
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorAppointmentScreen(
                              doctorId: doctor?.id ?? 0,
                              doctorName: DoctorUtils.doctorName(doctor),
                              doctorImage: doctor?.profileImage ?? '',
                              specialization:
                                  DoctorUtils.doctorSpecialization(doctor),
                              rating: doctor?.rating ?? 0.0,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        margin: const EdgeInsets.only(
                            left: 32, right: 32, bottom: 40, top: 8),
                        height: 54,
                        decoration: BoxDecoration(
                          color: termsAndConditionAgreed
                              ? PetVeterinaryColors.newPetMainColorVeterinary
                              : AppColors.grey,
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

                  kHeight30,
                ],
              ),
            );
          }),
    );
  }

  Widget termsAndConditions(BuildContext context) => Row(
        children: [
          Checkbox(
            activeColor: PetVeterinaryColors.newPetMainColorVeterinary,
            value: termsAndConditionAgreed,
            onChanged: (value) {
              termsAndConditionAgreed = !termsAndConditionAgreed;
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
              style: PetVeterinaryFontstyles2.getRegularStyle(context, 12)
                  .copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      );
}

class _InfoIconBox extends StatelessWidget {
  final String assetPath;
  final String title;
  final String value;
  final bool isLanguage;

  const _InfoIconBox({
    required this.assetPath,
    required this.title,
    required this.value,
    this.isLanguage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            assetPath,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            // 👈 ensures text takes remaining width only
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: PetVeterinaryFontstyles2.getMediumStyle(context, 13)
                      .copyWith(color: PetVeterinaryColors.customGrayColor2),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: PetVeterinaryFontstyles2.getMediumStyle(context, 13)
                      .copyWith(color: PetVeterinaryColors.customBlackColor2),
                  maxLines: isLanguage ? null : 3,
                  overflow:
                      isLanguage ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String formatLanguages(List<String>? languages, BuildContext context) {
  if (languages == null || languages.isEmpty) {
    return 'Unavailable'.tr();
  }

  final localeCode = LanguageManager.locale;

  List<String> localizedLanguages = languages.map((lang) {
    return localizedLanguageMap[localeCode]?[lang] ?? lang;
  }).toList();

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
