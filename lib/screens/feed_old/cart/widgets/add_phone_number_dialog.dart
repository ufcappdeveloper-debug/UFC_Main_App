import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/constants/custom_loading_dialog.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_text_field.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';
import 'package:ufc_mobile/screens/feed_old/profile/widgets/edit_profile_page/edit_profile_widgets.dart';

class AddPhoneNumberDialog extends StatefulWidget {
  const AddPhoneNumberDialog({
    super.key,
    required this.onSave,
  });
  final Function(String, String) onSave;

  @override
  State<AddPhoneNumberDialog> createState() => _AddPhoneNumberDialogState();
}

class _AddPhoneNumberDialogState extends State<AddPhoneNumberDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String mask = '000000000';
  CountryCode countryCode = CountryCode(code: "SA", dialCode: "+966");
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) async {
            if (state is EditEmailPhoneFailure) {
              Navigator.pop(context);
              CustomSnackBar.error(context, state.message.toString());
            } else if (state is EditEmailPhoneSuccess) {
              CustomSnackBar.success(context, state.message);
              if (!context.mounted) return;
              Navigator.pop(context);
              String newPhoneValue = _phoneController.text.replaceAll(" ", "");
              await showSMSCodeDialog(
                context,
                newPhoneValue,
                onSubmit: (v, cxt) async {
                  Map<String, String> data = {
                    "alpha_code": 'SA',
                    "country_code": '+966',
                    "phone_number": newPhoneValue,
                    "otp": v
                  };

                  final verifyFuture =
                      cxt.read<AuthCubit>().verifyNewEmailPhone(data);

                  await LoadingDialog.show(cxt, verifyFuture);
                  await cxt.read<AuthCubit>().updatePhoneNumber(newPhoneValue);
                  Navigator.pop(cxt);
                },
              );
            }
          },
          builder: (context, state) {
            return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Phone Number".tr(),
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                  kHeight5,
                  CustomText(
                    text:
                        'Please enter your phone number to continue with the process',
                    fontSize: 15,
                    fontFamily: 'Kanit',
                    color: const Color(0xff939393),
                    fontWeight: FontWeight.w400,
                  ),
                CustomTextField(
                  labelColor: primaryColor,
                  cursorColor: primaryColor,
                  inputTextColor: primaryColor,
                  labelText: 'Phone Number'.tr(),
                  controller: _phoneController,
                  textInputType: TextInputType.phone,
                  fillColor: const Color(0xFFE6E6E6),
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    PhoneInputFormatter(
                      defaultCountryCode: countryCode.code,
                      onCountrySelected: (c) => mask = c
                              ?.getCorrectMask(countryCode.dialCode)
                              .replaceAll(" ", "") ??
                          '000000000',
                    ),
                  ],
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  contentPadding: const EdgeInsetsDirectional.only(start: 57),
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required";
                    } else if (mask.length !=
                        value.replaceAll(" ", "").length) {
                      return "Invalid number";
                    } else if (value.startsWith("0")) {
                      return "Phone number must not start with 0";
                    }
                    return null;
                  },
                  prefixIcon: Container(
                    margin: const EdgeInsets.only(
                      right: 10,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                    ),
                    child: CountryCodePicker(
                      builder: (countryCode) => InkWell(
                        onTap: AppConfig.server == Build.dev ? null : () {},
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              countryCode.toString(),
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                          ],
                        ),
                      ),
                      initialSelection: 'SA',
                      favorite: const ['+966'],
                      onChanged: (value) => countryCode = value,
                    ),
                  ),
                ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.onSave(countryCode.dialCode ?? "+966",
                                _phoneController.text.replaceAll(" ", ""));
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: CustomText(
                          text: "Save".tr(),
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      kWidth10,
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: primaryColor,
                          backgroundColor: Colors.transparent,
                        ),
                        child: CustomText(
                          text: "Cancel".tr(),
                          fontSize: 14,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ]);
          },
        ),
      ),
    ));
  }
}
