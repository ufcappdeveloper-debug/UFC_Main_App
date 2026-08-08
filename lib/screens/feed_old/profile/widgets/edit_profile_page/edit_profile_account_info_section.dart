import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/text_filed_input_formatters.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_grey_divider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_email_model.dart';
import 'package:ufc_mobile/screens/feed_old/profile/widgets/edit_profile_page/edit_profile_contact_info_section.dart';
import 'package:ufc_mobile/screens/feed_old/profile/widgets/edit_profile_page/edit_profile_text_field.dart';

import '../custom_calender.dart';

class EditProfileAccountInfoSection extends StatelessWidget {
  const EditProfileAccountInfoSection({
    super.key,
    required this.email,
    required this.focusNode,
    required this.editProfile,
    required this.onDobUpdate,
    required this.genderValue,
    required this.isEmailExist,
    required this.dobController,
    required this.dropdownValue,
    required this.isPhoneSelected,
    required this.passwordFormKey,
    required this.emailController,
    required this.passwordController,
    required this.lastNameController,
    required this.firstNameController,
    required this.occupationController,
    required this.middleNameController,
    required this.onContactInfoChanged,
    required this.onCounrtyCodeChanged,
    required this.rePasswordController,
    required this.phoneNumberController,
    required this.onDropdownValueChanged,
    required this.onEditAccountInfoPressed,
  });
  final bool editProfile;
  final bool isEmailExist;
  final FocusNode focusNode;
  final Key passwordFormKey;
  final bool isPhoneSelected;
  final UserEmailModel? email;
  final String? dropdownValue;
  final List<String> genderValue;
  final Function(String) onDobUpdate;
  final TextEditingController dobController;
  final Function(bool) onContactInfoChanged;
  final VoidCallback onEditAccountInfoPressed;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController lastNameController;
  final Function(String?)? onDropdownValueChanged;
  final TextEditingController firstNameController;
  final TextEditingController occupationController;
  final TextEditingController rePasswordController;
  final TextEditingController middleNameController;
  final Function(CountryCode) onCounrtyCodeChanged;
  final TextEditingController phoneNumberController;

  @override
  Widget build(BuildContext context) => Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CustomText(
              text: "Account Info".tr(),
              fontSize: 16,
              fontWeight: FontWeight.w500),
          !editProfile
              ? InkWell(
                  onTap: onEditAccountInfoPressed,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: SvgPicture.asset(
                      "assets/images/profile/edit_profile_icon.svg"))
              : InkWell(
                  onTap: onEditAccountInfoPressed,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: const Icon(Icons.close_rounded,
                      color: Colors.black, size: 20)),
        ]),
        const CustomGreyDivider(),
        EditProfileTextField(
            formatter: <TextInputFormatter>[
              denyDigits,
              denySpecialCharacters,
            ],
            maxLength: 35,
            text: "First Name:",
            focusNode: focusNode,
            hintText: "first name",
            readOnly: !editProfile,
            controller: firstNameController),
        EditProfileTextField(
            formatter: <TextInputFormatter>[
              denyDigits,
              denySpecialCharacters,
            ],
            maxLength: 35,
            text: "Middle Name:",
            readOnly: !editProfile,
            hintText: "middle name",
            controller: middleNameController),
        EditProfileTextField(
            formatter: <TextInputFormatter>[
              denyDigits,
              denySpecialCharacters,
            ],
            maxLength: 35,
            text: "Last Name:",
            hintText: "last name",
            readOnly: !editProfile,
            controller: lastNameController),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(children: [
              Expanded(
                  flex: 1,
                  child: CustomText(
                      text: "Gender:".tr(),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF898989))),
              Expanded(
                  flex: 2,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 3, left: 22),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: double.infinity,
                                child: DropdownButton<String>(
                                    elevation: 1,
                                    isDense: true,
                                    value: dropdownValue,
                                    hint: Text('Select a gender'.tr()),
                                    icon: const SizedBox.shrink(),
                                    onChanged: onDropdownValueChanged,
                                    underline: const SizedBox.shrink(),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Kanit',
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                    items: genderValue
                                        .map<DropdownMenuItem<String>>(
                                            (String value) =>
                                                DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value.tr())))
                                        .toList())),
                            !editProfile
                                ? const SizedBox()
                                : Container(
                                    height: 1,
                                    color: const Color(0xFFE1E1E1),
                                    margin: const EdgeInsets.only(top: 5)),
                          ]))),
            ])),
        EditProfileTextField(
            maxLength: 35,
            text: "Occupation:",
            readOnly: !editProfile,
            hintText: "occupation",
            controller: occupationController),
        Row(children: [
          Expanded(
              flex: 1,
              child: CustomText(
                  text: "Birthday:".tr(),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF898989))),
          Expanded(
              flex: 2,
              child: Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: TextField(
                      readOnly: true,
                      controller: dobController,
                      cursorColor: primaryColor,
                      style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Kanit',
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                          isDense: true,
                          hintText: "dd/mm/yyyy",
                          hintStyle: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Kanit',
                              color: Color(0xFF898989),
                              fontWeight: FontWeight.w300),
                          border: !editProfile
                              ? InputBorder.none
                              : const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFFE1E1E1))),
                          enabledBorder: !editProfile
                              ? InputBorder.none
                              : const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFFE1E1E1))),
                          focusedBorder: !editProfile
                              ? InputBorder.none
                              : const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: primaryColor))),
                      onTap: !editProfile
                          ? () {}
                          : () async {
                              FocusManager.instance.primaryFocus?.unfocus();

                              DateTime? pickedDate;
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    contentPadding: const EdgeInsets.all(8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: const BorderSide(
                                          color: Colors.green, width: 2),
                                    ),
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.58, // Reduced height
                                      child: CustomCalendar(
                                        onDateSelected: (selectedDate) {
                                          pickedDate = selectedDate;
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );

                              if (pickedDate != null) {
                                String formattedDateAr =
                                    DateFormat('dd/MM/yyyy', 'ar')
                                        .format(pickedDate!);
                                String formattedDate =
                                    convertToWesternDigits(formattedDateAr);
                                onDobUpdate(formattedDate);
                              }
                            },
                      onEditingComplete: () =>
                          FocusManager.instance.primaryFocus?.nextFocus()))),
        ]),
        const SizedBox(height: 31),
        EditProfileContactinfoSection(
            email: email,
            editProfile: editProfile,
            isEmailExist: isEmailExist,
            isPhoneSelected: isPhoneSelected,
            passwordFormKey: passwordFormKey,
            emailController: emailController,
            passwordController: passwordController,
            rePasswordController: rePasswordController,
            onContactInfoChanged: onContactInfoChanged,
            onCounrtyCodeChanged: onCounrtyCodeChanged,
            phoneNumberController: phoneNumberController),
      ]);

  String convertToWesternDigits(String input) {
    const easternToWestern = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
    };

    return input.split('').map((char) => easternToWestern[char] ?? char).join();
  }
}
