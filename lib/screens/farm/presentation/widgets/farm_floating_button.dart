import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/pages/signin_page.dart';
import 'package:ufc_mobile/screens/feed_old/categories/widgets/signin_alert_sheet_for_guest_users.dart';

import '../../../../global/extensions/app_colors.dart';
import '../../../../global/shared/constants/constants.dart';
import '../../../../riverpod/app_bar/app_bar_riverpod.dart';
import '../../../../riverpod/auth/auth.dart';

import '../addreport.dart';

class FarmFloatingButton extends ConsumerWidget {
  const FarmFloatingButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(authProvider).asData?.value;
    final selectedIndex = ref.watch(farmBodySelectedIndexProvider);
    return (selectedIndex == 0 || selectedIndex == 1)
        ? Padding(
            padding: EdgeInsets.only(
              right: 16,
              bottom: (kNavBarHeight + 30),
            ),
            child: FloatingActionButton(
              onPressed: () {
                if (user == null) {
                  showUnauthorizedBottomSheet(
                    context,
                    onSignInPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const SignInPage()),
                              (route) => false);
                    },
                  );
                } else {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => AddReportPage(),
                      fullscreenDialog: true,
                    ),
                  );
                }
              },
              backgroundColor: AppColors.farmColor,
              shape: CircleBorder(),
              child: Icon(Icons.add, size: 30),
            ),
          )
        : SizedBox();
  }
}
