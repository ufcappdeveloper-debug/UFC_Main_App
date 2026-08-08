import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/global/util/exception/error_handler.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/bottom_bar_bloc/bottom_bar_bloc.dart';
import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';

class FeedGuestContinueButton extends StatefulWidget {
  final Color color;
  final AppType appType;
  const FeedGuestContinueButton({
    super.key,
    required this.color,
    required this.appType,
  });

  @override
  State<FeedGuestContinueButton> createState() =>
      _FeedGuestContinueButtonState();
}

class _FeedGuestContinueButtonState extends State<FeedGuestContinueButton> {
  bool isTryingGuestLogin = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        final page = switch (widget.appType) {
          AppType.feed => 0,
          AppType.veterinary => 1,
          AppType.farm => 2,
          AppType.community => 3,
        };
        if (state is GuestLoginSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => BottomBar(initialIndex: page)),
            (route) => false,
          );
          if (page == 0) {
            context.read<FeedBottomNavCubit>().changeTab(0);

            context.read<AppBarCubit>().setMode(AppBarMode.normal);
          }
          setState(() => isTryingGuestLogin = false);
        } else if (state is AuthError) {
          if (isTryingGuestLogin) {
            ErrorHandler.handleError(context, state.message);
            setState(() => isTryingGuestLogin = false);
          }
        }
      },
      builder: (context, state) {
        final isLoading = state is GuestLoginLoading;

        return Center(
          child: TextButton(
            onPressed: isLoading
                ? null
                : () {
                    setState(() => isTryingGuestLogin = true);
                    context.read<AuthCubit>().guestLogin();
                  },
            child: isLoading
                ? const CircularProgressIndicator()
                : CustomText(
                    text: 'Continue as Guest'.tr(),
                    decorationColor: widget.color,
                    decoration: TextDecoration.underline,
                    color: widget.color,
                  ),
          ),
        );
      },
    );
  }
}
