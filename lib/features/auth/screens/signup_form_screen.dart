import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:statefulclickcounter/core/widgets/orange_button.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class SignupFormScreen extends StatefulWidget {
  const SignupFormScreen({super.key});

  @override
  State<SignupFormScreen> createState() => _SignupFormScreenState();
}

class _SignupFormScreenState extends State<SignupFormScreen> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;
  String _civility = 'Mrs';
  String _accountType = 'Particulier';

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/onb1.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0B1A28).withOpacity(0.55),
                    const Color(0xFF0B1A28).withOpacity(0.35),
                    const Color(0xFF0B1A28).withOpacity(0.65),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'auth.create_account'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Image.asset(
                    'assets/icons/logoUbaxWhite.png',
                    width: 86,
                    height: 86,
                  ),
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 24,
                          offset: Offset(0, -6),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 24, 18, 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'auth.signup_form_title'.tr(),
                                  style: AppTextStyles.sectionTitle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: _DropdownField(
                                      value: _civility,
                                      items: const ['Mrs', 'Mr'],
                                      onChanged: (v) =>
                                          setState(() => _civility = v),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 4,
                                    child: _Field(
                                      controller: _firstName,
                                      hint: 'auth.first_name'.tr(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _Field(
                                controller: _lastName,
                                hint: 'auth.last_name'.tr(),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _Field(
                                      controller: _email,
                                      hint: 'auth.email'.tr(),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _DropdownField(
                                      value: _accountType,
                                      items: const ['Particulier', 'Agence'],
                                      onChanged: (v) =>
                                          setState(() => _accountType = v),
                                      hint: 'auth.account_type'.tr(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _Field(
                                controller: _password,
                                hint: 'auth.password_hint'.tr(),
                                obscureText: _obscure1,
                                fontSize: 22,
                                suffix: IconButton(
                                  onPressed: () =>
                                      setState(() => _obscure1 = !_obscure1),
                                  icon: Icon(
                                    _obscure1
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: const Color(0xFF6D6D6D),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _Field(
                                controller: _confirmPassword,
                                hint: 'auth.confirm_password'.tr(),
                                obscureText: _obscure2,
                                fontSize: 22,
                                suffix: IconButton(
                                  onPressed: () =>
                                      setState(() => _obscure2 = !_obscure2),
                                  icon: Icon(
                                    _obscure2
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: const Color(0xFF6D6D6D),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              OrangeButton(
                                text: 'auth.signup_button'.tr(),
                                onPressed: () => Navigator.of(context)
                                    .popUntil((r) => r.isFirst),
                              ),
                              const SizedBox(height: 18),
                              _DividerLabel(text: 'auth.or_signup_with'.tr()),
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _SocialButton(
                                    assetPath: 'assets/icons/logo_google.png',
                                    onTap: () {},
                                  ),
                                  _SocialButton(
                                    assetPath: 'assets/icons/logo_apple.png',
                                    onTap: () {},
                                  ),
                                  _SocialButton(
                                    assetPath:
                                        'assets/icons/logos_whatsapp.png',
                                    onTap: () {},
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).padding.bottom + 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.fontSize = 15,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w300,
        height: 1.0,
        letterSpacing: 0,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w300,
          height: 1.0,
          letterSpacing: 0,
          color: Color(0xFF9E9E9E),
        ),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(40),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(40),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(40),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        suffixIcon: suffix,
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: const Color(0xFFE7E7E7)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          borderRadius: BorderRadius.circular(12),
          style: AppTextStyles.regular12
              .copyWith(fontSize: 13, color: Colors.black),
          hint: hint == null
              ? null
              : Text(
                  hint!,
                  style: AppTextStyles.regular12.copyWith(fontSize: 13),
                ),
          items: items
              .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(
                      e,
                      style: AppTextStyles.regular12.copyWith(fontSize: 13),
                    ),
                  ))
              .toList(growable: false),
          onChanged: (v) {
            if (v == null) return;
            onChanged(v);
          },
        ),
      ),
    );
  }
}

class _DividerLabel extends StatelessWidget {
  const _DividerLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: const TextStyle(color: Color(0xFF6D6D6D)),
          ),
        ),
        const Expanded(child: Divider(height: 1)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.assetPath, required this.onTap});

  final String assetPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 86,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE7E7E7)),
        ),
        alignment: Alignment.center,
        child: Image.asset(
          assetPath,
          width: 22,
          height: 22,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
