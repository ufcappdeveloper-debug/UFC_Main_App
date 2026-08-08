import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/model/user_points_model.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/model/user_tier_model.dart';

class LoyalitySystemService {
  Future<UserPointsModel> fetchUserTierPointsAndRewards() async {
    final response = await api.get("/api/ufc/v1/loyalty/user_tier_rewards");

    return UserPointsModel.fromJson(response.data);
  }

  Future<UserTierModel> fetchUserTierList() async {
    final response = await api.get("/api/ufc/v1/loyalty/user_tier_list");
    return UserTierModel.fromJson(response.data);
  }

  Future<void> claimProduct(int tierId, int productId, int variantId) async {
    final response = await api.post(
      "/api/ufc/v1/loyalty/claim_product",
      data: {
        "tier_id": tierId,
        "product_id": productId,
        "variant_id": variantId,
      },
    );

    if (response.statusCode! >= 200 || response.statusCode! < 300) {
      debugPrint("Product claimed successfully");
    } else {
      throw Exception("Failed to claim product: ${response.statusMessage}");
    }
  }

  Future<void> unclaimProduct(int cartId, int productId) async {
    final response = await api.post(
      "/api/ufc/v1/loyalty/unclaim_product",
      data: {
        "cart_id": cartId,
        "product_id": productId,
      },
    );

    if (response.statusCode! >= 200 || response.statusCode! < 300) {
      debugPrint("Product unclaimed successfully");
    } else {
      throw Exception("Failed to unclaim product: ${response.statusMessage}");
    }
  }

  Future<void> claimVoucher(int voucherId, int tierId) async {
    final response = await api.post(
      "/api/ufc/v1/loyalty/claim_voucher",
      data: {
        "voucher_id": voucherId,
        "tier_id": tierId,
      },
    );

    if (response.statusCode! >= 200 || response.statusCode! < 300) {
      debugPrint("Voucher claimed successfully");
    } else {
      throw Exception("Failed to claim voucher: ${response.statusMessage}");
    }
  }

  Future<bool> unclaimVoucher(int voucherId, int tierId) async {
    final response = await api.post(
      "/api/ufc/v1/loyalty/unclaim_voucher",
      data: {
        "voucher_id": voucherId,
        "tier_id": tierId,
      },
    );

    if (response.statusCode == 200) {
      debugPrint("Voucher unclaimed successfully");
      return response.statusCode == 200;
    } else {
      throw Exception("Failed to unclaim voucher: ${response.statusMessage}");
    }
  }

  Future<Voucher?> fetchClaimedVouchers() async {
    final response = await api.get("/api/ufc/v1/loyalty/claimed_vouchers");

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      debugPrint("Claimed vouchers fetched successfully");

      // Check if the response contains a single voucher
      if (response.data['voucher'] is Map<String, dynamic>) {
        // If it's a single voucher, return it as a Voucher object
        return Voucher.fromJson(response.data['voucher']);
      } else {
        // If no voucher is found or in an unexpected format, return null
        return null;
      }
    } else {
      throw Exception(
          "Failed to fetch claimed vouchers: ${response.statusMessage}");
    }
  }

  Future<List<Product>> fetchClaimedProducts() async {
    final response = await api.get("/api/ufc/v1/loyalty/claimed_products");

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      debugPrint("Claimed products fetched successfully");

      final products = response.data['data'];
      if (products is List) {
        // Convert the list of maps into a list of Product objects
        return products.map((item) => Product.fromJson(item)).toList();
      } else {
        debugPrint("Products data is not in the expected format");
        return [];
      }
    } else {
      throw Exception(
          "Failed to fetch claimed products: ${response.statusMessage}");
    }
  }
}
