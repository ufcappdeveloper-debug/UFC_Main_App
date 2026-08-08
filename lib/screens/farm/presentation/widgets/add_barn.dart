import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/functions/dio.dart';

import '../../../../global/extensions/app_colors.dart';
import '../../../../global/shared/constants/constants.dart';
import '../../../../global/shared/constants/text_filed_input_formatters.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../../../../riverpod/farm/barn/barn_provider.dart';
import '../../application/barn_details/barn_details_cubit.dart';
import '../../domain/entities/barn/barn_model.dart';
import '../charts/weight_chart.dart';
import 'arabic_number.dart';
import 'farm_text_field.dart';

class AddBarn extends ConsumerStatefulWidget {
  final bool isAddBarn;
  final bool fromQuestions;
  final int? barnId;
  final Function(BarnModel? newBarn)? onAddBarn;
  const AddBarn({
    super.key,
    this.isAddBarn = true,
    this.fromQuestions = false,
    this.barnId,
    this.onAddBarn,
  });

  @override
  ConsumerState<AddBarn> createState() => _AddBarnState();
}

class _AddBarnState extends ConsumerState<AddBarn> {
  late TextEditingController barnNumberController;
  late TextEditingController barnNameController;
  late TextEditingController feedController;
  bool isLoading = false;

  @override
  void initState() {
    if (widget.isAddBarn) {
      barnNumberController = TextEditingController();
      barnNameController = TextEditingController();
    } else {
      feedController = TextEditingController();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.isAddBarn) {
      barnNumberController.dispose();
      barnNameController.dispose();
    } else {
      feedController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomOutlinedContainer(
      title: widget.isAddBarn ? 'Add New Barn' : 'Add Feed Quantities',
      fill: widget.fromQuestions ? false : true,
      onTap: () => showModalBottomSheet(
        scrollControlDisabledMaxHeightRatio: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        context: context,
        builder: (context) {
          String? validationError;

          return StatefulBuilder(
            builder: (ccontext, setModalState) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      top: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            CustomText(
                              text: widget.isAddBarn
                                  ? 'Add New Barn'
                                  : 'Add Feed Quantities',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
                              fontFamily: isEnglish
                                  ? AppFontsFamily.english
                                  : AppFontsFamily.arabic,
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.close),
                            )
                          ],
                        ),
                        kHeight30,

                        // Form Fields
                        if (!widget.isAddBarn) ...[
                          textField(context, 'Feed',
                              controller: feedController),
                          if (validationError != null)
                            CustomText(
                              text: validationError!,
                              color: Colors.red,
                            ),
                          // kHeight15,
                          // textField(context, 'Maltah feed'),
                          // kHeight15,
                          // textField(context, 'Pills'),
                          kHeight40,
                        ] else ...[
                          CustomTextFormField(
                            keyboardType: TextInputType.number,
                            controller: barnNumberController,
                            hintText: 'Barn number'.tr(),
                            context: context,
                          ),
                          kHeight20,
                          CustomTextFormField(
                            controller: barnNameController,
                            hintText: 'Name of the barn'.tr(),
                            context: context,
                          ),
                        ],
                        kHeight40,

                        isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.farmColor,
                                ),
                              )
                            : CustomOutlinedContainer(
                                title: 'Save',
                                fill: true,
                                onTap: () async {
                                  if (widget.isAddBarn) {
                                    setModalState(() {
                                      isLoading = true;
                                    });
                                    // Get location
                                    final location = await _getLocation();

                                    // Get address from lat/long
                                    final address = await getAddress(location);
                                    await addBarn(location, address, context);

                                    setModalState(() {
                                      isLoading = false;
                                    });
                                    barnNameController.clear();
                                    barnNumberController.clear();
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    setModalState(() {
                                      isLoading = true;
                                      validationError = null;
                                    });

                                    final quantity = int.tryParse(
                                        convertNumbersToEnglish(
                                            feedController.text));

                                    if (quantity == null) {
                                      setState(() {
                                        validationError =
                                            'Quantity must be a whole number.';
                                        isLoading = false;
                                      });
                                      feedController.clear();
                                      return;
                                    }

                                    if (widget.barnId != null) {
                                      final errorMsg = await context
                                          .read<BarnDetailsCubit>()
                                          .updateFeed(widget.barnId!, quantity);
                                      if (errorMsg != null && context.mounted) {
                                        CustomSnackBar.error(context, errorMsg);
                                      }
                                    }

                                    setModalState(() {
                                      isLoading = false;
                                    });
                                    feedController.clear();
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                              ),
                        kHeight20,
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ).whenComplete(() {
        if (widget.isAddBarn) {
          barnNameController.clear();
          barnNumberController.clear();
        } else {
          feedController.clear();
        }
      }),
    );
  }

  Future<void> addBarn(
      loc.LocationData? location, String address, BuildContext context) async {
    try {
      var barnNum =
          int.tryParse(convertNumbersToEnglish(barnNumberController.text));

      /// API call to add barn
      final newBarn = await ref.read(barnAsyncProvider.notifier).addBarn({
        "barn_number": barnNum,
        "barn_name_en": barnNameController.text,

        /// will pass only if user have location permission
        /// and location is not null
        if (location != null) ...{
          "barn_lattitude": location.latitude.toString(),
          "barn_longitude": location.longitude.toString(),
          if (address.isNotEmpty) ...{
            "barn_address": address,
          }
        },
      });

      if (widget.onAddBarn != null) {
        widget.onAddBarn!(newBarn);
      }
    } on DioException catch (e) {
      if (context.mounted) {
        CustomSnackBar.error(context, extractErrorMessage(e.response?.data));
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.error(context, e.toString());
      }
    }
  }

  Future<String> getAddress(loc.LocationData? location) async {
    String address = '';
    try {
      if (location != null) {
        // Convert lat/long to address
        List<Placemark> placemarks = await placemarkFromCoordinates(
          location.latitude!,
          location.longitude!,
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;

          address = [
            place.street,
            place.locality,
            place.administrativeArea,
            place.country,
          ].where((e) => e != null && e.isNotEmpty).join(", ");
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return address;
  }

  /// Get current location and latitude/longitude
  Future<loc.LocationData?> _getLocation() async {
    try {
      loc.Location location = loc.Location();
      bool serviceEnabled = false;
      loc.LocationData? locationData;

      // Check if service is enabled
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return null;
      }

      loc.PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) return null;
      }

      // Get location
      locationData = await location.getLocation();

      return locationData;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  CustomTextFormField textField(BuildContext context, String hintText,
      {TextEditingController? controller}) {
    return CustomTextFormField(
      controller: controller,
      suffixIcon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: 'Kg',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            textAlign: TextAlign.center,
            // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
            fontFamily:
                isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
          ),
        ],
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [allowWholeNumbersOnly],
      hintText: hintText.tr(),
      context: context,
    );
  }
}
