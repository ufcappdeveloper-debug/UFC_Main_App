import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';

import '../../../../screens/feed/application/authentication/auth_cubit.dart';
import '../../../util/common/common_utils.dart';
import '../show_confirmation_dailog.dart';

class LogoutWidget extends StatelessWidget {
  final AppType appType;
  final bool isFromVet;
  final bool isFromFarm;
  final BuildContext parentContext;
  final Future<void> Function(BuildContext)? onLogout;

  const LogoutWidget({
    super.key,
    required this.appType,
    this.isFromVet = false,
    this.isFromFarm = false,
    required this.parentContext,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().currentUser;

    if (user == null) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap: () async {
        final confirm = await showConfirmationDialog(
          context: context,
          title: 'Are you sure?',
          content: 'Do you want to logout?'.tr(),
          fromFarm: isFromFarm,
          isFromVet: isFromVet,
        );

        if (!confirm) return;

        if (onLogout != null) {
          await onLogout!(parentContext);
        }
      },
      child: _buildContainer(
        child: Row(
          children: [
            Image.asset(
              'assets/new_design/icons/log_out_icon.png',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 12),
            Text(
              "Logout".tr(),
              style: isFromVet
                  ? PetVeterinaryFontstyles2.getLightStyle(context, 17)
                  : PetVeterinaryFontstyles2.getMediumStyle(context, 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer({required Widget child}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 0.5,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
