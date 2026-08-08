import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/support/pages/ask_us_page.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage>
    with ScreenEngagementTracker {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: const Color(0xffe5e5e5).withValues(alpha: 0.2),
          elevation: 8,
          title: CustomText(
            text: 'Support',
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
                              builder: (context) => const AskUsPage())),
                      text: "Ask Us",
                    ),
                    const Divider(
                      color: Color(0xffE5E5E5),
                      thickness: 1,
                      height: 2,
                    ),
                    supportMenuItem(
                        onTap: () {
                          launchUrl(Uri.parse("tel:+966551193955"));
                        },
                        prefixIconPath: 'assets/images/support/phone_call.png',
                        text: 'Call Us',
                        suffixIcon: Directionality(
                          textDirection: TextDirection.ltr,
                          child: CustomText(
                              // text: "920033385",
                              text: "+966 (551) 193955",
                              fontWeight: FontWeight.w500),
                        )),
                    const Divider(
                      color: Color(0xffE5E5E5),
                      thickness: 1,
                      height: 2,
                    ),
                    supportMenuItem(
                      onTap: () {
                        launchUrl(Uri(
                          scheme: 'mailto',
                          path: 'app-support@ufc.com.sa',
                          query:
                              'subject=App Feedback&body=I require assistance regarding...', //add subject and body here
                        ));
                      },
                      prefixIconPath: 'assets/images/support/arroba.png',
                      text: 'Email Us',
                    ),
                  ],
                ))
          ]),
        ));
  }
}

Widget supportMenuItem(
    {VoidCallback? onTap,
    String? prefixIconPath,
    String? text,
    Widget? suffixIcon}) {
  return Material(
    borderRadius: BorderRadius.circular(10),
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Image.asset(prefixIconPath ?? 'assets/images/support/help.png',
              height: 20),
          const SizedBox(width: 12.5),
          CustomText(
            text: text ?? 'Menu Item',
            fontWeight: FontWeight.w300,
          ),
          const Spacer(),
          suffixIcon ??
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 18, color: Color(0xffBFBFBF))
        ]),
      ),
    ),
  );
}
