// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthUser {
  String? get userId;
  String? get keycloakId;
  String? get firstName;
  String? get lastName;
  String? get title;
  String? get email;
  String? get phone;
  String? get country;
  String? get language;
  List<String> get roles;
  List<String> get subRoles;
  String? get avatarUrl;
  bool get emailVerified;
  bool get phoneVerified;
  bool get identityVerified;
  bool get active;
  String? get createdAt;
  String? get updatedAt;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthUserCopyWith<AuthUser> get copyWith =>
      _$AuthUserCopyWithImpl<AuthUser>(this as AuthUser, _$identity);

  /// Serializes this AuthUser to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthUser &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.keycloakId, keycloakId) ||
                other.keycloakId == keycloakId) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.language, language) ||
                other.language == language) &&
            const DeepCollectionEquality().equals(other.roles, roles) &&
            const DeepCollectionEquality().equals(other.subRoles, subRoles) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.phoneVerified, phoneVerified) ||
                other.phoneVerified == phoneVerified) &&
            (identical(other.identityVerified, identityVerified) ||
                other.identityVerified == identityVerified) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      keycloakId,
      firstName,
      lastName,
      title,
      email,
      phone,
      country,
      language,
      const DeepCollectionEquality().hash(roles),
      const DeepCollectionEquality().hash(subRoles),
      avatarUrl,
      emailVerified,
      phoneVerified,
      identityVerified,
      active,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'AuthUser(userId: $userId, keycloakId: $keycloakId, firstName: $firstName, lastName: $lastName, title: $title, email: $email, phone: $phone, country: $country, language: $language, roles: $roles, subRoles: $subRoles, avatarUrl: $avatarUrl, emailVerified: $emailVerified, phoneVerified: $phoneVerified, identityVerified: $identityVerified, active: $active, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $AuthUserCopyWith<$Res> {
  factory $AuthUserCopyWith(AuthUser value, $Res Function(AuthUser) _then) =
      _$AuthUserCopyWithImpl;
  @useResult
  $Res call(
      {String? userId,
      String? keycloakId,
      String? firstName,
      String? lastName,
      String? title,
      String? email,
      String? phone,
      String? country,
      String? language,
      List<String> roles,
      List<String> subRoles,
      String? avatarUrl,
      bool emailVerified,
      bool phoneVerified,
      bool identityVerified,
      bool active,
      String? createdAt,
      String? updatedAt});
}

/// @nodoc
class _$AuthUserCopyWithImpl<$Res> implements $AuthUserCopyWith<$Res> {
  _$AuthUserCopyWithImpl(this._self, this._then);

  final AuthUser _self;
  final $Res Function(AuthUser) _then;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? keycloakId = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? title = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? country = freezed,
    Object? language = freezed,
    Object? roles = null,
    Object? subRoles = null,
    Object? avatarUrl = freezed,
    Object? emailVerified = null,
    Object? phoneVerified = null,
    Object? identityVerified = null,
    Object? active = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      keycloakId: freezed == keycloakId
          ? _self.keycloakId
          : keycloakId // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _self.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _self.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      roles: null == roles
          ? _self.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      subRoles: null == subRoles
          ? _self.subRoles
          : subRoles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      avatarUrl: freezed == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      emailVerified: null == emailVerified
          ? _self.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneVerified: null == phoneVerified
          ? _self.phoneVerified
          : phoneVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      identityVerified: null == identityVerified
          ? _self.identityVerified
          : identityVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      active: null == active
          ? _self.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AuthUser].
extension AuthUserPatterns on AuthUser {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AuthUser value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthUser() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AuthUser value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthUser():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AuthUser value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthUser() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String? userId,
            String? keycloakId,
            String? firstName,
            String? lastName,
            String? title,
            String? email,
            String? phone,
            String? country,
            String? language,
            List<String> roles,
            List<String> subRoles,
            String? avatarUrl,
            bool emailVerified,
            bool phoneVerified,
            bool identityVerified,
            bool active,
            String? createdAt,
            String? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthUser() when $default != null:
        return $default(
            _that.userId,
            _that.keycloakId,
            _that.firstName,
            _that.lastName,
            _that.title,
            _that.email,
            _that.phone,
            _that.country,
            _that.language,
            _that.roles,
            _that.subRoles,
            _that.avatarUrl,
            _that.emailVerified,
            _that.phoneVerified,
            _that.identityVerified,
            _that.active,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String? userId,
            String? keycloakId,
            String? firstName,
            String? lastName,
            String? title,
            String? email,
            String? phone,
            String? country,
            String? language,
            List<String> roles,
            List<String> subRoles,
            String? avatarUrl,
            bool emailVerified,
            bool phoneVerified,
            bool identityVerified,
            bool active,
            String? createdAt,
            String? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthUser():
        return $default(
            _that.userId,
            _that.keycloakId,
            _that.firstName,
            _that.lastName,
            _that.title,
            _that.email,
            _that.phone,
            _that.country,
            _that.language,
            _that.roles,
            _that.subRoles,
            _that.avatarUrl,
            _that.emailVerified,
            _that.phoneVerified,
            _that.identityVerified,
            _that.active,
            _that.createdAt,
            _that.updatedAt);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String? userId,
            String? keycloakId,
            String? firstName,
            String? lastName,
            String? title,
            String? email,
            String? phone,
            String? country,
            String? language,
            List<String> roles,
            List<String> subRoles,
            String? avatarUrl,
            bool emailVerified,
            bool phoneVerified,
            bool identityVerified,
            bool active,
            String? createdAt,
            String? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthUser() when $default != null:
        return $default(
            _that.userId,
            _that.keycloakId,
            _that.firstName,
            _that.lastName,
            _that.title,
            _that.email,
            _that.phone,
            _that.country,
            _that.language,
            _that.roles,
            _that.subRoles,
            _that.avatarUrl,
            _that.emailVerified,
            _that.phoneVerified,
            _that.identityVerified,
            _that.active,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AuthUser extends AuthUser {
  const _AuthUser(
      {this.userId,
      this.keycloakId,
      this.firstName,
      this.lastName,
      this.title,
      this.email,
      this.phone,
      this.country,
      this.language,
      final List<String> roles = const <String>[],
      final List<String> subRoles = const <String>[],
      this.avatarUrl,
      this.emailVerified = false,
      this.phoneVerified = false,
      this.identityVerified = false,
      this.active = true,
      this.createdAt,
      this.updatedAt})
      : _roles = roles,
        _subRoles = subRoles,
        super._();
  factory _AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  @override
  final String? userId;
  @override
  final String? keycloakId;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? title;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? country;
  @override
  final String? language;
  final List<String> _roles;
  @override
  @JsonKey()
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  final List<String> _subRoles;
  @override
  @JsonKey()
  List<String> get subRoles {
    if (_subRoles is EqualUnmodifiableListView) return _subRoles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subRoles);
  }

  @override
  final String? avatarUrl;
  @override
  @JsonKey()
  final bool emailVerified;
  @override
  @JsonKey()
  final bool phoneVerified;
  @override
  @JsonKey()
  final bool identityVerified;
  @override
  @JsonKey()
  final bool active;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthUserCopyWith<_AuthUser> get copyWith =>
      __$AuthUserCopyWithImpl<_AuthUser>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AuthUserToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthUser &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.keycloakId, keycloakId) ||
                other.keycloakId == keycloakId) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.language, language) ||
                other.language == language) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            const DeepCollectionEquality().equals(other._subRoles, _subRoles) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.phoneVerified, phoneVerified) ||
                other.phoneVerified == phoneVerified) &&
            (identical(other.identityVerified, identityVerified) ||
                other.identityVerified == identityVerified) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      keycloakId,
      firstName,
      lastName,
      title,
      email,
      phone,
      country,
      language,
      const DeepCollectionEquality().hash(_roles),
      const DeepCollectionEquality().hash(_subRoles),
      avatarUrl,
      emailVerified,
      phoneVerified,
      identityVerified,
      active,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'AuthUser(userId: $userId, keycloakId: $keycloakId, firstName: $firstName, lastName: $lastName, title: $title, email: $email, phone: $phone, country: $country, language: $language, roles: $roles, subRoles: $subRoles, avatarUrl: $avatarUrl, emailVerified: $emailVerified, phoneVerified: $phoneVerified, identityVerified: $identityVerified, active: $active, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$AuthUserCopyWith<$Res>
    implements $AuthUserCopyWith<$Res> {
  factory _$AuthUserCopyWith(_AuthUser value, $Res Function(_AuthUser) _then) =
      __$AuthUserCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? userId,
      String? keycloakId,
      String? firstName,
      String? lastName,
      String? title,
      String? email,
      String? phone,
      String? country,
      String? language,
      List<String> roles,
      List<String> subRoles,
      String? avatarUrl,
      bool emailVerified,
      bool phoneVerified,
      bool identityVerified,
      bool active,
      String? createdAt,
      String? updatedAt});
}

/// @nodoc
class __$AuthUserCopyWithImpl<$Res> implements _$AuthUserCopyWith<$Res> {
  __$AuthUserCopyWithImpl(this._self, this._then);

  final _AuthUser _self;
  final $Res Function(_AuthUser) _then;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = freezed,
    Object? keycloakId = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? title = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? country = freezed,
    Object? language = freezed,
    Object? roles = null,
    Object? subRoles = null,
    Object? avatarUrl = freezed,
    Object? emailVerified = null,
    Object? phoneVerified = null,
    Object? identityVerified = null,
    Object? active = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_AuthUser(
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      keycloakId: freezed == keycloakId
          ? _self.keycloakId
          : keycloakId // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _self.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _self.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      roles: null == roles
          ? _self._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      subRoles: null == subRoles
          ? _self._subRoles
          : subRoles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      avatarUrl: freezed == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      emailVerified: null == emailVerified
          ? _self.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneVerified: null == phoneVerified
          ? _self.phoneVerified
          : phoneVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      identityVerified: null == identityVerified
          ? _self.identityVerified
          : identityVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      active: null == active
          ? _self.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
