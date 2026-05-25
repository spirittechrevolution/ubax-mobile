import 'package:dio/dio.dart';
import 'package:statefulclickcounter/core/constants/api_endpoints.dart';
import 'package:statefulclickcounter/core/network/api_exception.dart';
import '../models/reservation_models.dart';

class ReservationRemoteDataSource {
  ReservationRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ReservationResponse> createReservation(
      ReservationRequest request) async {
    try {
      final res = await _dio.post(
        ApiEndpoints.reservations,
        data: request.toJson(),
      );
      final data =
          (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return ReservationResponse.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<List<ReservationResponse>> getMyReservations() async {
    try {
      final res = await _dio.get(ApiEndpoints.reservationsMine);
      final data =
          (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      final results = (data['results'] as List? ?? []);
      return results
          .map((e) => ReservationResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<ReservationResponse> getReservationById(String id) async {
    try {
      final res = await _dio.get(ApiEndpoints.reservationById(id));
      final data =
          (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return ReservationResponse.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
