import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ufc_mobile/global/extensions/app_png_images.dart';
import 'package:ufc_mobile/global/util/extension/localized_gender.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

import '../../../../screens/farm/domain/entities/farm_profile_items.dart';
import '../../../../screens/feed/application/authentication/auth_cubit.dart';
import '../custom_widgets/custom_expansion_tile.dart';

class AccountTile extends StatefulWidget {
  final bool isFromVet;
  final bool isFromFarm;
  const AccountTile({
    super.key,
    this.isFromVet = false,
    this.isFromFarm = false,
  });

  @override
  State<AccountTile> createState() => _AccountTileState();
}

class _AccountTileState extends State<AccountTile> {
  // Controllers
  bool _accountTileExpanded = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController =
      TextEditingController(text: '************');

  // FocusNodes
  final FocusNode nameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode dobFocus = FocusNode();
  final FocusNode occupationFocus = FocusNode();
  final FocusNode genderFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().loadProfile();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
    occupationController.dispose();
    genderController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();

    nameFocus.dispose();
    dobFocus.dispose();
    occupationFocus.dispose();
    genderFocus.dispose();
    emailFocus.dispose();
    phoneFocus.dispose();
    passwordFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ProfileEditSuccess) {
          final updatedUser = state.user;
          nameController.text = updatedUser.name ?? '';
          lastNameController.text = updatedUser.lastName ?? '';
          dobController.text = updatedUser.dob ?? '';

          genderController.text = localizedGender(context, updatedUser.gender);
          emailController.text = updatedUser.email?.email ?? '';
          occupationController.text = updatedUser.occupation ?? '';
          phoneController.text =
              '${updatedUser.phone?.countryCode ?? ''} ${updatedUser.phone?.phoneNumber ?? ''}';

          Fluttertoast.showToast(
            msg: state.message.toString().tr(),
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        } else if (state is ProfileEditFailure) {
          Fluttertoast.showToast(
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            msg: state.message.toString().tr(),
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      },
      builder: (context, state) {
        final user = context.read<AuthCubit>().currentUser;
        nameController.text = user?.name ?? '';
        lastNameController.text = user?.lastName ?? '';
        dobController.text = user?.dob ?? '';
        occupationController.text = user?.occupation ?? "";
        genderController.text = localizedGender(context, user?.gender);
        emailController.text = user?.email?.email ?? '';
        phoneController.text =
            '${user?.phone?.countryCode ?? ''} ${user?.phone?.phoneNumber ?? ""}';

        final normalizedCode =
            user?.phone?.countryCode?.replaceAll('+', '') ?? '';
        final displayCode = '+$normalizedCode';
        // final phoneDisplay = '${user?.phone?.phoneNumber ?? ''}$displayCode ';
        final phoneDisplay =
            '\u200E$displayCode ${user?.phone?.phoneNumber ?? ''}';

        final data = FarmProfileItems(
          icon: AppPngImages.profileAccountPngIcon,
          title: 'Account',
          children: user == null
              ? []
              : [
                  FarmProfileChildItem(
                    label: 'Profile Image',
                    isProfilePic: true,
                    value: user.profilePicture ?? '',
                    onImageSelected: (path) {
                      // _profileController.uploadProfileImage(path);
                    },
                  ),
                  FarmProfileChildItem(
                      label: 'Name',
                      value: user.name ?? '',
                      controller: nameController,
                      showEditIcon: true,
                      focusNode: nameFocus),
                  FarmProfileChildItem(
                      label: 'Last Name',
                      value: user.lastName ?? '',
                      controller: lastNameController,
                      focusNode: lastNameFocus),
                  FarmProfileChildItem(
                      label: 'Date of Birth',
                      value: user.dob ?? '',
                      controller: dobController,
                      focusNode: dobFocus),
                  FarmProfileChildItem(
                      label: 'Occupation',
                      value: user.occupation ?? "",
                      controller: occupationController,
                      focusNode: occupationFocus),
                  FarmProfileChildItem(
                      label: 'Gender',
                      value: user.gender ?? '',
                      controller: genderController,
                      focusNode: genderFocus),
                  FarmProfileChildItem(
                      label: 'Email',
                      value: user.email?.email ?? '',
                      //uncomment the below line to enable editing email
                      // controller: emailController,
                      focusNode: emailFocus),
                  /* FarmProfileChildItem(
                label: 'Password',
                value: user.email?.email ?? '',
                controller: emailController,
                focusNode: emailFocus),*/
                  FarmProfileChildItem(
                      label: 'Phone Number',
                      value: phoneDisplay,
                      //uncomment the below line to enable editing phone number
                      //  controller: phoneController,
                      focusNode: phoneFocus),
                  FarmProfileChildItem(
                      label: 'Password',
                      value: '************',
                      showEditIcon: true,
                      controller: passwordController,
                      focusNode: passwordFocus),
                ],
        );

        return Stack(
          children: [
            CustomExpansionTile(
              key: ValueKey('account_tile_$_accountTileExpanded'),
              icon: data.icon,
              title: data.title,
              children: data.children,
              // isExpanded: _accountTileExpanded,
              isFromFarm: widget.isFromFarm,
              isFromVet: widget.isFromVet,
              onExpansionChanged: (expanded) {
                setState(() {
                  _accountTileExpanded = expanded;
                  if (expanded) context.read<AuthCubit>().loadProfile();
                });
              },
              onSavePressed: (updatedData) async {
                final userId = context.read<AuthCubit>().currentUser?.id;
                if (userId == null) return false;

                await context.read<AuthCubit>().editUser(userId, updatedData);
                return true;
              },
              onLanguageChange: () {},
            ),
            if (state is ProfileEditLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withOpacity(0.4),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.3, end: 1),
                          duration: Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: child,
                            );
                          },
                          onEnd: () {
                            // Repeat animation for a looping effect
                          },
                          child: CircleAvatar(
                            radius: 3.5, // smaller dots
                            backgroundColor:
                                PetVeterinaryColors.newPetMainColorVeterinary,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
