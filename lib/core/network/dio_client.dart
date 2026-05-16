import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'auth_interceptor.dart';

class DioClient {
  DioClient._();

  static Dio build({required Future<void> Function() onUnauthorized}) {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://173.249.7.89/api';
    final connectTimeout = int.tryParse(
          dotenv.env['API_CONNECT_TIMEOUT_MS'] ?? '',
        ) ??
        15000;
    final receiveTimeout = int.tryParse(
          dotenv.env['API_RECEIVE_TIMEOUT_MS'] ?? '',
        ) ??
        20000;

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(milliseconds: connectTimeout),
        receiveTimeout: Duration(milliseconds: receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(AuthInterceptor(onUnauthorized: onUnauthorized));

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: false,
          responseHeader: false,
          logPrint: (obj) => developer.log(obj.toString(), name: 'API'),
        ),
      );
    }

    return dio;
  }
}
