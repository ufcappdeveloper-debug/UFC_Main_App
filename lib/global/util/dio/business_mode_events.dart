import 'dart:async';

/// A create call (add to cart, quote, place order, station / distributor
/// `place_order`, …) returned `403 BUSINESS_MODE_DISABLED`: the admin
/// switched the business mode. [message] is the API's English text.
class BusinessModeDisabledEvent {
  final String? business;
  final String? message;

  const BusinessModeDisabledEvent({this.business, this.message});
}

/// Raised by `AppInterceptor`, handled by `BusinessConfigCubit`
/// (refetch the config and go back to Home).
class BusinessModeEvents {
  BusinessModeEvents._();

  static const code = 'BUSINESS_MODE_DISABLED';

  static final _controller =
      StreamController<BusinessModeDisabledEvent>.broadcast();

  static Stream<BusinessModeDisabledEvent> get stream => _controller.stream;

  /// Checks an error body and reports it when it is BUSINESS_MODE_DISABLED.
  static void reportIfDisabled(int? statusCode, dynamic body) {
    if (statusCode != 403 || body is! Map || body['code'] != code) return;
    _controller.add(BusinessModeDisabledEvent(
      business: body['business']?.toString(),
      message: body['message']?.toString(),
    ));
  }
}
