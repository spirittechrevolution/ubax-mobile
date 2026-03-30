import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:statefulclickcounter/core/widgets/orange_button.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';

import 'otp_screen.dart';
import '../widgets/africa_country_code_picker.dart';

class SignupPhoneScreen extends StatefulWidget {
  const SignupPhoneScreen({super.key});

  @override
  State<SignupPhoneScreen> createState() => _SignupPhoneScreenState();
}

class _SignupPhoneScreenState extends State<SignupPhoneScreen> {
  static const _textDark = AppColors.dark;

  final _phoneController = TextEditingController(text: '07 12 34 56 78');
  AfricaCountry _country = AfricaCountryCodePicker.byIso2('CI');

  @override
  void dispose() {
    _phoneController.dispose();
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
                const Spacer(),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Container(
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
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'auth.signup_phone_title'.tr(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: _textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'auth.signup_phone_subtitle'.tr(),
                            style: const TextStyle(
                              color: Color(0xFF6D6D6D),
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 16),
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
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          OrangeButton(
                            text: 'common.continue'.tr(),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => OtpScreen(
                                    phoneDisplay:
                                        '${_country.dialCode} ${_phoneController.text}',
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                          _DividerLabel(text: 'auth.or_signup_with'.tr()),
                          const SizedBox(height: 14),
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
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom + 6,
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
  const _Field({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(18),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
