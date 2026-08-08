import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/farm_appbar.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/livestock_grid.dart';

import '../../../global/extensions/app_colors.dart';
import '../../../global/shared/constants/constants.dart';
import '../../../global/shared/widgets/custom_pagination_footer.dart';
import '../application/dashbaord/dashboard_cubit.dart';
import '../application/mothers_babies/mothers_babies_cubit.dart';
import '../domain/entities/barn/animal_model.dart';
import '../domain/entities/mothers_and_babies.dart';
import 'charts/farm_circle_with_pointers_chart.dart';
import 'charts/farm_pointer_indicator.dart';

class MotherAndBaby extends StatefulWidget {
  const MotherAndBaby({super.key});

  @override
  State<StatefulWidget> createState() => _MotherAndBabyState();
}

class _MotherAndBabyState extends State<MotherAndBaby> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    context.read<MothersBabiesCubit>().getLivestocks(isMother, false,
        category: context.read<FarmDashboardCubit>().filter?.key);
    super.initState();
  }

  List<AnimalModel> posts = [];
  MothersBabiesChart? chart;
  bool isMother = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomFarmAppBar(title: 'Mothers and babies'),
        body: BlocConsumer<MothersBabiesCubit, MothersBabiesState>(
          listener: (context, state) {
            if (state is MothersBabiesLoaded) {
              posts = state.animals ?? [];
              chart = state.chart;
              _refreshController.loadComplete();
              if (state.hasReachedMax) {
                _refreshController.loadNoData();
              }
            }
            if (state is MothersBabiesLoadingMore) {
              chart = state.chart;
              posts = state.animals ?? [];
              _refreshController.loadComplete();
              if (state.hasReachedMax) {
                _refreshController.loadNoData();
              }
            }
          },
          builder: (context, state) {
            if (state is MothersBabiesLoading) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state is MothersBabiesError) {
              return Center(
                child: CustomText(text: state.message),
              );
            } else if (state is MothersBabiesLoaded ||
                state is MothersBabiesLoadingMore) {
              return SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                physics: const BouncingScrollPhysics(),
                footer: CustomPaginationFooter(pageLimit: null),
                onRefresh: () {
                  context.read<MothersBabiesCubit>().getLivestocks(
                      isMother, false,
                      category: context.read<FarmDashboardCubit>().filter?.key);
                },
                onLoading: () {
                  context.read<MothersBabiesCubit>().getLivestocks(
                      isMother, true,
                      category: context.read<FarmDashboardCubit>().filter?.key);
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // hiding foe now ( not implemented yet - api_issue: #930 )
                        // const DownloadExcelWidget(),
                        kHeight15,
                        graph(chart),
                        const Divider(color: Colors.grey),
                        kHeight15,
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [customBoxShadow],
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              button('Mothers', isMother),
                              button('Babies', !isMother)
                            ],
                          ),
                        ),
                        kHeight25,
                        LivestockGrid(
                          scrollPhysics: const NeverScrollableScrollPhysics(),
                          animals: posts,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  GestureDetector button(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        context.read<MothersBabiesCubit>().getLivestocks(
            title == 'Mothers', false,
            category: context.read<FarmDashboardCubit>().filter?.key);
        if (!isSelected) {
          setState(() {
            isMother = title == 'Mothers' ? true : false;
          });
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: 34,
        width: 160,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.farmColor : Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: CustomText(
            text: title,
            fontWeight: FontWeight.w700,
            // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
            fontFamily:
                isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.grey),
      ),
    );
  }

  FarmCircleWithPointersChart graph(MothersBabiesChart? chart) {
    return FarmCircleWithPointersChart(
      isPlus: chart?.percentageChange?.toString().split('').firstOrNull != '-'
          ? true
          : null,
      fromDetailsPage: false,
      title: null,
      percentageCircle: chart?.percentageChange ?? 0,
      firstPointer: PointerIndicatorData(
          color: AppColors.farmColor,
          name: chart?.data?.firstOrNull?.title ?? '',
          total: chart?.data?.firstOrNull?.value ?? 0),
      secondPointer: PointerIndicatorData(
          color: Colors.cyan,
          name: (chart?.data?.length ?? 0) >= 2
              ? chart?.data![1].title ?? ''
              : '',
          total:
              (chart?.data?.length ?? 0) >= 2 ? chart?.data![1].value ?? 0 : 0),
    );
  }
}

class DownloadExcelWidget extends StatelessWidget {
  const DownloadExcelWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [customBoxShadow],
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/svg/farm/save.svg', width: 13),
          kWidth5,
          CustomText(
            text: 'Download Excel Report',
            // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
            fontFamily:
                isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
            fontSize: 12,
            fontWeight: FontWeight.w300,
          )
        ],
      ),
    );
  }
}
