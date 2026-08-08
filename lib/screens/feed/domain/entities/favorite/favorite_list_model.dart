import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';

class FavoriteListModel {
  final int currentPage;
  final int lastPage;
  final List<ProductModel> data;

  FavoriteListModel({
    required this.currentPage,
    required this.lastPage,
    required this.data,
  });

  factory FavoriteListModel.fromJson(Map<String, dynamic> json) {
    // json["data"] is the list of favorite objects, each with a "product" key
    final favoritesList = (json["data"] as List<dynamic>?)
            ?.map((e) => ProductModel.fromJson(e["product"]))
            .toList() ??
        [];

    return FavoriteListModel(
      currentPage: json["current_page"] ?? 1,
      lastPage: json["last_page"] ?? 1,
      data: favoritesList,
    );
  }
}
