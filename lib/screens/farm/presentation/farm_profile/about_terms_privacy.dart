import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/farm_appbar.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/support_section.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_shadows.dart';

import '../../../../global/shared/constants/constants.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../widgets/custome_container.dart';

class AboutTermsPrivacy extends StatelessWidget {
  final List<InfoSection> info;
  final String title;
  final bool isFromVet;
  final bool isFromFarm;

  const AboutTermsPrivacy(
      {super.key,
      required this.title,
      required this.info,
      this.isFromVet = false,
      this.isFromFarm = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomFarmAppBar(title: title),
        body: ListView.separated(
          separatorBuilder: (context, index) => kHeight15,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          itemCount: info.length,
          itemBuilder: (context, index) {
            final item = info[index];
            final isMoreInfo =
                item.title.toLowerCase().contains('more informations');
            return CustomFarmContainer(
              margin: index == (info.length - 1)
                  ? EdgeInsets.only(bottom: 30)
                  : null,
              padding: EdgeInsets.zero,
              radius: 20,
              customShadow: PetVeterinaryShadows.standard2,
              child: ExpansionTile(
                  collapsedShape: RoundedRectangleBorder(
                    side: BorderSide.none,
                  ),
                  shape: RoundedRectangleBorder(side: BorderSide.none),
                  tilePadding:
                      const EdgeInsets.only(bottom: 0, right: 16, left: 16),
                  iconColor: Colors.black,
                  textColor: Colors.black,
                  title: CustomText(
                    text: item.title,
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                  ),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: isMoreInfo
                      ? [
                          const SizedBox(height: 12),
                          SupportSection(
                            isFromFarm: isFromFarm,
                            isFromVet: isFromVet,
                          ),
                        ]
                      : item.description
                          .map(
                            (desc) => Padding(
                              padding: EdgeInsets.only(
                                  bottom: 20,
                                  right: isEnglish ? 16 : 20,
                                  left: isEnglish ? 20 : 16),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: isArOrUr ? 0 : 8.0,
                                            left: isArOrUr ? 8 : 0,
                                            top: 2),
                                        child: Icon(Icons.circle, size: 6),
                                      ),
                                    ),
                                    TextSpan(
                                      text: desc.tr(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList()),
            );
          },
        ),
      ),
    );
  }
}

class InfoSection {
  final String title;
  final List<String> description;

  InfoSection({
    required this.title,
    required this.description,
  });
}
