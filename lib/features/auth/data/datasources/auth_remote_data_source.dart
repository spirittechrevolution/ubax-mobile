import 'package:dio/dio.dart';

import 'package:statefulclickcounter/core/constants/api_endpoints.dart';
import 'package:statefulclickcounter/core/network/api_exception.dart';
import '../models/api_response.dart';
import '../models/auth_requests.dart';
import '../models/auth_tokens.dart';
import '../models/auth_user.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<AuthTokens> loginByPhone(LoginPhoneRequest request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.loginPhone,
        data: request.toJson(),
      );
      final api = ApiResponse<AuthTokens>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => AuthTokens.fromJson(json! as Map<String, dynamic>),
      );
      final tokens = api.data;
      if (tokens == null) {
        throw ApiException(
            message: 'Réponse invalide du serveur', statusCode: api.statusCode);
      }
      return tokens;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> registerSendOtp(PhoneOnlyRequest request) =>
      _voidPost(ApiEndpoints.registerSendOtp, request.toJson());

  Future<void> registerVerifyOtp(VerifyOtpRequest request) =>
      _voidPost(ApiEndpoints.registerVerifyOtp, request.toJson());

  Future<AuthUser> registerComplete(CompleteRegistrationRequest request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.registerComplete,
        data: request.toJson(),
      );
      final api = ApiResponse<AuthUser>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => AuthUser.fromJson(json! as Map<String, dynamic>),
      );
      final user = api.data;
      if (user == null) {
        throw ApiException(
            message: 'Réponse invalide du serveur', statusCode: api.statusCode);
      }
      return user;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> forgotPasswordSendOtp(PhoneOnlyRequest request) =>
      _voidPost(ApiEndpoints.forgotPasswordSendOtp, request.toJson());

  Future<void> forgotPasswordVerifyOtp(VerifyOtpRequest request) =>
      _voidPost(ApiEndpoints.forgotPasswordVerifyOtp, request.toJson());

  Future<void> forgotPasswordReset(ResetPasswordRequest request) =>
      _voidPost(ApiEndpoints.forgotPasswordReset, request.toJson());

  Future<void> logout(LogoutRequest request) =>
      _voidPost(ApiEndpoints.logout, request.toJson());

  Future<AuthUser> getUserByKeycloakId(String keycloakId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.userByKeycloakId(keycloakId),
      );
      final body = response.data;
      final Map<String, dynamic> userJson;
      if (body is Map<String, dynamic>) {
        final data = body['data'];
        if (data is Map<String, dynamic>) {
          userJson = data;
        } else {
          userJson = body;
        }
      } else {
        throw ApiException(
          message: 'Réponse invalide du serveur',
          statusCode: response.statusCode,
        );
      }
      return AuthUser.fromJson(userJson);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<String> uploadAvatar(String imagePath) async {
    try {
      final file = await MultipartFile.fromFile(imagePath);
      final formData = FormData.fromMap({
        'file': file,
      });

      final response = await _dio.post(
        ApiEndpoints.updateAvatar,
        data: formData,
      );

      final api = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json! as Map<String, dynamic>,
      );

      final data = api.data;
      if (data == null || !data.containsKey('avatarUrl')) {
        throw ApiException(
            message: 'Réponse invalide du serveur', statusCode: api.statusCode);
      }

      return data['avatarUrl'] as String;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> _voidPost(String path, Map<String, dynamic> body) async {
    try {
      await _dio.post(path, data: body);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
