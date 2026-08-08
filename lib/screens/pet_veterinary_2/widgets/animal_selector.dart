import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/barn/barn_details_res_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_shadows.dart';

class AnimalSelector extends StatefulWidget {
  final List<AnimalCategory> availableCategories;
  final String? selectedCategoryKey;
  final ValueChanged<String?>? onCategoryChange;

  const AnimalSelector({
    super.key,
    required this.availableCategories,
    this.selectedCategoryKey,
    this.onCategoryChange,
  });

  @override
  State<AnimalSelector> createState() => _AnimalSelectorState();
}

class _AnimalSelectorState extends State<AnimalSelector> {
  int _selectedIndex = 0; // Track selection by index
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _itemKeys = {};

  @override
  void initState() {
    super.initState();

    // Initialize selected index based on key if provided
    if (widget.selectedCategoryKey != null) {
      final index = widget.availableCategories
          .indexWhere((c) => c.key == widget.selectedCategoryKey);
      if (index != -1) _selectedIndex = index;
    }

    // Assign keys for scroll tracking
    for (int i = 0; i < widget.availableCategories.length; i++) {
      _itemKeys[i] = GlobalKey();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // Call parent only (don’t auto scroll on first frame)
      widget.onCategoryChange
          ?.call(widget.availableCategories[_selectedIndex].key);
    });
  }

  void _scrollToSelected(int index) {
    final key = _itemKeys[index];
    if (key == null) return;

    final context = key.currentContext;
    if (context == null || !mounted) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      alignment: 0.5,
    );
  }

  void _onCategorySelected(int index) {
    if (_selectedIndex == index) return;

    setState(() => _selectedIndex = index);
    widget.onCategoryChange?.call(widget.availableCategories[index].key);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scrollToSelected(index);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 6.5, horizontal: 2.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: PetVeterinaryShadows.standard,
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 7.5),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(widget.availableCategories.length, (index) {
            final category = widget.availableCategories[index];
            final isSelected = _selectedIndex == index;

            return GestureDetector(
              key: _itemKeys[index],
              onTap: () => _onCategorySelected(index),
              child: Container(
                height: 34,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? PetVeterinaryColors.newPetMainColorVeterinary
                      : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    (isEnglish ? category.content : category.contentAr) ??
                        'Unknown'.tr(),
                    style: PetVeterinaryFontstyles2.getRegularStyle(context, 11)
                        .copyWith(
                      color: isSelected
                          ? Colors.white
                          : PetVeterinaryColors.newPetLightGray,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
