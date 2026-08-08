import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';

import '../../../../global/shared/widgets/custom_button.dart';
import '../../../../global/shared/widgets/custom_text_field.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import '../../../../global/shared/widgets/loading/loading_dialog.dart';
import '../pages/otp_page.dart';

class PhoneAuth extends ConsumerStatefulWidget {
  const PhoneAuth({super.key});

  @override
  ConsumerState<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends ConsumerState<PhoneAuth>
    with AutomaticKeepAliveClientMixin {
  String alphaCode = 'SA';
  String mask = '000000000';
  String countryCode = '+966';
  final phoneNode = FocusNode();
  final phoneController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      phoneController.text = "56 123 4566";
    }
  }

  @override
  void dispose() {
    phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Form(
        key: _key,
        child: Column(
          children: [
            CustomTextField(
              focusNode: phoneNode,
              labelText: 'Phone Number'.tr(),
              controller: phoneController,
              textInputType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              margin: const EdgeInsets.symmetric(vertical: 40),
              contentPadding: const EdgeInsetsDirectional.only(start: 95),
              errorStyle: const TextStyle(
                  fontFamily: "Kanit", fontSize: 14, color: Colors.yellow),
              inputFormatters: [
                PhoneInputFormatter(
                  defaultCountryCode: alphaCode,
                  onCountrySelected: (c) => mask =
                      c?.getCorrectMask(countryCode).replaceAll(" ", "") ??
                          '000000000',
                ),
              ],
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return "Required".tr();
                } else if (mask.length != value.replaceAll(" ", "").length) {
                  return "Invalid number".tr();
                } else if (value.startsWith("0")) {
                  return "Phone number must not start with 0".tr();
                }

                return null;
              },
              prefixIcon: Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                child: CountryCodePicker(
                  builder: (countryCode) => InkWell(
                    onTap: AppConfig.server == Build.dev ? null : () {},
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 8),
                        Image.asset(countryCode!.flagUri!,
                            width: 32, package: 'country_code_picker'),
                        const SizedBox(width: 5),
                        Text(countryCode.toString(),
                            style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                  onChanged: (CountryCode code) {
                    alphaCode = code.code ?? 'SA';
                    countryCode = code.dialCode ?? '+966';
                    debugPrint('dialCode $countryCode');
                    setState(() {});
                  },
                  initialSelection: 'SA',
                  favorite: const ['+966'],
                ),
              ),
            ),
            CustomButton(
              height: 42,
              width: 287,
              title: 'Sign in'.tr(),
              onTap: () async {
                if (_key.currentState!.validate()) {
                  try {
                    final data = {
                      "country_code": countryCode,
                      "phone_number": phoneController.text.replaceAll(" ", ""),
                    };

                    final future =
                        ref.read(authProvider.notifier).requestOtp(data);
                    await LoadingDialog.show(context, future);

                    if (!context.mounted) return;
                    //send an otp
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OTPPage(
                                countryCode: countryCode,
                                phoneNumber: phoneController.text.trim())));
                  } catch (e) {
                    if (!mounted) return;
                    CustomSnackBar.error(context, e.toString());
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
