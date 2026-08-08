import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/shared/functions/text_field.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/edit_email_phone.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/sadad/sadad_user_async_riverpod.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/checkout/sadad/sadad_user_info.dart';
import 'package:ufc_mobile/screens/feed_old/cart/widgets/add_phone_number_dialog.dart';
import 'package:ufc_mobile/screens/feed_old/cart/widgets/sadad_edit_dialog_content.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/enum/payment_option.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_add_user_name_widget.dart';

InputDecoration checkoutVehicleTextFieldDecoration(
        {String? icon, String? hintText, EdgeInsetsGeometry? contentPadding}) =>
    customTextFieldDecoration(
        radius: 6,
        hintText: hintText?.tr(),
        contentPadding: contentPadding,
        borderColor: const Color(0xFFEAEAEA),
        hintStyle: const TextStyle(
            fontSize: 12,
            fontFamily: 'Kanit',
            color: Colors.black,
            fontWeight: FontWeight.w300),
        prefixIcon: icon == null || icon.isEmpty
            ? null
            : Padding(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(icon),
              ));

bool isSadadInfoExist(SadadUserInfo? data,
    {PaymentOptionsEnum? selectedPaymentOption}) {
  if (selectedPaymentOption != null &&
      selectedPaymentOption != PaymentOptionsEnum.sadad) {
    return true;
  }
  if (data == null ||
      data.customerIdType == null ||
      data.customerFullName == null ||
      data.customerIdNumber == null ||
      data.customerMobileNumber == null) {
    return false;
  }
  return true;
}

String? sadadIdNumberFormate(SadadUserInfo? data) {
  if (data == null ||
      data.customerIdType == null ||
      data.customerIdType!.isEmpty ||
      data.customerIdNumber == null ||
      data.customerIdNumber!.isEmpty) {
    return null;
  }
  return "${data.customerIdType} ${data.customerIdNumber}";
}

String? sadadPhoneFormat(SadadUserInfo? data, {bool withoutCode = false}) {
  if (data == null ||
      data.customerMobileNumber == null ||
      data.customerMobileNumber!.isEmpty) {
    return null;
  }

  final phone = data.customerMobileNumber;
  if (withoutCode) {
    return phone?.replaceAllMapped(RegExp(r'^(\d{2})(\d{3})(\d{4})$'),
        (match) => '${match[1]} ${match[2]} ${match[3]}');
  } else {
    final temp = "966$phone";
    return temp.replaceAllMapped(RegExp(r'^(\966)(\d{2})(\d{3})(\d{4})$'),
        (match) => '${match[1]} ${match[2]} ${match[3]} ${match[4]}');
  }
}

bool isInteger(String value) {
  try {
    int.parse(value);
    return true;
  } catch (e) {
    return false;
  }
}

// Bottom Sheet for Adding User Name
Widget addUserNameBtmSheet() {
  return LayoutBuilder(
      builder: (context, constraints) => DraggableScrollableSheet(
          expand: false,
          maxChildSize: constraints.maxWidth < 400 ? 0.8 : 0.7,
          minChildSize: constraints.maxWidth < 400 ? 0.6 : 0.5,
          initialChildSize: constraints.maxWidth < 400 ? 0.7 : 0.6,
          builder: (context, scrollController) =>
              CheckoutAddUserNameWidget(scrollController: scrollController)));
}

// Add or Update User Phone Number Dialog
Future<dynamic> addOrUpdateUserPhoneDialog(
  WidgetRef ref,
  BuildContext context,
  AsyncValue<UserModel?> user,
) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AddPhoneNumberDialog(
      onSave: (countryCode, phone) async {
        try {
          Navigator.pop(context);

          // Verify User Phone Number Update
          await EditEmailPhone.verifyPhone(context, ref,
              newPhoneValue: phone.replaceAll(" ", ""));

          // Adding Phone Number: Edit User Phone Number
          await ref
              .read(authProvider.notifier)
              .updatePhoneNumber(phone.replaceAll(" ", ""));

          if (context.mounted) {
            Navigator.pop(context);
            CustomSnackBar.success(
                context, "User profile updated successfully");
          }
        } catch (e) {
          if (!context.mounted) return;
          CustomSnackBar.error(context, e.toString());
        }
      },
    ),
  );
}

// To Add or Edit SADAD User Information
Future<void> addOrEditSadadUserInfo(
  WidgetRef ref,
  BuildContext context,
  BoxConstraints constraints,
  SadadUserInfo? sadadUserData,
) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: constraints.maxWidth > 500 ? 111 : 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SadadEditDialogContent(
          sadadUserInfo: sadadUserData,
          onClick: (name, phone, idType, idNumber) async {
            Map<String, dynamic> data = {
              "customer_full_name": name,
              "customer_mobile_number": phone.replaceAll(" ", ""),
              "customer_id_type": idType,
              "customer_id_number": idNumber,
            };

            try {
              final future = ref
                  .read(sadadUserAsyncProvider.notifier)
                  .updateSadadUserInfo(data);
              await LoadingDialog.show(context, future);

              if (context.mounted) {
                CustomSnackBar.success(
                    context,
                    sadadUserData == null
                        ? "SADAD user information added successfully"
                        : "SADAD user information updated successfully");
              }
            } catch (e) {
              if (!context.mounted) {
                return;
              }
              CustomSnackBar.error(context, e.toString());
            }
          }),
    ),
  );
}
