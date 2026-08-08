import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_text_field.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class ReportMessageBottomSheet extends StatefulWidget {
  final String username;
  final String messageText;
  final String actionText;
  final Color actionButtonColor;
  final void Function(String reason) onAction;

  const ReportMessageBottomSheet({
    super.key,
    required this.username,
    required this.messageText,
    this.actionText = 'Report',
    this.actionButtonColor = const Color(0xFF9B51E0),
    required this.onAction,
  });

  @override
  State<ReportMessageBottomSheet> createState() =>
      _ReportMessageBottomSheetState();
}

class _ReportMessageBottomSheetState extends State<ReportMessageBottomSheet> {
  bool isLoading = false;
  late TextEditingController reasonController = TextEditingController();
  @override
  void initState() {
    super.initState();
    reasonController = TextEditingController();
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 30,
        right: 30,
        top: 25,
        bottom: MediaQuery.of(context).viewInsets.bottom + 40,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          headerWidget(context),
          kHeight25,

          // Username
          userName(),

          // Message Preview
          messagePreview(),

          kHeight20,

          // Reason TextField
          CustomTextField(
            inputTextColor: textGrey,
            cursorColor: textGrey,
            controller: reasonController,
            maxLines: 4,
            hint: "Why are you reporting this message?".tr(),
            borderRadius: BorderRadius.circular(10),
            borderColor: AppColors.grey,
          ),

          kHeight30,

          // Action Button
          submitButton(reasonController, context),
        ],
      ),
    );
  }

  CustomButton submitButton(
    TextEditingController reasonController,
    BuildContext context,
  ) {
    return CustomButton(
      height: 48,
      width: double.infinity,
      isLoading: isLoading,
      title: widget.actionText,
      color: widget.actionButtonColor,
      onTap: () {
        final reason = reasonController.text.trim();
        if (reason.isNotEmpty) {
          try {
            isLoading = true;
            setState(() {});
            widget.onAction(reason);
          } catch (e) {
            rethrow;
          }
        } else {
          Fluttertoast.showToast(
            msg: 'Please enter a reason.'.tr(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
    );
  }

  Align messagePreview() {
    return Align(
      alignment: Alignment.centerLeft,
      child: CustomText(
        text: widget.messageText,
        fontWeight: FontWeight.w300,
        fontSize: 12,
        color: textGrey,
      ),
    );
  }

  Align userName() {
    return Align(
      alignment: Alignment.centerLeft,
      child: CustomText(
        text: widget.username,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
    );
  }

  Row headerWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        kWidth40,
        CustomText(
          text: "Report Message",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        Visibility(
          visible: !isLoading,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close),
          ),
        ),
      ],
    );
  }
}
