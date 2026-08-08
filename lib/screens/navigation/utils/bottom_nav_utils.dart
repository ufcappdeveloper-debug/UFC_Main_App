import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/support/pages/privacy_policy_page.dart';
import 'package:ufc_mobile/screens/feed_old/support/pages/terms_of_services_page.dart';

class BottomNavUtils {
  static bool isPrivacyPolicy = false;
  static bool isTermsConditions = false;

  static void clear() {
    isPrivacyPolicy = false;
    isTermsConditions = false;
  }

  static void deepLinkNavigation(BuildContext context) {
    // Navigate to PrivacyPolicyPage if needed
    if (isPrivacyPolicy) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrivacyPolicyPage(),
        ),
      );
    }

    // Navigate to TermsOfServicesPage if needed
    if (isTermsConditions) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TermsOfServicesPage(),
        ),
      );
    }
  }
}
