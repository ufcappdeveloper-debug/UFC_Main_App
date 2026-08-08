import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

class ScrollUpFloatingBtn extends StatelessWidget {
  const ScrollUpFloatingBtn({
    super.key,
    this.margin,
    required this.onPressed,
    this.heroTag = 'scroll-up-fab',
  });

  final VoidCallback onPressed;
  final EdgeInsetsGeometry? margin;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(
        right: 16,
        bottom: (kNavBarHeight + bottomPadding + 16),
      ),
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          heroTag: heroTag,
          onPressed: onPressed,
          shape: const CircleBorder(),
          backgroundColor: primaryColor,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: RotatedBox(
              quarterTurns: 3,
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
