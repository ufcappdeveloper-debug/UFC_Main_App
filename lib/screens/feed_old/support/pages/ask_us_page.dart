import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/support/pages/contact_us_page.dart';
import 'package:ufc_mobile/screens/feed_old/support/pages/faq_page.dart';
import 'package:ufc_mobile/screens/feed_old/support/pages/privacy_policy_page.dart';
import 'package:ufc_mobile/screens/feed_old/support/pages/return_exchange_policy_page.dart';
import 'package:ufc_mobile/screens/feed_old/support/pages/support_page.dart';
import 'package:ufc_mobile/screens/feed_old/support/pages/terms_of_services_page.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';

class AskUsPage extends StatefulWidget {
  const AskUsPage({super.key});

  @override
  State<AskUsPage> createState() => _AskUsPageState();
}

class _AskUsPageState extends State<AskUsPage> with ScreenEngagementTracker {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: const Color(0xffe5e5e5).withValues(alpha: 0.2),
          elevation: 8,
          title: CustomText(
            text: 'Ask Us',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child:
                const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 16,
                          color:
                              const Color(0xFFe5e5e5).withValues(alpha: 0.7)),
                    ]),
                child: Column(
                  children: [
                    supportMenuItem(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ContactUsPage())),
                      text: "Contact Us",
                      prefixIconPath:
                          "assets/images/profile/online-support.png",
                    ),
                    const Divider(
                      color: Color(0xffE5E5E5),
                      thickness: 1,
                      height: 2,
                    ),
                    supportMenuItem(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FAQPage())),
                      prefixIconPath: 'assets/images/support/faq.png',
                      text: 'Frequently Asked Questions (FAQ)',
                    ),
                    const Divider(
                      color: Color(0xffE5E5E5),
                      thickness: 1,
                      height: 2,
                    ),
                    supportMenuItem(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const TermsOfServicesPage())),
                      prefixIconPath: 'assets/images/support/tnc.png',
                      text: 'Usage Policy',
                    ),
                    const Divider(
                      color: Color(0xffE5E5E5),
                      thickness: 1,
                      height: 2,
                    ),
                    supportMenuItem(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ReturnExchangePolicy())),
                      prefixIconPath: 'assets/images/support/return.png',
                      text: 'Return & Exchange Policy',
                    ),
                    const Divider(
                      color: Color(0xffE5E5E5),
                      thickness: 1,
                      height: 2,
                    ),
                    supportMenuItem(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PrivacyPolicyPage())),
                      prefixIconPath: 'assets/images/support/verified.png',
                      text: 'Privacy Policy',
                    ),
                  ],
                ))
          ]),
        ));
  }
}
