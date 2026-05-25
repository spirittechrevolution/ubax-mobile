import 'package:dio/dio.dart';
import 'package:statefulclickcounter/core/constants/api_endpoints.dart';
import 'package:statefulclickcounter/core/network/api_exception.dart';
import '../models/ticket_models.dart';

class TicketsRemoteDataSource {
  TicketsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<TicketItem>> getMyTickets() async {
    try {
      final res = await _dio.get(ApiEndpoints.ticketsMine);
      final body = res.data as Map<String, dynamic>;
      final data = body['data'];

      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(TicketItem.fromJson)
            .toList(growable: false);
      }
      if (data is Map<String, dynamic>) {
        final results = data['results'] ?? data['items'] ?? data['tickets'];
        if (results is List) {
          return results
              .whereType<Map<String, dynamic>>()
              .map(TicketItem.fromJson)
              .toList(growable: false);
        }
      }
      return const [];
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<TicketItem> createTicket(CreateTicketRequest request) async {
    try {
      final res = await _dio.post(
        ApiEndpoints.tickets,
        data: request.toJson(),
      );
      final body = res.data as Map<String, dynamic>;
      final data = body['data'];
      if (data is Map<String, dynamic>) {
        return TicketItem.fromJson(data);
      }
      return TicketItem(
        id: '',
        reference: '',
        category: request.category,
        title: request.title,
        status: 'OPEN',
        createdAt: '',
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
