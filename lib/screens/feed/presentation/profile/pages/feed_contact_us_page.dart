import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/exception/error_handler.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

import '../../../../farm/presentation/charts/weight_chart.dart';
import '../../../../farm/presentation/widgets/farm_appbar.dart';
import '../../../../farm/presentation/widgets/farm_text_field.dart';
import '../../../application/contact/contact_cubit.dart';
import '../../../application/contact/contact_state.dart';
import '../../../domain/entities/contact/support_model.dart';

class FeedContactPage extends StatefulWidget {
  final bool isFromVet;
  final bool isFromFarm;
  const FeedContactPage({
    super.key,
    this.isFromVet = false,
    this.isFromFarm = false,
  });

  @override
  State<FeedContactPage> createState() => _FeedContactPageState();
}

class _FeedContactPageState extends State<FeedContactPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController msgController;

  final _formKey = GlobalKey<FormState>();

  late SupportCubit supportCubit; // <-- add this

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    msgController = TextEditingController();

    supportCubit = GetIt.I<SupportCubit>(); // <-- get the same instance
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    msgController.dispose();
    super.dispose();
  }

  void _sendMsg() {
    if (_formKey.currentState!.validate()) {
      final request = SupportRequest(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        countryCode: "1231",
        city: "AD",
        subject: "title here",
        comment: msgController.text.trim(),
      );

      supportCubit.createSupport(request); // <-- use the same cubit
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: supportCubit, // <-- reuse existing cubit
      child: BlocListener<SupportCubit, SupportState>(
        listener: (context, state) {
          if (state is SupportLoading) {
            Fluttertoast.showToast(msg: 'Sending...'.tr());
          } else if (state is SupportSuccess) {
            CustomSnackBar.success(context, state.message);
            nameController.clear();
            emailController.clear();
            phoneController.clear();
            msgController.clear();
          } else if (state is SupportError) {
            if (!context.mounted) return;

            ErrorHandler.handleError(context, state.error);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomFarmAppBar(title: 'Contact Us'),
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap: _sendMsg,
              child: BlocBuilder<SupportCubit, SupportState>(
                builder: (context, state) {
                  final isLoading = state is SupportLoading;
                  return CustomOutlinedContainer(
                    title: isLoading ? 'Sending...' : 'Send',
                    fill: true,
                    fillColor: widget.isFromVet
                        ? PetVeterinaryColors.newPetMainColorVeterinary
                        : (widget.isFromFarm
                            ? AppColors.farmColor
                            : primaryColor),
                  );
                },
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    memberTextField('Name', 'Enter name'.tr(),
                        controller: nameController, validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name'.tr();
                      }
                      return null;
                    }),
                    memberTextField('Email', 'EnterEmail'.tr(),
                        controller: emailController, validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email'.tr();
                      } else if (value.isNotEmpty) {
                        final emailRegex =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Enter a valid email'.tr();
                        }
                      }
                      return null;
                    }),
                    memberTextField('Mobile Number', '5XXXXXXXX',
                        controller: phoneController, validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter mobile number'.tr();
                      }
                      if (!RegExp(r'^\d{7,15}$').hasMatch(value)) {
                        return 'Enter a valid phone number'.tr();
                      }
                      return null;
                    }),
                    memberTextField('Message', 'Write your message...'.tr(),
                        controller: msgController, validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter message'.tr();
                      }
                      return null;
                    }),
                    SizedBox(
                      height: 68,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column memberTextField(String title, String hintText,
      {required TextEditingController controller,
      String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        kHeight10,
        CustomTextFormField(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: PetVeterinaryColors.newPetLightGray,
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
          controller: controller,
          validator: validator,
          isMsg: controller == msgController,
          isPhone: controller == phoneController,
          keyboardType:
              controller == phoneController ? TextInputType.number : null,
          context: context,
        ),
        kHeight20,
      ],
    );
  }
}
