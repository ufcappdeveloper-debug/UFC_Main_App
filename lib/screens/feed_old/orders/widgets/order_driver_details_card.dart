import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/shared/widgets/checkout_title.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class OrderDriverDetailsCard extends StatelessWidget {
  const OrderDriverDetailsCard({
    super.key,
    required this.driverName,
    required this.plateNumber,
  });
  final String? driverName;
  final String? plateNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        checkoutTitle(title: 'Vehicle Details', color: Colors.black),
        orderDriverText(
          title: "Driver name",
          name: driverName ?? "",
          icon: "assets/images/cart/driver.svg",
        ),
        const Divider(color: Color(0xffE9E9E9), height: 2, thickness: 1),
        orderDriverText(
          title: "Plate number",
          name: plateNumber ?? "",
          icon: "assets/images/cart/license_plate.svg",
        ),
      ],
    );
  }

  Widget orderDriverText({
    required String icon,
    required String name,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 23, right: 15, bottom: 5),
      child: Row(
        children: [
          Expanded(
            child: SvgPicture.asset(icon,
                height: 16,
                colorFilter:
                    const ColorFilter.mode(Color(0xFFA9A9A9), BlendMode.srcIn)),
          ),
          const SizedBox(width: 13),
          Expanded(
            flex: 15,
            child: Row(
              children: [
                CustomText(
                    text: title, fontSize: 15, fontWeight: FontWeight.w300),
              ],
            ),
          ),
          CustomText(text: name, fontSize: 15, fontWeight: FontWeight.w300),
        ],
      ),
    );
  }
}
