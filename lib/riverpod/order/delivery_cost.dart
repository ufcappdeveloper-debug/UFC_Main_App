import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:ufc_mobile/data/delivery_fee_service.dart';

part 'delivery_cost.g.dart';

@riverpod
class DeliveryCost extends _$DeliveryCost {
  late final DeliveryCostService _deliveryCostService;

  @override
  FutureOr<DeliveryCostResponse?> build() async {
    _deliveryCostService = DeliveryCostService();
    return null;
  }

  Future<DeliveryCostResponse?> calculateDeliveryCost({
    required int userAddressId,
    required int shopId,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await _deliveryCostService.calculateDeliveryCost(
          shopId: shopId, userAddressId: userAddressId);

      // Parse the response into the DeliveryCostResponse object
      state = AsyncValue.data(response);
      return response;
    } catch (e) {
      Sentry.captureException(e, stackTrace: StackTrace.current);
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return null;
    }
  }
}

class DeliveryCostResponse {
  final double distanceInKm;
  final double pricePerKm;
  final double totalCost;

  DeliveryCostResponse({
    required this.distanceInKm,
    required this.pricePerKm,
    required this.totalCost,
  });

  factory DeliveryCostResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryCostResponse(
      distanceInKm: _parseDouble(json['distance_in_km']),
      pricePerKm: _parseDouble(json['price_per_km']),
      totalCost: _parseDouble(json['total_cost']),
    );
  }

  // Helper method to safely parse a value to double
  static double _parseDouble(dynamic value) {
    if (value is String) {
      // Attempt to parse String to double
      return double.tryParse(value) ?? 0.0;
    } else if (value is num) {
      // If it's already a number, return its double value
      return value.toDouble();
    }
    return 0.0; // Fallback to 0.0 if the value is not a valid number
  }
}
