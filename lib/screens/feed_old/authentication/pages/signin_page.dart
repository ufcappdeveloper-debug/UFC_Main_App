import 'dart:io';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/language_cubit/language_cubit.dart'
    show LanguageCubit;
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/social_login/twitter_signin.dart';
import 'package:ufc_mobile/global/shared/translations/l10n.dart';
import 'package:ufc_mobile/global/shared/widgets/app/auto_login.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/state/app_states.dart';
import 'package:ufc_mobile/global/util/storage/local_storage.dart';
import 'package:ufc_mobile/main.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/component/phone_auth.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/pages/signup_page.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/utils/feed_auth_utils.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/widgets/guest_continue_button.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/chat_socket_manager.dart';

import '../../../../global/shared/social_login/apple_sign_in.dart';
import '../../../../global/shared/social_login/google_signin.dart';
import '../../../../global/shared/widgets/loading/loading_dialog.dart';
import '../../../../global/shared/widgets/will_popscope_widget.dart';
import '../component/email_auth.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({
    super.key,
    this.fromAccount,
  });
  final bool? fromAccount;

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    _initChat();
    _initTabController();

    Future.microtask(_init);
  }

  Future<void> _initChat() async {
    ChatSocketManager.init();
  }

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
  }

  void _initTabController() {
    tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: widget.fromAccount == true ? 1 : 0);
  }

  Future<void> _init() async {
    final int? langIndex = preferences.getInt(LocalStorage.language);

    Future(() {
      if (mounted) {
        if (langIndex != null) {
          context.setLocale(L10n.all[langIndex]);
          context.read<LanguageCubit>().switchLanguage(
                context: context,
                localeString: L10n.all[langIndex].languageCode.toString(),
              );
        }
      }
    });
    final fromColdStart = ref.read(appStateProvider).dynamicLinkColdStart;
    if (fromColdStart == false) {
      debugPrint('no link');
      deepLinks();
    } else {
      debugPrint('link not null');
    }
  }

  Future<void> deepLinks() async {
    ref.read(appStateProvider).dynamicLinkColdStart = true;
    // --TODO:: handle the links
    // await AppDeepLinks().incomingLinkHandler(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScopeWidget(
      child: AutoLogin(
        child: Stack(
          children: [
            Image.asset('assets/images/authentication/background.png',
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover),
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/authentication/logo.svg',
                        ),
                        const SizedBox(height: 40),
                        Directionality(
                          textDirection: ui.TextDirection.ltr,
                          child: TabBar(
                            controller: tabController,
                            labelColor: Colors.white,
                            indicatorColor: primaryColor,
                            // tabAlignment: TabAlignment.center,
                            indicatorPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            unselectedLabelColor: Colors.white,
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            unselectedLabelStyle:
                                const TextStyle(fontWeight: FontWeight.normal),
                            tabs: [
                              Tab(text: 'Phone Number'.tr()),
                              Tab(text: 'Email'.tr()),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        AnimatedBuilder(
                          animation: tabController.animation!,
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              const PhoneAuth(
                                key: ValueKey("Phone"),
                              ),
                              EmailAuth(
                                fromAccount: widget.fromAccount,
                                key: const ValueKey("Email"),
                              ),
                            ],
                          ),
                          builder: (context, child) {
                            return SizedBox(
                              height: (tabController.animation!.value * 100)
                                      .clamp(0, 78) +
                                  255,
                              child: child,
                            );
                          },
                        ),
                        GuestContinueButton(),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                    thickness: 2,
                                    height: 20,
                                    color: Colors.white.withValues(alpha: 0.5)),
                              ),
                              CustomText(
                                  text: ' Or sign in with '.tr(),
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontFamily: 'Kanit'),
                              Expanded(
                                child: Divider(
                                    thickness: 2,
                                    height: 20,
                                    color: Colors.white.withValues(alpha: 0.5)),
                              ),
                            ],
                          ),
                        ),
                        socialLoginButton(
                          onTap: () async {
                            try {
                              final data = await signInWithGoogle(context);

                              final future = ref
                                  .read(authProvider.notifier)
                                  .googleSociaLogin(data);
                              if (!context.mounted) return;
                              await LoadingDialog.show(context, future);

                              if (!context.mounted) return;
                              AuthUtils.showNearbyStations(context, ref: ref);
                            } catch (e) {
                              if (!mounted) return;
                              CustomSnackBar.error(context, e.toString());
                            }
                          },
                          iconPath:
                              'assets/images/authentication/google-icon.svg',
                          title: 'Sign in with Google',
                        ),
                        if (Platform.isIOS)
                          socialLoginButton(
                            onTap: () async {
                              try {
                                final data = await signInWithApple(context);

                                final future = ref
                                    .read(authProvider.notifier)
                                    .appleSociaLogin(data);
                                if (!context.mounted) return;
                                await LoadingDialog.show(context, future);

                                if (!context.mounted) return;
                                AuthUtils.showNearbyStations(context, ref: ref);
                              } catch (e) {
                                if (!mounted) return;
                                CustomSnackBar.error(context, e.toString());
                              }
                            },
                            iconPath:
                                'assets/images/authentication/Apple logo.svg',
                            title: 'Sign in with Apple',
                          ),
                        socialLoginButton(
                          onTap: () async {
                            try {
                              final user = await signInWithTwitter(context);

                              final data = {
                                "twitter_id": user.id,
                                "twitter_email": user.email,
                                "name": user.name,
                              };

                              final future = ref
                                  .read(authProvider.notifier)
                                  .twitterSociaLogin(data);
                              if (!context.mounted) return;
                              await LoadingDialog.show(context, future);

                              if (!context.mounted) return;
                              AuthUtils.showNearbyStations(context, ref: ref);
                            } catch (e) {
                              if (!mounted) return;
                              CustomSnackBar.error(context, e.toString());
                            }
                          },
                          icon: Image.asset(
                              'assets/images/authentication/X logo.png',
                              height: 24),
                          title: 'Sign in with X',
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpPage())),
                          child: CustomText(
                            text: 'Create a new account'.tr(),
                            decorationColor:
                                Colors.white.withValues(alpha: 0.8),
                            decoration: TextDecoration.underline,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell socialLoginButton(
      {required Function() onTap,
      String? iconPath,
      Widget? icon,
      required String title}) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: 289,
          height: 42,
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.symmetric(horizontal: 50),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                    color: Colors.black.withValues(alpha: 0.2))
              ]),
          child: Row(
            children: [
              icon ?? SvgPicture.asset(iconPath!),
              const SizedBox(width: 15),
              CustomText(
                  text: title.tr(), fontSize: 14, fontWeight: FontWeight.w400)
            ],
          )),
    );
  }
}
