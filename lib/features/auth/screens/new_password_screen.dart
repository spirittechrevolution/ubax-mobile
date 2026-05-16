import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:statefulclickcounter/core/widgets/orange_button.dart';
import 'package:statefulclickcounter/features/auth/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({
    super.key,
    required this.phoneE164,
    required this.code,
  });

  final String phoneE164;
  final String code;

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

  void _onValidate() {
    final pwd = _password.text;
    final confirm = _confirmPassword.text;
    if (pwd.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('auth.fill_all_fields'.tr())),
      );
      return;
    }
    if (pwd != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('auth.passwords_dont_match'.tr())),
      );
      return;
    }
    context.read<ForgotPasswordBloc>().add(
          ForgotResetPassword(
            phone: widget.phoneE164,
            code: widget.code,
            newPassword: pwd,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.resetDone) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('auth.password_reset_success'.tr())),
          );
          Navigator.of(context).popUntil((r) => r.isFirst);
        } else if (state.status == ForgotPasswordStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'auth.reset_failed'.tr()),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      },
      child: Scaffold(
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
              BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                builder: (context, state) {
                  final loading =
                      state.status == ForgotPasswordStatus.resetting;
                  return OrangeButton(
                    text: loading
                        ? 'auth.resetting'.tr()
                        : 'auth.validate'.tr(),
                    onPressed: loading ? null : _onValidate,
                  );
                },
              ),
            ],
          ),
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
