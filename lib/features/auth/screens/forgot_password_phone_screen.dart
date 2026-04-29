import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:statefulclickcounter/core/widgets/orange_button.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

import '../widgets/africa_country_code_picker.dart';
import 'forgot_password_otp_screen.dart';

class ForgotPasswordPhoneScreen extends StatefulWidget {
  const ForgotPasswordPhoneScreen({super.key});

  @override
  State<ForgotPasswordPhoneScreen> createState() =>
      _ForgotPasswordPhoneScreenState();
}

class _ForgotPasswordPhoneScreenState extends State<ForgotPasswordPhoneScreen> {
  AfricaCountry _country = AfricaCountryCodePicker.byIso2('CI');
  final _phoneController = TextEditingController(text: '07 12 34 56 78');

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.dark, width: 1.5),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.dark, size: 18),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    Image.asset(
                      "assets/images/lock.png",
                      width: 113,
                      height: 113,
                    ),
                    const SizedBox(height: 38),
                    Image.asset(
                      "assets/images/lockinterro.png",
                      width: 247,
                      height: 57,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'auth.reset_password_title'.tr(),
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: 8),
              Text(
                'auth.reset_password_subtitle'.tr(),
                style: AppTextStyles.regular12,
              ),
              const SizedBox(height: 22),
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
              // const Spacer(),
              const SizedBox(
                height: 25,
              ),
              OrangeButton(
                text: 'auth.send'.tr(),
                onPressed: () {
                  final phone = '${_country.dialCode} ${_phoneController.text}';
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ForgotPasswordOtpScreen(
                        phoneDisplay: phone,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(18),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
