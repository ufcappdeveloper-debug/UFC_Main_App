import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../global/shared/constants/widgets.dart';

class RefreshFooter extends StatelessWidget {
  const RefreshFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (context, mode) {
        Widget body;
        if (mode == LoadStatus.noMore) {
          body = pullRefreshBody(
            text: "No More Data",
            icon: Icons.error_outline_rounded,
          );
        } else if (mode == LoadStatus.idle) {
          body = pullRefreshBody(
            text: "Load More",
            icon: Icons.arrow_downward_rounded,
          );
        } else if (mode == LoadStatus.loading ||
            mode == LoadStatus.canLoading) {
          body = pullRefreshBody(
            text: "Loading",
            iconWidget: const CupertinoActivityIndicator(),
          );
        } else if (mode == LoadStatus.failed) {
          body = pullRefreshBody(
            text: "Error",
            icon: Icons.error_outline_rounded,
          );
        } else {
          body = pullRefreshBody(
            text: "No More Data",
            icon: Icons.error_outline_rounded,
          );
        }
        return SizedBox(
          height: 55.0,
          child: Center(child: body),
        );
      },
    );
  }
}
