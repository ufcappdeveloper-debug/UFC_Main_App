import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/extensions/app_png_images.dart';
import 'package:ufc_mobile/global/language_cubit/language_cubit.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';
import 'package:ufc_mobile/screens/feed/presentation/authentication/widgets/guest_guard.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/chat_list_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/doctor_list_page_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/doctor_tabs_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/top_rated_doctors_page.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/vet_user_profile_page2.dart';

final petVetTabIndexProvider = StateProvider<int>((ref) => 0);

class PetVetBottomBar extends ConsumerStatefulWidget {
  const PetVetBottomBar({super.key});

  @override
  ConsumerState<PetVetBottomBar> createState() => _PetVetBottomBarState();
}

class _PetVetBottomBarState extends ConsumerState<PetVetBottomBar>
    with WidgetsBindingObserver {
  late int selectedIndex;
  bool isKeyboardOpen = false;

  final List<Map<String, String>> tabData = [
    {
      'title': 'Home',
      'asset': AppPngImages.vetHomeUnselectedIcon,
      'selectedAsset': AppPngImages.vetHomeSelectedIcon
    },
    {
      'title': 'Doctors',
      'asset': AppPngImages.vetDoctorsUnselectedIcon,
      'selectedAsset': AppPngImages.vetDoctorsSelectedIcon
    },
    {
      'title': 'Bookings',
      'asset': AppPngImages.vetBookingUnselectedIcon,
      'selectedAsset': AppPngImages.vetBookingSelectedIcon
    },
    {
      'title': 'Chat',
      'asset': AppPngImages.vetChatUnselectedIcon,
      'selectedAsset': AppPngImages.vetChatSelectedIcon
    },
    {
      'title': 'Profile',
      'asset': AppPngImages.vetAccountUnselectedIcon,
      'selectedAsset': AppPngImages.vetAccountSelectedIcon
    },
  ];

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final index = ref.read(petVetTabIndexProvider);
    selectedIndex = index;
    _pageController = PageController(initialPage: index);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppBarHeightCubit>().setHeight(index == 0 ? 74 : 31);
      context
          .read<AppBarCubit>()
          .setMode(index == 0 ? AppBarMode.normal : AppBarMode.channel);
      context.read<BottomNavIndexCubit>().update(farm: index == 0);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeMetrics() {
  //   final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
  //   setState(() {
  //     isKeyboardOpen = bottomInset > 0.0;
  //   });
  // }

  void _onTabTapped(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (ref.read(petVetTabIndexProvider) == index) return;

    ref.read(petVetTabIndexProvider.notifier).state = index;
    _pageController.jumpToPage(index);

    context.read<AppBarHeightCubit>().setHeight(index == 0 ? 74 : 31);
    context
        .read<AppBarCubit>()
        .setMode(index == 0 ? AppBarMode.normal : AppBarMode.channel);
    context.read<BottomNavIndexCubit>().update(farm: index == 0);
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    final currentIndex = ref.watch(petVetTabIndexProvider);

    if (currentIndex != selectedIndex) {
      selectedIndex = currentIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pageController.jumpToPage(currentIndex);

        context
            .read<AppBarHeightCubit>()
            .setHeight(currentIndex == 0 ? 74 : 31);
        context.read<AppBarCubit>().setMode(
            currentIndex == 0 ? AppBarMode.normal : AppBarMode.channel);
        context.read<BottomNavIndexCubit>().update(farm: currentIndex == 0);
      });
    }

    return SafeArea(
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            extendBody: true,
            resizeToAvoidBottomInset: true,
            body: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    DoctorListPage2(),
                    const TopRatedDoctorsPage(),
                    const DoctorTabsScreen(),
                    GuestGuard(
                        appType: AppType.veterinary,
                        color: PetVeterinaryColors.newPetMainColorVeterinary,
                        child: ChatListWrapper()),
                    VetUserProfilePage2()
                  ],
                )),
            bottomNavigationBar: isKeyboardOpen
                ? const SizedBox.shrink()
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          offset: Offset(0, -2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      child: BottomAppBar(
                        elevation: 8,
                        color: Colors.white,
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(tabData.length, (index) {
                            final isSelected = selectedIndex == index;

                            return GestureDetector(
                              onTap: () => _onTabTapped(index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                padding: isSelected
                                    ? const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8)
                                    : const EdgeInsets.symmetric(
                                        horizontal: 10),
                                decoration: isSelected
                                    ? BoxDecoration(
                                        color: PetVeterinaryColors
                                            .newPetMainColorVeterinary,
                                        borderRadius: BorderRadius.circular(20),
                                      )
                                    : null,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  textDirection: isRTL
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  children: [
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      transitionBuilder: (child, animation) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: SlideTransition(
                                            position: Tween<Offset>(
                                              begin: const Offset(0.0, 0.3),
                                              end: Offset.zero,
                                            ).animate(animation),
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: Image.asset(
                                        isSelected
                                            ? tabData[index]['selectedAsset']!
                                            : tabData[index]['asset']!,
                                        key: ValueKey(isSelected
                                            ? 'selected_$index'
                                            : 'normal_$index'),
                                        width: 24,
                                        height: 24,
                                        // color: isSelected
                                        //     ? Colors.white
                                        //     : Colors.grey,
                                      ),
                                    ),
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      transitionBuilder: (child, animation) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: SlideTransition(
                                            position: Tween<Offset>(
                                              begin: const Offset(0.0, 0.3),
                                              end: Offset.zero,
                                            ).animate(animation),
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: isSelected
                                          ? Padding(
                                              key: ValueKey('label_$index'),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6),
                                              child: Text(
                                                tabData[index]['title']!.tr(),
                                                style: PetVeterinaryFontstyles2
                                                        .getLightStyle(
                                                            context, 11)
                                                    .copyWith(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(
                                              key: ValueKey('empty')),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  final String title;
  final String asset;
  final bool isSelected;

  const CustomTab({
    super.key,
    required this.title,
    required this.asset,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    if (isSelected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Image.asset(
              asset,
              width: 20,
              height: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else {
      return Image.asset(
        asset,
        width: 24,
        height: 24,
        color: Colors.grey,
      );
    }
  }
}
