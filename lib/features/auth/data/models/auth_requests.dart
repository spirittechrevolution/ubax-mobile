class LoginPhoneRequest {
  const LoginPhoneRequest({required this.phone, required this.password});

  final String phone;
  final String password;

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'password': password,
      };
}

class PhoneOnlyRequest {
  const PhoneOnlyRequest({required this.phone});

  final String phone;

  Map<String, dynamic> toJson() => {'phone': phone};
}

class VerifyOtpRequest {
  const VerifyOtpRequest({required this.phone, required this.code});

  final String phone;
  final String code;

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'code': code,
      };
}

class CompleteRegistrationRequest {
  const CompleteRegistrationRequest({
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.title,
  });

  final String phone;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? title;

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'password': password,
      };
}

class ResetPasswordRequest {
  const ResetPasswordRequest({
    required this.phone,
    required this.code,
    required this.newPassword,
  });

  final String phone;
  final String code;
  final String newPassword;

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'code': code,
        'newPassword': newPassword,
      };
}

class LogoutRequest {
  const LogoutRequest({required this.refreshToken});

  final String refreshToken;

  Map<String, dynamic> toJson() => {'refreshToken': refreshToken};
}
