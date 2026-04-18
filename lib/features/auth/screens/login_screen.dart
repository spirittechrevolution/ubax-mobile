import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:statefulclickcounter/core/widgets/orange_button.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

import 'signup_phone_screen.dart';
import '../widgets/africa_country_code_picker.dart';
import 'forgot_password_phone_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onLoggedIn});

  final VoidCallback onLoggedIn;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController(text: '07 12 34 56 78');
  final _passwordController = TextEditingController(text: 'password1');
  bool _obscure = true;
  AfricaCountry _country = AfricaCountryCodePicker.byIso2('CI');

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/onb1.png',
              fit: BoxFit.cover,
            ),
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
                const SizedBox(height: 60),
                Center(
                  child: Image.asset(
                    'assets/icons/logoUbaxWhite.png',
                    width: 86,
                    height: 86,
                  ),
                ),
                const SizedBox(height: 70),
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
                            child: Text('auth.login_title'.tr(),
                                style: AppTextStyles.sectionTitle),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              AfricaCountryCodePicker(
                                value: _country,
                                onChanged: (c) => setState(() => _country = c),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _Field(
                                  controller: _phoneController,
                                  hint: 'auth.phone_hint'.tr(),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _Field(
                            controller: _passwordController,
                            hint: 'auth.password_hint'.tr(),
                            obscureText: _obscure,
                            fontSize: 22,
                            suffix: IconButton(
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF6D6D6D),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ForgotPasswordPhoneScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'auth.forgot_password'.tr(),
                                style: const TextStyle(
                                    color: AppColors.dark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          OrangeButton(
                            text: 'auth.login_button'.tr(),
                            onPressed: widget.onLoggedIn,
                          ),
                          const SizedBox(height: 60),
                          _DividerLabel(text: 'auth.or_login_with'.tr()),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                assetPath: 'assets/icons/logos_whatsapp.png',
                                onTap: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 60),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style:
                                    const TextStyle(color: Color(0xFF6D6D6D)),
                                children: [
                                  TextSpan(text: 'auth.no_account'.tr()),
                                  const TextSpan(text: ' '),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.baseline,
                                    baseline: TextBaseline.alphabetic,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const SignupPhoneScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'auth.signup_link'.tr(),
                                        style: const TextStyle(
                                          color: AppColors.textBlack,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).padding.bottom + 6),
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
