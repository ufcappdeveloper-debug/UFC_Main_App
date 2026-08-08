import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/models/ticket_model/ticket_model.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

import '../../../global/shared/widgets/checkout_details.dart';
import '../../../global/shared/widgets/common_back_app_bar.dart';
import '../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../../../global/util/image_network_extension_method.dart';

class TicketDetailsPage extends StatefulWidget {
  const TicketDetailsPage({super.key, required this.ticketDetails});

  final TicketModel ticketDetails;

  @override
  State<TicketDetailsPage> createState() => _TicketDetailsPageState();
}

class _TicketDetailsPageState extends State<TicketDetailsPage>
    with ScreenEngagementTracker {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonBackAppBar(
        title: "Ticket Details",
      ),
      body: Column(children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: Color(0xffe5e5e5),
                    offset: Offset(0, 4),
                    blurRadius: 8)
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              checkoutDetails(
                statusSize: 14,
                title: 'Order Number',
                amount: widget.ticketDetails.orderId.toString(),
                fontWeight: FontWeight.w500,
                titleColor: Colors.black,
              ),
              const Divider(),
              checkoutDetails(
                title: 'Order Problem',
                amount: widget.ticketDetails.ticketIssue!.name.toString(),
                currency: false,
                fontWeight: FontWeight.w500,
                statusSize: 14,
                titleColor: Colors.black,
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                          text: "Details",
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.black),
                    ),
                    Expanded(
                      child: CustomText(
                        // maxLines: 3,
                        //overflow: TextOverflow.ellipsis,
                        text: widget.ticketDetails.details ?? "-",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              checkoutDetails(
                titleColor: Colors.black,
                title: 'Status',
                amount: widget.ticketDetails.status,
                currency: false,
                fontWeight: FontWeight.w500,
                statusSize: 14,
                statusColor: widget.ticketDetails.status == "Finished"
                    ? const Color(0xff7BD41A)
                    : const Color(0xffFFC53F),
              ),
              if (widget.ticketDetails.image != null) const Divider(),
              if (widget.ticketDetails.image != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          text: "Image",
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.black),
                      CachedNetworkImage(
                          imageUrl: widget.ticketDetails.image!,
                          placeholder: loadingPlaceholder,
                          errorWidget: errorWidget,
                          fit: BoxFit.contain,
                          height: 80,
                          width: 80)
                    ],
                  ),
                )
            ],
          ),
        ),
      ]),
    );
  }
}
