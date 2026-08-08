import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'custom_widgets/custom_text.dart';

class TicketTextField extends StatelessWidget {
  const TicketTextField({
    super.key,
    required this.nameController,
    required this.nameNode,
    this.maxLines,
    this.maxLength,
    this.label,
    this.hideLabel = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType,
    this.nodeAfter,
    this.margin,
    this.enabled,
    this.onTap,
    this.validator,
  });

  final TextEditingController nameController;
  final FocusNode nameNode;
  final int? maxLines;
  final int? maxLength;
  final String? label;
  final bool hideLabel;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final FocusNode? nodeAfter;
  final EdgeInsets? margin;
  final bool? enabled;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hideLabel
            ? const SizedBox.shrink()
            : Container(
                margin: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 2),
                child: CustomText(
                  text: label ?? '',
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
        Container(
            margin:
                margin ?? const EdgeInsets.only(left: 20, right: 20, bottom: 5),
            // height: 30,
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     color: Colors.white,
            //     boxShadow: [
            //       BoxShadow(blurRadius: 2, color: Colors.grey.withValues(alpha:0.2))
            //     ]),
            child: TextFormField(
              enabled: enabled,
              controller: nameController,
              focusNode: nameNode,
              maxLines: maxLines,
              maxLength: maxLength,
              cursorColor: primaryColor,
              textInputAction: textInputAction,
              keyboardType: textInputType,
              onTap: onTap,

              //Note: this is needed to hide keyboard when tapping outside the field
              onTapOutside: (val) => FocusScope.of(context).unfocus(),

              onEditingComplete: () {
                if (nodeAfter != null) {
                  return nodeAfter!.requestFocus();
                }
                return FocusScope.of(context).requestFocus(FocusNode());
              },
              validator: validator ??
                  (value) {
                    if (value!.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                isDense: true,
                alignLabelWithHint: false,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                contentPadding: const EdgeInsets.all(10),
                hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11),
                errorStyle:
                    const TextStyle(fontFamily: 'Poppins', fontSize: 11),
                // border: InputBorder.none,
                // enabledBorder: InputBorder.none,
                // focusedBorder: InputBorder.none,
                // focusedErrorBorder: InputBorder.none,
                // disabledBorder: InputBorder.none,
                // errorBorder: InputBorder.none,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.1),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
              ),
            )),
      ],
    );
  }
}
