import 'package:ufc_mobile/screens/feed/domain/entities/favorite/favorite_list_model.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/favorite_repo.dart';

class AddProductToFavoritesUseCase {
  final FavoriteRepository repository;

  AddProductToFavoritesUseCase(this.repository);

  Future<bool> call(int productId) {
    return repository.addOrRemoveFavProduct(productId);
  }
}

class GetFavoritesUseCase {
  final FavoriteRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<FavoriteListModel?> call(Map<String, dynamic> data) {
    return repository.getFavProductList(data);
  }
}
