import 'package:flutter/material.dart';

import 'custom_widgets/custom_text.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? isCenter;

  Widget? leading;
  CustomAppbar({super.key, required this.title, this.leading,this.isCenter=false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: leading,
      centerTitle:isCenter,
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      elevation: 0.3,
      title: CustomText(
        text: title,
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
