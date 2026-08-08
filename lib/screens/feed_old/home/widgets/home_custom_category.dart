import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeCustomCategory extends StatelessWidget {
  const HomeCustomCategory({
    super.key,
    this.onTap,
    this.onLoading,
    required this.child,
    required this.controller,
  });
  final Widget child;
  final Function()? onTap;
  final Function()? onLoading;
  final RefreshController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 130,
        child: SmartRefresher(
          enablePullUp: true,
          enablePullDown: false,
          onLoading: onLoading,
          controller: controller,
          scrollDirection: Axis.horizontal,
          footer: CustomFooter(
            height: 0,
            builder: (context, mode) => const SizedBox.shrink(),
          ),
          physics: const BouncingScrollPhysics(),
          child: child,
        ));
  }
}
