import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/weight_chart.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

import '../../../../global/extensions/app_colors.dart';
import '../widgets/farm_appbar.dart';
import 'add_member_page.dart';

class MembersPage extends ConsumerStatefulWidget {
  const MembersPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MembersPageState();
}

class _MembersPageState extends ConsumerState<MembersPage> {
  final List<Map<String, String>> members = [
    {
      "name": "محمد احمد",
      "email": "mmiuo@gmail.com",
      "phone": "+966 50 123 4567",
    },
    {
      "name": "محمد احمد",
      "email": "mmiuo@gmail.com",
      "phone": "+966 50 123 4567",
    },
    {
      "name": "محمد احمد",
      "email": "mmiuo@gmail.com",
      "phone": "+966 50 123 4567",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomFarmAppBar(title: 'Members'),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: CustomOutlinedContainer(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) =>
                    AddMemberORContactUs(formContactUs: false),
              ),
            );
          },
          title: 'Add New Member',
          fill: true,
          fillColor: AppColors.farmColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListView.separated(
        padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 70),
        itemBuilder: (context, index) {
          final member = members[index];
          return Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [customBoxShadow],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textWidget(member['name']!),
                    textWidget(member['email']!),
                    textWidget(member['phone']!),
                  ],
                ),
                _showPopupMenu(context)
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => kHeight20,
        itemCount: members.length,
      ),
    );
  }

  Column textWidget(String text) {
    return Column(
      children: [
        CustomText(text: text, fontSize: 14, fontWeight: FontWeight.w300),
        kHeight10,
      ],
    );
  }

  PopupMenuButton<int> _showPopupMenu(BuildContext context) {
    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (value) {
        Fluttertoast.showToast(
          msg: 'Not available at the moment'.tr(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        if (value == 0) {
          // onEdit();
        } else if (value == 1) {
          // onDelete();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              SvgPicture.asset('assets/svg/farm/edit.svg'),
              kWidth10,
              CustomText(
                text: "Edit",
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
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
                text: "Delete",
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ],
          ),
        ),
      ],
      child: const Icon(Icons.more_horiz),
    );
  }
}
