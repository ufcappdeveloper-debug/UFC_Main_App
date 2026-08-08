import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryPageNotifier extends ChangeNotifier {
  int? categoryId;

  void changeCategoryId(final data) {
    categoryId = data;
    notifyListeners();
  }
}

final categoryPageProvider =
    ChangeNotifierProvider<CategoryPageNotifier>((ref) {
  return CategoryPageNotifier();
});
