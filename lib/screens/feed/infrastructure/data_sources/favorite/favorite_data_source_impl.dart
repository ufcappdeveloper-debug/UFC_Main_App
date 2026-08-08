import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/favorite/favorite_list_model.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/favorite/favorite_data_source.dart';

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  FavoriteRemoteDataSourceImpl();

  @override
  Future<bool> addOrRemoveFavProduct(int productId) async {
    try {
      Response response = await api.get("api/ufc/v1/fav_product/$productId");
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<FavoriteListModel?> getFavProductList(
      Map<String, dynamic> data) async {
    try {
      Response response =
          await api.get("api/ufc/v1/fav_product_list", queryParameters: data);
      FavoriteListModel? favoriteList =
          FavoriteListModel.fromJson(response.data["data"]);
      return favoriteList;
    } catch (e) {
      rethrow;
    }
  }
}
