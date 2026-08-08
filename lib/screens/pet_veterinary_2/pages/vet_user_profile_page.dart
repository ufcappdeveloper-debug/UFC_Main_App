// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ufc_mobile/global/extensions/app_png_images.dart';
// import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
// import 'package:ufc_mobile/global/shared/widgets/profile_widgets/logout_widget.dart';
// import 'package:ufc_mobile/global/util/common/common_utils.dart';
// import 'package:ufc_mobile/models/address_model.dart';
// import 'package:ufc_mobile/riverpod/auth/auth.dart';
// import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';
// import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
// import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
// import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';
// import 'package:ufc_mobile/screens/pet_veterinary_2/pages/pet_vet_bottom_bar.dart';
// import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/doctor_card_2.dart';

// class VetUserProfilePage extends ConsumerStatefulWidget {
//   const VetUserProfilePage({super.key});

//   @override
//   ConsumerState<VetUserProfilePage> createState() => _VetUserProfilePageState();
// }

// class _VetUserProfilePageState extends ConsumerState<VetUserProfilePage> {
//   bool isProfileExpanded = false;
//   bool isMedicalExpanded = false;
//   bool isSettingsExpanded = false;
//   String selectedLanguage = 'en';
//   bool isDarkModeEnabled = false;
//   bool isEditingProfile = false;
//   bool isEditingPassword = false;

//   bool _showNewPassword = false;
//   bool _showConfirmPassword = false;

//   @override
//   Widget build(BuildContext context) {
//     final user = ref.watch(authProvider).asData?.value;
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: SafeArea(
//           child: SingleChildScrollView(
//         padding: EdgeInsets.only(left: 20, right: 20, bottom: 120),
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             _buildProfileContainer(user),
//             const SizedBox(height: 20),
//             _buildMedicalRecordContainer(),
//             const SizedBox(height: 20),
//             _buildSettingsContainer(),
//             const SizedBox(height: 20),
//             // _buildLogoutContainer(),
//             LogoutWidget(
//               appType: AppType.veterinary,
//               isFromVet: true,

//             ),
//           ],
//         ),
//       )),
//     );
//   }

//   Widget _buildContainer({required Widget child}) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 8,
//             spreadRadius: 0.5,
//             offset: Offset(0, 2),
//           ),
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 12,
//             spreadRadius: 1,
//             offset: Offset(0, 4),
//           ),
//         ],
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: child,
//     );
//   }

//   Widget get _dividerWidget => Padding(
//         padding: const EdgeInsets.symmetric(vertical: 6),
//         child: Divider(
//           height: 1,
//           color: (isEditingProfile)
//               ? Colors.transparent
//               : PetVeterinaryColors.newPetLightGray,
//         ),
//       );

//   Widget _buildProfileContainer(UserModel? user) {
//     return _buildContainer(
//       child: Column(
//         children: [
//           GestureDetector(
//             onTap: () {
//               setState(() => isProfileExpanded = !isProfileExpanded);
//             },
//             child: Row(
//               children: [
//                 const CircleAvatar(
//                   radius: 10,
//                   backgroundColor: Colors.white,
//                   backgroundImage:
//                       AssetImage('assets/new_design/icons/profile.png'),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     'Account'.tr(),
//                     style: PetVeterinaryFontstyles2.getMediumStyle(context, 15),
//                   ),
//                 ),
//                 Icon(
//                   isProfileExpanded ? Icons.expand_less : Icons.expand_more,
//                   size: 24,
//                 ),
//               ],
//             ),
//           ),
//           if (isProfileExpanded) const SizedBox(height: 20),
//           if (isProfileExpanded && user != null)
//             Column(
//               children: [
//                 // Name field
//                 _buildProfileField(
//                   label: "Name",
//                   value: user.name ?? "N/A",
//                   canEdit: true,
//                   isPassword: false,
//                 ),
//                 _dividerWidget,
//                 const SizedBox(height: 8),

//                 // Other profile fields
//                 _buildProfileField(
//                     label: "Date of birth", value: user.dob ?? "N/A"),
//                 _dividerWidget,
//                 const SizedBox(height: 8),
//                 _buildProfileField(
//                     label: "Profession", value: user.occupation ?? "N/A"),
//                 _dividerWidget,
//                 const SizedBox(height: 8),
//                 _buildProfileField(
//                     label: "Gender", value: user.gender ?? "N/A"),
//                 _dividerWidget,
//                 const SizedBox(height: 8),
//                 _buildProfileField(
//                     label: "E-mail", value: user.email?.email ?? "N/A"),
//                 _dividerWidget,
//                 const SizedBox(height: 8),
//                 _buildProfileField(
//                     label: "Phone", value: user.phone?.phoneNumber ?? "N/A"),
//                 _dividerWidget,
//                 const SizedBox(height: 8),
//                 _buildProfileField(
//                     label: "Address",
//                     value: _formatPrimaryAddress(user.addresses)),
//                 _dividerWidget,
//                 const SizedBox(height: 8),

//                 if (isEditingProfile)
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 14, top: 2),
//                     child: CustomPetButton(
//                       text: "Save".tr(),
//                       onPressed: () {
//                         setState(() => isEditingProfile = false);
//                         // TODO: Save profile fields logic
//                       },
//                       backgroundColor:
//                           PetVeterinaryColors.newPetMainColorVeterinary,
//                       textStyle: PetVeterinaryFontstyles2.getRegularStyle(
//                         context,
//                         13,
//                         color: Colors.white,
//                       ),
//                       borderRadius: 8,
//                       horizontalPadding: 14,
//                       verticalPadding: 6,
//                       width: 109,
//                       height: 30,
//                     ),
//                   ),

//                 // Password field
//                 _buildProfileField(
//                   label: "Password",
//                   value: "••••••••",
//                   canEdit: true,
//                   isPassword: true,
//                 ),
//                 SizedBox(height: isEditingPassword ? 18 : 0),

//                 if (isEditingPassword)
//                   CustomPetButton(
//                     text: "Save Password".tr(),
//                     onPressed: () {
//                       setState(() => isEditingPassword = false);
//                       // TODO: Save password logic
//                     },
//                     backgroundColor:
//                         PetVeterinaryColors.newPetMainColorVeterinary,
//                     textStyle: PetVeterinaryFontstyles2.getRegularStyle(
//                       context,
//                       13,
//                       color: Colors.white,
//                     ),
//                     borderRadius: 8,
//                     horizontalPadding: 8,
//                     verticalPadding: 6,
//                     width: 150,
//                     height: 30,
//                   ),

//                 if (isEditingPassword) SizedBox(height: 12),
//               ],
//             ),
//         ],
//       ),
//     );
//   }

//   /// Helper to format an address string from AddressModel
//   String _formatPrimaryAddress(List<AddressModel>? addresses) {
//     if (addresses == null || addresses.isEmpty) return "N/A";

//     // Prefer default address if available
//     final addr = addresses.firstWhere(
//       (a) => a.isDefault == true,
//       orElse: () => addresses.first,
//     );

//     final parts = <String?>[
//       addr.address,
//       addr.landmark,
//       addr.city,
//       addr.alphaCode,
//     ].where((p) => p != null && p.trim().isNotEmpty).cast<String>().toList();

//     return parts.isEmpty ? "N/A" : parts.join(", ");
//   }

//   Widget _buildProfileField({
//     required String label,
//     required String value,
//     bool canEdit = false,
//     bool isPassword = false,
//   }) {
//     bool editableProfile = isEditingProfile && !isPassword;
//     bool editablePassword = isEditingPassword && isPassword;

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(label.tr(),
//                     style: PetVeterinaryFontstyles2.getLightStyle(context, 13)
//                         .copyWith(color: PetVeterinaryColors.newPetLightGray)),

//                 // Normal Profile Fields Editing
//                 if (editableProfile)
//                   TextField(
//                     controller: TextEditingController(text: value),
//                     decoration: const InputDecoration(
//                       isDense: true,
//                       border: UnderlineInputBorder(),
//                     ),
//                   )
//                 // Password Fields Editing
//                 else if (editablePassword)
//                   Column(
//                     children: [
//                       // Current password (always hidden)
//                       TextField(
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           hintText: "Current Password".tr(),
//                           border: const UnderlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 8),

//                       // New password with toggle
//                       TextField(
//                         obscureText: !_showNewPassword,
//                         decoration: InputDecoration(
//                           hintText: "New Password".tr(),
//                           border: const UnderlineInputBorder(),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _showNewPassword
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                               size: 18,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _showNewPassword = !_showNewPassword;
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 8),

//                       // Confirm new password with toggle
//                       TextField(
//                         obscureText: !_showConfirmPassword,
//                         decoration: InputDecoration(
//                           hintText: "Confirm New Password".tr(),
//                           border: const UnderlineInputBorder(),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _showConfirmPassword
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                               size: 18,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _showConfirmPassword = !_showConfirmPassword;
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   )

//                 // Normal view
//                 else
//                   Text(value,
//                       style: PetVeterinaryFontstyles2.getRegularStyle(
//                               context, 15)
//                           .copyWith(color: PetVeterinaryColors.newPetDarkGray)),
//               ],
//             ),
//           ),

//           // 👇 Show edit/un-edit toggle only if allowed
//           if (canEdit)
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   if (isPassword) {
//                     isEditingPassword = !isEditingPassword;
//                     isEditingProfile = false;
//                   } else {
//                     isEditingProfile = !isEditingProfile;
//                     isEditingPassword = false;
//                   }
//                 });
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 4),
//                 child: (isPassword && isEditingPassword) ||
//                         (!isPassword && isEditingProfile)
//                     ? Icon(
//                         Icons.close,
//                         size: 18,
//                       )
//                     : Image.asset(
//                         AppPngImages.profileEditPngIcon,
//                         width: 18,
//                         height: 18,
//                       ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMedicalRecordContainer() {
//     return _buildContainer(
//       child: Column(
//         children: [
//           GestureDetector(
//             onTap: () {
//               setState(() => isMedicalExpanded = !isMedicalExpanded);
//             },
//             child: Row(
//               children: [
//                 Image.asset(
//                   'assets/new_design/icons/medical_icon.png',
//                   width: 24,
//                   height: 24,
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     "Medical Record".tr(),
//                     style: PetVeterinaryFontstyles2.getMediumStyle(
//                       context,
//                       15,
//                     ),
//                   ),
//                 ),
//                 Icon(
//                   isMedicalExpanded ? Icons.expand_less : Icons.expand_more,
//                   size: 24,
//                 ),
//               ],
//             ),
//           ),
//           if (isMedicalExpanded) const SizedBox(height: 20),
//           if (isMedicalExpanded)
//             Column(
//               children: [
//                 GestureDetector(
//                   onTap: () async {
//                     try {
//                       context.read<SelectedAppbarItemCubit>().setIndex(1);
//                       ref.read(petVetTabIndexProvider.notifier).state = 2;
//                     } catch (e) {
//                       CustomSnackBar.error(
//                         context,
//                         'Something went wrong'.tr(),
//                       );
//                     }
//                   },
//                   child: _buildOptionRow("Booked Appointments"),
//                 ),
//                 _divider,
//                 const SizedBox(height: 8),
//                 _buildOptionRow("Cases That Need Follow-up"),
//                 const SizedBox(height: 8),
//               ],
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOptionRow(String label) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               label.tr(),
//               style: PetVeterinaryFontstyles2.getRegularStyle(
//                 context,
//                 15,
//               ).copyWith(color: PetVeterinaryColors.newPetDarkGray),
//             ),
//           ),
//           const Icon(Icons.arrow_forward_ios,
//               size: 14, color: PetVeterinaryColors.newPetLightGray),
//         ],
//       ),
//     );
//   }

//   Widget _buildDeleteAccountRow() {
//     return GestureDetector(
//       onTap: () {
//         // Handle delete account
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Align(
//           alignment: AlignmentDirectional.centerStart,
//           child: Text(
//             "Delete Account".tr(),
//             style: PetVeterinaryFontstyles2.getLightStyle(
//               context,
//               15,
//             ).copyWith(color: PetVeterinaryColors.brightRed),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSettingsContainer() {
//     return _buildContainer(
//       child: Column(
//         children: [
//           GestureDetector(
//             onTap: () {
//               setState(() => isSettingsExpanded = !isSettingsExpanded);
//             },
//             child: Row(
//               children: [
//                 Image.asset(
//                   'assets/new_design/icons/Settings.png',
//                   width: 24,
//                   height: 24,
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     "Settings".tr(),
//                     style: PetVeterinaryFontstyles2.getMediumStyle(
//                       context,
//                       15,
//                     ),
//                   ),
//                 ),
//                 Icon(
//                   isSettingsExpanded ? Icons.expand_less : Icons.expand_more,
//                   size: 24,
//                 ),
//               ],
//             ),
//           ),
//           if (isSettingsExpanded) const SizedBox(height: 20),
//           if (isSettingsExpanded)
//             Column(
//               children: [
//                 _buildLanguageRow(),
//                 _divider,
//                 const SizedBox(height: 8),
//                 _buildDarkModeRow(),
//                 _divider,
//                 const SizedBox(height: 8),
//                 _buildOptionRow("Communication Preferences"),
//                 _divider,
//                 const SizedBox(height: 8),
//                 _buildOptionRow("Contact Us"),
//                 _divider,
//                 const SizedBox(height: 8),
//                 _buildOptionRow("About the app"),
//                 _divider,
//                 const SizedBox(height: 8),
//                 _buildOptionRow("Terms and Conditions"),
//                 _divider,
//                 const SizedBox(height: 8),
//                 _buildOptionRow("Privacy Policy"),
//                 _divider,
//                 const SizedBox(height: 8),
//                 _buildDeleteAccountRow(),
//                 const SizedBox(height: 8),
//               ],
//             ),
//         ],
//       ),
//     );
//   }

// // LANGUAGE ROW WITH DROPDOWN
//   Widget _buildLanguageRow() {
//     return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 4.0),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 "Change Language".tr(),
//                 style: PetVeterinaryFontstyles2.getRegularStyle(
//                   context,
//                   15,
//                 ).copyWith(color: PetVeterinaryColors.newPetDarkGray),
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 6,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     value: selectedLanguage,
//                     icon: const SizedBox.shrink(), // Remove arrow
//                     dropdownColor: Colors.white,
//                     borderRadius: BorderRadius.circular(
//                         12), // This gives the dropdown rounded corners
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedLanguage = newValue!;
//                       });
//                     },
//                     selectedItemBuilder: (context) {
//                       return ['ar', 'en'].map((lang) {
//                         return Row(
//                           children: [
//                             Image.asset(
//                               lang == 'ar'
//                                   ? 'assets/new_design/icons/sa_flag.png'
//                                   : 'assets/new_design/icons/sa_flag.png',
//                               width: 20,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               lang == 'ar' ? 'العربية' : 'English',
//                               style: PetVeterinaryFontstyles2.getRegularStyle(
//                                   context, 15),
//                             ),
//                           ],
//                         );
//                       }).toList();
//                     },
//                     items: [
//                       DropdownMenuItem(
//                         value: 'ar',
//                         child: Row(
//                           children: [
//                             Image.asset('assets/new_design/icons/sa_flag.png',
//                                 width: 20),
//                             const SizedBox(width: 8),
//                             const Text("العربية"),
//                           ],
//                         ),
//                       ),
//                       DropdownMenuItem(
//                         value: 'en',
//                         child: Row(
//                           children: [
//                             Image.asset('assets/new_design/icons/sa_flag.png',
//                                 width: 20),
//                             const SizedBox(width: 8),
//                             const Text("English"),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ));
//   }

//   Widget _buildDarkModeRow() {
//     return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 4.0),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 "Dark Mode".tr(),
//                 style: PetVeterinaryFontstyles2.getRegularStyle(
//                   context,
//                   15,
//                 ).copyWith(color: PetVeterinaryColors.newPetDarkGray),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   isDarkModeEnabled = !isDarkModeEnabled;
//                 });
//               },
//               child: Image.asset(
//                 'assets/new_design/icons/dark_mode_moon.png',
//                 width: 24,
//                 height: 24,
//                 color: isDarkModeEnabled ? Colors.black : null,
//                 colorBlendMode: BlendMode.srcIn,
//               ),
//             ),
//           ],
//         ));
//   }
// }

// final Widget _divider = Padding(
//   padding: const EdgeInsets.symmetric(vertical: 6),
//   child: Divider(height: 1, color: PetVeterinaryColors.newPetLightGray),
// );
