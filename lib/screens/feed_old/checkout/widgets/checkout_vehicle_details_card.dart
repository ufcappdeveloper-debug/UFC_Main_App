import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_functions.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_page_widgets.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class CheckoutVehicleDetailsCard extends StatelessWidget {
  const CheckoutVehicleDetailsCard({
    super.key,
    required this.plateNumberNode,
    required this.driverNameController,
    required this.plateNumberController,
  });
  final FocusNode plateNumberNode;
  final TextEditingController? driverNameController;
  final TextEditingController? plateNumberController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 44),
        checkoutTitle(title: 'Pick up Vehicle Details'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomText(
            text:
                "Please provide the driver's and plate number of the pickup vehicle",
            fontWeight: FontWeight.w300,
            color: const Color(0xFFBABABA),
          ),
        ),
        const SizedBox(height: 22),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
                cursorColor: primaryColor,
                controller: driverNameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.go,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required".tr();
                  }
                  return null;
                },
                onEditingComplete: () => plateNumberNode.requestFocus(),
                decoration: checkoutVehicleTextFieldDecoration(
                    hintText: "Driver name",
                    icon: "assets/images/cart/driver.svg"))),
        const SizedBox(height: 15),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
                maxLength: 25,
                cursorColor: primaryColor,
                focusNode: plateNumberNode,
                controller: plateNumberController,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required".tr();
                  }
                  return null;
                },
                onEditingComplete: () =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                decoration: checkoutVehicleTextFieldDecoration(
                    hintText: "Plate number",
                    icon: "assets/images/cart/license_plate.svg"))),
      ],
    );
  }
}
