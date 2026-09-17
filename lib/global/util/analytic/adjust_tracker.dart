import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:flutter/foundation.dart';
import 'package:ufc_mobile/global/config/config.dart';

class AdjustTracker {
  //* Private constructor to prevent instantiation
  AdjustTracker._();

  static final AdjustTracker _instance = AdjustTracker._();

  factory AdjustTracker() => _instance;

  //* Analytics and Facebook App Events instances
  static const String appToken = 'sivdl3vawzy8';
  static final environment = AppConfig.server == Build.production
      ? AdjustEnvironment.production
      : AdjustEnvironment.sandbox;

  static void init() {
    AdjustConfig config = AdjustConfig(appToken, environment);
    config.logLevel = AdjustLogLevel.verbose;

    // Set attribution callback
    config.attributionCallback = (AdjustAttribution attribution) {
      debugPrint('[Adjust] Attribution received:');
      debugPrint('[Adjust] Tracker token: ${attribution.trackerToken}');
      debugPrint('[Adjust] Tracker name: ${attribution.trackerName}');
      debugPrint('[Adjust] Network: ${attribution.network}');
      debugPrint('[Adjust] Campaign: ${attribution.campaign}');
      debugPrint('[Adjust] Adgroup: ${attribution.adgroup}');
      debugPrint('[Adjust] Creative: ${attribution.creative}');
      debugPrint('[Adjust] Click label: ${attribution.clickLabel}');
    };

    // Set session success callback
    config.sessionSuccessCallback = (dynamic sessionSuccess) {
      debugPrint('[Adjust] Session tracked successfully');
      debugPrint('[Adjust] Session data: $sessionSuccess');
    };

    // Set session failure callback
    config.sessionFailureCallback = (dynamic sessionFailure) {
      debugPrint('[Adjust] Session tracking failed');
      debugPrint('[Adjust] Failure data: $sessionFailure');
    };

    // Set event success callback
    config.eventSuccessCallback = (dynamic eventSuccess) {
      debugPrint('[Adjust] Event tracked successfully');
      debugPrint('[Adjust] Event data: $eventSuccess');
    };

    // Set event failure callback
    config.eventFailureCallback = (dynamic eventFailure) {
      debugPrint('[Adjust] Event tracking failed');
      debugPrint('[Adjust] Failure data: $eventFailure');
    };

    // Enable deferred deep link callback
    config.deferredDeeplinkCallback = (String? uri) {
      debugPrint('[Adjust] Deferred deep link received: $uri');
    };

    // Initialize the SDK
    Adjust.initSdk(config);
    debugPrint('[Adjust] SDK initialized with app token: $appToken in $environment mode');
  }

  // Track user sign-up event
  static void trackSignUp() {
    final event = AdjustEvent('fylg62');
    Adjust.trackEvent(event);
  }

  // Track user login event
  static void trackLogin() {
    final event = AdjustEvent('xlvreg');
    Adjust.trackEvent(event);
  }

  // Track page view with page name
  static void trackPageView(String pageName) {
    final event = AdjustEvent('bqvh2m');
    event.addCallbackParameter('page_name', pageName);
    Adjust.trackEvent(event);
  }

  // Track content view with content ID
  static void trackContentView(String contentId) {
    final event = AdjustEvent('hk2lun');
    event.addCallbackParameter('content_id', contentId);
    Adjust.trackEvent(event);
  }

  // Track product added to cart
  static void trackAddToCart(String productId) {
    final event = AdjustEvent('kuupht');
    event.addCallbackParameter('product_id', productId);
    Adjust.trackEvent(event);
  }

  // Track initiation of checkout process
  static void trackInitiateCheckout() {
    final event = AdjustEvent('jwfnga');
    Adjust.trackEvent(event);
  }

  // Track user adding billing information
  static void trackAddBillingInfo() {
    final event = AdjustEvent('jdci1s');
    Adjust.trackEvent(event);
  }

  // Track successful purchase with order ID and amount
  static void trackPurchase({required String orderId, required double amount}) {
    final event = AdjustEvent('gvfjzw');
    event.setRevenue(amount, 'SAR');
    event.addCallbackParameter('order_id', orderId);
    Adjust.trackEvent(event);
  }

  // Test method to verify Adjust SDK is working
  static void testAdjustIntegration() {
    debugPrint('[Adjust] Testing Adjust SDK integration...');

    // Get Adjust ID (ADID)
    Adjust.getAdid().then((adid) {
      debugPrint('[Adjust] ✓ ADID: $adid');
    });

    // Get Attribution
    Adjust.getAttribution().then((attribution) {
      debugPrint('[Adjust] ✓ Attribution: ${attribution?.trackerName ?? "No attribution yet"}');
      debugPrint('[Adjust] ✓ Network: ${attribution?.network ?? "N/A"}');
      debugPrint('[Adjust] ✓ Campaign: ${attribution?.campaign ?? "N/A"}');
    });

    // Test a simple event
    final testEvent = AdjustEvent('bqvh2m'); // Using existing page view event
    testEvent.addCallbackParameter('test', 'integration_test');
    Adjust.trackEvent(testEvent);
    debugPrint('[Adjust] ✓ Test event sent');

    debugPrint('[Adjust] Integration test complete. Check logs above for results.');
  }
}
