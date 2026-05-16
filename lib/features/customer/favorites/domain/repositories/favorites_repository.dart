import '../../data/models/favorite_models.dart';

abstract class FavoritesRepository {
  Future<FavoriteAddedRef> addFavorite(String propertyId);
  Future<void> removeFavorite(String propertyId);
  Future<FavoritesPage> getMine({int page = 0, int size = 20});
}
