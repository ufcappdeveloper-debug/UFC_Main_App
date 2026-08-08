import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/screens/feed_old/profile/widgets/edit_profile_page/edit_profile_widgets.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';

class EditEmailPhone {
  static bool isValueChanged(String oldValue, String newValue) {
    if (oldValue == newValue) return false;
    return true;
  }

  static Future<bool> verifyEmail(
    BuildContext context,
    WidgetRef ref, {
    required String newEmailValue,
  }) async {
    Map<String, String> data = {
      "email": newEmailValue,
    };

    // Edit Email: Request OTP
    final requestFuture = ref.read(authProvider.notifier).editEmailPhone(data);
    if (!context.mounted) return false;
    await LoadingDialog.show(context, requestFuture);

    // Edit Email: Enter OTP
    if (!context.mounted) return false;
    final tempSmsCode =
        await showSMSCodeDialog(context, newEmailValue, isEmail: true);
    if (tempSmsCode == null || tempSmsCode.isEmpty) return false;
    final otpData = {"otp": tempSmsCode};
    data.addEntries(otpData.entries);

    // Edit Email: Verify OTP
    final verifyFuture =
        ref.read(authProvider.notifier).verifyNewEmailPhone(data);
    if (!context.mounted) return false;
    await LoadingDialog.show(context, verifyFuture);
    return true;
  }

  static Future<void> verifyPhone(
    BuildContext context,
    WidgetRef ref, {
    required String newPhoneValue,
  }) async {
    Map<String, String> data = {
      "alpha_code": 'SA',
      "country_code": '+966',
      "phone_number": newPhoneValue,
    };

    // Edit Phone Number: Request OTP
    final requestFuture = ref.read(authProvider.notifier).editEmailPhone(data);
    if (!context.mounted) return;
    await LoadingDialog.show(context, requestFuture);

    // Edit Phone Number: Enter OTP
    if (!context.mounted) return;
    final tempSmsCode = await showSMSCodeDialog(context, newPhoneValue);
    if (tempSmsCode == null || tempSmsCode.isEmpty) return;
    final otpData = {"otp": tempSmsCode};
    data.addEntries(otpData.entries);

    // Edit Phone Number: Verify OTP
    final verifyFuture =
        ref.read(authProvider.notifier).verifyNewEmailPhone(data);
    if (!context.mounted) return;
    await LoadingDialog.show(context, verifyFuture);
  }
}
