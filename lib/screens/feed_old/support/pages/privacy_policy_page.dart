import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/screens/navigation/utils/bottom_nav_utils.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage>
    with ScreenEngagementTracker {
  @override
  void initState() {
    super.initState();

    BottomNavUtils.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 8,
          backgroundColor: Colors.white,
          shadowColor: const Color(0xffe5e5e5).withValues(alpha: 0.2),
          title: Column(
            children: [
              CustomText(
                text: 'Privacy Policy',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              CustomText(
                text: 'Last Updated: May 07, 2025'.tr(),
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ],
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child:
                const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: SelectionArea(
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const PrivacyPolicyContainer(
                    title: 'Privacy and Information Confidentiality Statement',
                    subtitle:
                        // 'We appreciate your concerns and interests regarding the privacy of your data on the Internet. This policy has been prepared to help you understand the nature of the data we collect from you when you visit our website or use our internet application and how we handle this personal data.',
                        'United Company is committed to protecting your privacy and ensuring the security of your personal information. This policy outlines how we collect, use, and protect the information you provide to us.',
                  ),
                  const PrivacyPolicyContainer(
                    title: 'Browsing',
                    subtitle:
                        'We have not designed this website or application to collect your personal data from your computer while browsing this website or application. Only data provided by you with your knowledge and free will shall be used.',
                  ),
                  const PrivacyPolicyContainer(
                    title: 'Internet Protocol (IP) Address',
                    subtitle:
                        'At any time you visit any website, including this website or application, the host server will record your Internet Protocol (IP) address, date and time of your visit, and the type of web browser you are using, along with the URL address of any website that referred you to this website.',
                  ),
                  const PrivacyPolicyContainer(
                    title: 'Online Surveys',
                    subtitle:
                        'The online surveys we conduct directly on the web enable us to collect specific data regarding your opinions and feelings about our website or application. Your responses are of utmost importance and highly appreciated as they allow us to improve the website and the application. You have complete freedom and choice in providing data related to your name and other information.',
                  ),
                  const PrivacyPolicyContainer(
                    title:
                        //  'Links to Other Websites on the Internet',
                        "External links and third-party websites",
                    subtitle:
                        // 'Our website may include links to other websites or advertisements from other websites, such as Google AdSense. We are not responsible for data collection methods by those websites. You can review the privacy policies and content of those websites accessed through any link within this website.',
                        'Our website may contain links to external websites, and we note that we are not responsible for the privacy practices or the content of those websites. We encourage you to review the privacy statements of any site that collects information or requests your personal data.',
                  ),
                  const PrivacyPolicyContainer(
                    title: 'Information Disclosure',
                    subtitle:
                        // 'We will always maintain the privacy and confidentiality of all personal data we obtain. This information will not be disclosed unless required by any law or when we believe in good faith that such action is necessary or desirable to comply with the law or defend or protect the rights of the property of this website or the parties benefiting from it.',
                        "We at United Feed Company take the security and privacy of your personal information very seriously. We have implemented measures to safeguard and protect your data from unauthorized access, disclosure, alteration or destruction. We may disclose your information to third-party service providers that we use to support our business operations. In addition, we may disclose your personal information to respond to relevant government or regulatory requests, enforce our terms of use, and protect UFC's rights.",
                  ),
                  PrivacyPolicyContainer(
                    title: 'Data Needed for Your Required Transactions',
                    subtitle:
                        "${"When we need any data that is specific to you, we will ask you to provide it of your own free will.".tr()}\n${"This information will help us to contact you and execute your requests wherever possible.".tr()}\n${"Your provided data will never be sold to any third party for marketing purposes without your prior and written consent, unless it is included in aggregated data used for statistical and research purposes without any information that can identify you.".tr()}",
                  ),
                  const PrivacyPolicyContainer(
                    title: 'When Contacting Us',
                    subtitle:
                        'All data provided by you will be treated as confidential. The forms presented directly on the web require providing data that will help us improve our website. The data you provide will be used to respond to all your inquiries, feedback, or requests by this website or any of its affiliated sites.',
                  ),
                  const PrivacyPolicyContainer(
                    title: 'Information Disclosure to Third Parties',
                    subtitle:
                        'We will not sell, trade, rent, or disclose any information for the benefit of any third party outside of this website, application, or its affiliated sites. Information will only be disclosed in the event of an order from any judicial or regulatory authority.',
                  ),
                  const PrivacyPolicyContainer(
                    title:
                        'Amendments to the Privacy and Data Confidentiality Policy',
                    subtitle:
                        'We reserve the right to amend the terms and conditions of the Privacy and Data Confidentiality Policy if necessary and when it is appropriate. Amendments will be implemented here, and you will be continuously notified of the data we obtain, how we will use it, and the parties to whom we will provide this data.',
                  ),
                  const PrivacyPolicyContainer(
                    title: 'Contacting Us',
                    subtitle:
                        'You can contact us when needed by clicking on the "Contact Us" link available on our website or application, or by contacting us at the toll-free number 920006839.',
                  ),
                  const PrivacyPolicyContainer(
                    title: 'In Conclusion',
                    subtitle:
                        'Your concerns and interests regarding data confidentiality and privacy are of the utmost importance to us. We hope to achieve this through this policy.',
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class PrivacyPolicyContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  const PrivacyPolicyContainer(
      {super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CustomText(
        text: title,
        fontWeight: FontWeight.w600,
      ),
      const SizedBox(height: 2),
      CustomText(
        text: subtitle,
      ),
      const SizedBox(height: 15),
    ]);
  }
}
