import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/riverpod/product/product_async_riverpod.dart';

import '../../../../global/shared/widgets/custom_indicator.dart';
import '../../../../global/shared/widgets/custom_no_data.dart';
import '../../../../global/shared/widgets/custom_pagination_footer.dart';
import '../../../../global/shared/widgets/custom_pagination_header.dart';
import '../../../../global/shared/widgets/custom_reload_provider.dart';
import '../../../../global/shared/widgets/product_container.dart';
import '../../../../riverpod/auth/auth.dart';
import '../../../feed/application/navbar/app_bar_cubit.dart';

class HomePageSearch extends ConsumerStatefulWidget {
  final bool fromCategory;
  const HomePageSearch({super.key, this.fromCategory = false});

  @override
  ConsumerState<HomePageSearch> createState() => _HomePageSearchState();
}

class _HomePageSearchState extends ConsumerState<HomePageSearch>
    with ScreenEngagementTracker {
  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();
  late int shopId;
  int page = 1;
  String? pageLimit;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
    page = 1;
    pageLimit = null;
    shopId = (ref.read(authProvider).value!.preferredShopDetails?.id)!;
    Future(() =>
        ref.read(productAsyncProvider().notifier).getProducts(shopId, null));
    Future(() => searchNode.requestFocus());
  }

  void _onRefresh() async {
    page = 1;
    pageLimit = null;
    searchController.clear();
    await ref.read(productAsyncProvider().notifier).getProducts(shopId, null);
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (pageLimit != "empty") {
      page++;
    }

    pageLimit = await ref
        .read(productAsyncProvider().notifier)
        .loadProducts(page, shopId, null);
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    searchController.dispose();
    searchNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = ref.watch(productAsyncProvider());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            if (widget.fromCategory) {
              context.read<AppBarCubit>().setMode(AppBarMode.channel);
              context.read<AppBarHeightCubit>().setHeight(130);
            }
            Navigator.pop(context);
          },
        ),
        title: Container(
          height: 27,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: const Color(0xFFD9D9D9),
              ),
              borderRadius: BorderRadius.circular(36)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 9),
              SvgPicture.asset("assets/images/global/search_icon.svg"),
              const SizedBox(width: 7),
              Expanded(
                child: TextField(
                  cursorColor: primaryColor,
                  onChanged: (value) =>
                      ref.read(productAsyncProvider().notifier).getProducts(
                            shopId,
                            null,
                            search: searchController.text,
                          ),
                  controller: searchController,
                  focusNode: searchNode,
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ]")),
                  // ],
                  maxLength: 35,
                  decoration: const InputDecoration(
                    isDense: true,
                    counterText: "",
                    contentPadding: EdgeInsets.all(0),
                    hintText: "Search Product",
                    hintStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Kanit',
                      color: Color(0xFFD9D9D9),
                      fontWeight: FontWeight.w300,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(width: 7),
            ],
          ),
        ),
      ),
      body: productProvider.when(
        data: (data) => SmartRefresher(
          enablePullUp: true,
          enablePullDown: true,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          controller: _refreshController,
          header: const CustomPaginationHeader(),
          footer: CustomPaginationFooter(
              pageLimit: pageLimit, emptyDataText: "No More Product Found"),
          physics: const BouncingScrollPhysics(),
          child: (data == null || data.isEmpty)
              ? const Column(
                  children: [
                    CustomNoData(
                      height: 56,
                      text: "No Product Found",
                    ),
                  ],
                )
              : GridView.builder(
                  itemCount: data.length,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 17,
                      childAspectRatio: 0.65,
                      maxCrossAxisExtent: 197),
                  itemBuilder: (context, index) {
                    return ProductContainer(productData: data[index]);
                  },
                ),
        ),
        error: (error, stack) => Column(
          children: [
            CustomReloadProvider(
              height: 118,
              onPressed: () =>
                  ref.read(productAsyncProvider().notifier).getProducts(
                        shopId,
                        null,
                        search: searchController.text,
                      ),
            ),
          ],
        ),
        loading: () => const Column(
          children: [
            SizedBox(
              height: 157,
              child: Center(child: CustomIndicator(padding: 50)),
            ),
          ],
        ),
      ),
    );
  }
}
