import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/business_config/business_config_cubit.dart';

/// Reloads the business config when the app comes back to the foreground
/// and the last fetch is older than 10 minutes (plan §1).
class BusinessConfigLifecycle extends StatefulWidget {
  final Widget child;

  const BusinessConfigLifecycle({super.key, required this.child});

  @override
  State<BusinessConfigLifecycle> createState() =>
      _BusinessConfigLifecycleState();
}

class _BusinessConfigLifecycleState extends State<BusinessConfigLifecycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<BusinessConfigCubit>().reloadIfStale();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
