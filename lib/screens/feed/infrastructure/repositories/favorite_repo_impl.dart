import 'package:ufc_mobile/screens/feed/domain/entities/favorite/favorite_list_model.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/favorite_repo.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/favorite/favorite_data_source.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;

  FavoriteRepositoryImpl(this.remoteDataSource);

  @override
  Future<bool> addOrRemoveFavProduct(int productId) {
    return remoteDataSource.addOrRemoveFavProduct(productId);
  }

  @override
  Future<FavoriteListModel?> getFavProductList(Map<String, dynamic> data) {
    return remoteDataSource.getFavProductList(data);
  }
}
