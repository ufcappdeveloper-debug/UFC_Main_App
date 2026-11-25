import 'package:flutter/material.dart';

import '../../../domain/entities/main_source/main_source_model.dart';
import '../../../domain/entities/main_source/main_source_order_model.dart';
import '../../distributor/utils/distributor_style.dart';

/// Translation keys for order / payment values (plan §5). Call `.tr()`.
String orderStatusLabel(String? status) => switch (status) {
      MainSourceOrderStatus.pending => 'Order received',
      MainSourceOrderStatus.scheduled => 'Scheduled',
      MainSourceOrderStatus.processing => 'Being prepared',
      MainSourceOrderStatus.shipped => 'On the way',
      MainSourceOrderStatus.completed => 'Delivered',
      MainSourceOrderStatus.cancelled => 'Cancelled',
      MainSourceOrderStatus.rejected => 'Rejected',
      _ => status ?? '-',
    };

Color orderStatusColor(String? status) => switch (status) {
      MainSourceOrderStatus.completed => DistributorStyle.green,
      MainSourceOrderStatus.cancelled ||
      MainSourceOrderStatus.rejected =>
        DistributorStyle.error,
      MainSourceOrderStatus.shipped ||
      MainSourceOrderStatus.processing =>
        const Color(0xFF2F80ED),
      _ => const Color(0xFFF2994A),
    };

String paymentStatusLabel(String? status) => switch (status) {
      MainSourcePaymentStatus.pending => 'Not paid yet',
      MainSourcePaymentStatus.paid => 'Paid',
      MainSourcePaymentStatus.failed => 'Payment failed',
      MainSourcePaymentStatus.pendingVerification =>
        'Transfer is being verified',
      MainSourcePaymentStatus.rejected => 'Transfer rejected',
      MainSourcePaymentStatus.refunded => 'Refunded',
      _ => status ?? '-',
    };

Color paymentStatusColor(String? status) => switch (status) {
      MainSourcePaymentStatus.paid => DistributorStyle.green,
      MainSourcePaymentStatus.failed ||
      MainSourcePaymentStatus.rejected =>
        DistributorStyle.error,
      _ => DistributorStyle.textSecondary,
    };

String paymentMethodLabel(String? method) => switch (method) {
      MainSourcePaymentMethod.cash => 'Cash on delivery',
      MainSourcePaymentMethod.sadad => 'SADAD',
      MainSourcePaymentMethod.mada => 'MADA',
      MainSourcePaymentMethod.wallet => 'Wallet',
      MainSourcePaymentMethod.bank => 'Bank Transfer',
      _ => method ?? '-',
    };
