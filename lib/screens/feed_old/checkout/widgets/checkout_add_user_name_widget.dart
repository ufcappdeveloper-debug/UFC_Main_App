import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_functions.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';

class CheckoutAddUserNameWidget extends ConsumerStatefulWidget {
  const CheckoutAddUserNameWidget({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  ConsumerState<CheckoutAddUserNameWidget> createState() =>
      _CheckoutAddUserNameWidgetState();
}

class _CheckoutAddUserNameWidgetState
    extends ConsumerState<CheckoutAddUserNameWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              children: [
                const SizedBox(height: 21),
                Align(
                    alignment: Alignment.center,
                    child: CustomText(
                        text: "Enter  your  Details",
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 29),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: TextFormField(
                        autofocus: true,
                        cursorColor: primaryColor,
                        controller: firstNameController,
                        textInputAction: TextInputAction.go,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                        decoration: checkoutVehicleTextFieldDecoration(
                            hintText: "First Name *",
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 11)),
                        onEditingComplete: () =>
                            FocusManager.instance.primaryFocus?.nextFocus())),
                const SizedBox(height: 22),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: TextFormField(
                        cursorColor: primaryColor,
                        controller: middleNameController,
                        textInputAction: TextInputAction.go,
                        decoration: checkoutVehicleTextFieldDecoration(
                            hintText: "Middle Name",
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 11)),
                        onEditingComplete: () =>
                            FocusManager.instance.primaryFocus?.nextFocus())),
                const SizedBox(height: 22),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: TextFormField(
                        cursorColor: primaryColor,
                        controller: lastNameController,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                        decoration: checkoutVehicleTextFieldDecoration(
                            hintText: "Last Name *",
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 11)),
                        onEditingComplete: () =>
                            FocusManager.instance.primaryFocus?.nextFocus())),
                const SizedBox(height: 50),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  top: 3, left: 53, right: 53, bottom: 23),
              child: CustomButton(
                width: double.infinity,
                title: "Proceed",
                onTap: () async {
                  try {
                    if (_formKey.currentState!.validate()) {
                      Map<String, dynamic> result = {
                        "name": firstNameController.text,
                        "last_name": lastNameController.text,
                        "middle_name": middleNameController.text,
                      };

                      FormData data = FormData.fromMap(result);

                      final future = ref
                          .read(authProvider.notifier)
                          .editUser(user.value?.id ?? 0, data);
                      await LoadingDialog.show(context, future);
                      if (context.mounted) {
                        Navigator.pop(context, true);
                        CustomSnackBar.success(
                            context, "User profile updated successfully");
                      }
                    }
                  } catch (e) {
                    if (!context.mounted) return;
                    CustomSnackBar.error(context, e.toString());
                  }
                },
              )),
        ],
      ),
    );
  }
}
