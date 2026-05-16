import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:statefulclickcounter/core/widgets/orange_button.dart';
import 'package:statefulclickcounter/features/auth/presentation/bloc/signup/signup_bloc.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

import 'signup_form_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.phoneDisplay,
    required this.phoneE164,
  });

  final String phoneDisplay;
  final String phoneE164;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
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

  String _readCode() => _controllers.map((c) => c.text).join();

  void _onVerify() {
    final code = _readCode();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('auth.otp_incomplete'.tr())),
      );
      return;
    }
    context.read<SignupBloc>().add(
          SignupVerifyOtp(phone: widget.phoneE164, code: code),
        );
  }

  void _onResend() {
    context
        .read<SignupBloc>()
        .add(SignupResendOtp(phone: widget.phoneE164));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == SignupStatus.otpVerified) {
          final bloc = context.read<SignupBloc>();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: bloc,
                child: SignupFormScreen(phoneE164: widget.phoneE164),
              ),
            ),
          );
        } else if (state.status == SignupStatus.otpSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('auth.otp_resent'.tr())),
          );
        } else if (state.status == SignupStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'auth.otp_invalid'.tr()),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      },
      child: Scaffold(
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
                  const SizedBox(height: 50),
                  Expanded(
                    child: Container(
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  'auth.otp_title'.tr(),
                                  style: AppTextStyles.sectionTitle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'auth.otp_subtitle'.tr(namedArgs: {
                                  'phone': widget.phoneDisplay,
                                }),
                                style: AppTextStyles.regular12,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 40),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(6, (i) {
                                  return SizedBox(
                                    width: 46,
                                    height: 56,
                                    child: TextField(
                                      controller: _controllers[i],
                                      focusNode: _nodes[i],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                      onChanged: (v) => _onChanged(i, v),
                                      decoration: InputDecoration(
                                        counterText: '',
                                        filled: true,
                                        fillColor: const Color(0xFFF3F3F3),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _onResend,
                                  child: Text('auth.resend_code'.tr()),
                                ),
                              ),
                              const SizedBox(height: 30),
                              BlocBuilder<SignupBloc, SignupState>(
                                builder: (context, state) {
                                  final loading = state.status ==
                                      SignupStatus.verifyingOtp;
                                  return OrangeButton(
                                    text: loading
                                        ? 'auth.verifying'.tr()
                                        : 'auth.verify'.tr(),
                                    onPressed: loading ? null : _onVerify,
                                  );
                                },
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
