import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/util/extension/date_extenstions.dart';
import 'package:ufc_mobile/global/util/farm/farm_utils.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/barn/animal_model.dart';

import '../../../../global/shared/constants/constants.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../../../pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';
import 'package:ufc_mobile/screens/farm/domain/services/camel_age.dart';
import '../livestock/livestock_details_page.dart';

class LiveStockBox extends StatelessWidget {
  const LiveStockBox(
      {super.key,
      this.data,
      this.width = 190,
      required this.isMale,
      this.animal,
      this.isFromDeath = false,
      this.fromBarn = false,
      this.category,
      this.fromGrid = true});
  final Map<String, dynamic>? data;
  final double width;
  final bool isMale;
  final AnimalModel? animal;
  final bool isFromDeath;
  final bool fromBarn;
  final String? category;
  final bool fromGrid;
  @override
  Widget build(BuildContext context) {
    Color? color =
        FarmUtils.getAnimalByType(animal?.animalType ?? 'sheep')['color'];
    return GestureDetector(
      onTap: () {
        if (animal?.animalRef != null && animal?.animalUniqueKey != null) {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => LivestockDetailsPage(
                animalUniqueKey: animal!.animalUniqueKey!,
                fromBarn: fromBarn,
                category: category,
                // animal: animal,
              ),
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: 'No livestock found'.tr(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [customBoxShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 20,
                  child: animal?.animalIcon?.split('.').lastOrNull == 'svg'
                      ? SvgPicture.network(
                          animal?.animalIcon ?? "",
                          height: 20,
                        )
                      : CachedNetworkImage(
                          height: 20,
                          imageUrl: animal?.animalIcon ?? "",
                          placeholder: (context, url) => SizedBox.shrink(),
                          errorWidget: (context, url, error) =>
                              SizedBox.shrink(),
                          fit: BoxFit.contain,
                        ),
                ),
                CustomText(
                  text: '#$animalref', //'#1234'
                  textStyle: PetVeterinaryFontstyles.kanitRegular16
                      .copyWith(fontFamily: AppFontsFamily.alexandria),
                )
              ],
            ),
            Divider(thickness: 1, color: color),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWidget(context, animalGender),
                textWidget(context, animalWeight),
              ],
            ),
            if (!fromGrid) kHeight15,
            textWidget(context, () {
              final text = '$dob - $age ${'Years'.tr()}';
              // Camels: add the traditional age name (Hawar, Mafrood, ...).
              final name = CamelAge.isCamel(animal?.animalType)
                  ? CamelAge.nameFor(DateTime.tryParse(animal?.birthDate ?? ''),
                      at: animal?.deathDate)
                  : null;
              return name == null ? text : '$text ($name)';
            }())
          ],
        ),
      ),
    );
  }

  String get animalref {
    return animal?.animalRef ?? '';
  }

  String get animalWeight {
    if (animal?.weightKg != null) {
      return '${animal?.weightKg ?? '0'} ${'Kg'.tr()}';
    }
    return '';
  }

  String get animalGender {
    if (animal?.gender?.toLowerCase() == 'female') {
      return 'Female';
    } else if (animal?.gender?.toLowerCase() == 'male') {
      return 'Male';
    }
    return '-';
  }

  int get age {
    return (animal?.ageYears ?? 0).toInt();
  }

  String get dob {
    if (isFromDeath) {
      return animal?.deathDate?.toFormattedDate() ?? '-';
    }
    return animal?.birthDate ?? '-';
  }

  CustomText textWidget(BuildContext context, String text) {
    return CustomText(
      text: text,
      // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
      fontFamily: isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
      fontWeight: FontWeight.w400,
      fontSize: 11,
    );
  }
}
