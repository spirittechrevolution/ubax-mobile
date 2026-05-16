class PhoneFormatter {
  PhoneFormatter._();

  static String toE164({required String dialCode, required String rawPhone}) {
    final digits = rawPhone.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '';
    final code = dialCode.startsWith('+') ? dialCode : '+$dialCode';
    return '$code$digits';
  }
}
