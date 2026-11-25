import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_images.dart';
import 'package:ufc_mobile/global/shared/functions/url_launcher.dart';
import 'package:ufc_mobile/global/shared/init/injection.dart';
import 'package:ufc_mobile/global/shared/widgets/app_image_place_holder.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';

import '../../../application/authentication/auth_cubit.dart';
import '../../../application/business_config/business_config_cubit.dart';
import '../../../application/main_source/main_source_cart_cubit.dart';
import '../../../application/main_source/main_source_home_cubit.dart';
import '../../../application/main_source/main_source_products_cubit.dart';
import '../../../application/navbar/app_bar_cubit.dart';
import '../../bottom_bar/page/feed_bottom_bar.dart' show FeedBackgroundCubit;
import '../../../domain/entities/main_source/main_source_model.dart';
import '../../distributor/utils/distributor_style.dart';
import '../utils/main_source_errors.dart';
import '../widgets/main_source_catalog.dart';

/// Whether the Main Source home sheet is lifted to the top; the feed
/// bottom bar reads it so it keeps the small header in that case.
final mainSourceHomeExpanded = ValueNotifier<bool>(false);

/// Home tab in Main Source mode (plan §2): source header(s), categories
/// and the product grid with search, filter, sort and paging.
class MainSourceHomePage extends StatelessWidget {
  const MainSourceHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MainSourceProductsCubit>()..load(),
      child: const _MainSourceHomeView(),
    );
  }
}

class _MainSourceHomeView extends StatefulWidget {
  const _MainSourceHomeView();

  @override
  State<_MainSourceHomeView> createState() => _MainSourceHomeViewState();
}

class _MainSourceHomeViewState extends State<_MainSourceHomeView> {
  /// The sheet starts under the hero banner. Dragging its header (source
  /// photo and name) up lifts it to the top, like the Products tab, and
  /// dragging it down brings it back. The products scroll on their own.
  bool _expanded = false;

  /// Sheet top while the finger is on the header, null otherwise.
  double? _dragTop;

  static const _expandedTop = 4.0;

  @override
  void dispose() {
    mainSourceHomeExpanded.value = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<MainSourceHomeCubit>().load(silent: true);
    // Badge after login / app start (guests get no cart).
    if (!context.read<AuthCubit>().isGuest) {
      context.read<MainSourceCartCubit>().fetchCartCount();
    }
  }

  double get _collapsedTop => MediaQuery.of(context).size.height * 0.315;

  void _setExpanded(bool value) {
    if (_expanded == value) return;
    setState(() => _expanded = value);
    mainSourceHomeExpanded.value = value;
    // Same header as the Products tab when expanded, the Home one when not.
    context.read<AppBarHeightCubit>().setHeight(value ? 31 : 74);
    context
        .read<AppBarCubit>()
        .setMode(value ? AppBarMode.channel : AppBarMode.normal);
    context
        .read<FeedBackgroundCubit>()
        .updateBackground(value ? AppImages.feedSmallBg : AppImages.feedBg);
  }

  void _onDragStart(DragStartDetails _) {
    setState(() => _dragTop = _expanded ? _expandedTop : _collapsedTop);
  }

  void _onDragUpdate(DragUpdateDetails d) {
    setState(() => _dragTop = ((_dragTop ?? _collapsedTop) + d.delta.dy)
        .clamp(_expandedTop, _collapsedTop));
  }

  void _onDragEnd(DragEndDetails d) {
    final top = _dragTop ?? _collapsedTop;
    final velocity = d.primaryVelocity ?? 0;
    // A quick flick decides; otherwise the nearer position wins.
    final expand = velocity < -300
        ? true
        : velocity > 300
            ? false
            : top < (_expandedTop + _collapsedTop) / 2;
    setState(() => _dragTop = null);
    _setExpanded(expand);
  }

  @override
  Widget build(BuildContext context) {
    final dragging = _dragTop != null;
    final top = _dragTop ?? (_expanded ? _expandedTop : _collapsedTop);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedContainer(
        // Follows the finger while dragging, then slides into place.
        duration: dragging ? Duration.zero : const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        margin: EdgeInsets.fromLTRB(12, top, 12, 0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        clipBehavior: Clip.antiAlias,
        child: BlocBuilder<MainSourceHomeCubit, MainSourceHomeState>(
          builder: (context, home) {
            // Before /home answers, the business config already has the
            // source(s): show them right away.
            final sources = home.mainSources.isNotEmpty
                ? home.mainSources
                : context
                    .watch<BusinessConfigCubit>()
                    .state
                    .config
                    .mainSources;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // The handle: drag up / down to move the sheet.
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragStart: _onDragStart,
                  onVerticalDragUpdate: _onDragUpdate,
                  onVerticalDragEnd: _onDragEnd,
                  onTap: () => _setExpanded(!_expanded),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: DistributorStyle.muted,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      for (final source in sources)
                        MainSourceHeader(source: source),
                    ],
                  ),
                ),
                // Search, categories and products scroll on their own.
                Expanded(
                  child: MainSourceCatalog(
                    header: [
                      if (home.error != null && home.home == null)
                        SliverToBoxAdapter(
                          child: CustomReloadProviderV2(
                            error: mainSourceErrorText(home.error!),
                            height: 120,
                            decoration:
                                const BoxDecoration(color: Colors.transparent),
                            onPressed: () =>
                                context.read<MainSourceHomeCubit>().load(),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Source name, icon and photo, with a call button.
class MainSourceHeader extends StatelessWidget {
  final MainSourceModel source;

  const MainSourceHeader({super.key, required this.source});

  @override
  Widget build(BuildContext context) {
    final phone = source.phone;
    final hasPhoto = (source.photo ?? '').isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasPhoto)
          ImageWithPlaceHolder(
            imageUrl: source.photo,
            width: double.infinity,
            height: 130,
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ImageWithPlaceHolder(
                  imageUrl: source.icon,
                  width: 44,
                  height: 44,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(source.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DistributorStyle.style(
                            size: 15, weight: FontWeight.w600)),
                    Text(
                      source.description.isNotEmpty
                          ? source.description
                          : 'Delivered to your location'.tr(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: DistributorStyle.style(
                          size: 11,
                          weight: FontWeight.w300,
                          color: DistributorStyle.textSecondary),
                    ),
                  ],
                ),
              ),
              if (phone != null && phone.isNotEmpty)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.phone_outlined,
                      color: DistributorStyle.green, size: 20),
                  onPressed: () => launchPhoneCall(phone),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
