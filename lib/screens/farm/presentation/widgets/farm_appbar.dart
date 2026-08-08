import 'package:flutter/material.dart';

import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';

class CustomFarmAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function()? onPressed;
  final Widget? actionButton;
  final Function()? onPop;

  const CustomFarmAppBar({
    super.key,
    required this.title,
    this.onPressed,
    this.actionButton,
    this.onPop,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: Directionality(
            textDirection: TextDirection.ltr,
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  if (onPop != null) {
                    onPop!();
                  } else {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                  color: Colors.black,
                ),
              ),
              title: CustomText(
                text: title,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Colors.black,
              ),
              actions: [if (actionButton != null) actionButton!],
            )));
  }

  @override
  Size get preferredSize => Size(double.infinity, 55);
}
