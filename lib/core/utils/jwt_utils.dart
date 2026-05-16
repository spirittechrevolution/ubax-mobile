import 'dart:convert';

class JwtUtils {
  JwtUtils._();

  static Map<String, dynamic>? decodePayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    try {
      var payload = parts[1];
      payload = payload.padRight(payload.length + (4 - payload.length % 4) % 4, '=');
      final decoded = utf8.decode(base64Url.decode(payload));
      final json = jsonDecode(decoded);
      return json is Map<String, dynamic> ? json : null;
    } catch (_) {
      return null;
    }
  }

  static String? keycloakIdFromToken(String token) {
    final payload = decodePayload(token);
    return payload?['sub']?.toString();
  }
}
