import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class FavFilterContainer extends StatelessWidget {
  const FavFilterContainer({
    super.key,
    required this.data,
    required this.favSelectedFilter,
  });

  final String data;
  final String favSelectedFilter;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 9),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      decoration: BoxDecoration(
        border: favSelectedFilter == data
            ? null
            : Border.all(
                width: 1,
                color: const Color(0xFFD7D7D7),
              ),
        color: favSelectedFilter == data ? primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(47),
      ),
      child: CustomText(
        text: data,
        fontSize: 15,
        color:
            favSelectedFilter == data ? Colors.white : const Color(0xFF858585),
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
