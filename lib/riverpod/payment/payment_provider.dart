import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/data/payment_service.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/payment/bank_details_model.dart';

class PaymentMethodState extends ChangeNotifier {
  final Ref ref;

  PaymentMethodState(this.ref) {
    // Initialization logic for socket
  }

  BankDetailsModel? bankDetails;

  ///////////* <------ Clear ------> *///////////

  void clear() {
    // Clear logic
    bankDetails = null;
  }

  void get clearAll {
    // Clear all logic
    notifyListeners();
  }

  ///////////* <------ Auth Functionality ------> *///////////

  Future<void> getBankDetails(final int stationId) async {
    try {
      bankDetails = await PaymentService.getBankDetails(stationId);
    } catch (e) {
      rethrow;
    }
  }
}
