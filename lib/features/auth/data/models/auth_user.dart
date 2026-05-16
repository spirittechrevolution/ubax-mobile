import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    String? userId,
    String? keycloakId,
    String? firstName,
    String? lastName,
    String? title,
    String? email,
    String? phone,
    String? country,
    String? language,
    @Default(<String>[]) List<String> roles,
    @Default(<String>[]) List<String> subRoles,
    String? avatarUrl,
    @Default(false) bool emailVerified,
    @Default(false) bool phoneVerified,
    @Default(false) bool identityVerified,
    @Default(true) bool active,
    String? createdAt,
    String? updatedAt,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  const AuthUser._();

  String get fullName {
    final parts = [firstName, lastName]
        .whereType<String>()
        .where((s) => s.trim().isNotEmpty)
        .toList();
    return parts.isEmpty ? (email ?? phone ?? '') : parts.join(' ');
  }

  String? get primaryRole => roles.isEmpty ? null : roles.first;
}
