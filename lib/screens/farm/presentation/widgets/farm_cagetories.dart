import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

import '../../../../global/shared/constants/constants.dart';
import '../../domain/entities/barn/animal_model.dart';
import '../../domain/entities/barn/barn_details_res_model.dart';
import '../../domain/entities/barn/barn_model.dart';

class HorizontalOptionSelector extends StatefulWidget {
  const HorizontalOptionSelector({
    this.onCategoryChange,
    super.key,
    required this.list,
    this.initValue,
    this.barnList,
    this.onBarnChange,
    this.selectedBarnId,
    this.availableCategories,
    this.categoriesFromSelectAnimal,
    this.selectedCategoryKey,
    this.categoryKeyFromSelectAnimal,
  });
  final List<String> list;
  final List<BarnModel>? barnList;
  final List<AnimalCategory>? availableCategories;
  final List<AnimalCategoryModel>? categoriesFromSelectAnimal;
  final ValueChanged<BarnModel>? onBarnChange;
  final ValueChanged<String?>? onCategoryChange;
  final String? initValue;
  final int? selectedBarnId;
  final String? selectedCategoryKey;
  final String? categoryKeyFromSelectAnimal;

  @override
  _HorizontalOptionSelectorState createState() =>
      _HorizontalOptionSelectorState();
}

class _HorizontalOptionSelectorState extends State<HorizontalOptionSelector> {
  String selectedIndex = 'All';
  int? selecteId;
  String? selectedAnimalCategoryKey;
  String? categoryKeyFromSelectAnimal;

  void onChange(String value) {
    setState(() {
      selectedIndex = value;
    });
    if (widget.onCategoryChange != null) {
      widget.onCategoryChange!(selectedIndex);
    }
  }

  @override
  void initState() {
    if (widget.initValue != null) {
      selectedIndex = widget.initValue!;
    }

    if ((widget.barnList ?? []).isNotEmpty) {
      selecteId = widget.barnList?[0].id;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(0, 0),
              blurRadius: 10,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return _buildContent(constraints.maxWidth);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(double availableWidth) {
    final items = _buildItems();

    // Calculate total width needed for all items
    double totalWidth = 0;
    for (int i = 0; i < items.length; i++) {
      // Estimate width for each item (padding + text width estimate)
      final text = widget.barnList != null
          ? (widget.barnList?[i].name ?? '')
          : widget.availableCategories != null
              ? (widget.availableCategories?[i].name ?? '')
              : widget.categoriesFromSelectAnimal != null
                  ? (widget.categoriesFromSelectAnimal?[i].content ?? '')
                  : widget.list[i];
      totalWidth += _estimateTextWidth(text) + 28; // 28 for horizontal padding
    }

    // Check if content fits within available width
    if (totalWidth <= availableWidth) {
      // Content fits, use spaceBetween
      return Row(
        mainAxisAlignment: items.length < 5
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.spaceBetween,
        children: items,
      );
    } else {
      // Content overflows, use scrollable view
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: items,
        ),
      );
    }
  }

  double _estimateTextWidth(String text) {
    // Rough estimation based on average character width for your font size
    return text.length * 8.0;
  }

  List<Widget> _buildItems() {
    final itemCount = widget.barnList?.length ??
        widget.availableCategories?.length ??
        widget.categoriesFromSelectAnimal?.length ??
        widget.list.length;

    return List.generate(
      itemCount,
      (index) {
        final isSelected = _isSelected(index);

        return GestureDetector(
          onTap: () {
            if (widget.barnList != null) {
              setState(() {
                selecteId = widget.barnList?[index].id;
                if (widget.onBarnChange != null) {
                  widget.onBarnChange!(widget.barnList![index]);
                }
              });
            } else if (widget.availableCategories != null) {
              setState(() {
                selectedAnimalCategoryKey =
                    widget.availableCategories?[index].key;
              });
              if (widget.onCategoryChange != null) {
                widget.onCategoryChange!(selectedAnimalCategoryKey!);
              }
            } else if (widget.categoriesFromSelectAnimal != null) {
              setState(() {
                categoryKeyFromSelectAnimal =
                    widget.categoriesFromSelectAnimal?[index].key;
              });
              if (widget.onCategoryChange != null) {
                widget.onCategoryChange!(categoryKeyFromSelectAnimal);
              }
            } else {
              onChange(widget.list[index]);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.farmColor : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              style: TextStyle(
                // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
                fontFamily:
                    isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
                color: isSelected ? Colors.white : Colors.grey.shade400,
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
              child: CustomText(
                fontSize: 11,
                text: widget.barnList != null
                    ? '${widget.barnList?[index].barnNumber ?? ''} ${widget.barnList?[index].barnNumber != null && widget.barnList?[index].name.isNotEmpty == true ? '-' : ''} ${widget.barnList?[index].name ?? ''}'
                    : widget.availableCategories != null
                        ? (widget.availableCategories?[index].name ?? '')
                        : widget.categoriesFromSelectAnimal != null
                            ? (widget.categoriesFromSelectAnimal?[index]
                                    .content ??
                                '')
                            : widget.list[index].tr(),
                fontFamily:
                    isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isSelected(int index) {
    if (widget.barnList != null) {
      return widget.selectedBarnId != null
          ? widget.barnList![index].id == widget.selectedBarnId
          : widget.barnList![index].id == selecteId;
    }

    if (widget.availableCategories != null) {
      return widget.selectedCategoryKey != null
          ? widget.availableCategories![index].key == widget.selectedCategoryKey
          : widget.availableCategories![index].key == selectedAnimalCategoryKey;
    }

    if (widget.categoriesFromSelectAnimal != null) {
      final item = widget.categoriesFromSelectAnimal![index];

      // Special case: handle "All"
      if (item.all == true) {
        return widget.categoryKeyFromSelectAnimal == null ||
            widget.categoryKeyFromSelectAnimal == "All";
      }

      return widget.categoryKeyFromSelectAnimal != null
          ? item.key == widget.categoryKeyFromSelectAnimal
          : false;
    }

    return false;
  }
}
