import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/shared/init/injection.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';

import '../../../application/distributor/distributor_favorite_cubit.dart';
import '../pages/distributor_product_details_page.dart';
import '../utils/distributor_style.dart';
import 'distributor_product_card.dart';

/// "Distributors" tab of the favorites page.
class DistributorFavoritesView extends StatelessWidget {
  const DistributorFavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DistributorFavoriteCubit>()..load(),
      child: BlocBuilder<DistributorFavoriteCubit, DistributorFavoriteState>(
        builder: (context, state) {
          final cubit = context.read<DistributorFavoriteCubit>();
          if (state.loading) {
            return const Center(
                child:
                    CircularProgressIndicator(color: DistributorStyle.green));
          }
          if (state.error != null && state.products.isEmpty) {
            return CustomReloadProviderV2(
              error: state.error,
              height: 120,
              decoration: const BoxDecoration(color: Colors.transparent),
              onPressed: cubit.load,
            );
          }
          if (state.products.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text('no_products_found'.tr(),
                    style: DistributorStyle.style(size: 16)),
              ),
            );
          }
          final width = MediaQuery.of(context).size.width;
          return RefreshIndicator(
            color: DistributorStyle.green,
            onRefresh: cubit.load,
            child: NotificationListener<ScrollNotification>(
              onNotification: (n) {
                if (n.metrics.extentAfter < 300) cubit.loadMore();
                return false;
              },
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: width >= 600 ? 3 : 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: .7,
                ),
                itemCount: state.products.length,
                itemBuilder: (context, i) {
                  final product = state.products[i];
                  return DistributorProductCard(
                    product: product,
                    onFavorite: () => cubit.toggle(product),
                    onTap: () => Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                          builder: (_) => DistributorProductDetailsPage(
                              productId: product.id!, initial: product),
                        ))
                        .then((_) => cubit.load()),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
