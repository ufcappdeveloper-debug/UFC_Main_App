import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/farm/application/barn_details/barn_details_cubit.dart';
import 'package:ufc_mobile/screens/farm/application/barn_details/barn_details_state.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/barn/barn_model.dart';

import '../../../../global/extensions/app_colors.dart';
import '../../../../global/shared/widgets/custom_pagination_footer.dart';
import '../../../../global/shared/widgets/custom_reload_provider.dart';
import '../../../../riverpod/farm/barn/barn_provider.dart';
import '../widgets/add_barn.dart';
import '../widgets/barn_popup_menu.dart';
import '../widgets/custome_container.dart';
import '../widgets/farm_appbar.dart';
import '../widgets/farm_cagetories.dart';
import '../widgets/livestock_grid.dart';

class BarnPage extends ConsumerStatefulWidget {
  const BarnPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BarnPageState();
}

class _BarnPageState extends ConsumerState<BarnPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<Map<String, dynamic>> fodderData = [
    {'title': 'Feed', "value": '50'},
    // {'title': 'Maltah feed', "value": '20'},
    // {'title': 'Pills', "value": '100'},
  ];

  void _loadData() async {
    await ref.read(barnAsyncProvider.notifier).getBarn();
    final data = ref.read(barnAsyncProvider).value;
    context.read<BarnDetailsCubit>().filter.clear();
    if (data != null) {
      selectedBarn = data.firstOrNull;
      if (selectedBarn != null) {
        context.read<BarnDetailsCubit>().filter = {};
        if (mounted) {
          await context
              .read<BarnDetailsCubit>()
              .fetchBarnDetails(selectedBarn?.id ?? 0);
        }
      } else {
        context.read<BarnDetailsCubit>().clearState();
      }
    }
  }

  final ValueNotifier<int> registeredAnimalCount = ValueNotifier<int>(0);
  BarnModel? selectedBarn;
  @override
  void initState() {
    Future(() => _loadData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final barnAsync = ref.watch(barnAsyncProvider);
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(15),
            child: AddBarn(
              isAddBarn: true,
              onAddBarn: (newBarn) async {
                setState(() {
                  selectedBarn = newBarn;
                });
                if (selectedBarn?.id != null) {
                  await context
                      .read<BarnDetailsCubit>()
                      .fetchBarnDetails(selectedBarn!.id!);
                }
              },
            ),
          ),
          appBar: CustomFarmAppBar(
            title: 'Barns',
            actionButton: selectedBarn == null
                ? null
                : BarnPopupMenu(
                    selectedBarn: selectedBarn,
                    ref: ref,
                    onBarnChanged: (barn) {
                      setState(() {
                        selectedBarn = barn;
                      });
                    },
                  ),
          ),
          body: barnAsync.when(
            data: (data) => Column(
              children: [
                if (data.isNotEmpty)
                  HorizontalOptionSelector(
                    selectedBarnId: selectedBarn?.id,
                    barnList: data,
                    list: [],
                    onBarnChange: (value) async {
                      selectedBarn = value;
                      debugPrint('selectedBarn:${selectedBarn?.id}');
                      await context
                          .read<BarnDetailsCubit>()
                          .fetchBarnDetails(selectedBarn?.id ?? 0);
                      setState(() {});
                    },
                  ),
                kHeight5,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (data.isNotEmpty) fodder(),
                        kHeight20,
                        Row(
                          children: [
                            textWidget('${'Registered Animals'.tr()}:',
                                fontWeight: FontWeight.w500),
                            ValueListenableBuilder<int>(
                              valueListenable: registeredAnimalCount,
                              builder: (context, value, child) {
                                return textWidget(
                                  ': ${data.isNotEmpty == true ? registeredAnimalCount.value : 0}',
                                  color: AppColors.farmColor,
                                  fontWeight: FontWeight.w500,
                                );
                              },
                            )
                          ],
                        ),
                        kHeight10,
                        if (data.isNotEmpty == true)
                          Expanded(
                            child:
                                BlocConsumer<BarnDetailsCubit, BarnDetailsState>(
                              listener: (context, state) {
                                if (state is BarnDetailsLoaded) {
                                  if (!state.hasMore) {
                                    _refreshController.loadNoData();
                                  } else {
                                    _refreshController.loadComplete();
                                  }
                                }
                              },
                              builder: (context, state) {
                                if (state is BarnDetailsInitial) {
                                  if (selectedBarn != null) {
                                    context
                                        .read<BarnDetailsCubit>()
                                        .fetchBarnDetails(selectedBarn?.id ?? 0);
                                  }
                                  return const SizedBox();
                                } else if (state is BarnDetailsLoading) {
                                  return const Center(
                                      child: CupertinoActivityIndicator());
                                } else if (state is BarnDetailsLoaded) {
                                  WidgetsBinding.instance.addPostFrameCallback(
                                    (_) {
                                      registeredAnimalCount.value =
                                          state.barnDetails?.animalsCount ?? 0;
                                    },
                                  );
      
                                  final cubit = context.read<BarnDetailsCubit>();
      
                                  return SmartRefresher(
                                    footer: CustomPaginationFooter(
                                        pageLimit:
                                            !state.hasMore ? "empty" : null),
                                    physics: BouncingScrollPhysics(),
                                    controller: _refreshController,
                                    enablePullDown: true,
                                    enablePullUp: true,
                                    onRefresh: () async {
                                      await cubit.fetchBarnDetails(
                                          selectedBarn?.id ?? 0,
                                          loadMore: false);
                                      _refreshController.refreshCompleted();
                                    },
                                    onLoading: () async {
                                      await cubit.fetchBarnDetails(
                                          selectedBarn?.id ?? 0,
                                          loadMore: true);
                                      _refreshController.loadComplete();
                                    },
                                    child: LivestockGrid(
                                      fromBarn: true,
                                      scrollPhysics:
                                          NeverScrollableScrollPhysics(),
                                      bootomPadding: 80,
                                      animals: state.barnDetails?.animals,
                                    ),
                                  );
                                } else if (state is BarnDetailsError) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                          child: Text('Error: ${state.message}')),
                                      ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<BarnDetailsCubit>()
                                              .fetchBarnDetails(
                                                  selectedBarn?.id ?? 0);
                                        },
                                        child: CustomText(
                                          text: 'Retry',
                                          fontSize: 16,
                                          color: AppColors.grey,
                                        ),
                                      )
                                    ],
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                          )
                      ],
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
              child: Center(child: CupertinoActivityIndicator()),
            ),
          )),
    );
  }

  BlocBuilder fodder() {
    return BlocBuilder<BarnDetailsCubit, BarnDetailsState>(
      builder: (context, state) {
        return CustomFarmContainer(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              fodderRow('Fodder', 'Quantity'),
              Divider(thickness: 1, color: AppColors.grey),
              // dont remove the
              ...List.generate(
                  fodderData.length,
                  (index) => Column(
                        children: [
                          fodderRow(
                              fodderData[index]['title'],
                              state is BarnDetailsLoaded
                                  ? '${state.barnDetails?.barn?.feedQuantity ?? 0}'
                                  : '0'),
                          if (isArOrUr) kHeight5
                        ],
                      )),
              kHeight10,
              AddBarn(isAddBarn: false, barnId: selectedBarn?.id),
            ],
          ),
        );
      },
    );
  }

  Row fodderRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        textWidget(title, color: title == 'Fodder' ? null : AppColors.grey),
        textWidget(value,
            color: value == 'Quantity' ? AppColors.farmColor : null)
      ],
    );
  }

  CustomText textWidget(String text, {Color? color, FontWeight? fontWeight}) =>
      CustomText(
          text: text,
          // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
          fontFamily:
              isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
          color: color,
          fontSize: 16,
          fontWeight: fontWeight ?? FontWeight.w300);
}
