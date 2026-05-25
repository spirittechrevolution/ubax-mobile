import 'package:dio/dio.dart';
import 'package:statefulclickcounter/core/constants/api_endpoints.dart';
import 'package:statefulclickcounter/core/network/api_exception.dart';
import '../models/property_visit_models.dart';

class PropertyVisitsRemoteDataSource {
  PropertyVisitsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<AvailableSlot>> getAvailableSlots(String propertyId) async {
    try {
      final res = await _dio.get(ApiEndpoints.propertyVisitSlots(propertyId));
      final body = res.data as Map<String, dynamic>;
      final data = body['data'];

      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(AvailableSlot.fromJson)
            .toList(growable: false);
      }
      if (data is Map<String, dynamic>) {
        final results = data['results'] ?? data['slots'] ?? data['dates'];
        if (results is List) {
          return results
              .whereType<Map<String, dynamic>>()
              .map(AvailableSlot.fromJson)
              .toList(growable: false);
        }
      }
      return const [];
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<PropertyVisitResponse> createVisit(
      PropertyVisitRequest request) async {
    try {
      final res = await _dio.post(
        ApiEndpoints.propertyVisits,
        data: request.toJson(),
      );
      final body = res.data as Map<String, dynamic>;
      final data = body['data'];
      if (data is Map<String, dynamic>) {
        return PropertyVisitResponse.fromJson(data);
      }
      return PropertyVisitResponse(id: '', status: 'SUCCESS');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
