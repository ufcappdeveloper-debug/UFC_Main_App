import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/extensions/app_images.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/productList/product_list_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/bottom_bar/page/feed_bottom_bar.dart';

import '../../../application/authentication/auth_cubit.dart';
import '../../../application/bottom_bar_bloc/bottom_bar_bloc.dart';
import '../../../application/feed_channel/feed_channel_cubit.dart';
import '../../../application/feed_channel/feed_channel_state.dart';
import '../../../application/station/station_cubit.dart';
import '../../../application/station/station_state.dart';
import '../widgets/feed_home_helper.dart';
import '../../../domain/entities/product/product_list_params.dart';
import '../../category/pages/category_screen.dart';
import '../../distributor/utils/distributor_style.dart';

/// Feed Home (design: "Feed - Home v2"): hero title plus two entry cards,
/// "Buy from Station" and "Buy from Distributor".
class FeedHomePage extends StatefulWidget {
  const FeedHomePage({super.key});

  @override
  State<FeedHomePage> createState() => _FeedHomePageState();
}

class _FeedHomePageState extends State<FeedHomePage> {
  @override
  void initState() {
    super.initState();
    final authCubit = context.read<AuthCubit>();
    final currentState = authCubit.state;
    if (currentState is ProfileLoadedSuccess) {
      _fetchStationProducts(currentState.user);
    } else if (!authCubit.isGuest) {
      authCubit.loadProfile();
    }
  }

  /// Keeps the station catalogue warm for the Products tab.
  void _fetchStationProducts(UserModel user) {
    context.read<ProductListCubit>().getProducts(
          params: ProductListQueryParams(
              shopId: user.preferredShopDetails?.id ?? 0, userId: user.id),
        );
  }

  Future<void> _open(FeedChannel channel) async {
    if (channel == FeedChannel.station && !await _ensureStation()) return;
    if (!mounted) return;
    if (channel == FeedChannel.distributor) {
      // Always choose from all distributors (no saved distributor).
      context.read<FeedChannelCubit>().startDistributorSelection();
    } else {
      context.read<FeedChannelCubit>().setChannel(channel);
    }
    context.read<FeedBottomNavCubit>().changeTab(1);
    context.read<AppBarHeightCubit>().setHeight(31);
    context.read<AppBarCubit>().setMode(AppBarMode.channel);
    context.read<FeedBackgroundCubit>().updateBackground(AppImages.feedSmallBg);
    if (channel == FeedChannel.station) {
      CategoryScreen.categoryKey.currentState?.resetTab();
    }
  }

  /// "Buy from Station" without a preferred station: ask for one first.
  /// Returns false when the user closed the picker without choosing.
  Future<bool> _ensureStation() async {
    final auth = context.read<AuthCubit>();
    if (auth.isGuest || auth.currentUser?.preferredShopDetails?.id != null) {
      return true;
    }
    await feedHomeHelper.showStationBottomSheet(context);
    if (!mounted) return false;
    return context.read<StationCubit>().state is StationSuccess;
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      _HomeOption(
        title: 'Buy from Station',
        subtitle: 'Order from a nearby station for pickup or delivery',
        icon: 'assets/svg/feed/stations_icon.svg',
        iconSize: const Size(26, 26),
        mirror: false,
        onTap: () => _open(FeedChannel.station),
      ),
      _HomeOption(
        title: 'Buy from Distributor',
        subtitle: 'Order directly from approved feed distributors',
        icon: 'assets/svg/feed/truck.svg',
        iconSize: const Size(30, 24),
        // The truck faces the reading direction.
        mirror: !isArOrUr,
        onTap: () => _open(FeedChannel.distributor),
      ),
    ];
    // Distributor always on top, in every language.
    final ordered = options.reversed.toList();

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, curr) => curr is ProfileLoadedSuccess,
      listener: (context, state) {
        if (state is ProfileLoadedSuccess) _fetchStationProducts(state.user);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // Fills the screen when there is room (cards at the bottom) and
        // scrolls instead of overflowing on small screens / large fonts.
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  children: [
                    Transform.translate(
                      offset: Offset(0, -sHeight(context) * 0.06),
                      child: const _HeroTitle(),
                    ),
                    const SizedBox(height: 16),
                    const Spacer(),
                    for (final option in ordered) ...[
                      _HomeOptionCard(option: option),
                      if (option != ordered.last) const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroTitle extends StatelessWidget {
  const _HeroTitle();

  @override
  Widget build(BuildContext context) {
    const shadow = [
      Shadow(color: Color(0x8A000000), offset: Offset(1, 1), blurRadius: 4)
    ];
    TextStyle style(double size) => TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: size,
          height: 1.17,
          shadows: shadow,
        );
    // Shrinks to fit narrow screens instead of spilling over the edges.
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Discover'.tr(), style: style(isArOrUr ? 40 : 50)),
            Text('100% Plant-Based Feed'.tr(),
                style: style(isArOrUr ? 45 : 33)),
          ],
        ),
      ),
    );
  }
}

class _HomeOption {
  final String title;
  final String subtitle;
  final String icon;
  final Size iconSize;
  final bool mirror;
  final VoidCallback onTap;

  const _HomeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconSize,
    required this.mirror,
    required this.onTap,
  });
}

class _HomeOptionCard extends StatelessWidget {
  final _HomeOption option;

  const _HomeOptionCard({required this.option});

  @override
  Widget build(BuildContext context) {
    Widget icon = SvgPicture.asset(
      option.icon,
      width: option.iconSize.width,
      height: option.iconSize.height,
      colorFilter:
          const ColorFilter.mode(DistributorStyle.green, BlendMode.srcIn),
    );
    if (option.mirror) {
      icon = Transform.flip(flipX: true, child: icon);
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: option.onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: DistributorStyle.card(radius: 20),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: DistributorStyle.greenTint,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: icon,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(option.title.tr(),
                        style: DistributorStyle.style(
                            size: 16, weight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(option.subtitle.tr(),
                        style: DistributorStyle.style(
                            size: 12,
                            weight: FontWeight.w300,
                            color: DistributorStyle.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                    color: DistributorStyle.green, shape: BoxShape.circle),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
