import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

import '../../application/dashbaord/dashboard_cubit.dart';
import '../../application/members/farm_account_cubit.dart';
import '../../domain/entities/member/farm_member_model.dart';

/// "Active farm" chip for farm members: "My farm" or an owner's farm.
/// Hidden for users who aren't a member of any farm.
class FarmSwitcher extends StatefulWidget {
  const FarmSwitcher({super.key});

  @override
  State<FarmSwitcher> createState() => _FarmSwitcherState();
}

class _FarmSwitcherState extends State<FarmSwitcher> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<FarmAccountCubit>().loadAccounts());
  }

  Future<void> _pick(FarmAccountState state) async {
    final picked = await showModalBottomSheet<_Choice>(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            CustomText(
                text: 'Choose farm', fontSize: 16, fontWeight: FontWeight.w500),
            const SizedBox(height: 8),
            _tile(ctx, 'My farm'.tr(), null, null, state.ownerId == null),
            for (final a in state.accounts)
              _tile(ctx, a.label, a.role?.name, a,
                  state.ownerId == a.ownerUserId),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
    if (picked == null || !mounted) return;
    await context.read<FarmAccountCubit>().select(picked.account);
  }

  Widget _tile(BuildContext ctx, String title, String? subtitle,
      MemberAccountModel? account, bool selected) {
    return ListTile(
      onTap: () => Navigator.of(ctx).pop(_Choice(account)),
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: selected ? AppColors.farmColor : Colors.grey,
      ),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FarmAccountCubit, FarmAccountState>(
      listenWhen: (p, c) => p.ownerId != c.ownerId || p.eventId != c.eventId,
      listener: (context, state) {
        if (state.revokedMessage != null) {
          CustomSnackBar.error(context, state.revokedMessage!);
        }
        // Another farm's data now: reload.
        context.read<FarmDashboardCubit>().getDashboardDetails();
      },
      builder: (context, state) {
        if (state.accounts.isEmpty && !state.isOnOwnerFarm) {
          return const SizedBox.shrink();
        }
        final label = state.isOnOwnerFarm
            ? (state.selected?.label ?? 'Owner farm'.tr())
            : 'My farm'.tr();
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: GestureDetector(
            onTap: () => _pick(state),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.farmColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.agriculture_outlined,
                      size: 18, color: AppColors.farmColor),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text('${'Active farm'.tr()}: $label',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.farmColor)),
                  ),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 18, color: AppColors.farmColor),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Choice {
  final MemberAccountModel? account;
  const _Choice(this.account);
}
