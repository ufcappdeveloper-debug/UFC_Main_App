import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_category_model.dart';

class CategoryService {
  Future<List<CategoryModel>> getCategories(final data) async {
    Response response =
        await api.get("api/ufc/v1/categories/search", data: data);
    return (response.data["categories"]["data"] as List<dynamic>)
        .map((data) => CategoryModel.fromJson(data))
        .toList();
  }
}
