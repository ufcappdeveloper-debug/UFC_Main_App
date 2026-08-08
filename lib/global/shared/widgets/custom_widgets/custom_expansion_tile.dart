import 'dart:io';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/extensions/app_png_images.dart';
import 'package:ufc_mobile/global/language_cubit/language_cubit.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/profile_widgets/editable_profile_image.dart';
import 'package:ufc_mobile/global/util/storage/local_storage.dart';
import 'package:ufc_mobile/screens/feed/application/productList/product_list_cubit.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/pages/feed_address_page.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/pages/feed_favorite_page.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/pages/feed_my_orders_page.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/pages/feed_support_screen.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/pages/feed_wallet_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_shadows.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/utils/saudi_phone_formatter.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/doctor_tabs_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/pet_vet_bottom_bar.dart';

import '../../../../main.dart';
import '../../../../screens/farm/domain/entities/farm_profile_items.dart';
import '../../../../screens/farm/presentation/farm_profile/about_terms_privacy.dart';
import '../../../../screens/farm/presentation/farm_profile/barn.dart';
import '../../../../screens/farm/presentation/farm_profile/members_page.dart';
import '../../../../screens/farm/presentation/farm_profile/reposts.dart';
import '../../../../screens/feed/application/authentication/auth_cubit.dart';
import '../../../../screens/feed/application/bottom_bar_bloc/bottom_bar_bloc.dart';
import '../../../../screens/feed/application/cart/cart_cubit.dart';
import '../../../../screens/feed/application/navbar/app_bar_cubit.dart';
import '../../../../screens/feed/application/notification/notification_cubit.dart';
import '../../../../screens/feed/presentation/profile/pages/feed_contact_us_page.dart';
import '../../../../screens/feed/presentation/profile/pages/feed_notification_screen.dart';
import '../../../../screens/landing_page.dart';
import '../../../config/config.dart';
import '../../../extensions/app_colors.dart';
import '../../constants/constants.dart';
import '../../constants/custom_loading_dialog.dart';
import '../../translations/l10n.dart';
import '../show_confirmation_dailog.dart';

class CustomExpansionTile extends ConsumerStatefulWidget {
  final String icon;
  final String title;
  final List<FarmProfileChildItem> children;
  final Function() onLanguageChange;
  final Future<bool> Function(Map<String, dynamic> updatedData)? onSavePressed;
  // bool isExpanded;
  final Function(bool) onExpansionChanged;
  final bool isFromVet;
  final bool isFromFarm;

  const CustomExpansionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
    required this.onLanguageChange,
    this.onSavePressed,
    // this.isExpanded = false,
    required this.onExpansionChanged,
    this.isFromVet = false,
    this.isFromFarm = false,
  });

  @override
  ConsumerState<CustomExpansionTile> createState() =>
      _CustomExpansionTileState();
}

class _CustomExpansionTileState extends ConsumerState<CustomExpansionTile> {
  bool isExpanded = false;
  String? selectedLanguage;
  late TextEditingController newPassController;
  late TextEditingController confirmPassController;
  bool passwordEdit = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? currentPasswordError;
  String? newPasswordError;
  String? confirmPasswordError;

  int langIndex = 0;
  List<String> languageData = ["English", "Arabic", "Urdu"];

  Map<String, WidgetBuilder> get routesMap => {
        'Members': (context) => MembersPage(),
        'Reports': (context) => RepostsPage(),
        'Contact Us': (context) => FeedContactPage(
              isFromVet: widget.isFromVet,
              isFromFarm: widget.isFromFarm,
            ),
        'Barns': (context) => BarnPage(),
        // 'Medical Record': (context) => MedicalRecords(), // do uncomment after api implement
        'My Wallet': (context) => FeedWalletScreen(),
        'My Orders': (context) => FeedMyOrdersPage(),
        'Favorites': (context) => FeedFavoritePage(),
        'Address': (context) => AddressScreen(),
        'Notifications': (context) => FeedNotificationScreen(),
        'Support': (context) => FeedSupportScreen(
              isFromFarm: widget.isFromFarm,
              isFromVet: widget.isFromVet,
            ),
        'About App': (context) => AboutTermsPrivacy(
              title: 'About App',
              info: [
                InfoSection(title: 'About UFC App', description: [
                  'UFC - United Farm Center is an intelligent, integrated system designed to simplify livestock farming management, including enclosures and veterinary care. Our goal is to empower farm owners and workers to monitor all daily details accurately and easily, helping improve efficiency, productivity, and overall livestock health.'
                ]),
                InfoSection(title: 'For more informations', description: [])
              ],
              isFromFarm: widget.isFromFarm,
              isFromVet: widget.isFromVet,
            ),
        'Terms and conditions': (context) =>
            AboutTermsPrivacy(title: 'Terms and conditions', info: [
              InfoSection(title: 'App Usage', description: [
                "The app is used for managing livestock farms, monitoring enclosures, veterinary care, and organizing daily operations.",
                "Users are responsible for the accuracy of the data entered into the app.",
                "The app must not be used for any illegal or unethical activities.",
              ]),
              InfoSection(title: 'Data & Information', description: []),
              InfoSection(title: 'Subscriptions & Payments', description: []),
              InfoSection(title: 'Technical Support & Updates', description: [
                "(The United Feed Company may make updates or releases that will develop the application, and we may automatically upgrade the version of the application. We may also change, expand and improve the application, and we may at any time stop operating it partially or completely or selectively disable certain functions in the application, and the United Feed Company does not bear any responsibility as a result of that.)"
              ]),
            ]),
        'Privacy Policy': (context) =>
            AboutTermsPrivacy(title: 'Privacy Policy', info: [
              InfoSection(
                title: "Privacy Policy - UFC App",
                description: [
                  "(United Company is committed to protecting your privacy and ensuring the security of your personal information. This policy outlines how we collect, use, and protect the information you provide to us. By using our services, you consent to the practices described in this privacy statement.)"
                  // "Your privacy matters to us. This privacy policy aims to clarify how we collect, use, and protect your personal information while using the UFC - United Farm Center app."
                ],
              ),
              InfoSection(
                title: "Information we collect",
                description: [
                  "(Our website may contain links to external websites. We note that we are not responsible for the privacy practices or content of those websites. We urge you to review the privacy statements of any website that collects information or requests your personal data.)"
                ],
              ),
              InfoSection(
                title: "How we use information",
                description: [
                  "(We at United Feed Company take the security and privacy of your personal information seriously. We have implemented measures to safeguard your data and protect it from unauthorized access, disclosure, alteration, or destruction. We may disclose your information to third-party service providers we use to support our business operations. In addition, we may disclose your personal information to respond to requests from relevant government or regulatory authorities, enforce our Terms of Use, and protect the rights of United Feed Company for the purpose of accuracy.)"
                ],
              ),
              InfoSection(
                title: "Do we share your data with others?",
                description: [
                  "Regarding restrictions on use:",
                  "(Anything that constitutes a violation of the Anti-Cybercrime Law or related regulations in force in the Kingdom of Saudi Arabia).",
                  "(Create any electronic links to the United Feed Company website or display or place them on any website, unless you obtain written permission from the United Feed Company)."
                ],
              ),
            ])
      };

  void _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime today = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(1900),
      lastDate: today, // prevent picking future dates
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  bool isSpecialField(FarmProfileChildItem child) {
    final label = child.label?.toLowerCase();
    return label == "date of birth" || label == "gender";
  }

  TextInputType getKeyboardType(FarmProfileChildItem child) {
    final label = child.label?.toLowerCase();
    if (label == 'phone number') return TextInputType.phone;
    return TextInputType.text;
  }

  void _selectGender(BuildContext context, FarmProfileChildItem child) async {
    final gender = await showModalBottomSheet<String>(
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['male', 'female'].map((key) {
              return ListTile(
                title: Text(key.tr()),
                onTap: () => Navigator.pop(context, key),
              );
            }).toList(),
          ),
        );
      },
    );

    if (gender != null) {
      setState(() {
        child.controller?.text = gender.tr();
        child.isEditing = true;
      });
    }
  }

  void _loadSelectedLanguage() {
    if (!mounted) return;
    final savedLangIndex = preferences.getInt(LocalStorage.language);
    setState(() {
      if (savedLangIndex != null) {
        if (savedLangIndex < languageData.length) {
          selectedLanguage = languageData[savedLangIndex];
          langIndex = savedLangIndex;
        } else {
          selectedLanguage = null;
        }
      }
    });
  }

  Widget textField(FarmProfileChildItem child,
      {TextEditingController? controller,
      FormFieldValidator<String?>? valid,
      String? hint}) {
    bool isPhone = getKeyboardType(child) == TextInputType.phone;
    return SizedBox(
        child: TextFormField(
      textAlign: isArOrUr ? TextAlign.right : TextAlign.left,
      textDirection: isPhone
          ? ui.TextDirection.ltr
          : (isArOrUr ? ui.TextDirection.rtl : ui.TextDirection.ltr),
      obscureText: false,
      enabled: child.isEditing,
      // enabled: child.isEditing,
      controller: controller ?? child.controller,
      focusNode: controller == null ? child.focusNode : null,
      readOnly: isSpecialField(child),
      inputFormatters: isPhone ? [SaudiPhoneFormatter()] : [],
      validator: (v) => valid?.call(v),
      onTap: () {
        final label = child.label?.toLowerCase();
        if (label == 'date of birth') {
          _selectDate(context, child.controller!);
        } else if (label == 'gender') {
          _selectGender(context, child);
        }
      },
      keyboardType: isPhone ? TextInputType.number : getKeyboardType(child),
      style: TextStyle(
          fontWeight: FontWeight.w400,
          color: PetVeterinaryColors.newPetDarkGray,
          fontFamily:
              isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
          fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        isDense: true,
      ),
    ));
  }

  @override
  void initState() {
    newPassController = TextEditingController();
    confirmPassController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContainer(
      child: Column(
        children: [
          _buildHeader(context),
          if (isExpanded) ...[
            const SizedBox(height: 18),
            _buildChildrenList(context),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => isExpanded = !isExpanded),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            widget.icon,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.title.tr(),
              style: PetVeterinaryFontstyles2.getMediumStyle(context, 15),
            ),
          ),
          Icon(
            isExpanded ? Icons.expand_less : Icons.expand_more,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildChildrenList(BuildContext context) {
    final hasEditing = widget.children.any((c) => c.isEditing);

    // Split children into 2 groups: non-password and password
    final nonPasswordChildren = widget.children
        .where((child) => child.label?.toLowerCase() != 'password')
        .toList();

    final passwordChildren = widget.children
        .where((child) => child.label?.toLowerCase() == 'password')
        .toList();

    return Column(
      children: [
        // 🔹 All non-password fields
        ...nonPasswordChildren.map((child) => _buildChildItem(context, child)),

        // 🔹 Save button (only if editing)
        if (hasEditing) _buildSaveButton(context),

        // 🔹 Password field(s)
        ...passwordChildren.map((child) => _buildChildItem(context, child)),
      ],
    );
  }

  Widget _buildChildItem(BuildContext context, FarmProfileChildItem child) {
    final isPassword = child.label?.toLowerCase() == 'password';
    final spaceRequired = !child.isEditing && child != widget.children.last;

    if (child.value == "Language") {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _loadSelectedLanguage());
    }

    return GestureDetector(
      onTap: () {
        if (child.value == "Delete Account") {
          _handleDeleteAccount(context, widget.isFromFarm, widget.isFromVet);
        } else {
          onTapNavigateTo(child);
        }
      },
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: !child.isEditing
                      ? child != widget.children.last
                          ? 10
                          : isPassword
                              ? 4
                              : 16
                      : child != widget.children.last
                          ? 8
                          : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: _buildChildForm(
                          context, child, isPassword, child.isEditing)),
                  _buildTrailingWidget(context, child, isPassword),
                ],
              ),
            ),
            if (child != widget.children.last &&
                !child.isEditing &&
                !isPassword &&
                !child.isProfilePic)
              const Divider(
                  height: 1, color: PetVeterinaryColors.newPetLightGray),
            if (spaceRequired)
              SizedBox(
                height: 12,
              )
          ],
        ),
      ),
    );
  }

  Widget _buildChildForm(BuildContext context, FarmProfileChildItem child,
      bool isPassword, bool isEditable) {
    // Only wrap in a container if editable and not a password
    final bool shouldWrap =
        isEditable && !isPassword && child.controller != null;

    if (isPassword && passwordEdit) {
      return _buildPasswordEditSection(context, child);
    }

    if (child.isProfilePic)
      return EditableProfileImage(
        imageUrl: child.value,
        localImagePath: child.localImagePath,
        isEditable: isEditable,
        onImageSelected: (path) {
          setState(() {
            child.localImagePath = path;
          });
        },
      );

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (child.label != null)
          Text(
            (child.label ?? '').tr(),
            style: PetVeterinaryFontstyles2.getLightStyle(context, 13)
                .copyWith(color: PetVeterinaryColors.newPetLightGray),
          ),
        child.controller != null
            ? SizedBox(
                child: textField(
                  child,
                ),
              )
            : CustomText(
                color: child.color ?? PetVeterinaryColors.newPetDarkGray,
                text: child.value,
                fontSize: 16,
              ),
      ],
    );

    if (shouldWrap) {
      content = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: PetVeterinaryColors.newPetLightGray),
          borderRadius: BorderRadius.circular(10),
        ),
        child: content,
      );
    }

    return content;
  }

  Widget _buildPasswordEditSection(
    BuildContext context,
    FarmProfileChildItem child,
  ) {
    final Color buttonColor = widget.isFromVet
        ? PetVeterinaryColors.newPetMainColorVeterinary
        : widget.isFromFarm
            ? AppColors.farmColor
            : primaryColor;

    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Close icon row, only when editing password
            if (passwordEdit)
              Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          passwordEdit = false;
                          child.controller?.text = '********';
                          newPassController.clear();
                          confirmPassController.clear();
                        });
                      },
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: PetVeterinaryColors.newPetDarkGray,
                      ),
                    ),
                  ],
                ),
              ),

            _buildPasswordFieldSection(
              context: context,
              title: 'Current Password',
              controller: child.controller!,
              validator: (value) {
                if (value == null || value.isEmpty) return "Required".tr();
                if (value.length < 6) return "At least 6 characters".tr();
                return null;
              },
              onErrorChanged: (err) => currentPasswordError = err,
            ),
            SizedBox(
              height: 12,
            ),

            _buildPasswordFieldSection(
              context: context,
              title: 'New Password',
              controller: newPassController,
              validator: (value) {
                if (value == null || value.isEmpty) return "Required".tr();
                if (value.length < 6) return "At least 6 characters".tr();
                return null;
              },
              onErrorChanged: (err) => newPasswordError = err,
            ),
            SizedBox(
              height: 12,
            ),

            _buildPasswordFieldSection(
              context: context,
              title: 'Confirm New Password',
              controller: confirmPassController,
              validator: (value) {
                if (value == null || value.isEmpty) return "Required".tr();
                if (value.length < 6) return "At least 6 characters".tr();
                if (value != newPassController.text)
                  return "Must match new password".tr();
                return null;
              },
              onErrorChanged: (err) => confirmPasswordError = err,
            ),
            kHeight10,

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextButton(
                  onPressed: () {
                    // TODO: Handle forgot password action
                    print("Forgot Password tapped");
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text('Forgot Password?'.tr(),
                      style: PetVeterinaryFontstyles2.getRegularStyle(
                              context, 14)
                          .copyWith(color: PetVeterinaryColors.mainColorUFC)),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),

            // 🟢 Update Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is UpdatePasswordSuccess) {
                      newPassController.clear();
                      confirmPassController.clear();
                      CustomSnackBar.success(
                          context, 'Password reset successfully');
                      setState(() => passwordEdit = false);
                      child.controller?.text = '********';
                    } else if (state is UpdatePasswordError) {
                      CustomSnackBar.error(context, state.message);
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                        title: 'Update Password',
                        height: 37,
                        width: double.infinity,
                        color: buttonColor,
                        radius: 12,
                        isLoading: state is UpdatePasswordLoading,
                        onTap: () async {
                          final currentErr = currentPasswordError ??
                              ((child.controller!.text.isEmpty)
                                  ? "Required".tr()
                                  : null);

                          final newErr = newPasswordError ??
                              ((newPassController.text.isEmpty)
                                  ? "Required".tr()
                                  : null);

                          final confirmErr = confirmPasswordError ??
                              ((confirmPassController.text.isEmpty)
                                  ? "Required".tr()
                                  : null);

                          if (currentErr != null ||
                              newErr != null ||
                              confirmErr != null) return;
                          final data = {
                            "old_password": child.controller?.text ?? '',
                            "new_password": newPassController.text,
                            "confirm_password": confirmPassController.text,
                          };
                          final future =
                              context.read<AuthCubit>().updatePassword(data);
                          await LoadingDialog.show(context, future);
                        });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordFieldSection({
    required BuildContext context,
    required String title,
    required TextEditingController controller,
    required String? Function(String?) validator,
    void Function(String?)? onErrorChanged,
  }) {
    bool obscure = true;
    String? errorText;

    return StatefulBuilder(
      builder: (context, setState) {
        void updateError(String? error) {
          if (errorText != error) {
            setState(() => errorText = error);
            if (onErrorChanged != null) onErrorChanged(error);
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(
                  color: errorText == null
                      ? PetVeterinaryColors.newPetLightGray
                      : Colors.redAccent,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Label
                  Text(
                    title.tr(),
                    style: PetVeterinaryFontstyles2.getLightStyle(context, 12)
                        .copyWith(color: PetVeterinaryColors.newPetLightGray),
                  ),
                  // Text Input
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      obscureText: obscure,
                      validator: (value) {
                        final result = validator(value);
                        WidgetsBinding.instance
                            .addPostFrameCallback((_) => updateError(result));
                        return null; // prevent TextFormField error space
                      },
                      onChanged: (value) {
                        final result = validator(value);
                        updateError(result);
                      },
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        height: 1.1,
                      ),
                      decoration: InputDecoration(
                        errorText: null,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        suffixIconConstraints:
                            const BoxConstraints(minWidth: 30, minHeight: 30),
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(minWidth: 30, minHeight: 30),
                          icon: Icon(
                            obscure ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() => obscure = !obscure);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Validator message below container
            AnimatedOpacity(
              opacity: errorText == null ? 0 : 1,
              duration: const Duration(milliseconds: 250),
              child: errorText == null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(left: 4, top: 4),
                      child: Text(
                        errorText!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                          height: 1,
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTrailingWidget(
      BuildContext context, FarmProfileChildItem child, bool isPassword) {
    // ✅ Don't show edit icon for password if email is empty
    bool canEditPassword = true;
    if (isPassword) {
      // Try to find the email child
      final emailChild = widget.children.firstWhere(
        (c) => c.label?.toLowerCase() == 'email',
        orElse: () => FarmProfileChildItem(label: 'email', value: ''),
      );
      if ((emailChild.value).isEmpty) {
        canEditPassword = false;
      }
    }

    bool showEditIconForThisChild = child.showEditIcon &&
        ((isPassword && !passwordEdit && canEditPassword) ||
            (!isPassword && !child.isEditing));

    if (showEditIconForThisChild) {
      return GestureDetector(
        onTap: () {
          if (isPassword && !passwordEdit) {
            setState(() {
              passwordEdit = true;
              child.controller?.clear();
            });
          } else {
            setState(() {
              for (var item in widget.children) {
                item.isEditing = true;
              }
            });
          }
        },
        child: Image.asset(
          AppPngImages.profileEditPngIcon,
          width: 18,
          height: 18,
        ),
      );
    }

    if (child.needArrow == true) {
      return GestureDetector(
        onTap: () => onTapNavigateTo(child),
        child: Icon(Icons.arrow_forward_ios,
            size: 16, color: PetVeterinaryColors.newPetLightGray),
      );
    }

    if (child.value == 'Language') return languageDropdown(context);
    if (child.value == 'Theme') {
      return Image.asset(
        AppPngImages.profileEditPngIcon,
        width: 18,
        height: 18,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildSaveButton(BuildContext context) {
    final Color buttonColor = widget.isFromVet
        ? PetVeterinaryColors.newPetMainColorVeterinary
        : widget.isFromFarm
            ? AppColors.farmColor
            : primaryColor;

    return GestureDetector(
      onTap: () async {
        final updatedData = await _collectUpdatedData();
        if (updatedData == null) return;
        await widget.onSavePressed?.call(updatedData);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        margin: const EdgeInsets.only(top: 12, bottom: 18, left: 16, right: 16),
        height: 37,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          "Save".tr(),
          style: PetVeterinaryFontstyles2.getRegularStyle(context, 14)
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> _collectUpdatedData() async {
    final phoneChild = widget.children.firstWhere(
      (c) => c.label?.toLowerCase() == 'phone number',
      orElse: () => FarmProfileChildItem(
        label: 'Phone Number',
        controller: TextEditingController(text: ''),
        value: '',
      ),
    );

    final fullPhone = phoneChild.controller?.text ?? '';
    final phoneParts = fullPhone.trim().split(RegExp(r'\s+'));

    String countryCode = '';
    String phoneNumber = '';

    if (phoneParts.length >= 2) {
      countryCode = phoneParts[0].replaceAll(RegExp(r'[^\d+]'), '');
      phoneNumber = phoneParts[1].replaceAll(RegExp(r'\D'), '');
    } else if (phoneParts.length == 1) {
      phoneNumber = phoneParts[0].replaceAll(RegExp(r'\D'), '');
    }

    final updatedData = <String, dynamic>{};

    for (var child in widget.children) {
      if (child.controller != null &&
          child.label != null &&
          child.label?.toLowerCase() != 'password') {
        final key = child.label!.toLowerCase().replaceAll(' ', '_');
        final value = child.controller!.text.trim();

        if ((key == 'date_of_birth' || key == 'dob') && value.isNotEmpty) {
          try {
            final parsedDate = DateFormat('dd-MM-yyyy').parseStrict(value);
            final today = DateTime.now();
            int age = today.year - parsedDate.year;

            if (today.month < parsedDate.month ||
                (today.month == parsedDate.month &&
                    today.day < parsedDate.day)) {
              age--;
            }

            if (age < 18) {
              Fluttertoast.showToast(
                msg: 'minimum_age_required'.tr(),
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
              return null;
            }

            updatedData['dob'] = DateFormat('yyyy-MM-dd').format(parsedDate);
          } catch (_) {}
        } else if (key == 'gender' && value.isNotEmpty) {
          final val = value.toLowerCase();
          if (val == 'male' || val == 'ذكر') {
            updatedData['gender'] = 'Male';
          } else if (val == 'female' || val == 'أنثى') {
            updatedData['gender'] = 'Female';
          } else {
            updatedData['gender'] = value;
          }
        } else {
          updatedData[key == 'date_of_birth' ? 'dob' : key] = value;
        }
      }

      if (child.isProfilePic && child.localImagePath != null) {
        try {
          final file = File(child.localImagePath!);
          final bytes = await file.readAsBytes();
          final image = img.decodeImage(bytes);

          if (image != null) {
            final jpgBytes = img.encodeJpg(image, quality: 85);

            // Ensure the file has .jpg extension
            final jpgFilePath = file.path.endsWith('.jpg')
                ? file.path
                : file.path.replaceAll(RegExp(r'\.\w+$'), '.jpg');

            final jpgFile = File(jpgFilePath);
            await jpgFile.writeAsBytes(jpgBytes);
            updatedData['profile_image'] = jpgFile;
          }
        } catch (e) {
          print('Failed to process profile image: $e');
        }
      }
    }

    updatedData['phone_number'] = phoneNumber;
    updatedData['country_code'] = countryCode != ''
        ? countryCode
        : phoneNumber != ''
            ? '+966'
            : null;

    return updatedData;
  }

  void onTapNavigateTo(FarmProfileChildItem child) {
    if (child.value == 'Language') return;

    if (child.value == 'Booked Appointments') {
      if (widget.isFromFarm) {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => const DoctorTabsScreen(isFromFarm: true),
          ),
        );
      } else {
        context.read<SelectedAppbarItemCubit>().setIndex(1);
        ref.read(petVetTabIndexProvider.notifier).state = 2;
      }
      return;
    }

    // Check if there's a route for this child
    final routeBuilder = routesMap[child.value];
    if (routeBuilder != null) {
      Navigator.of(context, rootNavigator: true)
          .push(
        MaterialPageRoute(builder: routeBuilder),
      )
          .then((v) {
        if (child.value == 'Favorites') {
          context.read<ProductListCubit>().getProducts();
        }
      });
    }
    // If no route, focus the TextField if it has a focus node
    else {
      if (child.focusNode != null) {
        child.focusNode!.requestFocus();
      } else {
        Fluttertoast.showToast(
          msg: 'No action available',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
      }
    }
  }

//   CustomFarmContainer languageDropdown(BuildContext context) {
//     return CustomFarmContainer(
//       height: 40,
//       padding: const EdgeInsets.all(6),
//       child: DropdownButton<String>(
//         alignment: Alignment.center,
//         elevation: 2,
//         value: selectedLanguage,
//         underline: const SizedBox.shrink(),
//         icon: selectedLanguage != null
//             ? SvgPicture.asset(selectedLanguage == 'Arabic'
//                 ? "assets/images/on_boarding/arabic_icon.svg"
//                 : selectedLanguage == 'English'
//                     ? "assets/images/on_boarding/english_icon.svg"
//                     : selectedLanguage == 'Urdu'
//                         ? "assets/images/on_boarding/urudu_icon.svg"
//                         : '')
//             : null,
//         hint: CustomText(
//           text: selectedLanguage ?? 'select_language',
//           fontSize: 16,
//           fontWeight: FontWeight.w300,
//           color: const Color(0xFF757575),
//         ),
//         onChanged: (String? value) {
//           selectedLanguage = value!;
//           langIndex = languageData.indexOf(selectedLanguage!);

//           context.read<LanguageCubit>().switchLanguage(
//                 context: context,
//                 localeString: L10n.all[langIndex].languageCode.toString(),
//               );

//           preferences.setInt(LocalStorage.language, langIndex);
//         },
//         items: languageData.map<DropdownMenuItem<String>>((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: CustomText(
//               text: value.tr(),
//               fontSize: 16,
//               fontWeight: FontWeight.w300,
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

  Widget languageDropdown(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLanguage,
          icon: const SizedBox.shrink(),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          onChanged: (String? value) {
            setState(() {
              selectedLanguage = value!;
              langIndex = languageData.indexOf(selectedLanguage!);

              context.read<LanguageCubit>().switchLanguage(
                    context: context,
                    localeString: L10n.all[langIndex].languageCode,
                  );

              preferences.setInt(LocalStorage.language, langIndex);
            });
          },
          selectedItemBuilder: (context) {
            return languageData.map((lang) {
              return Row(
                children: [
                  SvgPicture.asset(
                    lang == 'Arabic'
                        ? "assets/images/on_boarding/arabic_icon.svg"
                        : lang == 'English'
                            ? "assets/images/on_boarding/english_icon.svg"
                            : "assets/images/on_boarding/urudu_icon.svg",
                    width: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    lang.tr(),
                    style:
                        PetVeterinaryFontstyles2.getRegularStyle(context, 15),
                  ),
                ],
              );
            }).toList();
          },
          items: languageData.map((lang) {
            return DropdownMenuItem(
              value: lang,
              child: Row(
                children: [
                  SvgPicture.asset(
                    lang == 'Arabic'
                        ? "assets/images/on_boarding/arabic_icon.svg"
                        : lang == 'English'
                            ? "assets/images/on_boarding/english_icon.svg"
                            : "assets/images/on_boarding/urudu_icon.svg",
                    width: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(lang.tr()),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

void _handleDeleteAccount(
    BuildContext context, bool isFromFarm, bool isFromVet) async {
  final confirm = await showConfirmationDialog(
    context: context,
    title: 'Are you sure?',
    content: 'delete_account_confirmation',
    fromFarm: isFromFarm,
    isFromVet: isFromVet,
  );

  if (!confirm) return;

  try {
    final future = context.read<AuthCubit>().deleteAccount();
    await LoadingDialog.show(context, future);

    await preferences.clear();
    AppConfig.token = null;

    context.read<FeedBottomNavCubit>().changeTab(0);
    context.read<AppBarCubit>().setMode(AppBarMode.normal);
    context.read<NotificationCubit>().resetNotifications();
    context.read<CartCubit>().clearCart();

    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LandingPage()),
      (route) => false,
    );
  } catch (e) {
    if (!context.mounted) return;
    Fluttertoast.showToast(msg: 'Failed to delete account: ${e.toString()}');
  }
}

Widget _buildContainer({required Widget child}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: PetVeterinaryShadows.standard2,
      borderRadius: BorderRadius.circular(20),
    ),
    child: child,
  );
}
