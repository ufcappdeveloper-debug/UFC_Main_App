import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/show_confirmation_dailog.dart';

import '../../../application/distributor/distributor_cart_cubit.dart';

/// Shows distributor cart feedback: the 409 "Start a new cart?" dialog,
/// "added" and error snackbars.
class DistributorCartListener extends StatelessWidget {
  final Widget child;
  final bool showAdded;

  const DistributorCartListener(
      {super.key, required this.child, this.showAdded = true});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DistributorCartCubit, DistributorCartState>(
      listenWhen: (p, c) => p.eventId != c.eventId,
      listener: (context, state) async {
        switch (state.event) {
          case DistributorCartEvent.conflict:
            final replace = await showConfirmationDialog(
              context: context,
              title: 'confirmation'.tr(),
              content:
                  'Your cart has items from another distributor. Start a new cart?'
                      .tr(),
            );
            if (replace && context.mounted) {
              context.read<DistributorCartCubit>().confirmReplaceCart();
            }
          case DistributorCartEvent.added:
            if (showAdded) {
              CustomSnackBar.success(context, 'Added to cart');
            }
          case DistributorCartEvent.error:
            CustomSnackBar.error(context, state.message ?? 'Something went wrong');
          case DistributorCartEvent.reordered:
          case DistributorCartEvent.none:
            break;
        }
      },
      child: child,
    );
  }
}
