import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:statefulclickcounter/core/widgets/orange_button.dart';

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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'auth.verification'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'auth.verification_subtitle'.tr(),
                style: const TextStyle(
                  color: Color(0xFFE2E8F0),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  return _OtpDotField(
                    controller: _controllers[i],
                    node: _nodes[i],
                    onChanged: (v) => _onChanged(i, v),
                  );
                }),
              ),
              const Spacer(),
              OrangeButton(
                text: 'auth.verify_code'.tr(),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const NewPasswordScreen()),
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
      width: 52,
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFF1B3A55),
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        focusNode: node,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        onChanged: onChanged,
        style: const TextStyle(
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
