import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/language_cubit/language_cubit.dart';
import 'package:ufc_mobile/screens/farm/application/dashbaord/dashboard_cubit.dart';
import 'package:ufc_mobile/screens/farm/presentation/addreport.dart';
import 'package:ufc_mobile/screens/farm/presentation/home/farm_dashboard_screen.dart';
import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';
import 'package:ufc_mobile/screens/navigation/widgets/custom_tab_bar.dart';
import '../../../global/util/common/common_utils.dart';
import '../../../riverpod/app_bar/app_bar_riverpod.dart';
import '../../feed/application/authentication/auth_cubit.dart';
import '../../feed/presentation/authentication/widgets/guest_guard.dart';
import 'farm_profile/farm_profile_page.dart';
import 'livestock/livestock_page.dart';

class FarmBody extends ConsumerStatefulWidget {
  const FarmBody({super.key});

  @override
  ConsumerState<FarmBody> createState() => _FarmBodyState();
}

class _FarmBodyState extends ConsumerState<FarmBody> {
  @override
  void initState() {
    super.initState();

    final index = ref.read(farmBodySelectedIndexProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppBarHeightCubit>().setHeight(index == 0 ? 74 : 31);
      context
          .read<AppBarCubit>()
          .setMode(index == 0 ? AppBarMode.normal : AppBarMode.channel);
      context.read<BottomNavIndexCubit>().update(farm: index == 0);
    });
    Future(
      () {
        if (mounted) {
          context.read<FarmDashboardCubit>().getDashboardDetails();
        }
      },
    );
  }

  void onTap(int index) {
    final currentIndex = ref.read(farmBodySelectedIndexProvider);
    if (currentIndex == index) return;

    ref.read(farmBodySelectedIndexProvider.notifier).state = index;

    context.read<AppBarHeightCubit>().setHeight(index == 0 ? 74 : 31);
    context
        .read<AppBarCubit>()
        .setMode(index == 0 ? AppBarMode.normal : AppBarMode.channel);
    context.read<BottomNavIndexCubit>().update(farm: index == 0);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(farmBodySelectedIndexProvider);
    final isGuest = context.watch<AuthCubit>().isGuest;
    return SafeArea(
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: GuestGuard(
                appType: AppType.farm,
                color: AppColors.farmColor,
                child: _buildBody(selectedIndex)),
            floatingActionButton:
                (!isGuest && (selectedIndex == 0 || selectedIndex == 1))
                    ? FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => AddReportPage(),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        backgroundColor: AppColors.farmColor,
                        shape: CircleBorder(),
                        child: Icon(Icons.add, size: 30),
                      )
                    : null,
            bottomNavigationBar: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
                  borderRadius: BorderRadiusGeometry.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ExpandedCustomTab(
                      onTap: () => onTap(0),
                      asset: selectedIndex == 0
                          ? 'assets/images/navigation/white_home.svg'
                          : 'assets/images/navigation/home.png',
                      isSelected: selectedIndex == 0,
                      title: 'Home',
                    ),
                    ExpandedCustomTab(
                      onTap: () => onTap(1),
                      asset: selectedIndex == 1
                          ? 'assets/images/navigation/sheep.svg'
                          : 'assets/images/navigation/sheep_strok.svg',
                      isSelected: selectedIndex == 1,
                      title: 'Livestock',
                    ),
                    ExpandedCustomTab(
                      onTap: () => onTap(2),
                      asset: selectedIndex == 2
                          ? 'assets/images/navigation/farm_filled.svg'
                          : 'assets/images/navigation/farm_strok.svg',
                      isSelected: selectedIndex == 2,
                      title: 'Farm',
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return FarmDashboardScreen();
      case 1:
        return LivestockPage();
      case 2:
        return FarmProfilePage(onLanguageChange: () {
          setState(() {});
        });
      default:
        return SizedBox.shrink();
    }
  }
}
