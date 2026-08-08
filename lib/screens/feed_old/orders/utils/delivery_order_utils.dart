import 'package:easy_localization/easy_localization.dart';

class DeliveryOrderUtils {
  static Map<String, (String title, String Function(String?) subtitle)>
      statusMessages = {
    'PENDING': (
      'Order Placed Successfully',
      (driver) => 'We have received your order and will process it soon.'.tr()
    ),
    'Order Placed Successfully': (
      'Order Placed Successfully',
      (driver) => 'We have received your order and will process it soon.'.tr()
    ),
    'PROCESSING': (
      'Preparing Your Order',
      (driver) => 'We are getting your order ready. Hang tight!'.tr()
    ),
    'ORDER SHIPPED': (
      'Order Shipped',
      (driver) => 'Your order has been shipped and will reach you soon.'.tr()
    ),
    'ORDER COMPLETED': (
      'Order Delivered',
      (driver) => 'Your order has been delivered. Hope you love it!'.tr()
    ),
    'ORDER CANCELLED': (
      'Order Cancelled',
      (driver) => 'Your order was cancelled. Let us know if you need help.'.tr()
    ),
    'REJECTED': (
      'Order Not Accepted',
      (driver) =>
          'Unfortunately, we couldn’t process your order. Contact support for details.'
              .tr()
    ),
    'SCHEDULED': (
      'Order Scheduled',
      (driver) =>
          'Your order is set for a future date. We’ll notify you when it’s on the way.'
              .tr()
    ),
  };

  static (String? title, String? subtitle) getStatusMessage(String status,
      {String? driverName}) {
    final entry = statusMessages[status];
    return (entry?.$1, entry?.$2(driverName));
  }
}
