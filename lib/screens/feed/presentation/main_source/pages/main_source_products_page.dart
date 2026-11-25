import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/shared/init/injection.dart';

import '../../../application/main_source/main_source_home_cubit.dart';
import '../../../application/main_source/main_source_products_cubit.dart';
import '../widgets/main_source_catalog.dart';

/// Products tab in Main Source mode: the same catalogue as Home, without
/// the source header (plan §2 / §7.2).
class MainSourceProductsPage extends StatefulWidget {
  const MainSourceProductsPage({super.key});

  @override
  State<MainSourceProductsPage> createState() => _MainSourceProductsPageState();
}

class _MainSourceProductsPageState extends State<MainSourceProductsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MainSourceHomeCubit>().ensureLoaded();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MainSourceProductsCubit>()..load(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          margin: const EdgeInsets.fromLTRB(12, 2, 12, 0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          clipBehavior: Clip.antiAlias,
          child: const MainSourceCatalog(),
        ),
      ),
    );
  }
}
