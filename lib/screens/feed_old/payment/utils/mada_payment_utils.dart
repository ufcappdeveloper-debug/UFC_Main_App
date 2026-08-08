import 'package:easy_localization/easy_localization.dart';
import 'package:ufc_mobile/global/config/config.dart';

class MadaPaymentUtils {
  static String get actionUrl {
    if (AppConfig.server == Build.production) {
      return 'https://www.ufc.mvp-apps.ae/';
    } else {
      return 'https://www.ufc.rvamp.com/';
    }
  }

  static String get paymentUrl {
    if (AppConfig.server == Build.production) {
      return 'https://eu-prod.oppwa.com/v1';
    } else {
      return 'https://eu-test.oppwa.com/v1';
    }
  }

  static String cardSessionHtml({
    required String language,
    required String integrity,
    required String checkoutId,
  }) =>
      '''
      <!DOCTYPE html>
      <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>HyperPay Payment Widget</title>
      </head>
      <body>

      <!-- Payment Form -->
      <form action="$actionUrl"
            class="paymentWidgets"
            data-brands="MADA">
      </form>

      <!-- HyperPay Payment Widget Script -->
      <script>
          var wpwlOptions = {
          locale:"$language"  
          }
      </script>
      <script 
          src="$paymentUrl/paymentWidgets.js?checkoutId=$checkoutId"
          integrity="$integrity"
          crossorigin="anonymous">
      </script>

      </body>
      </html>

    ''';

  /// Function to extract relevant error messages
  static String extractRelevantErrorMessage(String? description) {
    if (description == null || description.isEmpty) {
      return "An unknown error occurred. Please try again.";
    }

    // Attempt to extract a meaningful message
    // Handle different known patterns or provide the raw description
    if (description.contains(':')) {
      // Split the description by ":" and return the part after it
      return description.split(':').last.trim();
    }

    if (description.contains('HttpResponseError')) {
      description = 'Something went wrong'.tr();
    }

    // Fallback to returning the original description
    return description;
  }
}
