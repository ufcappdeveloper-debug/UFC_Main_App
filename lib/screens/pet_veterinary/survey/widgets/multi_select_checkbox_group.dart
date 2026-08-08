import 'package:flutter/material.dart';
import 'package:ufc_mobile/models/survey/survey_quest_option_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/survey/widgets/selectable_check_box_tile.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

class MultiselectCheckboxGroup extends StatelessWidget {
  final List<SurveyQuestionOptionModel> options;
  final Set<SurveyQuestionOptionModel> selectedOptions;
  final void Function(SurveyQuestionOptionModel option) onToggle;

  const MultiselectCheckboxGroup({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options
          .map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: SelectableCheckboxTile(
                label: currentOptionText(option, context),
                isSelected: selectedOptions.contains(option),
                onTap: () => onToggle(option),
              ),
            ),
          )
          .toList(),
    );
  }

  String currentOptionText(
    SurveyQuestionOptionModel? option,
    BuildContext context,
  ) {
    if (option != null) {
      if (isArabic) {
        return option.optionTextAr ?? option.optionText ?? '';
      } else {
        return option.optionText ?? option.optionTextAr ?? '';
      }
    }
    return '';
  }
}
