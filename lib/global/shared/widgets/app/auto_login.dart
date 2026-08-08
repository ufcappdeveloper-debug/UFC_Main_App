import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/app_update/app_update.dart';
import 'package:ufc_mobile/global/app_update/update_dialog.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/utils/feed_auth_utils.dart';

class AutoLogin extends ConsumerStatefulWidget {
  const AutoLogin({
    super.key,
    required this.child,
    this.needBackground = true,
  });
  final Widget child;
  final bool needBackground;

  @override
  ConsumerState<AutoLogin> createState() => _AutoLoginState();
}

class _AutoLoginState extends ConsumerState<AutoLogin> {
  late Future<void> pageFuture;

  @override
  void initState() {
    super.initState();
    pageFuture = Future.microtask(_init);
  }

  Future<void> _init() async {
    // future() async {
    await _checkForUpdate();
    // }

    // if (!context.mounted) return;
    // await LoadingDialog.show(context, future());
  }

  Future<void> _checkForUpdate() async {
    await AppUpdate.init();
    if (AppUpdate.updateStatus() != UpdateStatus.updated) {
      final mandatory = AppUpdate.updateStatus() == UpdateStatus.critical;
      if (mounted) {
        await showDialog(
          barrierDismissible: !mandatory,
          context: context,
          builder: (context) => UpdateDialog(mandatory: mandatory),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.needBackground ? Colors.green[900] : null,
      body: FutureBuilder(
        future: pageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            context.read<AuthCubit>().loadProfile();
          }

          return BlocConsumer<AuthCubit, AuthState>(
            listener: (BuildContext context, AuthState state) async {
              if (state is ProfileLoadedSuccess) {
                AuthUtils.showNearbyStations(
                  context,
                  ref: ref,
                  userModel: state.user,
                );
              }
            },
            builder: (context, state) {
              if (state is AuthError) {
                return widget.child;
              }
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
