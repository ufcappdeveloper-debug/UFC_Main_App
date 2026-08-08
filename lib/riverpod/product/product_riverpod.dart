import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductNotifier extends ChangeNotifier {
  int qty = 1;

  void changeProductQty(final int data) {
    if (data < 1) {
      qty = 1;
    } else {
      qty = data;
    }
    notifyListeners();
  }

  void incrementProductQty() {
    qty++;
    notifyListeners();
  }

  void decrementProductQty() {
    if (qty > 1) {
      qty--;
      notifyListeners();
    }
  }
}

final productProvider = ChangeNotifierProvider<ProductNotifier>((ref) {
  return ProductNotifier();
});
