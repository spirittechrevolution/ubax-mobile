import 'package:dio/dio.dart';

import 'package:statefulclickcounter/core/storage/app_prefs.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.onUnauthorized});

  final Future<void> Function() onUnauthorized;

  static const _publicPaths = <String>{
    '/v1/auth/login/phone',
    '/v1/auth/register/send-otp',
    '/v1/auth/register/verify-otp',
    '/v1/auth/register/complete',
    '/v1/auth/forgot-password/send-otp',
    '/v1/auth/forgot-password/verify-otp',
    '/v1/auth/forgot-password/reset',
  };

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_publicPaths.contains(options.path)) {
      final token = await AppPrefs.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 &&
        !_publicPaths.contains(err.requestOptions.path)) {
      await onUnauthorized();
    }
    handler.next(err);
  }
}
