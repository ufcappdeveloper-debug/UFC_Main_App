import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

import '../../domain/entities/dashboard/analytics_filter_model.dart';

class FilterSelector extends StatefulWidget {
  const FilterSelector({
    super.key,
    required this.filters,
    required this.onFilterSelected,
    required this.initFilter,
  });

  final List<AnalyticsFilterModel> filters;
  final AnalyticsFilterModel? initFilter;
  final ValueChanged<AnalyticsFilterModel> onFilterSelected;

  @override
  State<FilterSelector> createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  String? selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initFilter?.key;
  }

  @override
  void didUpdateWidget(covariant FilterSelector oldWidget) {
    if (widget.initFilter != oldWidget.initFilter) {
      setState(() {
        selectedIndex = widget.initFilter?.key;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
      child: Container(
        height: 47,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
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

    // Estimate total width of all items
    double totalWidth = 0;
    for (final filter in widget.filters) {
      totalWidth += _estimateTextWidth(filter.contentText ?? '') + 28;
    }

    if (totalWidth <= availableWidth) {
      // Fits in a row
      return Row(
        mainAxisAlignment: widget.filters.length < 5
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.spaceBetween,
        children: items,
      );
    } else {
      // Scrollable
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: items),
      );
    }
  }

  double _estimateTextWidth(String text) {
    return text.length * 8.0;
  }

  List<Widget> _buildItems() {
    return List.generate(widget.filters.length, (index) {
      final filter = widget.filters[index];
      final isSelected = filter.key == selectedIndex;

      return GestureDetector(
        onTap: () {
          setState(() => selectedIndex = filter.key);
          widget.onFilterSelected(filter);
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
              fontSize: 1,
            ),
            child: CustomText(
              fontSize: 11,
              text: filter.contentText ?? '',
              // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
              fontFamily:
                  isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
            ),
          ),
        ),
      );
    });
  }
}
