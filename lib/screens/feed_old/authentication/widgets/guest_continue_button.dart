import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/exception/error_handler.dart';

import '../../../../riverpod/app_bar/app_bar_riverpod.dart';

class GuestContinueButton extends ConsumerWidget {
  const GuestContinueButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () async {
        try {
          ref.read(selectedAppbarItem.notifier).state = 0;
          final future = ref.read(authProvider.notifier).guestLogin();
          await LoadingDialog.show(context, future);
          if (!context.mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomBar(),
            ),
            (route) => false,
          );
        } catch (e) {
          ErrorHandler.handleError(context, e);
        }
      },
      child: CustomText(
        text: 'Continue as Guest'.tr(),
        decorationColor: Colors.white.withValues(alpha: 0.8),
        decoration: TextDecoration.underline,
        color: Colors.white.withValues(alpha: 0.8),
      ),
    );
  }
}
