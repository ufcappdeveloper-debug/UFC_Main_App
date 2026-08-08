import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

import '../widgets/custome_container.dart';
import '../widgets/farm_appbar.dart';

class MedicalRecords extends StatelessWidget {
  const MedicalRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomFarmAppBar(title: 'Medical Record'),
      body: ListView.separated(
        padding: EdgeInsets.all(20),
        itemBuilder: (context, index) => CustomFarmContainer(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/farm/animal2.svg',
                    height: 30,
                  ),
                  kWidth10,
                  CustomText(
                      text: '#1234', fontWeight: FontWeight.w400, fontSize: 20),
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/farm/pdf.svg',
                    height: 25,
                  ),
                  kWidth15,
                  SvgPicture.asset(
                    'assets/svg/farm/download-01.svg',
                    height: 25,
                  ),
                ],
              )
            ],
          ),
        ),
        separatorBuilder: (context, index) => kHeight20,
        itemCount: 4,
      ),
    );
  }
}
