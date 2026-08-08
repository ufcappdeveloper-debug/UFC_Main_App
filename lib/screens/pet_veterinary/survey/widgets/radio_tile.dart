import 'package:flutter/material.dart';
import 'package:ufc_mobile/models/survey/survey_quest_option_model.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class RadioTileListView extends StatefulWidget {
  final List<SurveyQuestionOptionModel> options;
  final void Function(SurveyQuestionOptionModel selectedOptions)? onChanged;
  const RadioTileListView({
    super.key,
    required this.options,
    this.onChanged,
  });

  @override
  State<RadioTileListView> createState() => _RadioTileListViewState();
}

class _RadioTileListViewState extends State<RadioTileListView> {
  SurveyQuestionOptionModel? selectedOption;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.options.map((option) {
        return RadioListTile<SurveyQuestionOptionModel>(
          activeColor: primaryColor,
          title: CustomText(text: option.optionText ?? ''),
          value: option,
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() {
              selectedOption = value;
            });
            widget.onChanged?.call(value!);
          },
        );
      }).toList(),
    );
  }
}
