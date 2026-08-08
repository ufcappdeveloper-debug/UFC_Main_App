import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class VetPolicyPage extends StatelessWidget {
  const VetPolicyPage({super.key});

  Widget buildSection(String titleKey, List<String> pointKeys) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        kHeight25,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              text: '•\t\t',
              height: -0.5,
              fontSize: 13,
            ),
            CustomText(
              text: '${titleKey.tr()}\t:\n',
              decoration: TextDecoration.underline,
              height: 0,
              fontSize: 13,
            ),
          ],
        ),
        ...pointKeys.map((point) {
          return CustomText(text: '- $point');
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   shadowColor: const Color(0xffe5e5e5).withAlpha(50),
      //   elevation: 8,
      //   title: Column(
      //     children: [
      // CustomText(
      //   text: 'appBarTitle'.tr(),
      //   fontSize: 15,
      //   fontWeight: FontWeight.w600,
      //   color: Colors.black,
      // ),
      // CustomText(
      //   text: 'Last Updated: May 07, 2025'.tr(),
      //   fontSize: 10,
      //   fontWeight: FontWeight.w500,
      //   color: Colors.black,
      // ),
      //     ],
      //   ),
      //   centerTitle: true,
      //   leading: InkWell(
      //     onTap: () => Navigator.pop(context),
      //     child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
      //   ),
      // ),

      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Directionality(
            textDirection: flutter.TextDirection.ltr,
            child: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.white,
              shadowColor: const Color(0xffe5e5e5).withAlpha(50),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: 'appBarTitle'.tr(),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  CustomText(
                    text: 'Last Updated: May 07, 2025'.tr(),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ],
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded,
                    size: 16, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          )),

      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSection(
              'sectionDataUsageTitle'.tr(),
              [
                'sectionDataUsagePoints.0'.tr(),
                'sectionDataUsagePoints.1'.tr(),
              ],
            ),
            buildSection(
              'sectionUserResponsibilitiesTitle'.tr(),
              [
                'sectionUserResponsibilitiesPoints.0'.tr(),
                'sectionUserResponsibilitiesPoints.1'.tr(),
                'sectionUserResponsibilitiesPoints.2'.tr(),
                'sectionUserResponsibilitiesPoints.3'.tr(),
                'sectionUserResponsibilitiesPoints.4'.tr(),
                'sectionUserResponsibilitiesPoints.5'.tr(),
                'sectionUserResponsibilitiesPoints.6'.tr(),
                'sectionUserResponsibilitiesPoints.7'.tr(),
                'sectionUserResponsibilitiesPoints.8'.tr(),
              ],
            ),
            buildSection(
              'sectionDisclaimerTitle'.tr(),
              [
                'sectionDisclaimerPoints.0'.tr(),
                'sectionDisclaimerPoints.1'.tr(),
                'sectionDisclaimerPoints.2'.tr(),
                'sectionDisclaimerPoints.3'.tr(),
                'sectionDisclaimerPoints.4'.tr(),
                'sectionDisclaimerPoints.5'.tr(),
              ],
            ),
            buildSection(
              'sectionThirdPartyTitle'.tr(),
              [
                'sectionThirdPartyPoints.0'.tr(),
                'sectionThirdPartyPoints.1'.tr(),
                'sectionThirdPartyPoints.2'.tr(),
                'sectionThirdPartyPoints.3'.tr(),
              ],
            ),
            buildSection(
              'sectionEmployeeTitle'.tr(),
              [
                'sectionEmployeePoints.0'.tr(),
                'sectionEmployeePoints.1'.tr(),
                'sectionEmployeePoints.2'.tr(),
                'sectionEmployeePoints.3'.tr(),
              ],
            ),
            buildSection(
              'sectionTreatmentDisclaimerTitle'.tr(),
              [
                'sectionTreatmentDisclaimerPoints.0'.tr(),
                'sectionTreatmentDisclaimerPoints.1'.tr(),
                'sectionTreatmentDisclaimerPoints.2'.tr(),
                'sectionTreatmentDisclaimerPoints.3'.tr(),
                'sectionTreatmentDisclaimerPoints.4'.tr(),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
