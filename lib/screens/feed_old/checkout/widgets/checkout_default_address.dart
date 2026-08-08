import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/riverpod/default_address/default_address.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_page_widgets.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_widgets.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class CheckoutDefaultAddress extends ConsumerWidget {
  const CheckoutDefaultAddress({
    super.key,
    required this.onAddAddressPressed,
  });
  final VoidCallback onAddAddressPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultAddress = ref.watch(defaultAddressProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        checkoutTitle(title: 'Address'),
        defaultAddress.when(
          error: (error, stack) {
            return (error == "User has no default address" ||
                    error ==
                        "type 'Null' is not a subtype of type 'Map<String, dynamic>'")
                ? Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                            text: 'An address is required for checkout*',
                            color: Colors.red),
                        const SizedBox(height: 15),
                        CustomButton(
                          onTap: onAddAddressPressed,
                          height: 36,
                          width: 207,
                          radius: 10,
                          color: Colors.white,
                          textColor: primaryColor,
                          border: Border.all(color: primaryColor),
                          fontSize: 13,
                          title: "Add Address",
                        ),
                      ],
                    ),
                  )
                : CustomReloadProvider(
                    height: 118,
                    onPressed: () => ref
                        .read(defaultAddressProvider.notifier)
                        .getDefaultAddress(),
                  );
          },
          loading: () => const SizedBox(
            height: 157,
            child: Center(child: CustomIndicator(padding: 50)),
          ),
          data: (data) => Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Column(
              children: [
                data == null
                    ? const SizedBox.shrink()
                    : Row(
                        children: [
                          Image.asset('assets/images/cart/map_location.png',
                              height: 20),
                          const SizedBox(width: 5),
                          CustomText(
                            text: data.label == 'work' ? "Work" : "Home",
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(width: 5),
                          Container(
                            height: 24,
                            width: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: primaryColor,
                            ),
                            child: Center(
                                child: CustomText(
                              text: 'Default',
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            )),
                          ),
                          // const Spacer(),
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) =>
                          //             AddressMapScreen(
                          //           selectedAddressModel: data,
                          //           isEdit: true,
                          //         ),
                          //       ),
                          //     ).then(
                          //       (value) {
                          //         if (value) {
                          //           Future(() => ref
                          //               .read(
                          //                   defaultAddressProvider
                          //                       .notifier)
                          //               .getDefaultAddress());
                          //         }
                          //       },
                          //     );
                          //   },
                          //   child: CustomText(
                          //     text: 'Edit',
                          //     fontSize: 13,
                          //     color: Colors.grey,
                          //     fontFamily: 'Poppins',
                          //   ),
                          // )
                        ],
                      ),
                const SizedBox(height: 5),
                const Divider(
                  color: Color.fromRGBO(234, 234, 234, 1),
                  thickness: 1,
                ),
                data == null
                    ? CustomText(
                        text: 'An address is required for checkout*',
                        color: Colors.red)
                    : Column(
                        children: [
                          addressDetails(
                              title: 'Name',
                              value: "${data.firstName} ${data.lastName}"),
                          // title: 'Name', value: 'Mohamed Alii'),
                          addressDetails(
                              title: 'Address', value: data.address ?? ''),
                          // value: '6-AlBurwaz st - zon1AlDhna Jiddah'),
                          addressDetails(
                              title: 'Mobile Number',
                              value: data.phoneNumber ?? ''),
                          // value: '966 50 7299514'),
                        ],
                      ),
                const SizedBox(height: 15),
                CustomButton(
                  onTap: onAddAddressPressed,
                  height: 36,
                  width: 207,
                  radius: 10,
                  color: Colors.white,
                  textColor: primaryColor,
                  border: Border.all(color: primaryColor),
                  fontSize: 13,
                  title: "Add Address",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
