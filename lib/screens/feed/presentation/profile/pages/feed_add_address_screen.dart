import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/log/log_utils.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/farm_appbar.dart';
import 'package:ufc_mobile/screens/feed_old/saved_address/enum/address_type.dart';
import 'package:ufc_mobile/screens/feed_old/saved_address/widget/add_address/add_address_field.dart';
import 'package:ufc_mobile/screens/feed_old/saved_address/widget/add_address/add_address_selection_button.dart';

import '../../../../../global/shared/widgets/custom_button.dart';
import '../../../../../global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import '../../../application/address/address_cubit.dart';
import '../../../domain/entities/address/profile_address_model.dart';

class FeedAddAddressScreen extends ConsumerStatefulWidget {
  final double lat, lng;
  final String locationName, locationCountry;
  final ProfileAddressModel? selectedAddressModel;
  final bool isEdit;
  const FeedAddAddressScreen(
      {super.key,
      this.isEdit = false,
      required this.lat,
      required this.lng,
      required this.locationName,
      required this.locationCountry,
      this.selectedAddressModel});

  @override
  ConsumerState<FeedAddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<FeedAddAddressScreen>
    with ScreenEngagementTracker {
  String alphaCode = 'SA';
  String mask = '000000000';
  String countryCode = '+966';
  late TextEditingController shippingController;
  late TextEditingController lastNameController;
  late TextEditingController firstNameController;
  late TextEditingController phoneNumberController;
  final ValueNotifier<AddressType> selectedAddressType =
      ValueNotifier<AddressType>(AddressType.home);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    shippingController = TextEditingController(
        text: "${widget.locationName}, ${widget.locationCountry}");
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    phoneNumberController = TextEditingController();
    if (widget.selectedAddressModel != null) {
      firstNameController.text = widget.selectedAddressModel!.firstName ?? '';
      lastNameController.text = widget.selectedAddressModel!.lastName ?? '';
      phoneNumberController.text =
          widget.selectedAddressModel!.phoneNumber ?? '';
      selectedAddressType.value = (widget.selectedAddressModel!.label == 'home')
          ? AddressType.home
          : AddressType.work;
    }
  }

  @override
  void dispose() {
    shippingController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomFarmAppBar(
          title: widget.isEdit ? "edit_address" : "add_new_address"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddAddressField(
                  heading: "shipping_to",
                  controller: shippingController,
                  enabled: false,
                ),
                AddAddressField(
                  heading: "first_name",
                  controller: firstNameController,
                ),
                AddAddressField(
                  heading: "last_name",
                  controller: lastNameController,
                ),
                Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AddAddressField(
                          heading: "mobile_number",
                          controller: phoneNumberController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            PhoneInputFormatter(
                              defaultCountryCode:
                                  widget.selectedAddressModel?.countryCode ??
                                      '+966',
                              onCountrySelected: (c) {
                                mask = c
                                        ?.getCorrectMask(widget
                                                .selectedAddressModel
                                                ?.countryCode ??
                                            '+966')
                                        .replaceAll(" ", "") ??
                                    '000000000';
                              },
                            ),
                          ],
                          prefix: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              widget.selectedAddressModel?.countryCode ??
                                  '+966',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "required".tr();
                            } else if (mask.length !=
                                value.replaceAll(" ", "").length) {
                              return "invalid_number".tr();
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: selectedAddressType,
                  builder: (context, AddressType type, _) {
                    return Row(
                      children: <Widget>[
                        AddAddressSelectionButton(
                          image: "assets/images/profile/Home.svg",
                          title: "Home",
                          selected: type == AddressType.home,
                          onPressed: () {
                            selectedAddressType.value = AddressType.home;
                          },
                        ),
                        const SizedBox(
                          width: 28,
                        ),
                        AddAddressSelectionButton(
                          image: "assets/images/profile/work.svg",
                          title: "Work",
                          selected: type == AddressType.work,
                          onPressed: () {
                            selectedAddressType.value = AddressType.work;
                          },
                        )
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 75,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: CustomButton(
          title: "save".tr(),
          onTap: () async {
            if (formKey.currentState!.validate()) {
              final data = {
                "alpha_code": alphaCode,
                "country_code": countryCode,
                "label": selectedAddressType.value.name,
                "address": shippingController.text,
                "latitude": widget.lat,
                "longitude": widget.lng,
                "first_name": firstNameController.text,
                "last_name": lastNameController.text,
                "phone_number": phoneNumberController.text.replaceAll(" ", ""),
              };

              final cubit = context.read<AddressCubit>();

              Future<void> future;
              if (widget.selectedAddressModel == null) {
                future = cubit.createAddress(data); // ✅ Cubit create
              } else {
                future = cubit.updateAddress(
                  data,
                  widget.selectedAddressModel!.id,
                ); // ✅ Cubit update
              }

              try {
                await LoadingDialog.show(context, future);

                if (!context.mounted) return;
                Navigator.of(context)
                  ..pop()
                  ..pop();
              } catch (e) {
                debugLog(e.toString());
                CustomSnackBar.error(context, e.toString());
              }
            }
          },
          fontSize: 15,
          fontWeight: FontWeight.w600,
          width: 287,
          height: 42,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
