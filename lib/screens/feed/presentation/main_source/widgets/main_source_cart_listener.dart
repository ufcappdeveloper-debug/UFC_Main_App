import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/show_confirmation_dailog.dart';

import '../../../application/main_source/main_source_cart_cubit.dart';
import '../../../domain/entities/main_source/main_source_api_exception.dart';
import '../utils/main_source_errors.dart';

/// Main Source cart feedback: the `MIXED_MAIN_SOURCE_CART` replace dialog,
/// "added" and translated error snackbars.
class MainSourceCartListener extends StatelessWidget {
  final Widget child;
  final bool showAdded;

  const MainSourceCartListener(
      {super.key, required this.child, this.showAdded = true});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainSourceCartCubit, MainSourceCartState>(
      listenWhen: (p, c) => p.eventId != c.eventId,
      listener: (context, state) async {
        switch (state.event) {
          case MainSourceCartEvent.conflict:
            final source = state.apiError?.cartMainSource;
            final replace = await showConfirmationDialog(
              context: context,
              title: 'confirmation'.tr(),
              content: source != null && source.name.isNotEmpty
                  ? 'ms_mixed_cart_named'.tr(namedArgs: {'name': source.name})
                  : mainSourceCodeText(MainSourceErrorCode.mixedCart)!,
            );
            if (replace && context.mounted) {
              context.read<MainSourceCartCubit>().confirmReplaceCart();
            }
          case MainSourceCartEvent.added:
            if (showAdded) CustomSnackBar.success(context, 'Added to cart');
          case MainSourceCartEvent.error:
            // Mode switched: the app-wide handler shows it and goes home.
            if (state.apiError?.isBusinessModeDisabled ?? false) return;
            CustomSnackBar.error(context,
                state.error == null ? 'Something went wrong' : mainSourceErrorText(state.error!));
          case MainSourceCartEvent.reordered:
          case MainSourceCartEvent.none:
            break;
        }
      },
      child: child,
    );
  }
}
