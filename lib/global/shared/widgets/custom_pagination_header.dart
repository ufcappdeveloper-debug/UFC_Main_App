import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';

class CustomPaginationHeader extends StatelessWidget {
  const CustomPaginationHeader({
    super.key,
    this.indicatorColor = primaryColor,
    this.bgColor = const Color(0xFFF2F2F4),
  });

  final Color bgColor;
  final Color indicatorColor;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child:
          MaterialClassicHeader(color: primaryColor, backgroundColor: bgColor),
    );
  }
}
