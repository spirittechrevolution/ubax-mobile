// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
      userId: json['userId'] as String?,
      keycloakId: json['keycloakId'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      title: json['title'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      country: json['country'] as String?,
      language: json['language'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
      subRoles: (json['subRoles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      avatarUrl: json['avatarUrl'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      phoneVerified: json['phoneVerified'] as bool? ?? false,
      identityVerified: json['identityVerified'] as bool? ?? false,
      active: json['active'] as bool? ?? true,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
      'userId': instance.userId,
      'keycloakId': instance.keycloakId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'title': instance.title,
      'email': instance.email,
      'phone': instance.phone,
      'country': instance.country,
      'language': instance.language,
      'roles': instance.roles,
      'subRoles': instance.subRoles,
      'avatarUrl': instance.avatarUrl,
      'emailVerified': instance.emailVerified,
      'phoneVerified': instance.phoneVerified,
      'identityVerified': instance.identityVerified,
      'active': instance.active,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
