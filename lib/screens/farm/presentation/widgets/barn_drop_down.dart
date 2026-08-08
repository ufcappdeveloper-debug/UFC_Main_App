import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/riverpod/farm/barn/barn_provider.dart';
import 'package:ufc_mobile/screens/farm/application/barn_details/barn_details_cubit.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/error_widget.dart';

class BarnDropdown extends ConsumerStatefulWidget {
  final int? initBarn;
  final bool isFromSelectAnimal;
  final Function(int? barnId) onChangeBarn;
  const BarnDropdown(
      {super.key,
      this.isFromSelectAnimal = false,
      this.initBarn,
      required this.onChangeBarn});

  @override
  ConsumerState<BarnDropdown> createState() => _BarnDropdownState();
}

class _BarnDropdownState extends ConsumerState<BarnDropdown> {
  @override
  void initState() {
    selectedBarn = widget.initBarn;
    super.initState();
  }

  int? selectedBarn;
  // Future<void> loadData(int id) async {
  //   await context.read<BarnDetailsCubit>().fetchBarnDetails(id);
  // }

  @override
  Widget build(BuildContext context) {
    final barnAsync = ref.watch(barnAsyncProvider);
    return barnAsync.when(
      data: (data) {
        return DropdownButton<int>(
          borderRadius: BorderRadius.circular(10),
          elevation: 1,
          menuMaxHeight: data.length > 8 ? 300 : null,
          value: selectedBarn,
          items: [
            DropdownMenuItem<int>(
              value: null, // represent "All barns"
              child: CustomText(
                fontWeight: FontWeight.w500,
                text: "All Barns",
                fontSize: 11,
              ),
            ),
            ...data.map((barn) {
              return DropdownMenuItem(
                value: barn.id,
                child: CustomText(
                    fontSize: 11,
                    text:
                        '${barn.name} ${barn.barnNumber != null ? '- ${barn.barnNumber}' : ''}'),
              );
            })
          ],
          onChanged: (value) async {
            context.read<BarnDetailsCubit>().filter = {};

            if (value != null) {
              // user selected a specific barn
              widget.onChangeBarn(value);
              if (!widget.isFromSelectAnimal) {
                await context.read<BarnDetailsCubit>().fetchBarnDetails(value);
              }
            } else {
              // user selected "All Barns"
              final barns = ref.read(barnAsyncProvider).value ?? [];
              final firstBarnId = barns.firstOrNull?.id;

              widget.onChangeBarn(null); // keep dropdown in All Barns

              if (!widget.isFromSelectAnimal && firstBarnId != null) {
                await context
                    .read<BarnDetailsCubit>()
                    .fetchBarnDetails(firstBarnId, allBarn: true);
              }
            }
          },
          underline: const SizedBox(),
          style: TextStyle(
            // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
            fontFamily:
                isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: Colors.black,
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
        );
      },
      error: (error, stack) => errorWidget(context),
      loading: () => const CupertinoActivityIndicator(),
    );
  }
}
