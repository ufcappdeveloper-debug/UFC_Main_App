import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/riverpod/cart/cart_provider.dart';
import 'package:ufc_mobile/riverpod/payment/payment_provider.dart';

final paymentMethodProvider =
    ChangeNotifierProvider((ref) => PaymentMethodState(ref));
final cartProvider = ChangeNotifierProvider((ref) => CartState(ref));
