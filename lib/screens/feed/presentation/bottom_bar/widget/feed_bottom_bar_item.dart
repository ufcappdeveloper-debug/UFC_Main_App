import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

/// USED AS A PLACEHOLDER FOR THE BOTTOM BAR ITEM COMPONENT
/// This widget contains the title and icon for each item in the bottom navigation bar.
/// It can be customized further to include more functionality or styling as needed.
class FeedBottomBarItem extends BottomNavigationBarItem {
  FeedBottomBarItem({
    required String? title,
    required String? iconPath,
    required bool isSelected,
    bool isFirst = false,
    bool isLast = false,
    int badgeCount = 0,
  }) : super(
          icon: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                  padding: isEnglish
                      ? EdgeInsets.only(
                          top: 10,
                          left: isFirst ? 16.0 : 0,
                          right: isLast ? 16.0 : 0,
                        )
                      : EdgeInsets.only(
                          top: 10,
                          right: isFirst ? 16.0 : 0,
                          left: isLast ? 16.0 : 0,
                        ),
                  child: Container(
                    padding:
                        isSelected ? EdgeInsets.fromLTRB(14, 10, 14, 10) : null,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? PetVeterinaryColors.mainColorUFC
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        (iconPath ?? '').isNotEmpty
                            ? Badge(
                                isLabelVisible: badgeCount > 0,
                                backgroundColor: const Color(0xFFF7D66D),
                                textColor: Colors.black,
                                label: Text(
                                    badgeCount > 99 ? '99+' : '$badgeCount'),
                                child: Image.asset(
                                  iconPath!,
                                  height: 24,
                                  width: 24,
                                ),
                              )
                            : SizedBox.shrink(),
                        if (isSelected) ...[
                          SizedBox(
                            width: 8,
                          ),
                          CustomText(
                            text: title ?? '',
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ]
                      ],
                    ),
                  ))),
          label: '',
        );
}
