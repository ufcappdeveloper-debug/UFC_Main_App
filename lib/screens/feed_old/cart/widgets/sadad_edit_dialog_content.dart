import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/checkout/sadad/sadad_user_info.dart';
import 'package:ufc_mobile/screens/feed_old/cart/widgets/sadad_edit_custom_id_drop_down.dart';
import 'package:ufc_mobile/screens/feed_old/cart/widgets/sadad_edit_text_field.dart';
import 'package:ufc_mobile/screens/feed_old/cart/widgets/sadad_edit_widgets.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_functions.dart';

class SadadEditDialogContent extends ConsumerStatefulWidget {
  const SadadEditDialogContent({
    super.key,
    this.sadadUserInfo,
    required this.onClick,
  });
  final SadadUserInfo? sadadUserInfo;

  final Function(String, String, String, String) onClick;

  @override
  ConsumerState<SadadEditDialogContent> createState() =>
      _SadadEditDialogContentState();
}

class _SadadEditDialogContentState
    extends ConsumerState<SadadEditDialogContent> {
  bool isIdFocused = false;
  bool isPhoneFocused = false;
  String idType = 'PAS (passport)';
  FocusNode idFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  List<String> sadadIdTypeList = <String>[
    'PAS (passport)',
    'CRR (Commercial Register)',
    'NAT (National ID)',
    'IQA (Iqama)',
  ];

  @override
  void initState() {
    nameController.text = widget.sadadUserInfo?.customerFullName ?? '';
    phoneController.text =
        sadadPhoneFormat(widget.sadadUserInfo, withoutCode: true) ?? '';
    idNumberController.text = widget.sadadUserInfo?.customerIdNumber ?? '';
    idType =
        getFullType(widget.sadadUserInfo?.customerIdType) ?? 'PAS (passport)';
    super.initState();
    idFocusNode.addListener(_onIdFocusChange);
    phoneFocusNode.addListener(_onPhoneFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    idFocusNode.dispose();
    phoneFocusNode.dispose();
  }

  void _onIdFocusChange() {
    isIdFocused = !isIdFocused;
    setState(() {});
  }

  void _onPhoneFocusChange() {
    isPhoneFocused = !isPhoneFocused;
    setState(() {});
  }

  String? getFullType(String? type) {
    if (type == null || type.isEmpty) return null;
    final temp = sadadIdTypeList.where((element) => element.contains(type));
    return temp.isEmpty ? null : temp.first;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Form(
        key: formState,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset("assets/images/cart/close_icon.svg"),
              ),
            ),
            const SizedBox(height: 6),
            CustomText(
                text: widget.sadadUserInfo == null
                    ? "Enter your SADAD info"
                    : "Edit your SADAD info",
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 14),
            const SizedBox(height: 14),
            SadadEditTextField(
              phoneController: nameController,
              keyboardType: TextInputType.name,
              decoration: sadadEditFieldDecoration(
                  labelText: 'User Name'.tr(),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.person,
                    ),
                  )),
            ),
            SadadEditTextField(
              validator: validate,
              focusNode: idFocusNode,
              phoneController: idNumberController,
              maxLength: idTypeCode == "PAS" ? null : 10,
              keyboardType: idTypeCode == "PAS" ? null : TextInputType.number,
              inputFormatters: idTypeCode == "PAS"
                  ? null
                  : [FilteringTextInputFormatter.digitsOnly],
              decoration: sadadEditFieldDecoration(
                labelText: 'ID Number'.tr(),
                hintText: "eg: 1346529875",
                prefixIcon: SadadEditCustomIdDropDown(
                    isIdFocused: isIdFocused,
                    sadadIdType: idType,
                    sadadIdTypeList: sadadIdTypeList,
                    onChanged: (value) {
                      idType = value ?? "";
                      setState(() {});
                    }),
              ),
            ),
            SadadEditTextField(
              focusNode: phoneFocusNode,
              phoneController: phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9)
              ],
              decoration: sadadEditFieldDecoration(
                labelText: 'Phone Number'.tr(),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "+966",
                        color: isPhoneFocused ? primaryColor : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 44),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27),
              child: CustomButton(
                  title: "Save",
                  onTap: () {
                    if (formState.currentState!.validate()) {
                      //     Navigator.pop(context);
                      widget.onClick(
                        nameController.text,
                        phoneController.text,
                        idType.substring(0, 3),
                        idNumberController.text,
                      );
                    }
                  }),
            ),
            const SizedBox(height: 37),
          ],
        ),
      ),
    );
  }

  String get idTypeCode {
    return idType.substring(0, 3);
  }

  String? validate(value) {
    if (value == null || value.trim().isEmpty) {
      return "required";
    } else if (idTypeCode == "CRR" && value.length != 10) {
      return "Please provide a valid 10 digit CRR";
    } else if (idTypeCode == "NAT" && startWithValidValue(value)) {
      return "NAT must begin with the digit 1 or 2";
    } else if (idTypeCode == "NAT" && value.length != 10) {
      return "Please provide a valid 10 digit NAT";
    } else if (idTypeCode == "IQA" && startWithValidValue(value)) {
      return "IQA must begin with the digit 1 or 2";
    } else if (idTypeCode == "IQA" && value.length != 10) {
      return "Please provide a valid 10 digit IQA";
    } else if (idTypeCode != "PAS" && !isInteger(value)) {
      return "Please enter only numerical digits in this field";
    }

    return null;
  }

  bool startWithValidValue(String value) {
    if (value.startsWith("1")) return false;
    if (value.startsWith("2")) return false;
    return true;
  }
}
