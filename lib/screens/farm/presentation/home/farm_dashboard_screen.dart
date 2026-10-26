import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/functions/is_network_error.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/no_internet.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/farm/application/dashbaord/dashboard_cubit.dart';
import 'package:ufc_mobile/screens/farm/presentation/home/analytics_filter_container.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/build_cards.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/farm_shimmers.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/farm_switcher.dart';
import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';

class FarmDashboardScreen extends StatefulWidget {
  const FarmDashboardScreen({super.key});

  @override
  State<FarmDashboardScreen> createState() => _FarmDashboardScreenState();
}

class _FarmDashboardScreenState extends State<FarmDashboardScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;

    double newHeight = 74 - offset.clamp(0, 43);
    context.read<AppBarHeightCubit>().setHeight(newHeight);

    if (offset > 20) {
      context.read<AppBarCubit>().setMode(AppBarMode.channel);
    } else {
      context.read<AppBarCubit>().setMode(AppBarMode.normal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: primaryColor,
      onRefresh: () {
        return context.read<FarmDashboardCubit>().getDashboardDetails();
      },
      child: Column(
        children: [
          /// Active farm (farm members can work on an owner's farm)
          const FarmSwitcher(),

          /// Filter Container
          BlocBuilder<FarmDashboardCubit, DashboardState>(
              builder: (context, state) {
            final cubit = context.read<FarmDashboardCubit>();
            final filters = cubit.dashboard?.data?.filters ?? [];
            if (state is! DashboardError) {
              return FilterSelector(
                filters: filters,
                initFilter: cubit.filter ?? filters.firstOrNull,
                onFilterSelected: (value) {
                  context.read<FarmDashboardCubit>().updateFilter(value);
                },
              );
            }
            return SizedBox.shrink();
          }),
          BlocBuilder<AppBarHeightCubit, double>(
            builder: (context, appBarHeight) {
              if (appBarHeight == 74) {
                return const SizedBox.shrink();
              }
              return const SizedBox(height: 16);
            },
          ),

          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                heightSpace(20),

                /// Analytics Graphs
                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: buildContent(),
                      )
                    ],
                  ),
                ),
                heightSpace(200),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget heightSpace(double height) {
    return SliverToBoxAdapter(
      child: SizedBox(height: height),
    );
  }

  BlocBuilder buildContent() {
    return BlocBuilder<FarmDashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          /// Loading.....
          return DashboardShimmer();
        } else if (state is DashboardLoaded) {
          final cards = state.dashboardData?.data?.cards;

          /// NO DATA FOUND
          if (cards == null || cards.isEmpty) {
            return SizedBox(
              height: 200,
              child: Center(child: Text("No data found")),
            );
          }

          /// GRAPH LIST
          return BuildDashboardCards(cards: cards);
        } else if (state is DashboardError) {
          /// ERROR WIDGET
          return isNetworkError(state.message)
              ? NoInternet(
                  type: AppType.farm,
                  onTap: () {
                    return context
                        .read<FarmDashboardCubit>()
                        .getDashboardDetails();
                  },
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: Text('Error: ${state.message}')),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<FarmDashboardCubit>()
                            .getDashboardDetails();
                      },
                      child: CustomText(
                        text: 'Retry'.tr(),
                        fontSize: 16,
                        color: AppColors.grey,
                      ),
                    )
                  ],
                );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
