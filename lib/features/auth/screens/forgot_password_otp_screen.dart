import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:statefulclickcounter/core/widgets/orange_button.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

import 'new_password_screen.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  const ForgotPasswordOtpScreen({super.key, required this.phoneDisplay});

  final String phoneDisplay;

  @override
  State<ForgotPasswordOtpScreen> createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _onChanged(int i, String v) {
    if (v.length > 1) {
      _controllers[i].text = v.substring(v.length - 1);
    }
    if (v.isNotEmpty && i < _nodes.length - 1) {
      _nodes[i + 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16324A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16324A),
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
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 18),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 74),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'auth.verification'.tr(),
                style: AppTextStyles.sectionTitle.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'auth.verification_subtitle'.tr(),
                style: AppTextStyles.regular12
                    .copyWith(color: const Color(0xFFE2E8F0)),
              ),
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  return _OtpDotField(
                    controller: _controllers[i],
                    node: _nodes[i],
                    onChanged: (v) => _onChanged(i, v),
                  );
                }),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OrangeButton(
                text: 'auth.verify_code'.tr(),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const NewPasswordScreen()),
                  );
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
          ],
        ),
      ),
    );
  }
}

class _OtpDotField extends StatelessWidget {
  const _OtpDotField({
    required this.controller,
    required this.node,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode node;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        color: Color(0xFF1B3A55),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        focusNode: node,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        onChanged: onChanged,
        style: AppTextStyles.sectionTitle.copyWith(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
