import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/functions/is_network_error.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/no_internet.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/feed/presentation/authentication/widgets/guest_guard.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/provider/doctor_service_provider.dart';
import 'package:ufc_mobile/screens/pet_veterinary/widgets/try_again_button.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/utils/doctor_utils.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/doctor_appointment_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/doctor_details_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/doctor_card_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/filter_bottom_sheet.dart';

final topRatedFocusProvider = StateProvider<bool>((ref) => false);

class TopRatedDoctorsPage extends ConsumerStatefulWidget {
  const TopRatedDoctorsPage({
    super.key,
  });

  @override
  ConsumerState<TopRatedDoctorsPage> createState() =>
      _TopRatedDoctorsPageState();
}

class _TopRatedDoctorsPageState extends ConsumerState<TopRatedDoctorsPage> {
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  bool isGridView = false;
  late FocusNode _focusNode;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    Future(() {
      _fetchInitialDoctors();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final focusOn = ref.read(topRatedFocusProvider);
    if (focusOn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _focusNode.requestFocus();
          ref.read(topRatedFocusProvider.notifier).state = false;
        }
      });
    }
  }

  void _fetchInitialDoctors({String? search}) {
    final q =
        (search != null && search.trim().isNotEmpty) ? search.trim() : null;

    ref
        .read(doctorServiceProviderProvider.notifier)
        .fetchInitialDoctors(searchName: q);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !isLoadingMore) {
      _loadMoreDoctors();
    }
  }

  Future<void> _loadMoreDoctors() async {
    if (isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    await ref.read(doctorServiceProviderProvider.notifier).fetchMoreDoctors();

    setState(() {
      isLoadingMore = false;
    });
  }

  Future<void> _refreshDoctors() async {
    _fetchInitialDoctors(search: _searchController.text);
  }

  Widget content(AsyncValue<PaginatedDoctorsResponse?> doctorState) => Scaffold(
        backgroundColor: Colors.transparent,
        body: GuestGuard(
          appType: AppType.veterinary,
          color: PetVeterinaryColors.newPetMainColorVeterinary,
          child: RefreshIndicator(
            onRefresh: _refreshDoctors,
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 90),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              spreadRadius: 0.5,
                              offset: const Offset(0, 2),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 12,
                              spreadRadius: 1,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          autocorrect: false,
                          onChanged: (value) {
                            if (_debounce?.isActive ?? false)
                              _debounce!.cancel();
                            _debounce =
                                Timer(const Duration(milliseconds: 500), () {
                              _fetchInitialDoctors(search: value);
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Find the doctor'.tr(),
                            hintStyle: PetVeterinaryFontstyles2.getRegularStyle(
                              context,
                              11,
                              color: PetVeterinaryColors.newPetLightGray,
                            ),
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                'assets/new_design/icons/search_icon.png',
                                width: 16,
                                height: 16,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () async {
                              final result = await FilterBottomSheet.show(
                                context,
                                ref,
                                currentRankOrder: ref
                                    .read(
                                        doctorServiceProviderProvider.notifier)
                                    .currentRankOrder,
                                currentAvailability: ref
                                    .read(
                                        doctorServiceProviderProvider.notifier)
                                    .currentAvailability,
                              );

                              if (result != null) {
                                ref
                                    .read(
                                        doctorServiceProviderProvider.notifier)
                                    .fetchInitialDoctors(
                                      rankOrder: result["rankOrder"],
                                      availability: result["availability"],
                                    );
                              }
                            },
                            padding: EdgeInsets.zero,
                            icon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/new_design/icons/filter_icon.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -2,
                          left: isEnglish ? -2 : null,
                          right: isEnglish ? null : -2,
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: ref
                                    .watch(
                                        doctorServiceProviderProvider.notifier)
                                    .isFilterActive
                                ? 1.0
                                : 0.0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: PetVeterinaryColors.backgroundRed,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top rated doctor'.tr(),
                      style:
                          PetVeterinaryFontstyles2.getMediumStyle(context, 15),
                    ),
                    IconButton(
                      icon: Icon(
                        isGridView ? Icons.list : Icons.grid_view,
                        color: PetVeterinaryColors.newPetDarkGray,
                        size: 31,
                      ),
                      onPressed: () {
                        setState(() {
                          isGridView = !isGridView;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                doctorState.when(
                  data: (paginatedResponse) {
                    if (paginatedResponse == null ||
                        paginatedResponse.doctors.isEmpty) {
                      return Text("No doctors available".tr(),
                          style: PetVeterinaryFontstyles2.getRegularStyle(
                                  context, 13)
                              .copyWith(
                            color: PetVeterinaryColors.newPetDarkGray,
                          ));
                    }

                    if (isGridView) {
                      final isTablet =
                          MediaQuery.of(context).size.shortestSide >= 600;
                      return GridView.builder(
                        itemCount: paginatedResponse.doctors.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isTablet ? 4 : 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 18,
                            mainAxisExtent: 200),
                        itemBuilder: (context, index) {
                          final doctor = paginatedResponse.doctors[index];
                          return GestureDetector(
                            onTap: () {
                              final doctorId = doctor.id ?? 0;
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) => DoctorDetailsScreen(
                                    doctorId: doctorId,
                                  ),
                                ),
                              );
                            },
                            child: Builder(
                              builder: (context) {
                                final doctorId = doctor.id ?? 0;
                                final doctorName =
                                    DoctorUtils.doctorName(doctor);
                                final specialty =
                                    DoctorUtils.doctorSpecialization(doctor);
                                final imageUrl = doctor.profileImage ?? '';
                                final rating = doctor.rating ?? 0;

                                return DoctorGridCard(
                                  doctorName: doctorName,
                                  specialty: specialty,
                                  imageUrl: imageUrl,
                                  rating: rating,
                                  onRebook: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DoctorAppointmentScreen(
                                          doctorId: doctorId,
                                          doctorName: doctorName,
                                          specialization: specialty,
                                          doctorImage: imageUrl,
                                          rating: rating,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      );
                    } else {
                      return Column(
                        children: List.generate(
                          paginatedResponse.doctors.length,
                          (index) {
                            final doctor = paginatedResponse.doctors[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: GestureDetector(
                                onTap: () =>
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                  MaterialPageRoute(
                                    builder: (context) => DoctorDetailsScreen(
                                      doctorId: doctor.id ?? 0,
                                    ),
                                  ),
                                ),
                                child: DoctorCard2(
                                  doctorId: doctor.id,
                                  monthText: '',
                                  type: DoctorCardType.available,
                                  doctorName: DoctorUtils.doctorName(doctor),
                                  specialty:
                                      DoctorUtils.doctorSpecialization(doctor),
                                  time: doctor.bookingTime ?? '',
                                  dateText: doctor.bookingDate ?? '',
                                  imageUrl: doctor.profileImage ?? '',
                                  rating: doctor.rating ?? 0,
                                  isAvailable:
                                      doctor.nearestAvailabletime != null,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: TryAgainButton(
                      styleType: TryAgainButtonStyle.newPet,
                      message: "Failed to load doctors. Please try again.",
                      onPressed: () => _refreshDoctors(),
                    ),
                  ),
                ),
                if (isLoadingMore)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doctorState = ref.watch(doctorServiceProviderProvider);
    return doctorState.maybeWhen(
      error: (error, stackTrace) => isNetworkError(error.toString())
          ? NoInternet(
              type: AppType.veterinary,
              onTap: () => _fetchInitialDoctors(),
            )
          : content(doctorState),
      orElse: () => content(doctorState),
    );
  }
}
