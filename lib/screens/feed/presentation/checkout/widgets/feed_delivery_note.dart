import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/farm_text_field.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/pages/feed_order_details.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

class DeliveryNoteWidget extends StatelessWidget {
  final String? deliveryNote;
  final ValueChanged<String>? onNoteSaved;

  const DeliveryNoteWidget({
    super.key,
    this.deliveryNote,
    this.onNoteSaved,
  });

  void _openAddNoteModal(BuildContext context) {
    final noteController = TextEditingController(text: deliveryNote ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 28,
            right: 28,
            top: 28,
            bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: CustomText(
                        text: "Add a delivery note",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.close,
                      size: 17,
                    ),
                  ),
                ],
              ),
              kHeight24,
              CustomTextFormField(
                maxLines: 3,
                controller: noteController,
                hintText: 'Write your delivery instructions here...'.tr(),
                hintStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: isEnglish
                        ? AppFontsFamily.english
                        : AppFontsFamily.arabic,
                    fontSize: 14,
                    fontWeight: FontWeight.w300),
                context: context,
              ),
              const SizedBox(height: 24),
              CustomButton(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                width: MediaQuery.sizeOf(context).width,
                height: 45,
                title: 'Save',
                onTap: () {
                  final note = noteController.text.trim();
                  Navigator.of(context).pop(note);
                },
              ),
              kHeight40,
            ],
          ),
        );
      },
    ).then((note) {
      if (note != null) {
        onNoteSaved?.call(note.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasNote = deliveryNote != null && deliveryNote!.isNotEmpty;
    return InfoCard(
      containerPadding:
          EdgeInsets.fromLTRB(isEnglish ? 4 : 0, 4, isEnglish ? 0 : 4, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoTile(
            title: 'Add a delivery note',
            leadingWidget: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(isArOrUr ? 0 : math.pi),
              child: SvgPicture.asset(
                height: 20,
                width: 20,
                'assets/svg/feed/truck.svg',
                colorFilter: svgGreenColor,
              ),
            ),
            trailingWidget: IconButton(
              padding: const EdgeInsets.only(bottom: 0),
              icon: Icon(
                hasNote ? Icons.remove_circle : Icons.add_circle_outline,
                color: hasNote
                    ? Colors.redAccent
                    : PetVeterinaryColors.mainColorUFC,
                size: 20,
              ),
              onPressed: () {
                if (hasNote) {
                  onNoteSaved?.call("");
                } else {
                  _openAddNoteModal(context);
                }
              },
            ),
          ),
          if (hasNote)
            Padding(
              padding: EdgeInsets.fromLTRB(16, 2, 16, 12),
              child: CustomText(
                text: deliveryNote!,
                fontSize: 15,
                color: PetVeterinaryColors.newPetDarkGray,
              ),
            ),
        ],
      ),
    );
  }
}
