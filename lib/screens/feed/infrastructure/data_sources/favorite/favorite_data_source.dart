import 'package:ufc_mobile/screens/feed/domain/entities/favorite/favorite_list_model.dart';

abstract class FavoriteRemoteDataSource {
  Future<bool> addOrRemoveFavProduct(int productId);
  Future<FavoriteListModel?> getFavProductList(Map<String, dynamic> data);
}
