import '../../data/models/auth_tokens.dart';
import '../../data/models/auth_user.dart';

abstract class AuthRepository {
  Future<AuthTokens> loginByPhone({
    required String phone,
    required String password,
  });

  Future<void> registerSendOtp({required String phone});

  Future<void> registerVerifyOtp({
    required String phone,
    required String code,
  });

  Future<AuthUser> registerComplete({
    required String phone,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? title,
  });

  Future<void> forgotPasswordSendOtp({required String phone});

  Future<void> forgotPasswordVerifyOtp({
    required String phone,
    required String code,
  });

  Future<void> forgotPasswordReset({
    required String phone,
    required String code,
    required String newPassword,
  });

  Future<void> logout();

  Future<bool> hasSession();

  Future<AuthUser?> getCurrentUser({bool forceRefresh = false});

  Future<String> uploadAvatar(String imagePath);
}
