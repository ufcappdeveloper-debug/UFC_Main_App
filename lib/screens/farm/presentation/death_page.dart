import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/farm/presentation/charts/curved_line_chart.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/farm_appbar.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/livestock_grid.dart';

import '../../../global/extensions/app_colors.dart';
import '../../../global/shared/constants/constants.dart';
import '../../../global/shared/widgets/custom_pagination_footer.dart';
import '../application/dashbaord/dashboard_cubit.dart';
import '../application/death/death_cubit.dart';
import '../domain/entities/barn/animal_model.dart';
import '../domain/entities/dashboard/dashboard_card_model.dart';
import '../domain/entities/donut_chart_model.dart';
import 'charts/farm_chart_component.dart';
import 'charts/farm_circal_chart.dart';

class DeathPage extends StatefulWidget {
  const DeathPage({super.key});

  @override
  State<DeathPage> createState() => _DeathPageState();
}

class _DeathPageState extends State<DeathPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    context
        .read<DeathCubit>()
        .getDeathData(category: context.read<FarmDashboardCubit>().filter?.key);
  }

  List<AnimalModel> posts = [];
  DonutChartModel? donutChart;
  CardModel? lineChart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomFarmAppBar(title: 'Death'),
      body: BlocConsumer<DeathCubit, DeathState>(
        listener: (context, state) {
          if (state is DeathLoaded) {
            posts = state.animals ?? [];
            donutChart = state.donutChart;
            lineChart = state.lineChart;
            _refreshController.refreshCompleted();
            state.hasMore
                ? _refreshController.loadComplete()
                : _refreshController.loadNoData();
          }
          if (state is DeathLoadingMore) {
            posts = state.animals ?? [];
            donutChart = state.donutChart;
            lineChart = state.lineChart;
            state.hasMore
                ? _refreshController.loadComplete()
                : _refreshController.loadNoData();
          }
        },
        builder: (context, state) {
          if (state is DeathLoading) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (state is DeathError) {
            return Center(
              child: GestureDetector(
                onTap: () {
                  context.read<DeathCubit>().getDeathData(
                      category: context.read<FarmDashboardCubit>().filter?.key);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      text: state.message,
                      color: AppColors.grey,
                      fontSize: 10,
                    ),
                    kHeight10,
                    CustomText(
                      text: 'Retry',
                      color: AppColors.farmColor,
                      fontSize: 13,
                    ),
                  ],
                ),
              ),
            );
          } else if (state is DeathLoaded || state is DeathLoadingMore) {
            return SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              physics: const BouncingScrollPhysics(),
              footer: CustomPaginationFooter(pageLimit: null),
              onRefresh: () {
                context.read<DeathCubit>().getDeathData(
                    category: context.read<FarmDashboardCubit>().filter?.key);
              },
              onLoading: () {
                context.read<DeathCubit>().getDeathData(
                    loadMore: true,
                    category: context.read<FarmDashboardCubit>().filter?.key);
              },
              child: ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  // hiding foe now ( not implemented yet - api_issue: #930 )
                  // Row(children: [DownloadExcelWidget()]),
                  kHeight15,
                  if (donutChart != null && lineChart != null)
                    graph(donutChart!.percentageChange, donutChart!.value,
                        lineChart!),
                  const Divider(color: Colors.grey, thickness: 1),
                  kHeight25,
                  //mosthafa mentioned here not need search
                  // SizedBox(
                  //   height: 40,
                  //   child: Row(
                  //     children: [
                  //       FarmSearchField(
                  //         onSubmitted: (value) {},
                  //         hint: 'Sort by'.tr(),
                  //         iconSvg: 'assets/svg/global/menu.svg',
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  kHeight25,
                  LivestockGrid(
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                    isFromDeath: true,
                    animals: posts,
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  FarmChartComponent graph(
      double? percentage, int? deathValue, CardModel lineCahrt) {
    return FarmChartComponent(
      height: null,
      needBorder: false,
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 90,
            width: 90,
            child: PercentageCircle(
              percentage: percentage ?? 0,
              firstColor: AppColors.purpleColor,
              secondColor: Colors.grey.shade200,
              size: Size(90, 90),
              strokeWidth: 16,
            ),
          ),
          kWidth10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  // text: '${'Death as of this Month'.tr()} ${deathValue ?? 0}',
                  text: lineCahrt.subtitle,
                  // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
                  fontFamily: isEnglish
                      ? AppFontsFamily.english
                      : AppFontsFamily.arabic,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  textAlign: TextAlign.center,
                ),
                DeathLineChart(
                  maxX: (lineCahrt.data?.length ?? 0).toDouble(),
                  maxY: (lineCahrt.data
                              ?.map((e) => e.value ?? 0)
                              .reduce((a, b) => a > b ? a : b)
                              .toDouble() ??
                          0) +
                      1,
                  spots: lineCahrt.data
                          ?.asMap()
                          .entries
                          .map((entry) => FlSpot(entry.key.toDouble(),
                              (entry.value.value ?? 0).toDouble()))
                          .toList() ??
                      [],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
