import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class SadadInfoReloadProvider extends StatelessWidget {
  const SadadInfoReloadProvider({
    super.key,
    required this.onPressed,
  });
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomText(
                text: "Something went wrong",
                fontSize: 12,
                color: primaryColor.withValues(alpha: 0.5)),
            Icon(Icons.replay_outlined,
                size: 20, color: primaryColor.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}
