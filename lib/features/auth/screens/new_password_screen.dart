import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:statefulclickcounter/core/widgets/orange_button.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _password.dispose();
    _confirmPassword.dispose();
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
                  border: Border.all(color: AppColors.text, width: 1.5),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.text, size: 18),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
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
                      "assets/images/locktrue.png",
                      width: 247,
                      height: 57,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'auth.new_password_title'.tr(),
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: 8),
              Text(
                'auth.new_password_subtitle'.tr(),
                style: AppTextStyles.regular12,
              ),
              const SizedBox(height: 30),
              _Field(
                controller: _password,
                hint: 'auth.new_password_hint'.tr(),
                obscureText: _obscure1,
                suffix: IconButton(
                  onPressed: () => setState(() => _obscure1 = !_obscure1),
                  icon: Icon(
                    _obscure1
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF6D6D6D),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _Field(
                controller: _confirmPassword,
                hint: 'auth.confirm_password_hint'.tr(),
                obscureText: _obscure2,
                suffix: IconButton(
                  onPressed: () => setState(() => _obscure2 = !_obscure2),
                  icon: Icon(
                    _obscure2
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF6D6D6D),
                  ),
                ),
              ),
              const SizedBox(height: 33),
              OrangeButton(
                text: 'auth.validate'.tr(),
                onPressed: () {
                  Navigator.of(context).popUntil((r) => r.isFirst);
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
    this.obscureText = false,
    this.suffix,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
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
        suffixIcon: suffix,
      ),
    );
  }
}
