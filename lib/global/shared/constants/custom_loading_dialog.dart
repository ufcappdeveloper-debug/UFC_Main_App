import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

class LoadingDialog {
  static Future<dynamic> show(
    BuildContext context,
    Future future, {
    bool fromPayment = false,
    bool isFromFarm = false,
    bool isFromVet = false,
  }) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (c) {
        final minimumSize = MediaQuery.of(context).size.width * 0.3;
        return FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Future(() {
                Navigator.pop(c);
                if (fromPayment == true) Navigator.pop(c);
              });
            }
            final indicatorColor = isFromVet
                ? PetVeterinaryColors.newPetMainColorVeterinary
                : isFromFarm
                    ? AppColors.farmColor
                    : primaryColor;

            return Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.symmetric(horizontal: minimumSize),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator.adaptive(
                      backgroundColor:
                          Platform.isIOS ? indicatorColor : Colors.transparent,
                      valueColor: AlwaysStoppedAnimation(indicatorColor),
                    ),
                    const SizedBox(height: 15),
                    Text('Loading...'.tr()),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    try {
      return await future;
    } catch (e) {
      rethrow;
    }
  }
}
