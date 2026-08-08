import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/global/language_cubit/language_cubit.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/functions/is_network_error.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_footer.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_header.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_search_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/no_internet.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/models/community_models/channel_model/channel_list_model.dart';
import 'package:ufc_mobile/riverpod/community/channel_riverpod.dart';
import 'package:ufc_mobile/screens/community/components/channel_list_component.dart';
import 'package:ufc_mobile/screens/community/components/community_rules.dart';
import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';
import 'package:ufc_mobile/screens/feed/presentation/authentication/widgets/guest_guard.dart';

final isInHomeProvider = StateProvider<bool>((ref) => true);

class CommunityPage extends ConsumerStatefulWidget {
  const CommunityPage({super.key});

  @override
  ConsumerState<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends ConsumerState<CommunityPage>
    with TickerProviderStateMixin {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController searchController = TextEditingController();
  int page = 1;
  late TabController _tabController;
  late ScrollController _scrollController;
  String searchValue = '';
  FocusNode focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(channelRiverpodProvider.notifier).fetchChannels(page: page);
      ref.read(isInHomeProvider.notifier).state = true;

      final isInHome = ref.read(isInHomeProvider);

      context.read<AppBarHeightCubit>().setHeight(isInHome ? 74 : 31);
      context
          .read<AppBarCubit>()
          .setMode(isInHome ? AppBarMode.normal : AppBarMode.channel);
      context.read<BottomNavIndexCubit>().update(farm: isInHome);
    });

    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    searchController.addListener(() {
      onCompleted(searchController.text);
    });
  }

  Future<void> _refreshChannels() async {
    page = 1;
    await ref.read(channelRiverpodProvider.notifier).fetchChannels(page: page);
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _refreshController.dispose();
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

  Widget content(AsyncValue<ChannelListResponseModel?> channelList) =>
      BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) {
          return SafeArea(
            child: GuestGuard(
              appType: AppType.community,
              color: Color(0xff9D4EDD),
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                onRefresh: _refreshChannels,
                onLoading: () async {
                  final nextPage = page + 1;
                  await ref.read(channelRiverpodProvider.notifier).loadChannels(
                        page: nextPage,
                        searchValue: searchValue,
                      );
                  _refreshController.loadComplete();
                },
                header: const CustomPaginationHeader(),
                footer: CustomPaginationFooter(
                  pageLimit: channelList.value?.pagination?.lastPage == page
                      ? "empty"
                      : null,
                  emptyDataText: "No More Channels Found".tr(),
                ),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            kHeight10,
                            CommunityRulesComponent(),
                            kHeight20,
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverPersistentHeader(
                        pinned: true,
                        delegate: _SearchBarDelegate(
                          height: 40,
                          searchBar: CustomSearchBar(
                            controller: searchController,
                            isExpanded: true,
                            height: 40,
                            myFocusNode: focus,
                            hintText: 'Search for a community'.tr(),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 15,
                                color: Colors.black.withOpacity(0.1),
                              )
                            ],
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              width: 0,
                              color: Colors.transparent,
                            ),
                            suffixIcon: searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => cancelSearch(),
                                  )
                                : SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ),

                    /// Channel List
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            kHeight10,
                            CommunityChannelList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    final channelList = ref.watch(channelRiverpodProvider);
    return channelList.maybeWhen(
        error: (error, stackTrace) => isNetworkError(error.toString())
            ? NoInternet(
                type: AppType.community,
                onTap: () => _refreshChannels(),
              )
            : content(channelList),
        orElse: () => content(channelList));
  }

  Future<void> onCompleted(String? value) async {
    if ((value ?? '').isNotEmpty) {
      try {
        await ref
            .read(channelRiverpodProvider.notifier)
            .fetchChannels(page: page, searchValue: value);
        searchValue = value ?? '';
        setState(() {});
      } catch (e) {
        if (!mounted) return;
        CustomSnackBar.error(
          context,
          !kDebugMode ? 'Something Went Wrong' : 'Error fetching channels: $e',
        );
      }
    } else {
      if (focus.hasPrimaryFocus) {
        ref.read(channelRiverpodProvider.notifier).fetchChannels(page: page);
      }
    }
  }

  Future<void> cancelSearch() async {
    searchController.clear();
    searchValue = '';
    setState(() {});
    _refreshChannels();
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget searchBar;
  final double height;

  _SearchBarDelegate({required this.searchBar, required this.height});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: searchBar,
    );
  }

  @override
  double get maxExtent => height;
  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
