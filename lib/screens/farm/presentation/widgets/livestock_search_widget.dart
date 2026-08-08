import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/custome_container.dart';

import '../../../../global/shared/constants/constants.dart';
import '../../domain/entities/barn/barn_details_res_model.dart';
import 'farm_text_field.dart';
import 'livestock_filter.dart';

class LiveStockSearchWidget extends StatelessWidget {
  final String? category;
  final int? barnId;
  final bool isAllBarn;
  final Function(String value) onSubmitted;
  final List<AnimalCategory> availableFilters;
  const LiveStockSearchWidget(
      {super.key,
      this.category,
      this.barnId,
      this.isAllBarn = false,
      required this.availableFilters,
      required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                useRootNavigator: true,
                scrollControlDisabledMaxHeightRatio: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                context: context,
                builder: (context) {
                  return LivestockFilter(
                    isAllBarn: isAllBarn,
                    barnId: barnId,
                    category: category,
                    availableFilters: availableFilters,
                  );
                },
              );
            },
            child: CustomFarmContainer(
              height: 40,
              width: 40,
              child: SvgPicture.asset('assets/svg/global/menu.svg'),
            ),
          ),
          kWidth10,
          FarmSearchField(
            onSubmitted: (value) {
              onSubmitted(value);
            },
          ),
        ],
      ),
    );
  }
}
