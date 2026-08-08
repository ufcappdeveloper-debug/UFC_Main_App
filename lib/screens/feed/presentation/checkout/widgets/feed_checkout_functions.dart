import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/functions/text_field.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/util/edit_email_phone_V2.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/checkout/sadad/sadad_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/checkout/sadad/sadad_state.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/checkout/sadad/sadad_user_info.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/widgets/feed_checkout_add_user_name_widget.dart';
import 'package:ufc_mobile/screens/feed_old/cart/widgets/add_phone_number_dialog.dart';
import 'package:ufc_mobile/screens/feed_old/cart/widgets/sadad_edit_dialog_content.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/enum/payment_option.dart';

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
          builder: (context, scrollController) => FeedCheckoutAddUserNameWidget(
              scrollController: scrollController)));
}

// Add or Update User Phone Number Dialog
Future<dynamic> addOrUpdateUserPhoneDialog(
  BuildContext context,
  UserModel? user,
) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AddPhoneNumberDialog(
      onSave: (countryCode, phone) async {
        await EditEmailPhoneV2.verifyPhone(context,
              newPhoneValue: phone.replaceAll(" ", ""));
      },
    ),
  );
}

Future<void> addOrEditSadadUserInfo(
  BuildContext context,
  BoxConstraints constraints,
  SadadUserInfo? sadadUserData,
) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: constraints.maxWidth > 500 ? 111 : 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: BlocConsumer<SadadUserInfoCubit, SadadUserInfoState>(
        listener: (context, state) {
          if (state is SadadLoaded) {
            if (!context.mounted) return;
            Navigator.pop(context);
            CustomSnackBar.success(
              context,
              sadadUserData == null
                  ? "SADAD info added successfully"
                  : "SADAD info updated successfully",
            );
          } else if (state is SadadError) {
            if (!context.mounted) return;
            String errorText = "Unknown error";

            if (state.message is DioException) {
              final dioError = state.message as DioException;
              final responseData = dioError.response?.data;
              if (responseData is Map<String, dynamic>) {
                errorText = extractErrorMessage(responseData);
              } else {
                errorText = dioError.message ?? "Unknown error";
              }
            } else if (state.message is Map<String, dynamic>) {
              errorText =
                  extractErrorMessage(state.message as Map<String, dynamic>);
            } else if (state.message is String) {
              errorText = state.message.toString();
            }

            Fluttertoast.showToast(
              msg: errorText,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 14.0,
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SadadEditDialogContent(
                sadadUserInfo: sadadUserData,
                onClick: (name, phone, idType, idNumber) {
                  final data = {
                    "customer_full_name": name,
                    "customer_mobile_number":
                        phone.replaceAll(" ", "").replaceAll("+", ""),
                    "customer_id_type": idType,
                    "customer_id_number": idNumber,
                  };
                  context.read<SadadUserInfoCubit>().updateUserInfo(data);
                },
              ),
              if (state is SadadLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.white.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );
}

String extractErrorMessage(dynamic response) {
  if (response is Map<String, dynamic>) {
    if (response['errors'] is Map<String, dynamic>) {
      final errors = response['errors'] as Map<String, dynamic>;
      if (errors.isNotEmpty) {
        final firstKey = errors.keys.first;
        final firstErrorList = errors[firstKey];
        if (firstErrorList is List && firstErrorList.isNotEmpty) {
          return firstErrorList.first.toString();
        }
      }
    }
    return response['message']?.toString() ?? 'Unknown error';
  }

  if (response is String) {
    return response;
  }

  return 'Unknown error';
}
