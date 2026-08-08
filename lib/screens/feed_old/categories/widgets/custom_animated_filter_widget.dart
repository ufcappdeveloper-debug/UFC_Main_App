import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/categories/categories_page.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class CustomAnimatedFilter extends StatefulWidget {
  const CustomAnimatedFilter(
      {super.key,
      this.icon,
      required this.index,
      required this.title,
      this.selectedFilter,
      this.selectedFilterList,
      this.hasDivider = false,
      required this.filterItems})
      : assert((selectedFilter != null || selectedFilterList == null) ||
            (selectedFilter == null || selectedFilterList != null));
  final int index;
  final Widget? icon;
  final String title;
  final bool hasDivider;
  final String? selectedFilter;
  final List<dynamic> filterItems;
  final List<int>? selectedFilterList;

  @override
  State<CustomAnimatedFilter> createState() => _CustomAnimatedFilterState();
}

class _CustomAnimatedFilterState extends State<CustomAnimatedFilter>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String? selectedFilter;
  List<int> selectedFilterList = [];
  bool showList = false;

  @override
  void initState() {
    super.initState();

    selectedFilter = widget.selectedFilter;
    selectedFilterList = widget.selectedFilterList ?? [];
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    );

    if (selectedFilter != null || selectedFilterList.isNotEmpty) {
      _controller.forward();
      showList = true;
    }
  }

  void _toggleContainer(
      {required Animation<double> animation,
      required AnimationController controller}) {
    // print(animation.status);
    if (animation.status != AnimationStatus.completed) {
      controller.forward();
      showList = true;
    } else {
      controller.animateBack(0, duration: const Duration(milliseconds: 300));
      showList = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.icon ??
                Image.asset('assets/images/global/sack.png', height: 16),
            const SizedBox(width: 5),
            InkWell(
              onTap: () => _toggleContainer(
                  animation: _animation, controller: _controller),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: widget.title,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                  Icon(
                    showList ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  ),
                ],
              ),
            ),
            const Spacer(),
            const SizedBox(),
            // CustomButton(
            //   title: 'Select All',
            //   onTap: () {
            //     widget.selectedFilters.addAll(widget.filterItems);
            //     widget.selectedFilters.toSet().toList();
            //     setState(() {});
            //   },
            //   height: 15,
            //   width: 95,
            //   color: const Color.fromRGBO(241, 241, 241, 1),
            //   textColor: Colors.black,
            //   fontSize: 10,
            //   fontWeight: FontWeight.w300,
            //   radius: 0,
            //   boxShadow: const [],
            // ),
          ],
        ),
        SizeTransition(
          sizeFactor: _animation,
          axis: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(height: 5),
              ...List.generate(widget.filterItems.length, (index) {
                switch (widget.index) {
                  case 5:
                    return checkboxItem(
                      selected: false,
                      subIndex: index,
                      title: widget.filterItems[index].name,
                    );
                  default:
                    return checkboxItem(
                      selected: false,
                      subIndex: index,
                      title: widget.filterItems[index],
                    );
                }
              }),
            ],
          ),
        ),
        if (widget.hasDivider)
          Column(
            children: [
              const SizedBox(height: 5),
              Divider(
                color: Colors.grey.withValues(alpha: 0.2),
                thickness: 1,
              ),
              const SizedBox(height: 5),
            ],
          ),
      ],
    );
  }

  Widget checkboxItem({
    bool selected = false,
    required String title,
    required int subIndex,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            switch (widget.index) {
              case 5:
                if (selectedFilterList.contains(subIndex)) {
                  selectedFilterList
                      .removeWhere((element) => element == subIndex);
                } else {
                  selectedFilterList.add(subIndex);
                }
              default:
                if (selectedFilter == title) {
                  selectedFilter = null;
                } else {
                  selectedFilter = title;
                }
            }

            selectData(
                widget.index, subIndex, selectedFilter, selectedFilterList);
            setState(() {});
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Row(
            children: [
              Container(
                height: 8,
                width: 10,
                decoration: BoxDecoration(
                  color: selectedFilterList.contains(subIndex) ||
                          selectedFilter == title
                      ? primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: Colors.black, width: 0.8),
                ),
              ),
              const SizedBox(width: 8),
              CustomText(
                text: title,
                fontWeight: FontWeight.w300,
              )
            ],
          ),
        ),
      ),
    );
  }
}

void selectData(
    int index, int subIndex, String? title, List<dynamic>? selectedFilterList) {
  switch (index) {
    case 0:
      selectedProductType = title?.toLowerCase();
    case 1:
      if (title == null) {
        selectedSize = null;
      } else if (title == "Ton") {
        selectedSize = 1000;
      } else {
        final int temp = int.parse(title.split(' ').first.toString());
        selectedSize = temp;
      }
    case 2:
      if (title == null) {
        selectedMinPrice = null;
        selectedMaxPrice = null;
      } else {
        if (title == 'Under 100 SAR') {
          selectedMinPrice = 0;
          selectedMaxPrice = 100;
        } else {
          selectedMinPrice = int.parse(title.split(' ').first.toString());
          selectedMaxPrice = int.parse(title.split(' ')[3].toString());
        }
      }
    case 3:
      if (title == null) {
        selectedNewArrivals = null;
      } else {
        selectedNewArrivals = convertNewArrivals(title);
      }

    case 4:
      if (title == null) {
        selectedSpecialOffer = null;
      } else {
        selectedSpecialOffer = 1;
      }
    case 5:
      selectedAnimalTypes =
          selectedFilterList == null ? [] : selectedFilterList.cast<int>();
  }
}

dynamic convertNewArrivals(final data) {
  switch (data) {
    case 7:
      return 'This week';
    case 14:
      return 'Last week';
    case 30:
      return 'This month';
    case 'This week':
      return 7;
    case 'Last week':
      return 14;
    case 'This month':
      return 30;
  }
}
