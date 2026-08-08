import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/screens/feed_old/support/pages/privacy_policy_page.dart';
import 'package:ufc_mobile/screens/navigation/utils/bottom_nav_utils.dart';

class TermsOfServicesPage extends StatefulWidget {
  const TermsOfServicesPage({super.key});

  @override
  State<TermsOfServicesPage> createState() => _TermsOfServicesPageState();
}

class _TermsOfServicesPageState extends State<TermsOfServicesPage>
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
          backgroundColor: Colors.white,
          shadowColor: const Color(0xffe5e5e5).withValues(alpha: 0.2),
          elevation: 8,
          title: Column(
            children: [
              CustomText(
                text: 'Usage Policy',
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
              child: Column(children: [
                CustomText(
                  text:
                      "This is the website of the United Feeds Company in the Kingdom of Saudi Arabia (referred to as 'the website' or 'the website'). It is available for the personal use of site visitors. Visitor access and use of this site are subject to these terms and conditions and the laws of the Kingdom of Saudi Arabia. The visitor's entry and use of this site constitute an unconditional agreement to the terms and conditions of use, whether registered or not. This agreement takes effect from the first use of this site - This website provides information, data, and services related to the business of the United Feeds Company (referred to as United Feeds Company). By using this website, you acknowledge and agree to refrain from the following:",
                ),
                const SizedBox(height: 10),
                const SubContent(
                  bullet: "1.",
                  text:
                      'Providing or uploading files that contain software, materials, data, or other information that you do not own or have a license for.',
                ),
                const SubContent(
                  bullet: "2.",
                  text:
                      'Using this site in any way to send any commercial or unwanted email or any form of abuse.',
                ),
                const SubContent(
                  bullet: "3.",
                  text:
                      'Providing or uploading files on this site that contain viruses or corrupted data.',
                ),
                const SubContent(
                  bullet: "4.",
                  text:
                      'Publishing, advertising, distributing, or disseminating materials or information that defame, violate regulations, contain obscene or indecent content, or are in violation of public morality, or any illegal materials or information through the site.',
                ),
                const SubContent(
                  bullet: "5.",
                  text:
                      'Engaging through this site in unlawful or irregular activities within the Kingdom of Saudi Arabia.',
                ),
                const SubContent(
                  bullet: "6.",
                  text:
                      'Advertising on this site any product or service that puts us in violation of any applicable law or regulation in any field.',
                ),
                const SubContent(
                  bullet: "7.",
                  text:
                      'Using any means, software, or actions to obstruct or attempt to obstruct the proper operation of the site.',
                ),
                const SubContent(
                  bullet: "8.",
                  text:
                      "Taking any action that unreasonably or inappropriately imposes an undue or excessive burden on the site's infrastructure.",
                ),
                const SizedBox(
                  height: 10,
                ),
                const PrivacyPolicyContainer(
                  title: 'Electronic links',
                  subtitle:
                      "The United Feeds Company's website may contain electronic links to other websites or portals that may use methods to protect information and privacy different from ours. We are not responsible for the content, methods, and privacy of these other websites, and we recommend referring to their privacy notices.",
                ),
                const PrivacyPolicyContainer(
                  title: 'Property rights',
                  subtitle:
                      "This website is owned by the United Feeds Company. All website content, including software and information, is fully protected in accordance with Saudi copyright, trademark, and various property rights laws. Furthermore, all intellectual property rights for the website's content belong to the United Feeds Company. Except as otherwise indicated, you may not sell, license, rent, modify, copy, reproduce, reprint, download, advertise, transmit, distribute, publicly display, edit, or create derivative works from any materials or content from this website for public or commercial purposes without prior written consent from the website's management. Any modification of the website's content is strictly prohibited. In addition, the graphics and images on this website are protected by copyright, and may not be copied or used in any way without prior written consent from the website's management.",
                ),
                const PrivacyPolicyContainer(
                  title: 'Disclaimer Policy',
                  subtitle:
                      "This website is a private website managed by the United Feeds Company. Its content is published in collaboration with other government entities. The United Feeds Company does not guarantee the full accuracy and correctness of the website's content, as some information may change. Therefore, the company assumes no responsibility or consequences resulting from the use of the information provided on the website, including:",
                ),
                const SubContent(
                  bullet: "1.",
                  text: 'Accuracy and correctness of information.',
                ),
                const SubContent(
                  bullet: "2.",
                  text: 'Effectiveness in preventing breaches.',
                ),
                const SubContent(
                  bullet: "3.",
                  text: 'Relevance of the website content.',
                ),
                const SubContent(
                  bullet: "4.",
                  text: 'Continuity or validity.',
                ),
                const SubContent(
                  bullet: "5.",
                  text:
                      'Absence of viruses or harmful elements on the website or server.',
                ),
                const SizedBox(height: 10),
                CustomText(
                  text:
                      "The company is not legally responsible for any loss or damage of any kind (direct or indirect) resulting from the use of this website.",
                ),
                const SizedBox(height: 10),
                CustomText(
                  text:
                      "The servers operating the site automatically collect visitors' IP addresses when they visit one of the organization's websites. The IP address is used to help diagnose server problems and to perform statistics on its usage. The site uses cookies, and these files help users navigate the site easily. If desired, these files can be used to remember passwords and facilitate and speed up the login process to some sites. These files are stored on the computer's hard drive.",
                ),
                const SizedBox(height: 15),
                const PrivacyPolicyContainer(
                  title: 'Limitation of liability',
                  subtitle:
                      "The electronic services and data provided by the website of the United Company for Feeds and obtaining any information about various government entities are only provided to facilitate manual procedures. By this, the user acknowledges full awareness that Internet communications may be subject to interception or interception by others, and that the website does not replace the information available through official authorities, and that requests and administrative procedures can be taken directly with the relevant authorities.",
                ),
                const PrivacyPolicyContainer(
                  title: 'Virus protection',
                  subtitle:
                      "The company makes every effort to examine and test the contents of this website at all stages of its preparation, and visitors are always advised to run an up-to-date antivirus program on all materials downloaded from the Internet. The company is not responsible for any loss, interruption, data damage to the user, their personal computer, or any damage that may occur when connecting to this website or using any material contained therein.",
                ),
                const PrivacyPolicyContainer(
                  title: 'Waiver of Claims',
                  subtitle:
                      "In its entirety, the website of the United Feeds Company, including all its information, services, materials, and functions, or that which can be accessed through the website, is provided for your personal use as is, without any acknowledgments, promises, or warranties of any kind. The website's administration cannot guarantee or be held responsible for any interruptions, errors, or violations that may arise from using this website, its content, or any associated site, whether with or without the knowledge of the website's administration. Any communications or information sent by the user through this website shall not grant them ownership or the right to guarantee its confidentiality. Additionally, any interactive use contained within this website does not imply or intend to guarantee any rights, licenses, or privileges of any kind to the user.",
                ),
                const PrivacyPolicyContainer(
                  title: 'Compensation',
                  subtitle:
                      "By this, the user acknowledges not to take any action against the United Feeds Company or any of its management, and to indemnify and secure them from liability, as well as any parties or employees responsible for the management, maintenance, update, or provision of the website, from any and all obligations and responsibilities that may arise in connection with any claim arising from any violation on their part of the terms and conditions of use, or any of the prevailing laws, whether in the Kingdom of Saudi Arabia or the place where they reside.",
                ),
                const PrivacyPolicyContainer(
                  title: 'Termination of Access',
                  subtitle:
                      "The United Feeds Company may, at its absolute discretion, terminate, restrict, or suspend your right to access and use the website without notice and for any reason, including a violation of the terms and conditions of use or any other behavior we may consider, at our discretion, to be unlawful or harmful to others. In the event of termination, you will not be permitted to access this website.",
                ),
                const PrivacyPolicyContainer(
                  title: 'Judicial reference',
                  subtitle:
                      "By this, the user exclusively agrees to submit to the judicial authorities in the Kingdom of Saudi Arabia regarding all claims and disputes arising from your use of this website.",
                ),
                PrivacyPolicyContainer(
                  title: 'Regarding usage restrictions'.tr(),
                  subtitle: [
                    '- Anything that constitutes a violation of the Anti-Cybercrime Law or the relevant regulations in force in the Kingdom of Saudi Arabia.'
                        .tr(),
                    '- Creating, displaying or placing any hyperlinks to the United Feed Company website on any site, unless written permission is obtained from United Feed Company.'
                        .tr(),
                  ].join('\n'),
                ),
                const PrivacyPolicyContainer(
                  title: 'Updates on the app',
                  subtitle:
                      'United Feed may make updates or releases that improve the App, we may automatically upgrade the version of the App and we may also change, expand and improve the App, and we may at any time partially or completely turn it off or selectively disable certain functions of the App and United Feed shall have no liability as a result',
                ),
              ]),
            ),
          ),
        ));
  }
}

class SubContent extends StatelessWidget {
  final String text;
  final String bullet;
  const SubContent({super.key, required this.text, required this.bullet});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: '   $bullet ',
          fontSize: 11,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 8.0),
            child: CustomText(
              text: text,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}
