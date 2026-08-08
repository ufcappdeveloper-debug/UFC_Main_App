import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/ticket/my_tickets_page.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

import '../../../global/shared/constants/app_colors.dart';
import '../../../global/shared/widgets/custom_button.dart';
import '../../../global/shared/widgets/custom_widgets/custom_text.dart';

class TicketSuccessPage extends StatefulWidget {
  const TicketSuccessPage({super.key});

  @override
  State<TicketSuccessPage> createState() => _TicketSuccessPageState();
}

class _TicketSuccessPageState extends State<TicketSuccessPage>
    with ScreenEngagementTracker {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 53),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/global/success.png',
                height: 120,
                width: 120,
              ),
              const SizedBox(height: 36),
              CustomText(
                text: "Your Ticket has been\nsent successfully",
                textAlign: TextAlign.center,
                fontSize: 23,
                fontWeight: FontWeight.w500,
                color: const Color.fromRGBO(30, 51, 84, 1),
              ),
              //    const SizedBox(height: 200),
              // Expanded(flex: 3, child: const SizedBox(height: 80)),
              Expanded(
                flex: 0,
                // flex: 2,
                child: Column(
                  children: [
                    const SizedBox(height: 150),
                    CustomButton(
                      boxShadow: const [],
                      onTap: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyTicket()),
                          (route) => false),
                      // MaterialPageRoute(
                      //     builder: (context) => const BottomBar()),
                      // (route) => false),
                      title: "Back to Tickets",
                      fontSize: 15,
                      textColor: primaryColor,
                      color: Colors.white,
                      border: Border.all(color: primaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
