import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/widgets/appointments_card.dart';
import 'package:ufc_mobile/global/shared/widgets/common_back_app_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

class VeterinaryPaymentPage extends StatefulWidget {
  const VeterinaryPaymentPage({super.key});

  @override
  VeterinaryPaymentPageState createState() => VeterinaryPaymentPageState();
}

class VeterinaryPaymentPageState extends State<VeterinaryPaymentPage>
    with ScreenEngagementTracker {
  String? _selectedPayment;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonBackAppBar(
        title: "Payment Method".tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _appointmentCard(),
                SizedBox(height: 12),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: AppointmentCard(
                        isPastAppointment: false,
                        appointment: AppointmentModel(
                          id: 1,
                          startTime: "2025-10-01 11:00:00",
                          endTime: "2025-10-01 11:00:00",
                          doctor: Doctor(
                            nameEn: 'Dr. Hassan Hamady',
                            profileImage:
                                'assets/images/dummy/Screenshot_2-removebg-preview 1.png',
                            specializationEn: 'Veterinarian',
                          ),
                        ))),

                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text("Payment Method",
                        style: PetVeterinaryFontstyles.kanitMediumTextStyle14
                            .copyWith(color: PetVeterinaryColors.titleColor2))),
                SizedBox(height: 16),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: _paymentSection()),
                SizedBox(height: 10),
                Divider(
                  color: PetVeterinaryColors.dividerLinecolor4,
                  thickness: 1.0,
                  indent: 40.0,
                  endIndent: 40.0,
                ),
                SizedBox(height: 12),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Invoice Details",
                              style: PetVeterinaryFontstyles
                                  .kanitMediumTextStyle14
                                  .copyWith(color: Colors.black)),
                          SizedBox(
                            height: 4,
                          ),
                          _invoiceDetails()
                        ])),
                SizedBox(height: 32),
                Center(
                    child: CustomButton(
                        title: "Pay",
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        onTap: () {}))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _paymentSection() {
    return Column(
      children: [
        _paymentMethodCard(),
        if (Platform.isIOS) ...[
          SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedPayment = "apple_pay";
              });
            },
            child: Container(
              padding: EdgeInsets.only(
                left: 12,
                right: 8,
                top: 16,
                bottom: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: _selectedPayment == "apple_pay"
                              ? null
                              : Border.all(
                                  color: PetVeterinaryColors.borderColor),
                        ),
                        child: _selectedPayment == "apple_pay"
                            ? Center(
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: PetVeterinaryColors.borderLeftColor,
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : null,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Apple Pay',
                        style: PetVeterinaryFontstyles.kanitMediumTextStyle12
                            .copyWith(color: Colors.black),
                      )
                    ],
                  ),
                  Image.asset(
                    "assets/images/cart/apple_pay.png",
                    width: 36,
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _paymentMethodCard() {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 4,
        top: 20,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Credit / Debit Card Payment',
                style: PetVeterinaryFontstyles.kanitMediumTextStyle12
                    .copyWith(color: Colors.black),
              ),
              Row(children: [
                Image.asset("assets/images/payment/visa_1.png"),
                SizedBox(width: 5),
                Image.asset("assets/images/payment/Master_Card_1_.png"),
                SizedBox(width: 5),
                SvgPicture.asset("assets/images/payment/Mada_Logo 1.svg"),
                SizedBox(width: 5),
                Image.asset(
                    "assets/images/payment/Lockup_black_English_2 1.png")
              ])
            ],
          ),
          SizedBox(height: 12),
          _paymentOption(
            "assets/images/payment/visa_1.png",
            "**** **** **** 1234",
            "visa_card",
          ),
          Divider(
            color: PetVeterinaryColors.dividerLinecolor5,
            thickness: 1.0,
            indent: 4.0,
            endIndent: 4.0,
          ),
          _paymentOption("assets/images/payment/Master_Card_1_.png",
              "**** **** **** 5678", "master_card"),
        ],
      ),
    );
  }

  Widget _paymentOption(String iconPath, String text, String paymentId) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPayment = paymentId;
        });
      },
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: _selectedPayment == paymentId
                  ? null
                  : Border.all(color: PetVeterinaryColors.borderColor),
            ),
            child: _selectedPayment == paymentId
                ? Center(
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: PetVeterinaryColors.borderLeftColor,
                      ),
                      child: Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: 10),
          Image.asset(
            iconPath,
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 10),
          Text(
            text,
            style: PetVeterinaryFontstyles.nunitosansRegularTextStyle12,
          ),
        ],
      ),
    );
  }

  Widget _invoiceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _invoiceRow("Cost", "400", currency: "SAR"),
        _invoiceRow("vat", "39.38", currency: "SAR"),
        _invoiceRow("Total", "439.38", currency: "SAR")
      ],
    );
  }

  Widget _invoiceRow(
    String label,
    String value, {
    String? currency,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Text(
              label,
              style: PetVeterinaryFontstyles.poppinsRegularTextStyle14
                  .copyWith(color: Colors.black),
            ),
          ),
          Expanded(
              flex: 2,
              child: currency != null
                  ? RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: value,
                              style: PetVeterinaryFontstyles.poppinsMedium16
                                  .copyWith(color: Colors.black)),
                          TextSpan(
                            text: " ",
                          ),
                          WidgetSpan(
                            child: SaudiRiyalIcon(
                              size: 11,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Text(value,
                      style: PetVeterinaryFontstyles.poppinsMedium16
                          .copyWith(color: Colors.black))),
        ],
      ),
    );
  }
}

// void _showCustomDialog(BuildContext context, Offset position) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return Stack(
//         children: [
//           Positioned(
//             left: position.dx - 180,
//             top: position.dy - 40,
//             child: Material(
//               color: Colors.transparent,
//               child: Container(
//                 height: 100,
//                 width: 160,
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         CustomText(
//                           text: "Re - Book",
//                           fontSize: 13,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         GestureDetector(
//                           onTap: () => Navigator.pop(context),
//                           child: Icon(Icons.close, size: 18),
//                         ),
//                       ],
//                     ),
//                     Divider(),
//                     GestureDetector(
//                       onTap: () => Navigator.pop(context),
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: CustomText(
//                           text: "Cancel",
//                           fontSize: 13,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.red,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }
