import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';

import '../../../../global/extensions/app_colors.dart';
import '../../../../global/shared/constants/constants.dart';
import '../../../../global/shared/widgets/custom_indicator.dart';
import '../../../../global/shared/widgets/custom_reload_provider.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../../../../riverpod/farm/barn/barn_provider.dart';
import '../../../../riverpod/farm/get_livestock_async.dart';
import '../livestock/select_livestock_page.dart';

class AnimalRefWidget extends ConsumerStatefulWidget {
  final Function(String? category) onSelectCtegory;
  final Function(String? animalKey, String? animalRef)? onSelectanimal;
  final String? selectedAnimalCtegory;
  final bool needCategories;
  final bool fromQuestions;
  final String? selectedAnimalKeyFromQuestionsPage;
  final String? selectedAnimalRefFromQuestionsPage;
  final bool isNewBornReport;
  const AnimalRefWidget({
    super.key,
    required this.onSelectCtegory,
    this.selectedAnimalCtegory,
    this.onSelectanimal,
    required this.needCategories,
    this.fromQuestions = false,
    this.isNewBornReport = false,
    this.selectedAnimalKeyFromQuestionsPage,
    this.selectedAnimalRefFromQuestionsPage,
  });

  @override
  ConsumerState<AnimalRefWidget> createState() => _AnimalRefWidgetState();
}

class _AnimalRefWidgetState extends ConsumerState<AnimalRefWidget> {
  String? selected;
  @override
  void initState() {
    Future(() => loadBarn());
    selected = widget.selectedAnimalCtegory;
    super.initState();
  }

  Future<void> loadBarn() async {
    await ref.read(barnAsyncProvider.notifier).getBarn();
  }

  @override
  Widget build(BuildContext context) {
    final livestockAsync = ref.watch(getLivestockProvider);
    String? animalRef = livestockAsync.asData?.value?.selectedAnimalRef;

    return livestockAsync.when(
      data: (data) {
        if (data?.animals?.isEmpty ?? true) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/no_animals.png'),
              kHeight30,
              CustomText(
                fontSize: 23,
                fontWeight: FontWeight.w500,
                // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
                fontFamily:
                    isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
                text: 'No livestock available!',
              ),
              CustomText(
                fontSize: 14,
                textAlign: TextAlign.center,
                // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
                fontFamily:
                    isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
                text: 'No livestock have been added yet, press (Add) to start.',
              ),
            ],
          );
        }
        if (data?.selectedAnimalRef != null) {
          selected = null;
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.fromQuestions)
                    CustomText(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
                      fontFamily: isEnglish
                          ? AppFontsFamily.english
                          : AppFontsFamily.arabic,
                      text: 'Select specific livestock',
                    ),
                  GestureDetector(
                    onTap: () => Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                            builder: (context) =>
                                // Scaffold(
                                //       appBar: CustomFarmAppBar(title: 'Add LiveStock'),
                                //     )
                                SelectLivestock(
                                  isNewBornReport: widget.isNewBornReport,
                                  selectedAnimalKey:
                                      widget.selectedAnimalKeyFromQuestionsPage,
                                  isFromquestions: widget.fromQuestions,
                                  onSelectanimal: (animalKey, animalRef) {
                                    if (widget.onSelectanimal != null) {
                                      widget.onSelectanimal!(
                                          animalKey, animalRef);
                                    }
                                  },
                                ))),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.grey,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: widget.fromQuestions
                                ? widget.selectedAnimalRefFromQuestionsPage ??
                                    'Livestock number (e.g., 1234)'
                                : animalRef ?? 'Livestock number (e.g., 1234)',
                            fontSize: 16,
                            color: widget.fromQuestions
                                ? widget.selectedAnimalRefFromQuestionsPage !=
                                        null
                                    ? Colors.black
                                    : AppColors.grey
                                : animalRef != null
                                    ? Colors.black
                                    : AppColors.grey,
                            fontWeight: FontWeight.w400,
                            fontFamily: isEnglish
                                ? AppFontsFamily.english
                                : AppFontsFamily.arabic,
                          ),
                          Icon(Icons.navigate_next)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              kHeight10,
              if (widget.needCategories)
                Column(
                  children: [
                    CustomText(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: isEnglish
                          ? AppFontsFamily.english
                          : AppFontsFamily.arabic,
                      text: 'OR',
                    ),
                    kHeight10,
                    Column(
                      children: List.generate(
                        (data?.animalCategories?.length ?? 0) + 1,
                        (index) {
                          final content = index == 0
                              ? "All livestock".tr()
                              : data?.animalCategories?[index - 1].content;
                          final contentKey = index == 0
                              ? 'All livestock'
                              : data?.animalCategories?[index - 1].key;
                          final icon = index == 0
                              ? null
                              : data?.animalCategories?[index - 1].icon;
                          return GestureDetector(
                              onTap: () {
                                if (selected == contentKey) {
                                  setState(() {
                                    selected = null;
                                  });
                                  widget.onSelectCtegory(null);
                                } else {
                                  setState(() {
                                    selected = contentKey;
                                  });
                                  widget.onSelectCtegory(contentKey);
                                }
                                ref
                                    .read(getLivestockProvider.notifier)
                                    .setAnimalRef(null,
                                        selectedAnimalKey: null);
                              },
                              child: CustomSelectBox(
                                title: isArOrUr ? content ?? '' : content ?? '',
                                isSelected: selected == contentKey,
                                icon: icon,
                              ));
                        },
                      ),
                    ),
                    kHeight100
                  ],
                ),
            ],
          ),
        );
      },
      error: (error, stack) => CustomReloadProvider(
        height: 118,
        onPressed: () async =>
            await ref.read(getLivestockProvider.notifier).getLiveStocks(),
      ),
      loading: () => const SizedBox(
        height: 157,
        child: Center(child: CustomIndicator(padding: 50)),
      ),
    );
  }
}

class CustomSelectBox extends StatelessWidget {
  const CustomSelectBox({
    super.key,
    required this.isSelected,
    required this.title,
    this.icon,
  });

  final bool isSelected;
  final String title;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? AppColors.farmColor : AppColors.grey,
        ),
        borderRadius: BorderRadius.circular(16),
        color: isSelected
            ? AppColors.farmColor.withOpacity(0.08)
            : Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: isSelected ? AppColors.farmColor : AppColors.grey,
                  ),
                  color: isSelected ? AppColors.farmColor : Colors.transparent,
                ),
                child: isSelected
                    ? Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 18,
                      )
                    : null,
              ),
              kWidth10,
              CustomText(
                text: title,
                fontSize: 15,
              ),
            ],
          ),
          if (icon != null)
            SizedBox(
              height: 33,
              child: icon?.split('.').lastOrNull == 'svg'
                  ? SvgPicture.network(
                      icon ?? "",
                      height: 33,
                    )
                  : CachedNetworkImage(
                      height: 33,
                      imageUrl: icon ?? "",
                      placeholder: (context, url) => SizedBox.shrink(),
                      errorWidget: (context, url, error) => SizedBox.shrink(),
                      fit: BoxFit.contain,
                    ),
            ),
        ],
      ),
    );
  }
}
