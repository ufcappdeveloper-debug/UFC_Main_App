import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/weight_chart.dart';

import '../../../../global/extensions/app_colors.dart';
import '../widgets/farm_appbar.dart';
import '../widgets/farm_text_field.dart';
import '../../application/members/members_cubit.dart';
import '../../domain/entities/member/farm_member_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';

class AddMemberORContactUs extends ConsumerStatefulWidget {
  final bool formContactUs;

  /// Edit mode when set (the mobile number is read-only then). Saving needs
  /// a [MembersCubit] above this page.
  final FarmMemberModel? member;

  const AddMemberORContactUs(
      {super.key, required this.formContactUs, this.member});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends ConsumerState<AddMemberORContactUs> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController msgController;

  final _formKey = GlobalKey<FormState>();

  bool allow = false;
  bool saving = false;

  bool get isEdit => widget.member != null;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.member?.name);
    emailController = TextEditingController(text: widget.member?.email);
    phoneController = TextEditingController(text: widget.member?.phoneNumber);
    msgController = TextEditingController();
    allow = widget.member?.canViewFinance ?? false;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    msgController.dispose();
    super.dispose();
  }

  Future<void> _saveMember() async {
    if (saving || !_formKey.currentState!.validate()) return;
    setState(() => saving = true);
    final error = await context.read<MembersCubit>().save(
          existing: widget.member,
          name: nameController.text.trim(),
          phoneNumber: phoneController.text.trim(),
          countryCode: widget.member?.countryCode ?? '+966',
          email: emailController.text.trim(),
          canViewFinance: allow,
        );
    if (!mounted) return;
    setState(() => saving = false);
    if (error != null) {
      CustomSnackBar.error(context, error);
      return;
    }
    CustomSnackBar.success(context, isEdit ? 'Member updated' : 'Member added');
    Navigator.of(context).pop(true);
  }

  void _sendMsg() {
    if (_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: 'Not available at the moment'.tr(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomFarmAppBar(
          title: widget.formContactUs
              ? 'Contact Us'
              : (isEdit ? 'Edit Member' : 'Add New Member')),
      // Hidden while the keyboard is open, so it never covers a field.
      floatingActionButton: MediaQuery.viewInsetsOf(context).bottom > 0
          ? null
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: GestureDetector(
          onTap: widget.formContactUs ? _sendMsg : _saveMember,
          child: saving
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.farmColor))
              : CustomOutlinedContainer(
                  title: widget.formContactUs ? 'Send' : 'Save',
                  fill: true,
                  fillColor: AppColors.farmColor,
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                memberTextField(
                  widget.formContactUs ? 'Name' : 'Member Name',
                  widget.formContactUs
                      ? 'Enter name'.tr()
                      : 'Enter member name'.tr(),
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter member name'.tr();
                    }
                    return null;
                  },
                ),
                memberTextField(
                  'Email (optional)',
                  'Enter your email'.tr(),
                  controller: emailController,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Enter a valid email'.tr();
                      }
                    }
                    return null;
                  },
                ),
                memberTextField(
                  'Mobile Number',
                  '501234567',
                  controller: phoneController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter mobile number'.tr();
                    }
                    if (!RegExp(r'^\d{7,15}$').hasMatch(value)) {
                      return 'Enter a valid phone number'.tr();
                    }
                    return null;
                  },
                  readOnly: isEdit && !widget.formContactUs,
                ),
                if (isEdit && !widget.formContactUs)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CustomText(
                      text:
                          'To change the number, delete and re-add the member',
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                    ),
                  ),
                if (widget.formContactUs)
                  memberTextField(
                    'Message',
                    'Write your message...'.tr(),
                    controller: msgController,
                    validator: (value) {
                      return null;
                    },
                  ),
                if (!widget.formContactUs) kHeight10,
                if (!widget.formContactUs)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          allow = !allow;
                        }),
                        child: Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                              color: allow
                                  ? AppColors.farmColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: Colors.grey.shade300,
                              )),
                        ),
                      ),
                      kWidth10,
                      Expanded(
                        child: CustomText(
                          text: 'Allow the user to view expenses and sales',
                          fontWeight: FontWeight.w300,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                kHeight50,
                kHeight10,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column memberTextField(String title, String hintText,
      {required TextEditingController controller,
      String? Function(String?)? validator,
      bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
          fontFamily:
              isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
        ),
        kHeight10,
        CustomTextFormField(
            hintText: hintText,
            controller: controller,
            validator: validator,
            readOnly: readOnly,
            isMsg: controller == msgController,
            isPhone: controller == phoneController,
            keyboardType:
                controller == phoneController ? TextInputType.number : null,
            context: context),
        kHeight20,
      ],
    );
  }
}
