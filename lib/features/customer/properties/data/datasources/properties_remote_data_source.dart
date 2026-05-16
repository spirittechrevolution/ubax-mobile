import 'package:dio/dio.dart';

import 'package:statefulclickcounter/core/constants/api_endpoints.dart';
import 'package:statefulclickcounter/core/network/api_exception.dart';
import 'package:statefulclickcounter/features/auth/data/models/api_response.dart';

import '../models/property_models.dart';

class PropertiesRemoteDataSource {
  PropertiesRemoteDataSource(this._dio);

  final Dio _dio;

  Future<PropertiesPage> getProperties({
    int page = 0,
    int perPage = 20,
    String? type,
    String? city,
    int? minPrice,
    int? maxPrice,
    int? bedrooms,
    bool? boosted,
  }) async {
    try {
      final qp = <String, dynamic>{
        'page': page,
        'perPage': perPage,
      };
      if (type != null && type.trim().isNotEmpty) qp['type'] = type;
      if (city != null && city.trim().isNotEmpty) qp['city'] = city;
      if (minPrice != null) qp['minPrice'] = minPrice;
      if (maxPrice != null) qp['maxPrice'] = maxPrice;
      if (bedrooms != null) qp['bedrooms'] = bedrooms;
      if (boosted != null) qp['boosted'] = boosted;

      final response = await _dio.get(
        ApiEndpoints.properties,
        queryParameters: qp,
      );

      final api = ApiResponse<PropertiesPage>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => PropertiesPage.fromJson(json! as Map<String, dynamic>),
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

  Future<PropertyItem> getPropertyById(String propertyId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.propertyById(propertyId),
      );

      final api = ApiResponse<PropertyItem>.fromJson(
        response.data as Map<String, dynamic>,
        (json) {
          final map = json! as Map<String, dynamic>;
          final data = map['property'];
          if (data is Map<String, dynamic>) {
            return PropertyItem.fromJson(data);
          }
          return PropertyItem.fromJson(map);
        },
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
