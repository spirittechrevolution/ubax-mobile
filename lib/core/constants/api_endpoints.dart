class ApiEndpoints {
  ApiEndpoints._();

  static const loginPhone = '/v1/auth/login/phone';
  static const logout = '/v1/auth/logout';

  static const registerSendOtp = '/v1/auth/register/send-otp';
  static const registerVerifyOtp = '/v1/auth/register/verify-otp';
  static const registerComplete = '/v1/auth/register/complete';

  static const forgotPasswordSendOtp = '/v1/auth/forgot-password/send-otp';
  static const forgotPasswordVerifyOtp = '/v1/auth/forgot-password/verify-otp';
  static const forgotPasswordReset = '/v1/auth/forgot-password/reset';

  static const properties = '/v1/properties';

  static String propertyById(String propertyId) => '/v1/properties/$propertyId';

  static const favoritesList = '/v1/favorites/mine';

  static String addFavorite(String propertyId) => '/v1/favorites/$propertyId';

  static String removeFavorite(String propertyId) =>
      '/v1/favorites/$propertyId';

  static String userByKeycloakId(String keycloakId) =>
      '/v1/users/keycloak/$keycloakId';
  static const updateAvatar = '/v1/users/me/avatar';

  static const tenantProfile = '/v1/tenants/profile';
  static const storageUpload = '/v1/storage/upload';

  static const agencies = '/v1/agencies';
  static const bailleurApply = '/v1/bailleur/apply';
  static const storagePresignBailleurDocument =
      '/v1/storage/presign/bailleur-document';
}
