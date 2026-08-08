import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/auth/un_authorized_widget.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';
import 'package:ufc_mobile/screens/feed/presentation/authentication/pages/login_with_number_page.dart';

class GuestGuard extends StatelessWidget {
  final Widget child;
  final AppType appType;
  final Color color;
  const GuestGuard(
      {super.key,
      required this.child,
      required this.appType,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isGuest = context.read<AuthCubit>().isGuest;

        if (isGuest) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UnAuthorizedWidget(),
              kHeight20,
              CustomButton(
                fontFamily:
                    isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
                color: color,
                title: "Login to Access",
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => LoginWithNumber(
                              appType: appType,
                              isNotFromStart: true,
                            )),
                    (route) => false,
                  );
                },
              ),
            ],
          );
        }

        return child;
      },
    );
  }
}
