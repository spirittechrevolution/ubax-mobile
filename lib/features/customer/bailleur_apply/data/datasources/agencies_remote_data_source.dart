import 'package:dio/dio.dart';

import 'package:statefulclickcounter/core/constants/api_endpoints.dart';
import 'package:statefulclickcounter/core/network/api_exception.dart';
import 'package:statefulclickcounter/features/auth/data/models/api_response.dart';

import '../models/agency_models.dart';

class AgenciesRemoteDataSource {
  AgenciesRemoteDataSource(this._dio);

  final Dio _dio;

  Future<AgenciesPage> getAgencies({
    String? city,
    String? country,
    String? region,
    String? zone,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.agencies,
        queryParameters: {
          'page': page,
          'size': size,
          'sort': 'name,asc',
          if (city != null && city.trim().isNotEmpty) 'city': city.trim(),
          if (country != null && country.trim().isNotEmpty)
            'country': country.trim(),
          if (region != null && region.trim().isNotEmpty)
            'region': region.trim(),
          if (zone != null && zone.trim().isNotEmpty) 'zone': zone.trim(),
        },
      );

      final api = ApiResponse<AgenciesPage>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => AgenciesPage.fromJson(json! as Map<String, dynamic>),
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
