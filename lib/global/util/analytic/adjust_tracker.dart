import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event.dart';
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
    Adjust.initSdk(config);
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
}
