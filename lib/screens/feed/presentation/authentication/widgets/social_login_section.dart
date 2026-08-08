import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/social_login/apple_sign_in.dart';
import 'package:ufc_mobile/global/shared/social_login/google_signin.dart';
import 'package:ufc_mobile/global/shared/social_login/twitter_signin.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';
import 'package:ufc_mobile/screens/feed/presentation/authentication/pages/sign_up_page.dart';

class SocialLoginSection extends StatelessWidget {
  final AppType appType;
  const SocialLoginSection({super.key, required this.appType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          kHeight10,
          Row(
            children: [
              Expanded(
                  child: Divider(thickness: 1, height: 20, color: Colors.grey)),
              CustomText(
                text: ' Or sign in with '.tr(),
                color: Color(0xff44444F),
                fontFamily: 'Kanit',
              ),
              Expanded(
                  child: Divider(thickness: 1, height: 20, color: Colors.grey)),
            ],
          ),
          kHeight10,
          socialLoginButton(
            onTap: () async {
              final data = await signInWithGoogle(context);
              if (!context.mounted) return;
              await context.read<AuthCubit>().googleSociaLogin(data);
            },
            iconPath: 'assets/images/authentication/google-icon.svg',
            title: 'Sign in with Google'.tr(),
          ),
          if (Platform.isIOS)
            socialLoginButton(
              onTap: () async {
                final data = await signInWithApple(context);
                if (!context.mounted) return;
                await context.read<AuthCubit>().appleSociaLogin(data);
              },
              iconPath: 'assets/images/authentication/Apple logo.svg',
              title: 'Sign in with Apple',
            ),
          socialLoginButton(
            onTap: () async {
              final user = await signInWithTwitter(context);
              final data = {
                "twitter_id": user.id,
                "twitter_email": user.email,
                "name": user.name,
              };
              if (!context.mounted) return;
              await context.read<AuthCubit>().twitterSociaLogin(data);
            },
            icon: Image.asset(
              'assets/images/authentication/X logo.png',
              height: 24,
            ),
            title: 'Sign in with X'.tr(),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedSignUpPage(appType: appType),
                ),
              );
            },
            child: CustomText(
              fontSize: 13,
              // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
              fontFamily:
                  isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
              text: 'Create a new account'.tr(),
              decoration: TextDecoration.underline,
              color: Colors.black,
            ),
          ),
          kHeight20,
        ],
      ),
    );
  }
}
