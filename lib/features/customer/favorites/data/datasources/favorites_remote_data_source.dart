import 'package:dio/dio.dart';

import 'package:statefulclickcounter/core/constants/api_endpoints.dart';
import 'package:statefulclickcounter/core/network/api_exception.dart';
import 'package:statefulclickcounter/features/auth/data/models/api_response.dart';

import '../models/favorite_models.dart';

class FavoritesRemoteDataSource {
  FavoritesRemoteDataSource(this._dio);

  final Dio _dio;

  Future<FavoriteAddedRef> addFavorite(String propertyId) async {
    try {
      final response = await _dio.post(ApiEndpoints.addFavorite(propertyId));

      final api = ApiResponse<FavoriteAddedRef>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => FavoriteAddedRef.fromJson(json! as Map<String, dynamic>),
      );

      final data = api.data;
      if (data == null) {
        throw ApiException(
          message: 'Réponse invalide du serveur',
          statusCode: api.statusCode,
        );
      }
      return data;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> removeFavorite(String propertyId) async {
    try {
      await _dio.delete(ApiEndpoints.removeFavorite(propertyId));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<FavoritesPage> getMine({int page = 0, int size = 20}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.favoritesList,
        queryParameters: {'page': page, 'size': size},
      );

      final api = ApiResponse<FavoritesPage>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => FavoritesPage.fromJson(json! as Map<String, dynamic>),
      );

      final data = api.data;
      if (data == null) {
        throw ApiException(
          message: 'Réponse invalide du serveur',
          statusCode: api.statusCode,
        );
      }
      return data;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
