import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/functions/is_network_error.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/no_internet.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/barn_drop_down.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/livestock_box.dart';

import '../../../../global/shared/constants/app_colors.dart';
import '../../../../global/shared/widgets/custom_pagination_footer.dart';
import '../../../../global/shared/widgets/custom_pagination_header.dart';
import '../../../../global/shared/widgets/custom_reload_provider.dart';
import '../../../../riverpod/farm/barn/barn_provider.dart';
import '../../../pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';
import '../../application/barn_details/barn_details_cubit.dart';
import '../../application/barn_details/barn_details_state.dart';
import '../../domain/entities/barn/animal_model.dart';
import '../home/farm_dashboard_screen.dart';
import '../widgets/farm_cagetories.dart';
import '../widgets/farm_shimmers.dart';
import '../widgets/livestock_grid.dart';
import '../widgets/livestock_search_widget.dart';

class LivestockPage extends ConsumerStatefulWidget {
  const LivestockPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LiveStockPageState();
}

class _LiveStockPageState extends ConsumerState<LivestockPage> {
  final PageController _pageController = PageController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int _currentPage = 0;
  String? _selectedCategory;
  int? _selectedBarn;
  final List<Map<String, dynamic>> data = [
    {'image': 'assets/svg/farm/animal2.svg', 'color': const Color(0xFF78B833)},
    {'image': 'assets/svg/farm/animal3.svg', 'color': const Color(0xFF977016)},
    {'image': 'assets/svg/farm/animal4.svg', 'color': const Color(0xFF0C83B6)},
    {'image': 'assets/svg/farm/animal1.svg', 'color': const Color(0xFFD2A848)},
    {'image': 'assets/svg/farm/animal2.svg', 'color': const Color(0xFF78B833)},
    {'image': 'assets/svg/farm/animal3.svg', 'color': const Color(0xFF977016)},
    {'image': 'assets/svg/farm/animal4.svg', 'color': const Color(0xFF0C83B6)},
  ];

  @override
  void initState() {
    Future(() => loadData());
    super.initState();
  }

  int? _firstBarnId;

  Future<void> loadData() async {
    final barns = await ref.read(barnAsyncProvider.notifier).getBarn();
    context.read<BarnDetailsCubit>().filter = {};
    if (barns?.isNotEmpty ?? false) {
      _firstBarnId = barns?.firstOrNull?.id;
      if (_firstBarnId != null && mounted) {
        context
            .read<BarnDetailsCubit>()
            .fetchBarnDetails(_firstBarnId!, allBarn: true);
        _selectedBarn = null;
      }
    } else {
      context.read<BarnDetailsCubit>().clearState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final barnAsync = ref.watch(barnAsyncProvider);
    return barnAsync.when(
      data: (data) {
        return BlocConsumer<BarnDetailsCubit, BarnDetailsState>(
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
            if (state is BarnDetailsLoading) {
              return LivestockShimmer();
            } else if (state is BarnDetailsLoaded) {
              final cubit = context.read<BarnDetailsCubit>();
              log('availableFilters: ${state.barnDetails?.availableFilters ?? []}');
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HorizontalOptionSelector(
                      selectedCategoryKey: _selectedCategory ??
                          state.barnDetails?.availableCategories?.firstOrNull
                              ?.key,
                      list: [],
                      availableCategories:
                          state.barnDetails?.availableCategories,
                      onCategoryChange: (String? index) {
                        context.read<BarnDetailsCubit>().filter = {};
                        _selectedCategory = index;
                        if (_selectedBarn != null) {
                          context.read<BarnDetailsCubit>().fetchBarnDetails(
                              _selectedBarn!,
                              animalCategory: index);
                        } else if (_firstBarnId != null) {
                          cubit.fetchBarnDetails(
                            _firstBarnId!,
                            animalCategory: _selectedCategory,
                            allBarn: true,
                            loadMore: false,
                          );
                        }
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BarnDropdown(
                        initBarn: _selectedBarn,
                        onChangeBarn: (barnId) {
                          setState(() {
                            _selectedBarn = barnId;
                          });
                        },
                      )
                    ],
                  ),
                  LiveStockSearchWidget(
                    availableFilters: state.barnDetails?.availableFilters ?? [],
                    onSubmitted: (value) async {
                      if (value.trim().isNotEmpty) {
                        context.read<BarnDetailsCubit>().filter = {
                          "search": value
                        };
                        if (_selectedBarn != null) {
                          await cubit.fetchBarnDetails(
                            _selectedBarn!,
                            animalCategory: _selectedCategory,
                            loadMore: false,
                          );
                        } else if (_firstBarnId != null) {
                          await cubit.fetchBarnDetails(
                            _firstBarnId!,
                            animalCategory: _selectedCategory,
                            allBarn: true,
                            loadMore: false,
                          );
                        }
                      }
                    },
                    isAllBarn: _selectedBarn == null,
                    barnId: _selectedBarn ?? _firstBarnId,
                    category: _selectedCategory,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: SmartRefresher(
                        header: CustomPaginationHeader(),
                        footer: CustomPaginationFooter(
                            pageLimit: !state.hasMore ? "empty" : null),
                        physics: BouncingScrollPhysics(),
                        controller: _refreshController,
                        enablePullDown: true,
                        enablePullUp: true,
                        onRefresh: () async {
                          context.read<BarnDetailsCubit>().filter = {};
                          if (_selectedBarn != null) {
                            await cubit.fetchBarnDetails(
                              _selectedBarn!,
                              animalCategory: _selectedCategory,
                              loadMore: false,
                            );
                          } else if (_firstBarnId != null) {
                            await cubit.fetchBarnDetails(
                              _firstBarnId!,
                              animalCategory: _selectedCategory,
                              allBarn: true,
                              loadMore: false,
                            );
                          }
                          _refreshController.refreshCompleted();
                        },
                        onLoading: () async {
                          if (_selectedBarn != null) {
                            await cubit.fetchBarnDetails(
                              _selectedBarn!,
                              animalCategory: _selectedCategory,
                              loadMore: true,
                            );
                          } else if (_firstBarnId != null) {
                            await cubit.fetchBarnDetails(
                              _firstBarnId!,
                              animalCategory: _selectedCategory,
                              allBarn: true,
                              loadMore: true,
                            );
                          }
                          _refreshController.loadComplete();
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Recently Added',
                                // fontFamily:
                                //     isArOrUr ? 'Graphik Arabic' : 'Kanit',
                                fontFamily: isEnglish
                                    ? AppFontsFamily.english
                                    : AppFontsFamily.arabic,
                                textStyle:
                                    PetVeterinaryFontstyles.kanitMedium16,
                              ),
                              kHeight15,
                              recentlyAddedList(
                                  state.barnDetails?.animals ?? []),
                              const Divider(
                                  height: 50, thickness: 1, color: Colors.grey),
                              LivestockGrid(
                                category: _selectedCategory,
                                scrollPhysics: NeverScrollableScrollPhysics(),
                                bootomPadding: 80,
                                animals: state.barnDetails?.animals,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is BarnDetailsError) {
              return Center(
                child: GestureDetector(
                  onTap: () {
                    // context.read<BarnDetailsCubit>().fetchBarnDetails();
                  },
                  child: Column(
                    children: [
                      CustomText(
                        text: state.message,
                        color: AppColors.grey,
                        fontSize: 10,   
                      ),
                      kHeight10,
                      CustomText(
                        text: 'Retry',
                        color: primaryColor,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: CustomText(
                  fontSize: 15,
                  textAlign: TextAlign.center,
                  fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
                  text: 'No livestock have been added yet',
                ),
              );
            }
          },
        );
      },
      error: (error, stack) => isNetworkError(error.toString())
          ? NoInternet(
              type: AppType.farm,
              onTap: () => loadData(),
            )
          : CustomReloadProvider(
              height: 118,
              onPressed: () {},
            ),
      loading: () => const Center(child: LivestockShimmer()),
    );
  }

  Column recentlyAddedList(List<AnimalModel?>? animals) {
    final int totalPages =
        ((((animals?.length ?? 0) > 4) ? 4 : animals?.length ?? 0) / 2).ceil();
    return Column(
      children: [
        // PageView with 2 items per page
        SizedBox(
          height: 110,
          child: PageView.builder(
            controller: _pageController,
            itemCount: totalPages,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, pageIndex) {
              final int firstIndex = pageIndex * 2;
              final int secondIndex = firstIndex + 1;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      LiveStockBox(
                        fromGrid: false,
                        category: _selectedCategory,
                        animal: animals?[firstIndex],
                        isMale: true,
                        width: MediaQuery.sizeOf(context).width * 0.44,
                      ),
                      if (secondIndex < (animals?.length ?? 0)) ...[
                        kWidth10,
                        LiveStockBox(
                          fromGrid: false,
                          category: _selectedCategory,
                          animal: animals?[secondIndex],
                          isMale: true,
                          width: MediaQuery.sizeOf(context).width * 0.44,
                        ),
                      ],
                    ],
                  ),
                  kHeight5,
                ],
              );
            },
          ),
        ),
        kHeight10,

        // Custom 3-dot indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              totalPages <= 1 ? 1 : (totalPages == 2 ? 2 : 3), (index) {
            Color color;
            double width = 6;
            if (totalPages <= 1) {
              color = index == 0 ? Colors.black : Colors.grey;
            } else if (totalPages == 2) {
              color = index == _currentPage ? Colors.black : Colors.grey;
            } else {
              // 3 or more pages
              if (_currentPage == 0) {
                color = index == 0 ? Colors.black : Colors.grey;
                width = index == 0 ? 12 : 6;
              } else if (_currentPage == totalPages - 1) {
                color = index == 2 ? Colors.black : Colors.grey;
                width = index == 2 ? 12 : 6;
              } else {
                color = index == 1 ? Colors.black : Colors.grey;
                width = index == 1 ? 12 : 6;
              }
            }
            return Row(
              children: [
                Container(height: 3, width: width, color: color),
                if (index != 2) kWidth5,
              ],
            );
          }),
        ),
      ],
    );
  }
}
