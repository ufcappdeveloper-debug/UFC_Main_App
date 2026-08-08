import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/data/support_service.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage>
    with ScreenEngagementTracker {
  final _key = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final countryCodeController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final subjectController = TextEditingController();
  final commentController = TextEditingController();

  final nameNode = FocusNode();
  final emailNode = FocusNode();
  final countryCodeNode = FocusNode();
  final phoneNode = FocusNode();
  final cityNode = FocusNode();
  final subjectNode = FocusNode();
  final commentNode = FocusNode();

  String countryCode = "+966";
  String selectedCity = "Riyadh";

  bool isSubmitting = false;

  Future<void> submitForm(final data) async {
    setState(() {
      isSubmitting = true;
    });
    try {
      String sentMessage = await SupportService().createTicket(data);
      // ignore: use_build_context_synchronously
      CustomSnackBar.success(context, sentMessage);
      setState(() {
        isSubmitting = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on DioException catch (e) {
      debugPrint('error $e');
      CustomSnackBar.error(
          context, 'Unable to submit comment, please try again later.');
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: const Color(0xffe5e5e5).withValues(alpha: 0.2),
          elevation: 8,
          title: CustomText(
            text: 'Contact Us',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child:
                const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 16,
                        color: const Color(0xFFe5e5e5).withValues(alpha: 0.7)),
                  ]),
              child: Form(
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SupportFormField(
                      nameController: nameController,
                      nameNode: nameNode,
                      nodeAfter: emailNode,
                      label: 'Name',
                      textInputType: TextInputType.name,
                    ),
                    SupportFormField(
                      nameController: emailController,
                      nameNode: emailNode,
                      nodeAfter: phoneNode,
                      label: 'Email',
                      textInputType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Required';
                        } else if (value.contains('@') != true) {
                          return 'Email invalid';
                        }
                        return null;
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 30, right: 30, top: 10, bottom: 2),
                          child: CustomText(
                            text: 'Phone',
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                            color: Colors.grey,
                          ),
                        ),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            children: [
                              Container(
                                height: 35,
                                margin: const EdgeInsets.only(left: 20),
                                padding: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color:
                                          Colors.grey.withValues(alpha: 0.2)),
                                ),
                                child: Row(
                                  children: [
                                    CountryCodePicker(
                                      onChanged: (CountryCode code) {
                                        countryCode = code.dialCode!;
                                        debugPrint('dialCode $countryCode');
                                      },
                                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                      initialSelection: 'SA',
                                      favorite: const ['+966'],
                                      // showDropDownButton: true,
                                      padding: const EdgeInsets.all(0),
                                      showFlag: true,
                                    ),
                                    const RotatedBox(
                                        quarterTurns: 3,
                                        child: Icon(
                                            Icons.arrow_back_ios_new_rounded,
                                            size: 12))
                                  ],
                                ),
                              ),
                              Expanded(
                                child: SupportFormField(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 20),
                                  hideLabel: true,
                                  nameController: phoneController,
                                  nameNode: phoneNode,
                                  nodeAfter: cityNode,
                                  label: 'Phone',
                                  textInputType: TextInputType.number,
                                  validator: (val) {
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 30, right: 30, top: 10, bottom: 2),
                      child: CustomText(
                        text: 'City',
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      height: 35,
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      padding: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField(
                              onChanged: (value) => selectedCity = value!,
                              // focusNode: cityNode,
                              // onSaved: (val) => subjectNode.requestFocus(),
                              value: selectedCity,
                              padding: const EdgeInsets.all(0),
                              icon: const RotatedBox(
                                  quarterTurns: 3,
                                  child: Icon(Icons.arrow_back_ios_new_rounded,
                                      size: 12)),
                              borderRadius: BorderRadius.circular(10),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.only(bottom: 15, left: 10)),
                              items: [
                                ...cities.map((e) => DropdownMenuItem(
                                    value: e,
                                    child: CustomText(
                                      text: e,
                                      fontFamily: null,
                                      fontSize: 13,
                                    ))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // CustomSupportFormField(
                    //     enabled: false,
                    //     nameController: cityController,
                    //     nameNode: cityNode,
                    //     nodeAfter: subjectNode,
                    //     label: 'City',
                    //     textInputType: TextInputType.text,
                    //     onTap:(){
                    //        showCountryPicker(
                    //         context: context,
                    //         favorite: <String>[
                    //           'AE',
                    //           'BH',
                    //           'SA',
                    //           'OM',
                    //           'QA',
                    //           'KW'
                    //         ],
                    //         showPhoneCode:
                    //             false, // optional. Shows phone code before the country name.
                    //         onSelect: (Country country) {
                    //           countryController.text = country.name;
                    //         },
                    //       );
                    //     },),
                    SupportFormField(
                      nameController: subjectController,
                      nameNode: subjectNode,
                      label: 'Subject',
                      textInputType: TextInputType.text,
                    ),
                    SupportFormField(
                      nameController: commentController,
                      nameNode: commentNode,
                      label: 'Comment',
                      textInputType: TextInputType.text,
                      maxLines: 5,
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: CustomFormField(
                    //       isArabic: false, useLabel: false, type: 'phone'),
                    // ),
                    const SizedBox(height: 10),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        child: CustomButton(
                            title: 'Submit',
                            color: isSubmitting ? Colors.grey : primaryColor,
                            onTap: () {
                              FormData formData = FormData.fromMap({
                                "name": nameController.text,
                                "email": emailController.text,
                                "country_code": countryCode,
                                "phone_number":
                                    phoneController.text.replaceAll(" ", ""),
                                "city": selectedCity,
                                "subject": subjectController.text,
                                "comment": commentController.text,
                              });
                              if (_key.currentState!.validate()) {
                                submitForm(formData);
                              } else {
                                CustomSnackBar.error(
                                    context, "Kindly fill in the all fields");
                              }
                            }))
                  ],
                ),
              )),
        ));
  }
}

class SupportFormField extends StatelessWidget {
  const SupportFormField({
    super.key,
    required this.nameController,
    required this.nameNode,
    this.maxLines,
    this.maxLength,
    this.label,
    this.hideLabel = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType,
    this.nodeAfter,
    this.margin,
    this.enabled,
    this.onTap,
    this.validator,
  });

  final TextEditingController nameController;
  final FocusNode nameNode;
  final int? maxLines;
  final int? maxLength;
  final String? label;
  final bool hideLabel;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final FocusNode? nodeAfter;
  final EdgeInsets? margin;
  final bool? enabled;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hideLabel
            ? const SizedBox.shrink()
            : Container(
                margin: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 2),
                child: CustomText(
                  text: label ?? '',
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                ),
              ),
        Container(
            margin:
                margin ?? const EdgeInsets.only(left: 20, right: 20, bottom: 5),
            // height: 30,
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     color: Colors.white,
            //     boxShadow: [
            //       BoxShadow(blurRadius: 2, color: Colors.grey.withValues(alpha:0.2))
            //     ]),
            child: TextFormField(
              enabled: enabled,
              controller: nameController,
              focusNode: nameNode,
              maxLines: maxLines,
              maxLength: maxLength,
              cursorColor: primaryColor,
              textInputAction: textInputAction,
              keyboardType: textInputType,
              onTap: onTap,

              //Note: this is needed to hide keyboard when tapping outside the field
              onTapOutside: (val) => FocusScope.of(context).unfocus(),

              onEditingComplete: () {
                if (nodeAfter != null) {
                  return nodeAfter!.requestFocus();
                }
                return FocusScope.of(context).requestFocus(FocusNode());
              },
              validator: validator ??
                  (value) {
                    if (value!.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                isDense: true,
                alignLabelWithHint: false,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                contentPadding: const EdgeInsets.all(10),
                hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11),
                errorStyle:
                    const TextStyle(fontFamily: 'Poppins', fontSize: 11),
                // border: InputBorder.none,
                // enabledBorder: InputBorder.none,
                // focusedBorder: InputBorder.none,
                // focusedErrorBorder: InputBorder.none,
                // disabledBorder: InputBorder.none,
                // errorBorder: InputBorder.none,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.1),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
              ),
            )),
      ],
    );
  }
}

class CustomSupportFormField extends StatelessWidget {
  const CustomSupportFormField({
    super.key,
    required this.nameController,
    required this.nameNode,
    this.maxLines,
    this.maxLength,
    this.label,
    this.hideLabel = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType,
    this.nodeAfter,
    this.margin,
    this.enabled,
    this.onTap,
    this.validator,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.readOnly,
    this.onPress,
    this.fileExists = false,
    this.file,
    this.enableOnTap,
    this.upload,
    this.hintText,
    this.fillColor,
    this.hintColor,
    this.showError,
    this.onTapDelete,
    this.disabled = false,
    this.suffixIcon,
  });

  final TextEditingController? nameController;
  final FocusNode nameNode;
  final int? maxLines;
  final int? maxLength;
  final String? label;
  final bool hideLabel;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final FocusNode? nodeAfter;
  final EdgeInsets? margin;
  final bool? enabled;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool? readOnly;
  final VoidCallback? onPress;
  final bool? enableOnTap;

  final bool? upload;
  final File? file;
  final bool? fileExists;
  final String? hintText;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color? hintColor;
  final bool? showError;
  final Function()? onTapDelete;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hideLabel
            ? const SizedBox.shrink()
            : Container(
                margin: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 2),
                child: CustomText(
                  text: label ?? '',
                  fontFamily: 'Poppins',
                  fontWeight: fontWeight ?? FontWeight.w300,
                  color: textColor ?? Colors.grey,
                ),
              ),
        nameController != null
            ? Container(
                margin: margin ??
                    const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                // height: 30,
                // decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     color: Colors.white,
                //     boxShadow: [
                //       BoxShadow(blurRadius: 2, color: Colors.grey.withValues(alpha:0.2))
                //     ]),
                child: TextFormField(
                  enabled: enabled,
                  controller: nameController,
                  focusNode: nameNode,
                  maxLines: maxLines,
                  maxLength: maxLength,
                  cursorColor: primaryColor,
                  textInputAction: textInputAction,
                  keyboardType: textInputType,
                  onTap: onTap,
                  readOnly: readOnly ?? false,

                  //Note: this is needed to hide keyboard when tapping outside the field
                  onTapOutside: (val) => FocusScope.of(context).unfocus(),

                  onEditingComplete: () {
                    if (nodeAfter != null) {
                      return nodeAfter!.requestFocus();
                    }
                    return FocusScope.of(context).requestFocus(FocusNode());
                  },
                  validator: validator ??
                      (value) {
                        if (value!.isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    prefixIcon: readOnly == true
                        ? GestureDetector(
                            onTap: onPress,
                            child: Center(
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                      'assets/images/upload_image.svg'),
                                  const SizedBox(width: 10),
                                  CustomText(
                                    text: 'Upload Image',
                                    fontSize: 14,
                                    color: const Color(0xff9b9b9b),
                                  )
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    isDense: true,
                    alignLabelWithHint: false,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: const EdgeInsets.all(10),
                    hintStyle:
                        const TextStyle(fontFamily: 'Poppins', fontSize: 11),
                    errorStyle:
                        const TextStyle(fontFamily: 'Poppins', fontSize: 11),

                    // border: InputBorder.none,
                    // enabledBorder: InputBorder.none,
                    // focusedBorder: InputBorder.none,
                    // focusedErrorBorder: InputBorder.none,
                    // disabledBorder: InputBorder.none,
                    // errorBorder: InputBorder.none,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.1),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.2))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.2))),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.2))),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.2))),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.2))),
                  ),
                ))
            : InkWell(
                onTap: onTap,
                child: Container(
                  margin: margin ??
                      const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color:
                            //widget.file == null
                            showError == true
                                ? Colors.red
                                : Colors.grey.withValues(alpha: 0.2),
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: (upload == true && file == null)
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/images/upload_image.svg'),
                              const SizedBox(width: 10),
                              CustomText(
                                text: 'Upload Image',
                                fontSize: 14,
                                color: const Color(0xff9b9b9b),
                              )
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                  child: CustomText(
                                      text: fileExists == true
                                          ? 'File already exists'
                                          : file != null
                                              ? file!.path
                                                  .split("/")
                                                  .last
                                                  .toString()
                                              : hintText ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: hintColor ??
                                          (disabled
                                              ? Colors.black
                                              : upload == true
                                                  ? fillColor != null
                                                      ? Colors.black
                                                      : Colors.black
                                                  : Colors.black))),
                              if (fileExists == true ||
                                  (upload == true && file != null))
                                InkResponse(
                                  onTap: onTapDelete,
                                  child: const Icon(
                                    Icons.close,
                                    color:
                                        primaryColor, //Colors.red.withValues(alpha:.7),
                                  ),
                                )
                              else if (upload == true && file == null)
                                Center(
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/images/upload_image.svg'),
                                      const SizedBox(width: 10),
                                      CustomText(
                                        text: 'Upload Image',
                                        fontSize: 14,
                                        color: const Color(0xff9b9b9b),
                                      )
                                    ],
                                  ),
                                )
                              else if (upload == false)
                                suffixIcon != null
                                    ? suffixIcon!
                                    : Icon(Icons.keyboard_arrow_down_rounded,
                                        color: disabled
                                            ? Colors.black
                                            : Colors.black)
                            ],
                          ),
                        ),
                ),
              )
      ],
    );
  }
}

List<String> cities = [
  'Riyadh',
  'Jeddah',
  'Mecca',
  'Medina',
  'Dammam',
  'Hofuf',
  'Taif',
  'Tabuk',
  'Buraydah',
  'Khamis Mushayt',
  'Al Jubayl',
  'Hail',
  'Najran',
  'Hafr Al Batin',
  'Et Tubka',
  'Abha',
  'Al-Kharj',
  'Yanbu',
  'Al Khobar',
  'Argali',
  'Unayzah',
  'Sakaki',
  'El Hawiye',
  'Jizan',
  'Dhahran',
  'Qatif',
  'El Kurayyat',
];
