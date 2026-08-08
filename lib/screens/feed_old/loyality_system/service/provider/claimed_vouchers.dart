import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/loyality_service.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/model/user_points_model.dart';

// Assuming your Voucher class is here

part 'claimed_vouchers.g.dart';

@Riverpod(keepAlive: true)
class ClaimedVouchers extends _$ClaimedVouchers {
  @override
  FutureOr<Voucher?> build() async {
    return null; // Default empty state
  }

  Future<void> fetchClaimedVouchers() async {
    debugPrint('Fetching claimed vouchers...');
    state = const AsyncValue.loading();
    try {
      final voucher = await LoyalitySystemService().fetchClaimedVouchers();
      debugPrint('Fetched claimed voucher: $voucher');
      state = AsyncValue.data(voucher);
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
