import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

class ChatLoadingSection extends StatelessWidget {
  const ChatLoadingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withValues(alpha: 0.5),
      highlightColor: Colors.white.withValues(alpha: 0.5),
      child: ListView.separated(
        reverse: true,
        itemCount: 11,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 33, horizontal: 20),
        itemBuilder: (context, index) => LayoutBuilder(
          builder: (context, constraints) {
            return Align(
              alignment: index.isEven
                  ? AlignmentDirectional.centerEnd
                  : AlignmentDirectional.centerStart,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth * 0.85,
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('E HH.mm', 'en').format(DateTime.now()),
                      style: PetVeterinaryFontstyles.poppinsRegularTextStyle12
                          .copyWith(color: PetVeterinaryColors.smokyGrayColor),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: index.isEven
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!index.isEven)
                          Container(
                            width: 43,
                            height: 43,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                          ),
                        if (!index.isEven) kWidth10,
                        Container(
                          height: dynamicHeight(index),
                          constraints: BoxConstraints(
                            maxWidth: dynamicWidth(index),
                          ),
                          padding: EdgeInsetsDirectional.only(
                            top: 11,
                            end: 10,
                            start: 12,
                            bottom: 9,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.25),
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ),
                        if (index.isEven) kWidth10,
                        if (index.isEven)
                          Container(
                            width: 43,
                            height: 43,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        separatorBuilder: (context, index) => kHeight20,
      ),
    );
  }

  double dynamicWidth(int index) {
    List<double> widths = [120, 160, 200, 235];
    return widths[index % widths.length];
  }

  double dynamicHeight(int index) {
    List<double> heights = [38, 235, 47];
    return heights[index % heights.length];
  }
}
