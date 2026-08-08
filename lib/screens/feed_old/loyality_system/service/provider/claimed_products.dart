import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/loyality_service.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/model/user_points_model.dart';

part 'claimed_products.g.dart';

@Riverpod(keepAlive: true)
class ClaimedProducts extends _$ClaimedProducts {
  @override
  FutureOr<List<Product>> build() async {
    return []; // Default empty state
  }

  Future<void> fetchClaimedProducts() async {
    debugPrint('Fetching claimed products...');
    state = const AsyncValue.loading();
    try {
      final products = await LoyalitySystemService().fetchClaimedProducts();
      debugPrint('Fetched claimed products: $products');
      state = AsyncValue.data(products);
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      state = AsyncValue.error(
          e.message ?? 'An error occurred', StackTrace.current);
    } catch (e) {
      debugPrint('Error: $e');
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
