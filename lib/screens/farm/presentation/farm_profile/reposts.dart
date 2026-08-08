import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/farm_appbar.dart';

import '../../../../global/shared/constants/constants.dart';
import '../widgets/custome_container.dart';
import '../widgets/farm_text_field.dart';

class RepostsPage extends StatelessWidget {
  const RepostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> data = [
      "Total Livestock Wealth",
      "Mothers And Babies",
      "Males",
      "Females",
      "Pregnant",
      "Active Animals",
      "Inactive Animals"
    ];
    return Scaffold(
      appBar: CustomFarmAppBar(title: 'Reports'),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            searchWidget(),
            kHeight20,
            list(data),
          ],
        ),
      ),
    );
  }

  ListView list(List<String> data) {
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return CustomFarmContainer(
            padding: EdgeInsets.symmetric(vertical: 13, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: data[index],
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                  fontFamily: isEnglish
                      ? AppFontsFamily.english
                      : AppFontsFamily.arabic,
                ),
                SvgPicture.asset('assets/svg/farm/save.svg')
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => kHeight20,
        itemCount: data.length);
  }

  Row searchWidget() {
    return Row(
      children: [
        customContainer('assets/svg/global/menu.svg'),
        kWidth10,
        FarmSearchField(
          hint: 'Search by cattle type, number, name, etc.'.tr(),
          onSubmitted: (value) {},
        ),
        kWidth10,
        customContainer('assets/svg/farm/save.svg'),
      ],
    );
  }

  CustomFarmContainer customContainer(String svg) {
    return CustomFarmContainer(
        height: 40, width: 40, child: SvgPicture.asset(svg));
  }
}
