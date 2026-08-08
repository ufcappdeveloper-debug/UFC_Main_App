import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class CommonBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonBackAppBar(
      {super.key,
      this.title,
      this.actions,
      this.boxShadow,
      this.height = 56,
      this.titleWidget,
      this.bottom,
      this.elevation = 0,
      this.onLeadingTap})
      : assert((title != null && titleWidget == null) ||
            (title == null && titleWidget != null));
  final String? title;
  final double height;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onLeadingTap;
  final PreferredSizeWidget? bottom;
  final double elevation;

  @override
  // Size get preferredSize => Size(double.infinity, height);
  Size get preferredSize =>
      Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: boxShadow),
      child: AppBar(
        centerTitle: true,
        elevation: elevation,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: onLeadingTap ?? () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
        ),
        title: titleWidget ??
            CustomText(
              text: (title ?? "").tr(),
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
        actions: actions,
        bottom: bottom,
      ),
    );
  }
}
