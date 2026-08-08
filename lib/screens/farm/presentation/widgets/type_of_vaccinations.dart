import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/barn/vaccine_model.dart';

import '../../../../global/shared/constants/constants.dart';
import '../../../../global/shared/constants/text_filed_input_formatters.dart'
    as filteringtextinputformatter;
import '../../../../global/shared/widgets/custom_indicator.dart';
import '../../../../global/shared/widgets/custom_reload_provider.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../../../../riverpod/farm/vaccination/get_vaccination.dart';

import 'farm_text_field.dart';

class TypeOfVaccination extends ConsumerStatefulWidget {
  const TypeOfVaccination({super.key});

  @override
  ConsumerState<TypeOfVaccination> createState() => TypeOfVaccinationState();
}

class TypeOfVaccinationState extends ConsumerState<TypeOfVaccination> {
  late List<TextEditingController> dateControllers;
  late List<TextEditingController> durationControllers;
  Set<int> editedDateIds = {};
  Set<int> editedDurationIds = {};
  bool initialized = false;

  @override
  void initState() {
    dateControllers = [];
    durationControllers = [];
    super.initState();
  }

  @override
  void dispose() {
    for (var c in dateControllers) {
      c.dispose();
    }
    for (var c in durationControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vaccinTypes = ref.watch(getVaccinationProvider);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget('Type of vaccination'),
          kHeight20,
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: 110,
                      child: textWidget('Vaccination', fontSize: 13)),
                  kHeight10,
                  SizedBox(
                    width: 120,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: textWidget('History of vaccination', fontSize: 13),
                    ),
                  ),
                  kHeight10,
                  SizedBox(
                      width: 90,
                      child:
                          textWidget('Duration of prohibition', fontSize: 13)),
                ],
              ),
              kHeight10,
              vaccinTypes.when(
                data: (data) {
                  if (!initialized && data != null) {
                    dateControllers = List.generate(
                      data.length,
                      (i) => TextEditingController(text: data[i].date ?? ''),
                    );
                    durationControllers = List.generate(
                      data.length,
                      (i) =>
                          TextEditingController(text: data[i].duration ?? ''),
                    );
                    initialized = true;
                  }

                  return Column(
                    children: List.generate(
                      data?.length ?? 0,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 110,
                                child: Text(
                                  data?[index].vaccineName ?? '',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    // fontFamily:
                                    //     isArOrUr ? 'Graphik Arabic' : 'Kanit',
                                    fontFamily: isEnglish
                                        ? AppFontsFamily.english
                                        : AppFontsFamily.arabic,
                                    height: 1.4,
                                  ),
                                )),
                            SizedBox(
                              width: 120,
                              child: CustomDatePicker(
                                needFormat: false,
                                hintText: 'Enter the date'.tr(),
                                needIcon: false,
                                onDateSelect: (date) {},
                                controller: dateControllers[index],
                              ),
                            ),
                            SizedBox(
                                width: 85,
                                child: CustomTextFormField(
                                    inputFormatters: [
                                      filteringtextinputformatter.digitsOnly,
                                    ],
                                    controller: durationControllers[index],
                                    keyboardType: TextInputType.number,
                                    suffixIcon: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            fontSize: 11,
                                            text: 'day'.tr(),
                                            textAlign: TextAlign.center,
                                          )
                                        ]),
                                    context: context)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                error: (error, stack) => CustomReloadProvider(
                  height: 118,
                  onPressed: () {},
                ),
                loading: () => const SizedBox(
                  height: 157,
                  child: Center(child: CustomIndicator(padding: 50)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  CustomText textWidget(String text,
      {double fontSize = 15, FontWeight? fontWeight = FontWeight.w500}) {
    return CustomText(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
      text: text,
    );
  }

  List<VaccineSchedules> getVaccinationData() {
    final vaccinTypes = ref.read(getVaccinationProvider).asData?.value;
    List<VaccineSchedules> vaccinations = [];

    for (int i = 0; i < (vaccinTypes?.length ?? 0); i++) {
      if (dateControllers[i].text.isNotEmpty ||
          durationControllers[i].text.isNotEmpty) {
        vaccinations.add(VaccineSchedules(
          vaccineTypeId: vaccinTypes?[i].id,
          vaccinationDate: dateControllers[i].text,
          prohibitionPeriod: int.tryParse(durationControllers[i].text),
        ));
      }
    }

    return vaccinations;
  }
}
