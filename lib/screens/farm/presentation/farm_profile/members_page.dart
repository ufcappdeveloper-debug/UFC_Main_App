import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/init/injection.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/show_confirmation_dailog.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/weight_chart.dart';

import '../../../../global/extensions/app_colors.dart';
import '../../application/members/members_cubit.dart';
import '../../domain/entities/member/farm_member_model.dart';
import '../widgets/farm_appbar.dart';
import 'add_member_page.dart';

/// The owner's farm members (from `GET /members`).
class MembersPage extends StatelessWidget {
  const MembersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MembersCubit>()..load(),
      child: const _MembersView(),
    );
  }
}

class _MembersView extends StatelessWidget {
  const _MembersView();

  Future<void> _openForm(BuildContext context, {FarmMemberModel? member}) async {
    final cubit = context.read<MembersCubit>();
    final saved = await Navigator.of(context, rootNavigator: true).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: AddMemberORContactUs(formContactUs: false, member: member),
        ),
      ),
    );
    if (saved == true) cubit.load();
  }

  Future<void> _delete(BuildContext context, FarmMemberModel member) async {
    final confirm = await showConfirmationDialog(
      context: context,
      title: 'Delete member'.tr(),
      content: 'Are you sure you want to delete this member?'.tr(),
      fromFarm: true,
    );
    if (!confirm || !context.mounted) return;
    final error = await context.read<MembersCubit>().delete(member);
    if (!context.mounted) return;
    if (error != null) {
      CustomSnackBar.error(context, error);
    } else {
      CustomSnackBar.success(context, 'Member deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomFarmAppBar(title: 'Members'),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: CustomOutlinedContainer(
          onTap: () => _openForm(context),
          title: 'Add New Member',
          fill: true,
          fillColor: AppColors.farmColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: BlocBuilder<MembersCubit, MembersState>(
        builder: (context, state) {
          final cubit = context.read<MembersCubit>();
          if (state.loading && state.members.isEmpty) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.farmColor));
          }
          if (state.error != null && state.members.isEmpty) {
            return CustomReloadProviderV2(
              error: state.error,
              height: 120,
              decoration: const BoxDecoration(color: Colors.transparent),
              onPressed: cubit.load,
            );
          }
          return RefreshIndicator(
            color: AppColors.farmColor,
            onRefresh: cubit.load,
            child: state.members.isEmpty
                ? ListView(
                    children: [
                      const SizedBox(height: 120),
                      const Icon(Icons.group_outlined,
                          size: 56, color: AppColors.farmColor),
                      kHeight10,
                      Center(
                        child: CustomText(
                            text: 'No members yet',
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      kHeight10,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: CustomText(
                          text:
                              'Add a member by mobile number to let them work on your farm',
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 20, bottom: 90),
                    itemCount: state.members.length,
                    separatorBuilder: (_, __) => kHeight20,
                    itemBuilder: (context, index) {
                      final member = state.members[index];
                      return _MemberCard(
                        member: member,
                        onEdit: () => _openForm(context, member: member),
                        onDelete: () => _delete(context, member),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final FarmMemberModel member;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MemberCard({
    required this.member,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    Widget line(String text, {IconData? icon}) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: CustomText(
                    text: text, fontSize: 14, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        );
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [customBoxShadow],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: CustomText(
                          text: member.name ?? '',
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    if (member.canViewFinance) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.farmColor.withOpacity(.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomText(
                            text: 'Finance',
                            fontSize: 11,
                            color: AppColors.farmColor),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                if ((member.email ?? '').isNotEmpty)
                  line(member.email!, icon: Icons.email_outlined),
                Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: line(member.displayPhone, icon: Icons.phone_outlined),
                ),
                if ((member.role?.name ?? '').isNotEmpty)
                  line(member.role!.name!, icon: Icons.badge_outlined),
              ],
            ),
          ),
          PopupMenuButton<int>(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (value) => value == 0 ? onEdit() : onDelete(),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    SvgPicture.asset('assets/svg/farm/edit.svg'),
                    kWidth10,
                    CustomText(
                        text: 'Edit', fontSize: 16, fontWeight: FontWeight.w300),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    SvgPicture.asset('assets/svg/farm/delete.svg'),
                    kWidth10,
                    CustomText(
                        text: 'Delete',
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w300),
                  ],
                ),
              ),
            ],
            child: const Icon(Icons.more_horiz),
          ),
        ],
      ),
    );
  }
}
