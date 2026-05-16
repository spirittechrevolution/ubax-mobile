import 'dart:convert';

import 'package:statefulclickcounter/core/storage/app_prefs.dart';
import 'package:statefulclickcounter/core/utils/jwt_utils.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_requests.dart';
import '../models/auth_tokens.dart';
import '../models/auth_user.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Future<AuthTokens> loginByPhone({
    required String phone,
    required String password,
  }) async {
    final tokens = await _remote.loginByPhone(
      LoginPhoneRequest(phone: phone, password: password),
    );
    await AppPrefs.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      expiresInSeconds: tokens.expiresIn,
    );
    return tokens;
  }

  @override
  Future<void> registerSendOtp({required String phone}) {
    return _remote.registerSendOtp(PhoneOnlyRequest(phone: phone));
  }

  @override
  Future<void> registerVerifyOtp({
    required String phone,
    required String code,
  }) {
    return _remote.registerVerifyOtp(
      VerifyOtpRequest(phone: phone, code: code),
    );
  }

  @override
  Future<AuthUser> registerComplete({
    required String phone,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? title,
  }) {
    return _remote.registerComplete(
      CompleteRegistrationRequest(
        phone: phone,
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        title: title,
      ),
    );
  }

  @override
  Future<void> forgotPasswordSendOtp({required String phone}) {
    return _remote.forgotPasswordSendOtp(PhoneOnlyRequest(phone: phone));
  }

  @override
  Future<void> forgotPasswordVerifyOtp({
    required String phone,
    required String code,
  }) {
    return _remote.forgotPasswordVerifyOtp(
      VerifyOtpRequest(phone: phone, code: code),
    );
  }

  @override
  Future<void> forgotPasswordReset({
    required String phone,
    required String code,
    required String newPassword,
  }) {
    return _remote.forgotPasswordReset(
      ResetPasswordRequest(
        phone: phone,
        code: code,
        newPassword: newPassword,
      ),
    );
  }

  @override
  Future<void> logout() async {
    final refreshToken = await AppPrefs.getRefreshToken();
    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _remote.logout(LogoutRequest(refreshToken: refreshToken));
      }
    } finally {
      await AppPrefs.clearTokens();
    }
  }

  @override
  Future<bool> hasSession() => AppPrefs.hasValidSession();

  @override
  Future<AuthUser?> getCurrentUser({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await AppPrefs.getUserProfileJson();
      if (cached != null && cached.isNotEmpty) {
        try {
          return AuthUser.fromJson(
            jsonDecode(cached) as Map<String, dynamic>,
          );
        } catch (_) {}
      }
    }
    final token = await AppPrefs.getAccessToken();
    if (token == null || token.isEmpty) return null;
    final keycloakId = JwtUtils.keycloakIdFromToken(token);
    if (keycloakId == null) return null;
    final user = await _remote.getUserByKeycloakId(keycloakId);
    await AppPrefs.saveUserProfileJson(jsonEncode(user.toJson()));
    return user;
  }

  @override
  Future<String> uploadAvatar(String imagePath) async {
    final avatarUrl = await _remote.uploadAvatar(imagePath);
    // Refresh the cached user profile after avatar upload
    await getCurrentUser(forceRefresh: true);
    return avatarUrl;
  }
}
