import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/picture_in_picture.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ufc_mobile/global/communication_preferences/communication_preference_screen.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/constants/functions.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/shared/widgets/show_confirmation_dailog.dart';
import 'package:ufc_mobile/global/util/call/agora_engine_singleton.dart';
import 'package:ufc_mobile/global/util/image_network_extension_method.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/global/util/storage/local_storage.dart';
import 'package:ufc_mobile/main.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/state.dart';
import 'package:ufc_mobile/screens/feed_old/categories/widgets/signin_alert_sheet_for_guest_users.dart';
import 'package:ufc_mobile/screens/feed_old/favorite/pages/favorite_screen.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/screens/loyality_points_page.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/provider/authorization_check.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/provider/user_points_feature_access.dart';
import 'package:ufc_mobile/screens/feed_old/my_wallet/pages/wallet_screen.dart';
import 'package:ufc_mobile/screens/feed_old/orders/pages/my_order_history.dart';
import 'package:ufc_mobile/screens/feed_old/profile/pages/about_page.dart';
import 'package:ufc_mobile/screens/feed_old/profile/pages/edit_profile_page.dart';
import 'package:ufc_mobile/screens/feed_old/profile/pages/language_and_currency_page.dart';
import 'package:ufc_mobile/screens/feed_old/support/pages/support_page.dart';

import '../../authentication/pages/signin_page.dart';
import '../../saved_address/pages/saved_address_list.dart';
import 'notification_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key, this.tabController, this.scrollController});
  final TabController? tabController;
  final ScrollController? scrollController;
  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with ScreenEngagementTracker {
  bool isAuthorized = true;
  bool hasShownBottomSheet = false;
  // @override
  // initState() {
  //   super.initState();
  //   isAuthorized = ref.watch(authorizationCheckProvider).asData?.value ?? true;
  //   if (!isAuthorized) {
  //     setState(() {
  //       isAuthorized = false;
  //     });
  //     _showUnauthorizedBottomSheet(context);
  //   }
  // }

  void _showUnauthorizedBottomSheet(BuildContext context) {
    showUnauthorizedBottomSheet(
      context,
      onSignInPressed: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
            (route) => false);
      },
    ).whenComplete(() {
      // This is triggered when the bottom sheet is dismissed.
      setState(() {
        hasShownBottomSheet = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).asData?.value;
    isAuthorized = ref.watch(authorizationCheckProvider).asData?.value ?? true;

    final featureAccess =
        ref.watch(userPointsFeatureAccessProvider).asData?.value;
    if (!isAuthorized && !hasShownBottomSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showUnauthorizedBottomSheet(context);
        setState(() {
          hasShownBottomSheet = true; // Mark bottom sheet as shown
        });
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 30,
      ),
      body: isAuthorized
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    // color: Colors.teal,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /* PROFILE ROW */
                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditProfilePage(),
                                )),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: SizedBox(
                                      width: 58,
                                      height: 58,
                                      child: user?.profilePicture == null ||
                                              user!.profilePicture!.isEmpty
                                          ? Container(
                                              color: const Color(0xFFD9D9D9),
                                              child: const Icon(
                                                size: 35,
                                                Icons.person,
                                                color: Colors.white,
                                              ),
                                            )
                                          : CachedNetworkImage(
                                              imageUrl:
                                                  user.profilePicture ?? "",
                                              placeholder: loadingPlaceholder,
                                              errorWidget: errorWidget,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 30),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (user?.name != null &&
                                              user!.name!.isNotEmpty)
                                            CustomText(
                                              text: user.name ?? "",
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          if (user?.email != null &&
                                              user?.email?.email != null &&
                                              user!.email!.email!.isNotEmpty)
                                            CustomText(
                                              text: user.email?.email ?? "",
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300,
                                              color: const Color(0xffAEAEAE),
                                            ),
                                          Directionality(
                                            textDirection: ui.TextDirection.ltr,
                                            child: CustomText(
                                              text: phoneFormat(user) ?? "",
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300,
                                              color: const Color(0xffAEAEAE),
                                            ),
                                          )
                                        ]),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      child: InkWell(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const NotificationPage(),
                                            )),
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        child: Image.asset(
                                            'assets/images/home/notification.png',
                                            height: 18,
                                            color: primaryColor),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const EditProfilePage(),
                                          )),
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      child: const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 18,
                                          color: primaryColor),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          /* PROFILE ROW */

                          const SizedBox(height: 20),
                        ]),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(blurRadius: 20, color: Color(0xffe5e5e5))
                        ]),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                  text: 'Account'.tr(),
                                  fontWeight: FontWeight.w500),
                              inviteButton(onTap: () {})
                            ],
                          ),
                        ),
                        menuItem(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MyOrderHistory()));
                            },
                            iconPath: "assets/images/profile/shopping-bag.png",
                            title: "My Orders"),
                        menuItem(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const FavoriteScreen())),
                            iconPath: "assets/images/profile/heart.png",
                            iconSize: 16,
                            title: "My Favorite"),
                        menuItem(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WalletScreen(),
                                ),
                              );
                            },
                            iconPath: "assets/images/profile/wallet.png",
                            iconSize: 18,
                            title: "My Wallet"),
                        if (featureAccess ?? true)
                          menuItem(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoyalityPointsPage())),
                              iconPath: "assets/images/profile/loyality.png",
                              iconSize: 16,
                              title: "My Loyalty Points"),
                        // menuItem(
                        //     onTap: () => Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => const MyTicket())),

                        //     // },
                        //     iconPath: "assets/images/profile/file.png",
                        //     title: "My Ticket",
                        //     iconSize: 18),
                        // menuItem(
                        //     onTap: () => Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => const PaymentMethods())),
                        //     iconPath: "assets/images/profile/credit-cards.png",
                        //     title: "Saved Cards",
                        //     iconSize: 18),
                        menuItem(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SavedAddressList(),
                                ),
                              );
                            },
                            iconPath: "assets/images/profile/map-pin.png",
                            title: "Saved Address",
                            iconSize: 18),
                        menuItem(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CommunicationPreferenceScreen(),
                                ),
                              );
                            },
                            iconPath: "assets/images/profile/conversation.png",
                            title: "Communication Preferences",
                            iconSize: 18),
                        menuItem(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationPage(),
                                )),
                            iconPath: "assets/images/home/notification.png",
                            title: "Notification",
                            iconSize: 18),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 15, right: 15, top: 10),
                          alignment: (isArOrUr)
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: CustomText(
                              text: 'Settings', fontWeight: FontWeight.w500),
                        ),
                        menuItem(
                            onTap: () async {
                              final updated = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LanguageAndCurrencyPage(),
                                ),
                              );

                              await Future.delayed(Duration(milliseconds: 111));

                              if (updated == true) {
                                if (!context.mounted) return;
                                CustomSnackBar.success(
                                    context, "Updated Successfully");
                              }
                            },
                            iconPath: "assets/images/profile/language.png",
                            title: "Language/ Currency".tr(),
                            iconSize: 18),
                        menuItem(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SupportPage())),
                            iconPath:
                                "assets/images/profile/online-support.png",
                            title: "Support",
                            iconSize: 16),
                        menuItem(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AboutPage())),
                            iconPath: "assets/images/profile/info.png",
                            title: "About UFC",
                            iconSize: 16),
                        // menuItem(
                        //     onTap: () async {
                        //       try {
                        //         final future =
                        //             ref.read(authProvider.notifier).logout();
                        //         await LoadingDialog.show(context, future);
                        //         await preferences.remove("token");
                        //         clearPreferencesExceptLanguage;
                        //         AppConfig.token = null;
                        //         if (mounted) {
                        //           ref
                        //               .read(cartProvider)
                        //               .clear(); // clear cart provider after success
                        //           if (!mounted) return;
                        //           Navigator.pushAndRemoveUntil(
                        //               context,
                        //               MaterialPageRoute(
                        //                 builder: (context) =>
                        //                     const SignInPage(),
                        //               ),
                        //               (route) => false);
                        //         }
                        //       } catch (e) {
                        //         if (!mounted) return;
                        //         CustomSnackBar.error(context, e.toString());
                        //       }
                        //     },
                        //     iconPath: "assets/images/profile/exit.png",
                        //     title: "Logout",
                        //     iconSize: 16),
                        menuItem(
                          onTap: () async {
                            final confirm = await showConfirmationDialog(
                              context: context,
                              title: 'Are you sure?',
                              content: 'Do you want to logout?'.tr(),
                            );

                            if (!confirm) return;

                            try {
                              final future =
                                  ref.read(authProvider.notifier).logout();
                              final agora = AgoraEngineSingleton();
                              agora.dispose();
                              if (PictureInPicture.isActive) {
                                PictureInPicture.stopPiP();
                              }
                              if (!context.mounted) return;
                              await LoadingDialog.show(context, future);
                              await preferences.remove("token");
                              await preferences.setBool('init_fcm', false);
                              clearPreferencesExceptLanguage;
                              AppConfig.token = null;

                              if (mounted) {
                                ref.read(cartProvider).clear();
                                if (!context.mounted) return;
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignInPage()),
                                  (route) => false,
                                );
                              }
                            } catch (e) {
                              if (!context.mounted) return;
                              CustomSnackBar.error(context, e.toString());
                            }
                          },
                          iconPath: "assets/images/profile/exit.png",
                          title: "Logout",
                          iconSize: 16,
                        ),

                        const SizedBox(height: 85),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    color: Colors.redAccent,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Access Denied',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You are not authorized.\nPlease sign in to continue.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Container menuItem({
    VoidCallback? onTap,
    String? iconPath,
    double? iconSize = 22,
    String? title,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        top: 15,
        right: 15,
        // bottom: 20,
      ),
      // height: 40,
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Row(children: [
            Expanded(
              child: Image.asset(
                  iconPath ?? 'assets/images/profile/shopping-bag.png',
                  height: iconSize,
                  width: iconSize,
                  color: primaryColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 15,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: (title ?? 'Menu Item').tr(),
                          maxLines: 1,
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          size: 16, color: Color(0xffBFBFBF))
                    ],
                  ),
                  const Divider(
                    color: Color(0xffE5E5E5),
                    thickness: 1,
                    height: 2,
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  InkWell inviteButton({VoidCallback? onTap}) {
    return InkWell(
        onTap: onTap,
        child: Container(
            height: 35,
            width: isUrdu ? 155 : 122,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 20,
                      color: const Color(0xffe5e5e5).withValues(alpha: 0.4))
                ]),
            child: Row(
              children: [
                Image.asset('assets/images/profile/add-group.png', height: 16),
                const Spacer(),
                InkWell(
                  // onTap: () async {
                  //   Uri uri = Uri.parse("https://www.ufc.mvp-apps.ae/");
                  //   await Share.share(
                  //     '${"Check out this post!".tr()} $uri',
                  //   );
                  // },
                  onTap: () async {
                    // final box = context.findRenderObject() as RenderBox?;
                    final screenSize = MediaQuery.of(context).size;

                    final center =
                        Offset(screenSize.width / 2, screenSize.height / 2);
                    final dummyBoxSize = const Size(100, 100);

                    await Share.share(
                      'Check out this post! https://www.ufc.mvp-apps.ae/',
                      sharePositionOrigin: Rect.fromCenter(
                        center: center,
                        width: dummyBoxSize.width,
                        height: dummyBoxSize.height,
                      ),
                    );
                  },

                  child: CustomText(
                    text: 'Invite Friend',
                    color: primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            )));
  }

  Future<void> clearPreferencesExceptLanguage() async {
    int? languageIndex = preferences.getInt(LocalStorage.language);

    await preferences.clear();

    if (languageIndex != null) {
      await preferences.setInt(LocalStorage.language, languageIndex);
    }
  }
}
