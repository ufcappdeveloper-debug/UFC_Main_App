import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';

class SadadEditCustomIdDropDown extends StatelessWidget {
  const SadadEditCustomIdDropDown({
    super.key,
    this.onChanged,
    required this.isIdFocused,
    required this.sadadIdType,
    required this.sadadIdTypeList,
  });
  final bool isIdFocused;
  final String sadadIdType;
  final List<String> sadadIdTypeList;
  final Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton2(
            underline: const SizedBox.shrink(),
            customButton: Text(
              sadadIdType.substring(0, 3),
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Kanit',
                color: isIdFocused ? primaryColor : Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
            onChanged: onChanged,
            dropdownStyleData: DropdownStyleData(
              width: 161,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            items: sadadIdTypeList
                .map((value) => DropdownMenuItem(
                      value: value,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            value,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Kanit',
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
