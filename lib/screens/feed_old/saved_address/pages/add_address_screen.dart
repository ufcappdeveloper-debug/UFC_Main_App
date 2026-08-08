import 'dart:ui' as ui;

import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/log/log_utils.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/riverpod/saved_address/saved_address.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/farm_appbar.dart';
import 'package:ufc_mobile/screens/feed_old/saved_address/enum/address_type.dart';
import 'package:ufc_mobile/screens/feed_old/saved_address/widget/add_address/add_address_field.dart';
import 'package:ufc_mobile/screens/feed_old/saved_address/widget/add_address/add_address_selection_button.dart';

import '../../../../global/shared/widgets/custom_button.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import '../../../../models/address_model.dart';

class AddAddressScreen extends ConsumerStatefulWidget {
  final double lat, lng;
  final String locationName, locationCountry;
  final AddressModel? selectedAddressModel;
  final bool isEdit;
  const AddAddressScreen(
      {super.key,
      this.isEdit = false,
      required this.lat,
      required this.lng,
      required this.locationName,
      required this.locationCountry,
      this.selectedAddressModel});

  @override
  ConsumerState<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<AddAddressScreen>
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
      selectedAddressType.value =
          (widget.selectedAddressModel!.label! == 'home')
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
      appBar: CustomFarmAppBar(
          title: widget.isEdit ? "Edit Address" : "Add Address"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddAddressField(
                  heading: "Shipping to",
                  controller: shippingController,
                  enabled: false,
                ),
                AddAddressField(
                  heading: "First Name",
                  controller: firstNameController,
                ),
                AddAddressField(
                  heading: "Last Name",
                  controller: lastNameController,
                ),
                Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: kTextTabBarHeight,
                        margin: const EdgeInsets.only(top: 31),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                        ),
                        child: CountryCodePicker(
                          builder: (countryCode) => InkWell(
                            onTap: AppConfig.server == Build.dev ? null : () {},
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                Image.asset(countryCode!.flagUri!,
                                    width: 32, package: 'country_code_picker'),
                                const SizedBox(width: 5),
                                Text(countryCode.toString(),
                                    style:
                                        Theme.of(context).textTheme.labelLarge),
                                const SizedBox(width: 8),
                                // const Icon(
                                //   Icons.keyboard_arrow_down,
                                //   color: Colors.black,
                                //   size: 24,
                                // ),
                              ],
                            ),
                          ),
                          onChanged: (CountryCode code) {
                            alphaCode = code.code ?? 'SA';
                            countryCode = code.dialCode ?? '+966';
                            debugPrint('dialCode $countryCode');
                          },
                          initialSelection: 'SA',
                          favorite: const ['+966'],
                        ),
                      ),
                      Expanded(
                        child: AddAddressField(
                          heading: "Mobile Number",
                          action: TextInputAction.done,
                          controller: phoneNumberController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            PhoneInputFormatter(
                                defaultCountryCode: alphaCode,
                                onCountrySelected: (c) => mask = c
                                        ?.getCorrectMask(countryCode)
                                        .replaceAll(" ", "") ??
                                    '000000000'),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required".tr();
                            } else if (mask.length !=
                                value.replaceAll(" ", "").length) {
                              return "Invalid number".tr();
                            }
                            return null;
                          },
                        ),
                      ),
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
                Center(
                  child: CustomButton(
                    title: "Save Location",
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
                          "phone_number":
                              phoneNumberController.text.replaceAll(" ", ""),
                        };
                        Future<void> future;
                        if (widget.selectedAddressModel == null) {
                          future = ref
                              .read(savedAddressProvider.notifier)
                              .createAddress(data);
                        } else {
                          future = ref
                              .read(savedAddressProvider.notifier)
                              .updateAddress(
                                  data, widget.selectedAddressModel!.id!);
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
