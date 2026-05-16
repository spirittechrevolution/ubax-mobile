import 'package:dio/dio.dart';

class ApiException implements Exception {
  ApiException({
    required this.message,
    this.statusCode,
    this.code,
  });

  final String message;
  final int? statusCode;
  final String? code;

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isConflict => statusCode == 409;
  bool get isBadRequest => statusCode == 400;
  bool get isNetwork => statusCode == null;

  factory ApiException.fromDio(DioException e) {
    final response = e.response;
    if (response != null) {
      final data = response.data;
      String message;
      String? code;
      if (data is Map) {
        message = (data['message'] ?? data['error'] ?? 'Erreur serveur').toString();
        code = data['code']?.toString();
      } else {
        message = response.statusMessage ?? 'Erreur serveur';
      }
      return ApiException(
        message: message,
        statusCode: response.statusCode,
        code: code,
      );
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(message: 'Délai dépassé. Vérifie ta connexion.');
      case DioExceptionType.connectionError:
        return ApiException(message: 'Connexion impossible au serveur.');
      case DioExceptionType.cancel:
        return ApiException(message: 'Requête annulée.');
      default:
        return ApiException(message: e.message ?? 'Erreur réseau');
    }
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
