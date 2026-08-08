import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/barn_drop_down.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/farm_cagetories.dart';

import '../../../../global/shared/widgets/custom_indicator.dart';
import '../../../../global/shared/widgets/custom_reload_provider.dart';
import '../../../../riverpod/farm/get_livestock_async.dart';
import '../../domain/entities/barn/animal_model.dart';
import '../widgets/animal_ref_widget.dart';
import '../widgets/farm_appbar.dart';

class SelectLivestock extends ConsumerStatefulWidget {
  final Function(String? animalKey, String? animalRef)? onSelectanimal;
  final bool isFromquestions;
  final bool isNewBornReport;
  final String? selectedAnimalKey;
  const SelectLivestock(
      {super.key,
      this.onSelectanimal,
      this.isFromquestions = false,
      this.isNewBornReport = false,
      this.selectedAnimalKey});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectLivestockState();
}

class _SelectLivestockState extends ConsumerState<SelectLivestock> {
  void _loadData() async {
    await ref.read(getLivestockProvider.notifier).getLiveStocks();
  }

  @override
  void initState() {
    Future(() => _loadData());
    super.initState();
  }

  String selectedcategory = "All";
  int? _selectedBarn;

  @override
  Widget build(BuildContext context) {
    final livestockAsync = ref.watch(getLivestockProvider);
    return SafeArea(
      child: Scaffold(
          appBar: CustomFarmAppBar(title: 'Add Livestock'),
          body: livestockAsync.when(
            data: (data) => Column(
              children: [
                HorizontalOptionSelector(
                  // initValue: selectedcategory,
                  categoryKeyFromSelectAnimal: selectedcategory,
                  onCategoryChange: (value) async {
                    await ref
                        .read(getLivestockProvider.notifier)
                        .getLiveStocksByCategory(
                            value == "All" ? null : value, _selectedBarn);
                    setState(() {
                      selectedcategory = value ?? 'All';
                    });
                  },
                  list: [],
                  categoriesFromSelectAnimal: [
                    AnimalCategoryModel(
                        all: true, content: 'All'.tr(), id: null, key: null),
                    ...data?.animalCategories ?? []
                  ],
                  // list: ["All", ...data?.animalCategories ?? []],
                ),
                // LiveStockSearchWidget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: BarnDropdown(
                        isFromSelectAnimal: true,
                        initBarn: _selectedBarn,
                        onChangeBarn: (barnId) async {
                          await ref
                              .read(getLivestockProvider.notifier)
                              .getLiveStocksByCategory(
                                  selectedcategory == 'All'
                                      ? null
                                      : selectedcategory,
                                  barnId);
                          setState(() {
                            _selectedBarn = barnId;
                          });
                        },
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                          children: List.generate(
                        data?.animals?.length ?? 0,
                        (index) {
                          final animal = data?.animals?[index];
                          if (animal?.animalRef == null) {
                            return SizedBox();
                          }
                          return GestureDetector(
                            onTap: () {
                              if (!widget.isFromquestions ||
                                  widget.isNewBornReport) {
                                ref
                                    .read(getLivestockProvider.notifier)
                                    .setAnimalRef(animal?.animalRef,
                                        selectedAnimalKey:
                                            animal?.animalUniqueKey)
                                    .then((value) {
                                  if (!widget.isNewBornReport) {
                                    Navigator.pop(context);
                                  }
                                });
                              }
                              if (widget.isFromquestions &&
                                  widget.onSelectanimal != null) {
                                widget.onSelectanimal!(
                                    animal?.animalUniqueKey, animal?.animalRef);
                                Navigator.pop(context);
                              }
                            },
                            child: CustomSelectBox(
                              icon: animal?.animalIcon,
                              title: "#${animal?.animalRef}",
                              isSelected: widget.isFromquestions
                                  ? widget.selectedAnimalKey ==
                                      animal?.animalUniqueKey
                                  : data?.selectedAnimalKey ==
                                      animal?.animalUniqueKey,
                            ),
                          );
                        },
                      )),
                    ),
                  ),
                )
              ],
            ),
            error: (error, stack) => CustomReloadProvider(
              height: 118,
              onPressed: () => _loadData(),
            ),
            loading: () => const SizedBox(
              height: 157,
              child: Center(child: CustomIndicator(padding: 50)),
            ),
          )),
    );
  }
}
