import 'dart:convert';

import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/main.dart';
import 'package:ufc_mobile/riverpod/currency/currency_riverpod.dart';
import 'package:ufc_mobile/global/shared/constants/widgets.dart';
import 'package:ufc_mobile/global/shared/translations/l10n.dart';
import 'package:ufc_mobile/global/shared/widgets/common_back_app_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/lang/langauge_manager.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/global/util/storage/local_storage.dart';

class LanguageAndCurrencyPage extends ConsumerStatefulWidget {
  const LanguageAndCurrencyPage({super.key});

  @override
  ConsumerState<LanguageAndCurrencyPage> createState() =>
      _LanguageAndCurrencyPageState();
}

class _LanguageAndCurrencyPageState
    extends ConsumerState<LanguageAndCurrencyPage>
    with ScreenEngagementTracker {
  int langIndex = 0;
  int? savedLangIndex;
  String? selectedCity;
  String? selectedLanguage;
  Currency? newSelectedCurrency;

  @override
  void initState() {
    super.initState();

    Future.microtask(_loadSelectedLanguage);
  }

  void _loadSelectedLanguage() {
    setState(() {
      // Retrieve the saved language index or set a default
      savedLangIndex = preferences.getInt(LocalStorage.language);
      if (savedLangIndex != null) {
        if ((savedLangIndex ?? 0) < languageData.length) {
          selectedLanguage = languageData[
              savedLangIndex ?? 0]; // Get the language from `languageData`
          langIndex = savedLangIndex ?? 0;
        } else {
          selectedLanguage = null; // No language selected initially
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final oldSelectedCurrency = ref.watch(currencyProvider).selectedCurrency;
    return Scaffold(
      appBar: CommonBackAppBar(
        title: "Language/Currency".tr(),
        boxShadow: const [appBarShadow],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 32),
                CustomText(
                  text:
                      "Items in your cart and shipping methods may vary depending on the selection"
                          .tr(),
                  fontSize: 15,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF333333),
                ),
                /*const SizedBox(height: 26),
                Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: const Color(0xFFEEEEEE)),
                      borderRadius: BorderRadius.circular(9)),
                  child: DropdownButton<String>(
                    elevation: 2,
                    isExpanded: true,
                    value: selectedCity,
                    underline: const SizedBox.shrink(),
                    icon: SvgPicture.asset(
                        "assets/images/global/down_arrow_ios.svg"),
                    hint: CustomText(
                      text: "City".tr(),
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF757575),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        selectedCity = value!;
                      });
                    },
                    items:
                        cityData.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.tr()),
                      );
                    }).toList(),
                  ),
                ),*/
                const SizedBox(height: 18),
                Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: const Color(0xFFEEEEEE)),
                      borderRadius: BorderRadius.circular(9)),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent),
                    child: DropdownButton<String>(
                      elevation: 2,
                      isExpanded: true,
                      value: selectedLanguage,
                      underline: const SizedBox.shrink(),
                      icon: SvgPicture.asset(
                          "assets/images/global/down_arrow_ios.svg"),
                      hint: CustomText(
                        text:
                            selectedLanguage?.tr() ?? "Select a Language".tr(),
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF757575),
                      ),
                      onChanged: (String? value) {
                        selectedLanguage = value!;
                        langIndex = languageData.indexOf(selectedLanguage!);
                        setState(() {});
                      },
                      items: languageData
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.tr()),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                InkWell(
                  onTap: () => showCurrencyPicker(
                    context: context,
                    showFlag: true,
                    favorite: ['sar'],
                    showSearchField: true,
                    showCurrencyName: true,
                    showCurrencyCode: true,
                    theme: CurrencyPickerThemeData(
                        bottomSheetHeight: size.height * 0.8),
                    onSelect: (Currency currency) {
                      newSelectedCurrency = currency;
                      setState(() {});
                    },
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: const Color(0xFFEEEEEE)),
                        borderRadius: BorderRadius.circular(9)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if ((newSelectedCurrency?.code ??
                                    oldSelectedCurrency?.code) ==
                                'AED')
                              SvgPicture.asset(
                                'assets/svg/global/dirham.svg',
                                height: 12,
                                width: 12,
                                colorFilter: ColorFilter.mode(
                                  Colors.black,
                                  BlendMode.srcIn,
                                ),
                              )
                            else
                              Text(
                                newSelectedCurrency?.symbol ??
                                    oldSelectedCurrency?.symbol ??
                                    '',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            const SizedBox(width: 6),
                            Text(
                              newSelectedCurrency?.name ??
                                  oldSelectedCurrency?.name ??
                                  '',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.asset(
                            "assets/images/global/down_arrow_ios.svg"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 55),
              child: CustomButton(
                title: "Save".tr(),
                width: double.infinity,
                onTap: () async {
                  bool updated = false;

                  if (savedLangIndex != langIndex) {
                    context.setLocale(L10n.all[langIndex]);

                    LanguageManager.update(
                        L10n.all[langIndex].languageCode.toString());
                    preferences.setInt(LocalStorage.language, langIndex);
                    updated = true;
                    setState(() {});
                  }

                  if (newSelectedCurrency != null) {
                    final future = changeCurrency(ref, newSelectedCurrency!);
                    await LoadingDialog.show(context, future);
                    updated = true;
                  }

                  if (!context.mounted) return;
                  Navigator.pop(context, updated);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<String> cityData = [
  "Riyadh",
  "Jeddah",
  "Medina",
  "Mecca",
  "Dammam",
  "Ta'if",
  "Tabuk",
  "Jubail",
  "Abha",
  "Khobar",
  "Najran",
  "Sakaka",
  "Riyadh Region",
  "Diriyah",
  "Hofuf",
  "Qatif",
  "Dhahran",
  "Al-Kharj",
  "Al Bahah",
  "Yanbu",
  "AlUla",
  "Al Qassim Province",
  "Buraidah",
  "Arar",
];

List<String> languageData = ["English", "Arabic", "Urdu"];

Future<void> changeCurrency(
    WidgetRef ref, Currency? newSelectedCurrency) async {
  preferences.setString("currency", json.encode(newSelectedCurrency));
  ref
      .read(currencyProvider.notifier)
      .changeSelectedCurrency(newSelectedCurrency);
}
