import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/station/station_model.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/product/product_async_riverpod.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_footer.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_pagination_header.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/product_container.dart';

class StationProduct extends ConsumerStatefulWidget {
  final StationModel station;
  const StationProduct({super.key, required this.station});

  @override
  ConsumerState<StationProduct> createState() => _StationProductState();
}

class _StationProductState extends ConsumerState<StationProduct> {
  int page = 1;
  String? pageLimit;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    page = 1;
    pageLimit = null;
    super.initState();
    Future(() => ref
        .read(productAsyncProvider().notifier)
        .getProducts(widget.station.id!, null));
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    page = 1;
    pageLimit = null;

    await ref
        .read(productAsyncProvider().notifier)
        .getProducts(widget.station.id!, null);
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (pageLimit != "empty") {
      page++;
    }

    pageLimit = await ref
        .read(productAsyncProvider().notifier)
        .loadProducts(page, widget.station.id!, null);
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).asData?.value;
    final productData = ref.watch(productAsyncProvider());
    return productData.when(
        error: (error, stackTrace) => CustomText(
              text: "something went wrong",
            ),
        loading: () => const Center(child: CupertinoActivityIndicator()),
        data: (data) {
          return data == null || data.isEmpty
              ? Center(
                  child: CustomText(text: "No Products Available"),
                )
              : SmartRefresher(
                  enablePullUp: true,
                  enablePullDown: true,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  controller: _refreshController,
                  header: const CustomPaginationHeader(),
                  footer: CustomPaginationFooter(
                      pageLimit: pageLimit,
                      emptyDataText: "No More Product Found"),
                  physics: const BouncingScrollPhysics(),
                  child: GridView.builder(
                      itemCount: data.length,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 18),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 18,
                              mainAxisExtent: 248,
                              crossAxisSpacing: 18),
                      itemBuilder: (context, index) {
                        final product = data[index];
                        return ProductContainer(
                            productData: product,
                            canBuy: user?.preferredShopDetails != null &&
                                    widget.station.id !=
                                        user?.preferredShopDetails?.id
                                ? false
                                : true);
                      }),
                );
        });
  }
}
