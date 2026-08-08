import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/models/rating_model.dart';

class RatingService {
  Future<List<RatingModel>> getProductRating(
      final int? productId, final data) async {
    Response response = await api
        .get("api/ufc/v1/public/product/rating/$productId", data: data);
    return (response.data["ratings"] as List<dynamic>)
        .map((data) => RatingModel.fromJson(data))
        .toList();
  }

  Future<bool> addProductRating(final data) async {
    Response response =
        await api.post("api/ufc/v1/product/rating/add", data: data);
    return response.data["message"] == "Rating added successfully";
  }
}
