import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/loyality_service.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

part 'authorization_check.g.dart';

@Riverpod(keepAlive: true)
class AuthorizationCheck extends _$AuthorizationCheck {
  @override
  Future<bool> build() async {
    return await _checkAuthorizationStatus();
  }

  // Helper method to check the authorization status
  Future<bool> _checkAuthorizationStatus() async {
    try {
      // Attempt to fetch homepage or any protected resource
      await LoyalitySystemService().fetchUserTierPointsAndRewards();
      return true; // User is authorized
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // User is unauthorized
        return false;
      } else {
        rethrow; // Rethrow other exceptions
      }
    } catch (e) {
      rethrow; // Rethrow other exceptions
    }
  }

  // Method to trigger authorization status check and update state
  Future<void> updateAuthorizationStatus() async {
    state = const AsyncValue.loading();
    try {
      bool isAuthorized = await _checkAuthorizationStatus();
      debugPrint('User is authorized: $isAuthorized');
      state = AsyncValue.data(isAuthorized); // Update state with the result
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
