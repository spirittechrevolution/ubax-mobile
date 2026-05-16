import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_data_source.dart';
import '../models/favorite_models.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._remote);

  final FavoritesRemoteDataSource _remote;

  @override
  Future<FavoriteAddedRef> addFavorite(String propertyId) {
    return _remote.addFavorite(propertyId);
  }

  @override
  Future<void> removeFavorite(String propertyId) {
    return _remote.removeFavorite(propertyId);
  }

  @override
  Future<FavoritesPage> getMine({int page = 0, int size = 20}) {
    return _remote.getMine(page: page, size: size);
  }
}
