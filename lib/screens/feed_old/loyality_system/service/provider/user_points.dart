import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/loyality_service.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

import '../model/user_points_model.dart';

part 'user_points.g.dart';

@Riverpod(keepAlive: true)
class UserPoints extends _$UserPoints {
  @override
  FutureOr<UserPointsModel> build() async {
    return UserPointsModel(); // Default empty state
  }

  // Future<void> checkFeatureStatus() async {
  //   try {
  //     await LoyalitySystemService().fetchUserTierPointsAndRewards();
  //     isFeatureEnabled = true; // Feature is enabled
  //   } on DioException catch (e) {
  //     if (e.response?.statusCode == 403) {
  //       isFeatureEnabled = false; // Feature is disabled
  //     } else {
  //       rethrow; // Handle other errors
  //     }
  //   }
  // }

  Future<void> fetchUserTierPoints() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(
          await LoyalitySystemService().fetchUserTierPointsAndRewards());
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> claimProduct(int tierId, int productId, int variantId) async {
    try {
      await LoyalitySystemService().claimProduct(tierId, productId, variantId);
      log("Product claimed successfully");
      // Optionally, you can refetch points after claiming
      await fetchUserTierPoints();
    } on DioException catch (e) {
      log("Failed to claim product: ${e.dioMessage}");
      throw Exception("Failed to claim product: ${e.dioMessage}");
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> unclaimProduct(int cartId, int productId) async {
    try {
      await LoyalitySystemService().unclaimProduct(cartId, productId);

      log("Product unclaimed successfully");
      // Optionally, you can refetch points after unclaiming
      await fetchUserTierPoints();
    } on DioException catch (e) {
      log("Failed to unclaim product: ${e.dioMessage}");
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> claimVoucher(int voucherId, int tierId) async {
    try {
      await LoyalitySystemService().claimVoucher(voucherId, tierId);
      log("Voucher claimed successfully");
      // Optionally, you can refetch points after claiming
      await fetchUserTierPoints();
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['message'] ?? e.dioMessage ?? "Unknown error";
      // final errorMessage = extractErrorMessage(e);

      log("Failed to claim voucher: $errorMessage");
      throw Exception("Failed to claim voucher: $errorMessage");
    } catch (e) {
      log(e.toString());
    }
  }

  // String extractErrorMessage(DioException e) {
  //   if (e.response != null) {
  //     final responseData = e.response?.data;

  //     if (responseData is Map<String, dynamic>) {
  //       return responseData['message'] ?? "Unknown error from server";
  //     } else if (responseData is String) {
  //       try {
  //         final parsedData = jsonDecode(responseData);
  //         return parsedData['message'] ?? "Unknown error from server";
  //       } catch (_) {
  //         return "Invalid JSON response from server";
  //       }
  //     } else {
  //       return "Unexpected error response format";
  //     }
  //   } else {
  //     return "No response from server: ${e.message}";
  //   }
  // }

  Future<void> unclaimVoucher(int voucherId, int tierId) async {
    try {
      await LoyalitySystemService().unclaimVoucher(voucherId, tierId);
      log("Voucher unclaimed successfully");
      // Optionally, you can refetch points after unclaiming
      await fetchUserTierPoints();
    } on DioException catch (e) {
      log("Failed to unclaim voucher: ${e.dioMessage}");
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
