import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart'
    show AppFontsFamily;

import '../../../../global/extensions/app_colors.dart';
import '../../../../global/shared/constants/constants.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../../../../riverpod/farm/report_category_questions_async.dart';
import '../charts/weight_chart.dart';
import 'farm_text_field.dart';

class AddOptionButton extends ConsumerStatefulWidget {
  const AddOptionButton(
      {super.key,
      required this.subText,
      required this.qid,
      this.contentId,
      this.parentQuestionId,
      required this.reportid,
      this.isLastButton = false});
  final String? subText;
  final int qid;
  final int? reportid;
  final int? contentId;
  final int? parentQuestionId;
  final bool isLastButton;

  @override
  ConsumerState<AddOptionButton> createState() => _AddOptionButtonState();
}

class _AddOptionButtonState extends ConsumerState<AddOptionButton> {
  late TextEditingController optionController;
  @override
  void initState() {
    optionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    optionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomOutlinedContainer(
      subText: widget.subText,
      onTap: () => addOptionBottomSheet(context),
      margin: EdgeInsets.only(bottom: widget.isLastButton ? 75 : 10),
      title: 'Add New Option',
    );
  }

  Future<dynamic> addOptionBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      scrollControlDisabledMaxHeightRatio: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      context: context,
      builder: (context) {
        bool isLoading = false;
        String? errorMsg;
        return StatefulBuilder(
          builder: (context, setModalState) => SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  top: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        CustomText(
                          text: 'Add New Option',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
                          fontFamily: isEnglish
                              ? AppFontsFamily.english
                              : AppFontsFamily.arabic,
                        ),
                        GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.close))
                      ],
                    ),
                    kHeight30,
                    CustomTextFormField(
                      controller: optionController,
                      hintText: '',
                      context: context,
                    ),
                    if (errorMsg != null)
                      CustomText(text: '$errorMsg', color: Colors.red),
                    kHeight40,
                    if (isLoading)
                      Center(
                          child: CircularProgressIndicator(
                              color: AppColors.farmColor))
                    else
                      CustomOutlinedContainer(
                        title: 'Save',
                        fill: true,
                        onTap: () async {
                          setModalState(() {
                            isLoading = true;
                          });
                          errorMsg = await ref
                              .read(reportCategoryQuestionsProvider.notifier)
                              .addContent(
                                parentId: widget.parentQuestionId,
                                contentId: widget.contentId,
                                questionId: widget.qid,
                                txt: optionController.text,
                                reportId: widget.reportid,
                              );
                          setModalState(() {
                            isLoading = false;
                          });
                          optionController.clear();
                          if (context.mounted && errorMsg == null) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    kHeight20,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
