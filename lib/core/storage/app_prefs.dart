import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static const _keyOnboardingDone = 'onboarding_done';
  static const _keyLanguageCode = 'language_code';
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyTokenExpiresAt = 'token_expires_at';
  static const _keyUserProfile = 'user_profile_json';

  static Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingDone) ?? false;
  }

  static Future<void> setOnboardingDone(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingDone, value);
  }

  static Future<String?> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguageCode);
  }

  static Future<void> setLanguageCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguageCode, code);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRefreshToken);
  }

  static Future<DateTime?> getTokenExpiresAt() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_keyTokenExpiresAt);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresInSeconds,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
    final expiresAt = DateTime.now().add(Duration(seconds: expiresInSeconds));
    await prefs.setInt(_keyTokenExpiresAt, expiresAt.millisecondsSinceEpoch);
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyTokenExpiresAt);
    await prefs.remove(_keyUserProfile);
  }

  static Future<bool> hasValidSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  static Future<String?> getUserProfileJson() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserProfile);
  }

  static Future<void> saveUserProfileJson(String json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserProfile, json);
  }
}
