import 'package:flutter/material.dart';
import 'package:ufc_mobile/models/survey/survey_quest_option_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/survey/widgets/comments_text_field.dart';
import 'package:ufc_mobile/screens/pet_veterinary/survey/widgets/multi_select_checkbox_group.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

class CheckboxOptionsWithCommentsField extends StatefulWidget {
  final List<SurveyQuestionOptionModel> options;
  final bool showOtherOption;
  final bool selectAll;
  final String otherPlaceholder;
  final void Function(
    List<SurveyQuestionOptionModel> selectedOptions,
    String otherText,
  )? onChanged;

  const CheckboxOptionsWithCommentsField({
    super.key,
    required this.options,
    this.otherPlaceholder = 'Other (writing 10 words)',
    this.onChanged,
    this.showOtherOption = false,
    this.selectAll = true,
  });

  @override
  State<CheckboxOptionsWithCommentsField> createState() =>
      _CheckboxOptionsWithCommentsFieldState();
}

class _CheckboxOptionsWithCommentsFieldState
    extends State<CheckboxOptionsWithCommentsField> {
  final Set<SurveyQuestionOptionModel> _selectedOptions = {};
  final TextEditingController _otherController = TextEditingController();

  void _toggleOption(SurveyQuestionOptionModel option) {
    if (widget.selectAll) {
      /// Check boxes
      if (_selectedOptions.contains(option)) {
        _selectedOptions.remove(option);
      } else {
        _selectedOptions.add(option);
      }
    } else {
      // Single-select
      if (_selectedOptions.contains(option)) {
        _selectedOptions.clear();
      } else {
        _selectedOptions
          ..clear()
          ..add(option);
      }
    }
    setState(() {});

    widget.onChanged?.call(_selectedOptions.toList(), _otherController.text);
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: MultiselectCheckboxGroup(
            options: widget.options,
            selectedOptions: _selectedOptions,
            onToggle: _toggleOption,
          ),
        ),
        kHeight16,
        Visibility(
          visible: widget.showOtherOption,
          child: Padding(
            padding: EdgeInsets.only(right: 40, left: 8),
            child: CommentsTextField(
              controller: _otherController,
              placeholder: widget.otherPlaceholder,
              onChanged: (text) {
                widget.onChanged?.call(_selectedOptions.toList(), text);
              },
            ),
          ),
        ),
      ],
    );
  }
}
