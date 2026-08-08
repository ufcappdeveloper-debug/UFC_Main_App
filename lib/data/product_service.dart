import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/models/animal_type_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';

class ProductService {
  Future<List<ProductModel>> getProducts(final data) async {
    Response response = await api.get("api/ufc/v1/get_products", data: data);
    return (response.data["products"]["data"] as List<dynamic>)
        .map((data) => ProductModel.fromJson(data))
        .toList();
  }

  Future<ProductModel> getProductDetails(final int productId) async {
    Response response = await api.get("api/ufc/v1/product/$productId");
    return ProductModel.fromJson(response.data["product"]);
  }

  Future<bool> addOrRemoveFavProduct(final int productId) async {
    Response response = await api.get("api/ufc/v1/fav_product/$productId");
    return response.data["message"] == "Favorite added successfully";
  }

  Future<List<ProductModel>> getFavProductList(final data) async {
    Response response =
        await api.get("api/ufc/v1/fav_product_list", data: data);
    return (response.data["data"]["data"] as List<dynamic>)
        .map((data) => ProductModel.fromJson(data["product"]))
        .toList();
  }

  Future<List<AnimalTypeModel>> getProductSubtypes() async {
    Response response = await api.get("api/ufc/v1/get_product_subtypes");
    return (response.data["product_subtypes"] as List<dynamic>)
        .map((data) => AnimalTypeModel.fromJson(data))
        .toList();
  }
}
