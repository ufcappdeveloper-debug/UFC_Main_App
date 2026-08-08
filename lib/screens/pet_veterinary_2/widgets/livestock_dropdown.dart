import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/barn/animal_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_shadows.dart';

class LivestockDropdown extends StatefulWidget {
  final List<AnimalModel> livestockList;
  final ValueChanged<AnimalModel?>? onLivestockSelected;
  final ScrollController? scrollController;

  const LivestockDropdown({
    super.key,
    required this.livestockList,
    this.onLivestockSelected,
    this.scrollController,
  });

  @override
  State<LivestockDropdown> createState() => _LivestockDropdownState();
}

class _LivestockDropdownState extends State<LivestockDropdown> {
  bool _isExpanded = true;
  int? _selectedIndex;
  final TextEditingController _controller = TextEditingController();
  final GlobalKey _dropdownKey = GlobalKey();
  List<AnimalModel> _filteredList = [];

  void _filterLivestock(String query) {
    final lowerQuery = query.toLowerCase().trim();
    setState(() {
      if (lowerQuery.isEmpty) {
        _filteredList = widget.livestockList;
      } else {
        _filteredList = widget.livestockList.where((animal) {
          final ref = animal.animalRef?.toLowerCase() ?? '';
          return ref.contains(lowerQuery);
        }).toList();
      }
    });
  }

  late final VoidCallback _textListener;

  @override
  void initState() {
    super.initState();
    _filteredList = widget.livestockList
        .where((animal) => animal.animalUniqueKey != null)
        .toList();

    _textListener = () => _filterLivestock(_controller.text);
    _controller.addListener(_textListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_textListener);

    _controller.dispose();
    super.dispose();
  }

  void _scrollToCenter() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollController == null) return;

      final renderBox =
          _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final dropdownPosition = renderBox.localToGlobal(Offset.zero);
        final screenHeight = MediaQuery.of(context).size.height;

        final scrollOffset = widget.scrollController!.offset +
            dropdownPosition.dy -
            screenHeight * 0.25;

        widget.scrollController!.animateTo(
          scrollOffset.clamp(
            widget.scrollController!.position.minScrollExtent,
            widget.scrollController!.position.maxScrollExtent,
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final livestockList = _filteredList;

    return Container(
      key: _dropdownKey,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: PetVeterinaryShadows.standard,
      ),
      child: Column(
        children: [
          // 🔹 Top Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Padding(
                  padding: isEnglish
                      ? const EdgeInsets.only(right: 10.0)
                      : const EdgeInsets.only(left: 10.0),
                  child: Image.asset(
                    'assets/new_design/icons/search_icon.png',
                    width: 16,
                    height: 16,
                    color: PetVeterinaryColors.newPetLightGray,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                    onTap: () {
                      setState(() => _isExpanded = true);
                      _scrollToCenter();
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Look for livestock'.tr(),
                      hintStyle: PetVeterinaryFontstyles2.getRegularStyle(
                        context,
                        11,
                        color: PetVeterinaryColors.newPetLightGray,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() => _isExpanded = !_isExpanded);
                    if (!_isExpanded) return;
                    _scrollToCenter();
                  },
                  child: Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Expandable List Section
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Builder(
              builder: (context) {
                double minHeight = 50;
                double itemHeight = 65;
                double maxHeight = 400;
                double listHeight = (livestockList.length * itemHeight) + 6;
                bool needsScroll = listHeight > maxHeight;
                double dynamicHeight =
                    listHeight > maxHeight ? maxHeight : listHeight;
                dynamicHeight =
                    dynamicHeight < minHeight ? minHeight : dynamicHeight;

                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: dynamicHeight),
                  child: _filteredList.isEmpty
                      ? ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: Text(
                                  'No livestock'.tr(),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          physics: needsScroll
                              ? const AlwaysScrollableScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: livestockList.length,
                          itemBuilder: (context, index) {
                            final animal = livestockList[index];
                            final isSelected = _selectedIndex == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  // ✅ Toggle selection
                                  if (_selectedIndex == index) {
                                    _selectedIndex = null;

                                    widget.onLivestockSelected?.call(null);
                                  } else {
                                    _selectedIndex = index;
                                    widget.onLivestockSelected?.call(animal);
                                  }
                                });

                                widget.onLivestockSelected?.call(animal);
                              },
                              child: Container(
                                height: 45,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? PetVeterinaryColors
                                          .newPetMainColorVeterinary
                                          .withOpacity(0.1)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? PetVeterinaryColors
                                            .newPetMainColorVeterinary
                                        : Colors.transparent,
                                    width: 1,
                                  ),
                                  boxShadow: isSelected
                                      ? []
                                      : PetVeterinaryShadows.standardLight,
                                ),
                                child: Row(
                                  children: [
                                    // Checkbox Style Circle
                                    Container(
                                      width: 26,
                                      height: 26,
                                      margin: isEnglish
                                          ? const EdgeInsets.only(right: 18)
                                          : const EdgeInsets.only(left: 18),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: isSelected
                                              ? PetVeterinaryColors
                                                  .newPetMainColorVeterinary
                                              : Colors.grey,
                                          width: 1,
                                        ),
                                        color: isSelected
                                            ? PetVeterinaryColors
                                                .newPetMainColorVeterinary
                                            : Colors.transparent,
                                      ),
                                      child: isSelected
                                          ? const Center(
                                              child: Icon(
                                                Icons.check,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                            )
                                          : null,
                                    ),

                                    if (animal.animalIcon != null &&
                                        animal.animalIcon!.isNotEmpty)
                                      Image.network(
                                        animal.animalIcon!,
                                        width: 18,
                                        height: 18,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(
                                                Icons.image_not_supported,
                                                size: 14),
                                      )
                                    else
                                      Icon(Icons.image_not_supported, size: 18),
                                    const SizedBox(width: 14),

                                    Text(
                                      '#${animal.animalRef ?? ''}',
                                      style: PetVeterinaryFontstyles2
                                          .getLightStyle(
                                        context,
                                        15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
