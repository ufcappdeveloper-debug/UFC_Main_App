import 'package:app_settings/app_settings.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/data/news_letter_service.dart';
import 'package:ufc_mobile/main.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/pages/signin_page.dart';
import 'package:ufc_mobile/screens/feed_old/profile/widgets/edit_profile_page/edit_profile_account_info_section.dart';
import 'package:ufc_mobile/screens/feed_old/profile/widgets/edit_profile_page/edit_profile_change_password_section.dart';
import 'package:ufc_mobile/screens/feed_old/profile/widgets/edit_profile_page/edit_profile_change_preferred_station_section.dart';
import 'package:ufc_mobile/screens/feed_old/profile/widgets/edit_profile_page/edit_profile_functions.dart';
import 'package:ufc_mobile/screens/feed_old/profile/widgets/edit_profile_page/edit_profile_image_container.dart';
import 'package:ufc_mobile/screens/feed_old/profile/widgets/edit_profile_page/edit_profile_widgets.dart';
import 'package:ufc_mobile/screens/feed_old/profile/widgets/profile_widgets.dart';
import 'package:ufc_mobile/screens/feed_old/stations/stations_map.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/app_location.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/constants/functions.dart';
import 'package:ufc_mobile/global/shared/widgets/common_back_app_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_grey_divider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/edit_email_phone.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/global/util/storage/local_storage.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage>
    with ScreenEngagementTracker {
  String? dropdownValue;
  String? userImage = '';
  String pickedImage = '';
  String alphaCode = 'SA';
  bool editProfile = false;
  bool editPassword = false;
  bool isEmailExist = false;
  String countryCode = '+966';
  bool isPhoneSelected = true;
  bool isNewsLetterEnabled = false;
  FocusNode focusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  RegExp regExp = RegExp(r'(\d{2})(\d{3})(\d+)');
  List<String> genderValue = <String>['Male', 'Female'];
  GlobalKey<FormState> accountFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> newPasswordFormKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    final user = ref.read(authProvider).asData?.value;

    isEmailExist = !(user == null ||
        user.email == null ||
        user.email?.email == null ||
        user.email!.email!.isEmpty);

    dobController.text = editProfileFormatDate(
            inFormate: "yyyy-MM-dd",
            outFormate: "dd/MM/yyyy",
            inputDate: user?.dob) ??
        "Select a Date".tr();
    userImage = user?.profilePicture ?? "";
    firstNameController.text = user?.name ?? "";
    lastNameController.text = user?.lastName ?? "";
    emailController.text = user?.email?.email ?? "";
    middleNameController.text = user?.middleName ?? "";
    occupationController.text = user?.occupation ?? "";
    String? phoneNumber = user?.phone?.phoneNumber;
    phoneNumberController.text = phoneNumber == null || phoneNumber.isEmpty
        ? ""
        : phoneNumber.replaceAllMapped(
            regExp, (Match m) => "${m[1]} ${m[2]} ${m[3]}");
    dropdownValue = user?.gender == null || user!.gender!.isEmpty
        ? null
        : user.gender![0].toUpperCase() +
            user.gender!.substring(1).toLowerCase();
    isNewsLetterEnabled =
        ref.read(authProvider).asData?.value?.newsletter ?? false;
    super.initState();
  }

  @override
  void dispose() {
    editProfile = false;
    editPassword = false;
    dobController.dispose();
    emailController.dispose();
    passwordController.dispose();
    lastNameController.dispose();
    firstNameController.dispose();
    middleNameController.dispose();
    rePasswordController.dispose();
    occupationController.dispose();
    phoneNumberController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool isValueChanged(String oldValue, String newValue) {
    if (oldValue == newValue) return false;
    return true;
  }

  Future<void> updateUserInfo(UserModel? userData) async {
    final String dateFormatter = editProfileFormatDate(
            inFormate: "dd/MM/yyyy",
            outFormate: "MM/dd/yyyy",
            inputDate: dobController.text) ??
        "";
    Map<String, dynamic> result = {
      "gender": dropdownValue,
      "dob": dateFormatter,
      "middle_name": middleNameController.text,
      "name": firstNameController.text,
      "last_name": lastNameController.text,
      "occupation": occupationController.text,
    };
    if (pickedImage.isNotEmpty) {
      result["profile_picture"] = await MultipartFile.fromFile(pickedImage);
    }

    try {
      if (isValueChanged(userData?.email?.email ?? "", emailController.text)) {
        if (!mounted) return;
        bool emailConfirmation = false;
        emailConfirmation = await showChangeUserDataConfirmationDialog(context,
                isEmailChanged: true) ??
            false;
        if (!emailConfirmation) return;
        // Verify User Email Update
        if (!mounted) return;
        await EditEmailPhone.verifyEmail(context, ref,
                newEmailValue: emailController.text)
            .then((value) {
          if (value && passwordController.text.isNotEmpty) {
            result["password"] = passwordController.text;
          }
        });
      }

      if (isValueChanged(userData?.phone?.phoneNumber ?? "",
          phoneNumberController.text.replaceAll(" ", ""))) {
        if (!mounted) return;
        bool phoneConfirmation = false;
        phoneConfirmation = await showChangeUserDataConfirmationDialog(context,
                isPhoneChanged: true) ??
            false;
        if (!phoneConfirmation) return;

        // Verify User Phone Number Update
        if (!mounted) return;
        await EditEmailPhone.verifyPhone(context, ref,
            newPhoneValue: phoneNumberController.text.replaceAll(" ", ""));
      }

      FormData data = FormData.fromMap(result);

      final future =
          ref.read(authProvider.notifier).editUser(userData?.id ?? 0, data);
      if (!mounted) return;
      await LoadingDialog.show(context, future);

      if (mounted) {
        CustomSnackBar.success(context, "User profile updated successfully");

        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.error(context, e.toString());
    }
  }

  Future<CroppedFile?> editImage(String imagePath) async {
    final CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imagePath,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Edit Image',
          toolbarColor: primaryColor,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: darkGreen,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
          ],
        ),
        IOSUiSettings(
          title: 'Edit Image',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
          ],
        ),
      ],
    );

    if (croppedImage != null) {
      return croppedImage;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    return WillPopScope(
        onWillPop: () async {
          if (editProfile || editPassword) {
            showClearProductDialog(context);
            return false;
          }
          return true;
        },
        child: Scaffold(
            appBar: CommonBackAppBar(
              title: "My Account".tr(),
              onLeadingTap: editProfile || editPassword
                  ? () => showClearProductDialog(context)
                  : () => Navigator.pop(context),
            ),
            body: user.when(
                data: (userData) => ListView(
                        padding:
                            const EdgeInsets.only(top: 15, left: 32, right: 32),
                        children: [
                          EditProfileImageContainer(
                            imageUrl: userImage,
                            editProfile: editProfile,
                            pickedImage: pickedImage,
                            onPressed: !editProfile
                                ? () {}
                                : () async {
                                    final ImagePicker picker = ImagePicker();
                                    final XFile? image = await picker.pickImage(
                                        source: ImageSource.gallery);
                                    if (image != null) {
                                      var editedImage =
                                          await editImage(image.path);
                                      pickedImage = editedImage?.path ?? "";
                                      //pickedImage = image.path;
                                      setState(() {});
                                    } else {
                                      if (!mounted) return;
                                      CustomSnackBar.error(
                                          context, 'Image not found!');
                                    }
                                  },
                          ),
                          const SizedBox(height: 21),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Edit Profile: Account Information Section
                                Form(
                                  key: accountFormKey,
                                  child: EditProfileAccountInfoSection(
                                    focusNode: focusNode,
                                    email: userData?.email,
                                    editProfile: editProfile,
                                    genderValue: genderValue,
                                    isEmailExist: isEmailExist,
                                    dobController: dobController,
                                    dropdownValue: dropdownValue,
                                    isPhoneSelected: isPhoneSelected,
                                    emailController: emailController,
                                    passwordFormKey: passwordFormKey,
                                    passwordController: passwordController,
                                    lastNameController: lastNameController,
                                    firstNameController: firstNameController,
                                    rePasswordController: rePasswordController,
                                    occupationController: occupationController,
                                    middleNameController: middleNameController,
                                    phoneNumberController:
                                        phoneNumberController,
                                    onContactInfoChanged: !editProfile
                                        ? (value) => setState(
                                            () => isPhoneSelected = value)
                                        : (value) async {
                                            // To Validate phone number if they are not empty
                                            if (!value &&
                                                !(accountFormKey.currentState !=
                                                        null &&
                                                    accountFormKey.currentState!
                                                        .validate())) {
                                              return;
                                            }
                                            // To Validate the email, new password, and re - password if they are not empty
                                            if (value &&
                                                !(passwordFormKey
                                                            .currentState !=
                                                        null &&
                                                    passwordFormKey
                                                        .currentState!
                                                        .validate())) {
                                              return;
                                            }
                                            final isEmailChanged =
                                                isValueChanged(
                                                    userData?.email?.email ??
                                                        "",
                                                    emailController.text);
                                            final isPhoneChanged =
                                                isValueChanged(
                                                    userData?.phone
                                                            ?.phoneNumber ??
                                                        "",
                                                    phoneNumberController.text
                                                        .replaceAll(" ", ""));
                                            if (!value && isPhoneChanged) {
                                              updateUserInfo(userData);
                                              return;
                                            } else if (value &&
                                                isEmailChanged) {
                                              updateUserInfo(userData);
                                              return;
                                            } else {
                                              setState(() =>
                                                  isPhoneSelected = value);
                                            }
                                          },
                                    onDobUpdate: (formattedDate) => setState(
                                        () =>
                                            dobController.text = formattedDate),
                                    onCounrtyCodeChanged: (CountryCode code) {
                                      alphaCode = code.code ?? 'SA';
                                      countryCode = code.dialCode ?? '+966';
                                      debugPrint('dialCode $countryCode');
                                    },
                                    onDropdownValueChanged: !editProfile
                                        ? null
                                        : (String? value) {
                                            dropdownValue = value!;
                                            FocusManager.instance.primaryFocus
                                                ?.nextFocus();
                                            setState(() {});
                                          },
                                    onEditAccountInfoPressed: () {
                                      editProfile = !editProfile;
                                      setState(() {});
                                    },
                                    // onEditAccountInfoPressed: !editProfile
                                    //     ? () {
                                    //         editPassword = false;
                                    //         editProfile = !editProfile;
                                    //         FocusScope.of(context)
                                    //             .requestFocus(focusNode);
                                    //         setState(() {});
                                    //       }
                                    //     : () {
                                    //         editPassword = false;
                                    //         editProfile = !editProfile;
                                    //         // passwordFormKey.currentState!
                                    //         //     .reset();
                                    //         FocusScope.of(context)
                                    //             .requestFocus(focusNode);
                                    //         setState(() {});
                                    //       },
                                  ),
                                ),
                                // Edit Profile: Change Password Section
                                EditProfileChangePasswordSection(
                                  editPassword: editPassword,
                                  isEmailExist: isEmailExist,
                                  passwordFocusNode: passwordFocusNode,
                                  newPasswordFormKey: newPasswordFormKey,
                                  oldPasswordController: oldPasswordController,
                                  newPasswordController: newPasswordController,
                                  confirmPasswordController:
                                      confirmPasswordController,
                                  onEditPasswordPressed: !editPassword
                                      ? () {
                                          editProfile = false;
                                          editPassword = !editPassword;
                                          FocusScope.of(context)
                                              .requestFocus(passwordFocusNode);
                                          setState(() {});
                                        }
                                      : () {
                                          setState(() {
                                            editProfile = false;
                                            editPassword = !editPassword;
                                            newPasswordFormKey.currentState!
                                                .reset();
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          });
                                        },
                                ),
                                // Edit Profile: Change Preferred Station Section
                                EditProfileChangePreferredStationSection(
                                  preferredShopDetails:
                                      userData?.preferredShopDetails,
                                  onEditPreferredStationPressed: () {
                                    editProfile = false;
                                    editPassword = false;
                                    FocusManager.instance.primaryFocus!
                                        .unfocus();
                                    setState(() {});
                                    updateStation(context, ref);
                                  },
                                ),
                                // Edit Profile: Change Newsletter Section
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: CustomText(
                                    text: "Newsletter".tr(),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const CustomGreyDivider(),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: CustomText(
                                        text:
                                            "Subscribe to the newsletter and get the latest product updates!"
                                                .tr(),
                                        height: 2,
                                        fontSize: 10,
                                        overflow: TextOverflow.clip,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF898989),
                                      ),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    Switch(
                                      value: isNewsLetterEnabled,
                                      overlayColor: WidgetStatePropertyAll(
                                          primaryColor.withValues(alpha: 0.23)),
                                      activeColor: primaryColor,
                                      thumbColor: const WidgetStatePropertyAll(
                                          Colors.white),
                                      onChanged: (value) async {
                                        isNewsLetterEnabled =
                                            !isNewsLetterEnabled;
                                        final data = {
                                          "subscribe":
                                              isNewsLetterEnabled ? 1 : 0
                                        };
                                        final future = NewsLetterService()
                                            .updateNewsLetter(data);
                                        try {
                                          await LoadingDialog.show(
                                              context, future);
                                          ref
                                              .read(authProvider.notifier)
                                              .updateNewsLetter(
                                                  isNewsLetterEnabled);
                                          setState(() {});
                                        } catch (e) {
                                          if (!mounted) return;
                                          CustomSnackBar.error(
                                              context, e.toString());
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30.03),
                                // Edit Profile: Save Button Section
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 19),
                                    child: editProfile || editPassword
                                        ? CustomButton(
                                            height: 42,
                                            width: size(context).width,
                                            title: "Save".tr(),
                                            onTap: editPassword
                                                ? () async {
                                                    if (newPasswordFormKey
                                                        .currentState!
                                                        .validate()) {
                                                      Map<String, dynamic>
                                                          result = {
                                                        "old_password":
                                                            oldPasswordController
                                                                .text,
                                                        "new_password":
                                                            newPasswordController
                                                                .text,
                                                        "confirm_password":
                                                            confirmPasswordController
                                                                .text,
                                                      };
                                                      FormData newPasswordData =
                                                          FormData.fromMap(
                                                              result);

                                                      try {
                                                        final future = ref
                                                            .read(authProvider
                                                                .notifier)
                                                            .updateUserPassword(
                                                                newPasswordData);
                                                        await LoadingDialog
                                                            .show(context,
                                                                future);
                                                        if (mounted) {
                                                          CustomSnackBar.success(
                                                              context,
                                                              "User password updated successfully");
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      } catch (e) {
                                                        if (!mounted) return;
                                                        if (e.toString().contains(
                                                            'Old password')) {
                                                          showClearProductDialog(
                                                            context,
                                                            message: CustomText(
                                                              text:
                                                                  "Your old password is incorrect, do you want to Log Out and Reset Password"
                                                                      .tr(),
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  'Poppins',
                                                              color: Colors
                                                                  .black87,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                            yesPressed:
                                                                () async {
                                                              final future = ref
                                                                  .read(authProvider
                                                                      .notifier)
                                                                  .logout();
                                                              if (!mounted)
                                                                return;
                                                              await LoadingDialog
                                                                  .show(context,
                                                                      future);
                                                              if (mounted) {
                                                                await preferences
                                                                    .remove(
                                                                        "token");
                                                                await preferences
                                                                    .clear();
                                                                AppConfig
                                                                        .token =
                                                                    null;
                                                                if (!mounted)
                                                                  return;
                                                                Navigator.pushAndRemoveUntil(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => const SignInPage(
                                                                              fromAccount: true,
                                                                            )),
                                                                    (route) => false);
                                                              }
                                                            },
                                                          );
                                                        } else {
                                                          CustomSnackBar.error(
                                                              context,
                                                              e.toString());
                                                        }
                                                      }
                                                    }
                                                  }
                                                : () async {
                                                    // To Validate phone number if they are not empty
                                                    if (isPhoneSelected &&
                                                        !(accountFormKey
                                                                    .currentState !=
                                                                null &&
                                                            accountFormKey
                                                                .currentState!
                                                                .validate())) {
                                                      return;
                                                    }
                                                    // To Validate the email, new password, and re - password if they are not empty
                                                    if (!isPhoneSelected &&
                                                        !(passwordFormKey
                                                                    .currentState !=
                                                                null &&
                                                            passwordFormKey
                                                                .currentState!
                                                                .validate())) {
                                                      return;
                                                    }
                                                    updateUserInfo(userData);
                                                  },
                                          )
                                        : Column(children: [
                                            InkWell(
                                              onTap: () async {
                                                try {
                                                  final bool deleteAccount =
                                                      await showDeleteProfileDialog(
                                                          context);
                                                  if (!deleteAccount) return;
                                                  final future = ref
                                                      .read(
                                                          authProvider.notifier)
                                                      .deleteUser();
                                                  if (!mounted) return;
                                                  await LoadingDialog.show(
                                                      context, future);
                                                  if (mounted) {
                                                    CustomSnackBar.success(
                                                        context,
                                                        "User deleted successfully");
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const SignInPage(),
                                                            ),
                                                            (route) => false);
                                                  }
                                                } catch (e) {
                                                  if (!mounted) return;
                                                  CustomSnackBar.error(
                                                      context, e.toString());
                                                }
                                              },
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              child: Container(
                                                height: 42,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: primaryColor)),
                                                child: CustomText(
                                                  text:
                                                      "Delete My Account".tr(),
                                                  color: primaryColor,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 14.92),
                                            CustomButton(
                                                height: 42,
                                                width: size(context).width,
                                                title: "Logout".tr(),
                                                onTap: () async {
                                                  try {
                                                    final future = ref
                                                        .read(authProvider
                                                            .notifier)
                                                        .logout();
                                                    if (!mounted) return;
                                                    await LoadingDialog.show(
                                                        context, future);
                                                    if (mounted) {
                                                      await preferences
                                                          .remove("token");
                                                      clearPreferencesExceptLanguage;
                                                      AppConfig.token = null;
                                                      if (!mounted) return;
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const SignInPage(),
                                                              ),
                                                              (route) => false);
                                                    }
                                                  } catch (e) {
                                                    if (!mounted) return;
                                                    CustomSnackBar.error(
                                                        context, e.toString());
                                                  }
                                                }),
                                          ])),
                                kHeight30,
                              ]),
                        ]),
                error: (error, stack) => CustomReloadProvider(
                    height: 118, onPressed: () => ref.refresh(authProvider)),
                loading: () => const SizedBox(
                    height: 157,
                    child: Center(child: CustomIndicator(padding: 50))))));
  }

  Future<void> updateStation(BuildContext context, WidgetRef ref) async {
    final Location location = Location();
    PermissionStatus givenPermission = await location.hasPermission();
    debugPrint(givenPermission.toString());
    if (givenPermission == PermissionStatus.granted) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const StationMapScreen(
                    fetchLocation: true, isFromSignUp: false)));
      });
    } else {
      givenPermission = await location.requestPermission();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LocationPermissionScreen(
                    onPressed: () async {
                      AppSettings.openAppSettings(
                          type: AppSettingsType.location);
                    },
                    isFromSignUp: false)));
      });
    }
  }

  Future<void> clearPreferencesExceptLanguage() async {
    int? languageIndex = preferences.getInt(LocalStorage.language);

    await preferences.clear();

    if (languageIndex != null) {
      await preferences.setInt(LocalStorage.language, languageIndex);
    }
  }
}
