import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class EmptyFavoriteWidget extends StatelessWidget {
  const EmptyFavoriteWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/favorite/empty_favorite.png",
            height: 201,
            width: 201,
          ),
          const SizedBox(height: 83),
          CustomText(
            text: "No favorites  yet !",
            fontSize: 15,
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          kHeight16,
          CustomText(
            text: "Go to shopping page and add favorite",
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            color: const Color(0xFF8D8D8D),
          ),
        ],
      ),
    );
  }
}
