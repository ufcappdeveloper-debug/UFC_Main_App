import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

import '../../../../models/ticket_model/ticket_model.dart';

class CustomTicket extends StatelessWidget {
  const CustomTicket({
    super.key,
    required this.ticketModel,
  });

  final TicketModel ticketModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          height: 78,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                offset: Offset(0, 2),
                blurRadius: 10,
              ),
            ],
            color: const Color(0xffffffff),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomText(
                            text: "Ticket #: ",
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            textAlign: TextAlign.center,
                            color: const Color(0xffBCBCBC),
                          ),
                          CustomText(
                              text: ticketModel.id.toString(),
                              fontFamily: "Kanit",
                              fontSize: 15,
                              height: 1,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                      CustomText(
                          text: ticketModel.ticketIssue!.name ?? "",
                          fontSize: 15,
                          textAlign: TextAlign.start,
                          color: Colors.black),
                    ],
                  ),
                ),
                CustomText(
                  text: DateFormat('dd/MM/yyyy', 'en').format(DateTime.parse(
                    ticketModel.createdAt.toString(),
                  )),

                  // ticketModel.createdAt.toString(),
                  fontSize: 13,
                  height: 1.8,
                  textAlign: TextAlign.start,
                  color: const Color(0xff6d6d6d),
                ),
                const Expanded(
                  child: Center(
                    child: SizedBox(
                        height: 60,
                        child: VerticalDivider(
                            thickness: 1.25, color: Color(0xffE4E4E4))),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 22,
                        width: 65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.5),
                          border: Border.all(
                            width: 1.0,
                            color:

                                // status == "Pending"
                                //     ? const Color(0xffFFC53F)
                                ticketModel.status == "Finished"
                                    ? const Color(0xff7BD41A)
                                    : const Color(0xffFFC53F),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            ticketModel.status.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: ticketModel.status == "Finished"
                                  ? const Color(0xff7BD41A)
                                  : const Color(0xffFFC53F),
                              height: 15 / 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )),
                  ],
                )
              ]),
        ),
      ],
    );
  }
}
