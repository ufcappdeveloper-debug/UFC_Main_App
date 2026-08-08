import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/extensions/app_images.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/show_confirmation_dailog.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/community/pages/community_page.dart';
import 'package:ufc_mobile/screens/farm/presentation/farm_body.dart';
import 'package:ufc_mobile/screens/feed/application/productList/product_list_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/station/station_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/bottom_bar/page/feed_bottom_bar.dart';
import 'package:ufc_mobile/screens/feed_old/home/widgets/tab_navigator.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/pet_vet_bottom_bar.dart'
    hide CustomTab;

import '../../feed/application/navbar/app_bar_cubit.dart';
import '../../feed/presentation/home/widgets/feed_home_indexed.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key, this.initialIndex = 0});
  static const routeName = "/home_page";
  final int initialIndex;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar>
    with SingleTickerProviderStateMixin {
  late TabController _topTabController;
  late ProductListCubit prodCubit;

  final List<GlobalKey<NavigatorState>> navigatorKeys =
      List.generate(4, (_) => GlobalKey<NavigatorState>());

  void onTabSelected(int index) {
    final currentSelected = context.read<SelectedAppbarItemCubit>().state;

    if (index == currentSelected) {
      navigatorKeys[index].currentState?.popUntil((r) => r.isFirst);
    } else {
      context.read<SelectedAppbarItemCubit>().setIndex(index);
    }
  }

  final List<Map<String, dynamic>> gradientSettings = [
    {
      "height": 200.0,
      "fadeHeight": 80.0,
    },
    {
      "height": 200.0,
      "colors": [Color(0xffCCE6FF), Color(0xFFF7FCF1)],
      "fadeHeight": 180.0,
      "image": AppImages.loginBackground,
    },
    {
      "height": 200.0,
      "colors": [Color(0xFF7BE3AC), Color(0xFFF7FCF1)],
      "fadeHeight": 65.0,
      "image": AppImages.loginBackground,
    },
    {
      "height": 200.0,
      "colors": [Color(0xFFDCAEFF), Color(0xFFF7FCF1)],
      "fadeHeight": 180.0,
      // "image": AppImages.loginBackground,
    },
  ];

  @override
  void initState() {
    super.initState();
    _topTabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _topTabController.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
    prodCubit = BlocProvider.of<ProductListCubit>(context);
  }

  @override
  void dispose() {
    _topTabController.dispose();
    super.dispose();
  }

//   @override
//   Widget build(BuildContext context) {
//     final appBarMode = context.watch<AppBarCubit>().state;
//     final isChannelMode = appBarMode == AppBarMode.channel;
//     final topHeight = context.watch<AppBarHeightCubit>().state;
//     final currentTab = _topTabController.index;

//     final screenHeight = MediaQuery.of(context).size.height;
//     final isFeedTab = currentTab == 0;

//     final currentGradient = gradientSettings[currentTab];
//     final gradientHeight = isFeedTab
//         ? screenHeight * 0.5
//         : gradientSettings[currentTab]["height"] as double;

//     final gradientColors = currentGradient["colors"] as List<Color>?;
//     final smoothGradientColors = gradientColors != null
//         ? [
//             for (var i = 0; i < gradientColors.length; i++) gradientColors[i],
//             gradientColors.last.withOpacity(0.0),
//           ]
//         : null;
//     final fadeHeight = gradientSettings[currentTab]["fadeHeight"] as double;

//     final gradientStops = isFeedTab ? [0.0, 0.55, 1.0] : [0.0, 0.65, 1.0];
//     final color = CommonUtils.getAppThemeColor(_topTabController.index == 0
//         ? AppType.feed
//         : _topTabController.index == 1
//             ? AppType.veterinary
//             : _topTabController.index == 2
//                 ? AppType.farm
//                 : AppType.community);

//     return PopScope(
//         canPop: false,
//         onPopInvokedWithResult: (didPop, result) async {
//           await showConfirmationDialog(
//                   context: context,
//                   title: 'exit_app_title'.tr(),
//                   content: 'exit_app_content'.tr(),
//                   color: color)
//               .then((v) {
//             if (v) SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//           });
//         },
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           body: Stack(
//             children: [
//               if (smoothGradientColors != null)
//                 AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   height: gradientHeight + fadeHeight,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: smoothGradientColors,
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       stops: gradientStops,
//                     ),
//                   ),
//                 ),
//               BlocBuilder<FeedBackgroundCubit, String?>(
//                 builder: (context, feedBg) {
//                   final imagePath =
//                       isFeedTab ? feedBg : currentGradient["image"] as String?;

//                   final currentFadeHeight = isFeedTab
//                       ? (feedBg == AppImages.feedBg ? 80.0 : 20.0)
//                       : currentGradient["fadeHeight"] as double;

//                   final currentGradientHeight = isFeedTab
//                       ? (feedBg == AppImages.feedBg
//                           ? screenHeight * 0.5
//                           : screenHeight * 0.275)
//                       : gradientSettings[currentTab]["height"] as double;

//                   if (imagePath == null) return const SizedBox.shrink();
//                   return BlocProvider.value(
//                     value: prodCubit,
//                     child: BlocBuilder<FeedBottomNavCubit, int>(
//                       builder: (context, selectedIndex) {
//                         return BlocBuilder<CartCubit, CartState>(
//                           builder: (context, cState) {
//                             return BlocBuilder<ProductListCubit,
//                                 ProductListState>(builder: (context, pState) {
//                               if (isFeedTab &&
//                                   pState is ProductListError &&
//                                   isNetworkError(pState.message) &&
//                                   selectedIndex == 0) {
//                                 return NoInternet(
//                                   type: AppType.feed,
//                                   onTap: () {
//                                     prodCubit.getProducts();
//                                   },
//                                 );
//                               } else if (isFeedTab &&
//                                       (selectedIndex == 0 || selectedIndex == 1)
//                                   ? pState is ProductListLoaded
//                                   : cState is CartLoaded) {
//                                 return Stack(
//                                   children: [
//                                     Image.asset(
//                                       imagePath,
//                                       height: currentGradientHeight +
//                                           currentFadeHeight,
//                                       width: double.infinity,
//                                       fit: BoxFit.fitWidth,
//                                       alignment: Alignment.topCenter,
//                                       colorBlendMode: BlendMode.darken,
//                                     ),
//                                     if (isFeedTab && feedBg == AppImages.feedBg)
//                                       Padding(
//                                           padding: EdgeInsets.symmetric(
//                                               horizontal: 16),
//                                           child: SizedBox(
//                                             height: currentGradientHeight +
//                                                 currentFadeHeight,
//                                             child: Center(
//                                               child: RichText(
//                                                 textAlign: TextAlign.start,
//                                                 text: TextSpan(
//                                                   children: [
//                                                     TextSpan(
//                                                       text: "Discover\n".tr(),
//                                                       style: TextStyle(
//                                                         fontFamily: isEnglish
//                                                             ? "Font/English Font"
//                                                             : "Font/Arabic Font",
//                                                         fontSize:
//                                                             isEnglish ? 50 : 40,
//                                                         fontWeight:
//                                                             FontWeight.w700,
//                                                         color: Colors.white,
//                                                         shadows: [
//                                                           Shadow(
//                                                             offset:
//                                                                 Offset(1, 1),
//                                                             blurRadius: 4,
//                                                             color:
//                                                                 Colors.black54,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     TextSpan(
//                                                       text:
//                                                           "100% Plant-Based Feed"
//                                                               .tr(),
//                                                       style: TextStyle(
//                                                         fontFamily: isEnglish
//                                                             ? "Font/English Font"
//                                                             : "Font/Arabic Font",
//                                                         fontSize:
//                                                             isEnglish ? 33 : 45,
//                                                         fontWeight:
//                                                             FontWeight.w700,
//                                                         color: Colors.white,
//                                                         shadows: [
//                                                           Shadow(
//                                                             offset:
//                                                                 Offset(1, 1),
//                                                             blurRadius: 4,
//                                                             color:
//                                                                 Colors.black54,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           )),
//                                   ],
//                                 );
//                               }
//                               return SizedBox.shrink();
//                             });
//                           },
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//               SafeArea(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 16),
//                     // Top Tabs
//                     AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       height: topHeight,
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: List.generate(4, (index) {
//                           final colors = [
//                             primaryColor,
//                             PetVeterinaryColors.newPetMainColorVeterinary,
//                             AppColors.farmColor,
//                             Color(0xff9D4EDD)
//                           ];
//                           final labels = [
//                             'United Feeds',
//                             'Veterinary',
//                             'Farm',
//                             'Community'
//                           ];
//                           final fonts = [
//                             'Kanit',
//                             'DM Sans',
//                             'Lobster',
//                             'Poppins'
//                           ];

//                           return Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 4),
//                             child: GestureDetector(
//                               onTap: () {
//                                 FocusManager.instance.primaryFocus?.unfocus();
//                                 setState(() {
//                                   onTabSelected(index);
//                                   _topTabController.index = index;
//                                 });
//                               },
//                               child: buildTab(
//                                 context,
//                                 index,
//                                 _topTabController,
//                                 [colors[index]],
//                                 null,
//                                 null,
//                                 isChannelMode,
//                                 labels[index],
//                                 fonts[index],
//                               ),
//                             ),
//                           );
//                         }),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     // Tab Content
//                     Expanded(
//                       child: TabBarView(
//                         controller: _topTabController,
//                         physics: const NeverScrollableScrollPhysics(),
//                         children: [
//                           TabNavigator(
//                             navigatorKey: navigatorKeys[0],
//                             child: FeedBottomBar(prodCubit: prodCubit),
//                           ),
//                           TabNavigator(
//                             navigatorKey: navigatorKeys[1],
//                             child: PetVetBottomBar(),
//                           ),
//                           TabNavigator(
//                             navigatorKey: navigatorKeys[2],
//                             child: FarmBody(),
//                           ),
//                           TabNavigator(
//                             navigatorKey: navigatorKeys[3],
//                             child: CommunityPage(),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }

  @override
  Widget build(BuildContext context) {
    final appBarMode = context.watch<AppBarCubit>().state;
    final isChannelMode = appBarMode == AppBarMode.channel;
    final topHeight = context.watch<AppBarHeightCubit>().state;
    final currentTab = _topTabController.index;

    final screenHeight = MediaQuery.of(context).size.height;
    final isFeedTab = currentTab == 0;

    final currentGradient = gradientSettings[currentTab];
    final gradientHeight = isFeedTab
        ? screenHeight * 0.5
        : gradientSettings[currentTab]["height"] as double;

    final gradientColors = currentGradient["colors"] as List<Color>?;
    final smoothGradientColors = gradientColors != null
        ? [
            for (var i = 0; i < gradientColors.length; i++) gradientColors[i],
            gradientColors.last.withOpacity(0.0),
          ]
        : null;
    final fadeHeight = gradientSettings[currentTab]["fadeHeight"] as double;
    final gradientStops = isFeedTab ? [0.0, 0.55, 1.0] : [0.0, 0.65, 1.0];

    final color = CommonUtils.getAppThemeColor(_topTabController.index == 0
        ? AppType.feed
        : _topTabController.index == 1
            ? AppType.veterinary
            : _topTabController.index == 2
                ? AppType.farm
                : AppType.community);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        await showConfirmationDialog(
          context: context,
          title: 'exit_app_title'.tr(),
          content: 'exit_app_content'.tr(),
          color: color,
        ).then((v) {
          if (v) SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        });
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            /// ----------------- Background -----------------
            if (smoothGradientColors != null)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: gradientHeight + fadeHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: smoothGradientColors,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: gradientStops,
                  ),
                ),
              ),

            BlocBuilder<FeedBackgroundCubit, String?>(
              builder: (context, feedBg) {
                final imagePath =
                    isFeedTab ? feedBg : currentGradient["image"] as String?;
                if (imagePath == null) return const SizedBox.shrink();

                final currentFadeHeight = isFeedTab
                    ? (feedBg == AppImages.feedBg ? 80.0 : 20.0)
                    : currentGradient["fadeHeight"] as double;

                final currentGradientHeight = isFeedTab
                    ? (feedBg == AppImages.feedBg
                        ? screenHeight * 0.5
                        : screenHeight * 0.275)
                    : gradientSettings[currentTab]["height"] as double;

                // Background stack independent of product or cart cubits
                return Stack(
                  children: [
                    Image.asset(
                      imagePath,
                      height: currentGradientHeight + currentFadeHeight,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                      colorBlendMode: BlendMode.darken,
                    ),
                    if (isFeedTab && feedBg == AppImages.feedBg)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          height: currentGradientHeight + currentFadeHeight,
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Discover\n".tr(),
                                    style: TextStyle(
                                      fontFamily: isEnglish
                                          ? "Font/English Font"
                                          : "Font/Arabic Font",
                                      fontSize: isEnglish ? 50 : 40,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      shadows: const [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 4,
                                          color: Colors.black54,
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextSpan(
                                    text: "100% Plant-Based Feed".tr(),
                                    style: TextStyle(
                                      fontFamily: isEnglish
                                          ? "Font/English Font"
                                          : "Font/Arabic Font",
                                      fontSize: isEnglish ? 33 : 45,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      shadows: const [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 4,
                                          color: Colors.black54,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),

            /// ----------------- Foreground Content -----------------
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Top Tabs
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: topHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        final colors = [
                          primaryColor,
                          PetVeterinaryColors.newPetMainColorVeterinary,
                          AppColors.farmColor,
                          const Color(0xff9D4EDD)
                        ];
                        final labels = [
                          'United Feeds',
                          'Veterinary',
                          'Farm',
                          'Community'
                        ];
                        final fonts = [
                          'Kanit',
                          'DM Sans',
                          'Lobster',
                          'Poppins'
                        ];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                onTabSelected(index);
                                _topTabController.index = index;
                              });
                            },
                            child: buildTab(
                              context,
                              index,
                              _topTabController,
                              [colors[index]],
                              null,
                              null,
                              isChannelMode,
                              labels[index],
                              fonts[index],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tab Content
                  Expanded(
                    child: TabBarView(
                      controller: _topTabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        TabNavigator(
                          navigatorKey: navigatorKeys[0],
                          child: FeedBottomBar(prodCubit: prodCubit),
                        ),
                        TabNavigator(
                          navigatorKey: navigatorKeys[1],
                          child: PetVetBottomBar(),
                        ),
                        TabNavigator(
                          navigatorKey: navigatorKeys[2],
                          child: FarmBody(),
                        ),
                        TabNavigator(
                          navigatorKey: navigatorKeys[3],
                          child: CommunityPage(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int categoryPage = 1;

String getShopName(BuildContext context, StationModel? shop) {
  if (shop == null) return 'No name'.tr();

  if (isArabic) {
    return shop.nameAr ?? shop.nameEn ?? shop.nameUr ?? 'No name'.tr();
  } else if (isUrdu) {
    return shop.nameUr ?? shop.nameEn ?? shop.nameAr ?? 'No name'.tr();
  } else {
    return shop.nameEn ?? shop.nameAr ?? shop.nameUr ?? 'No name'.tr();
  }
}
