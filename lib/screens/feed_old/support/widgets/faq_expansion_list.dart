import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class FAQExpansionList extends StatelessWidget {
  const FAQExpansionList({
    super.key,
    this.description,
    required this.heading,
    this.descriptionChildren,
  }) : assert((description != null && descriptionChildren == null) ||
            (description == null && descriptionChildren != null));
  final String heading;
  final String? description;
  final List<Widget>? descriptionChildren;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: heading),
          const Divider(
            color: Color(0xffE5E5E5),
            thickness: 1,
            height: 10,
          ),
        ],
      ),
      textColor: Colors.black,
      iconColor: Colors.black,
      collapsedTextColor: Colors.black,
      collapsedIconColor: Colors.black,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      children: descriptionChildren == null
          ? [
              CustomText(fontWeight: FontWeight.w300, text: description ?? ""),
            ]
          : descriptionChildren ?? [],
    );
  }
}
