import 'package:flutter/material.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _rememberMe = true;
  bool _faceId = true;
  bool _biometricId = false;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top bar
            Padding(
              padding: EdgeInsets.fromLTRB(14, topPadding + 10, 14, 24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.dark, size: 20),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Sécurité',
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontFamily: 'Lexend',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _SecurityRow(
                    label: 'Se souvenir de moi',
                    value: _rememberMe,
                    onChanged: (v) => setState(() => _rememberMe = v),
                  ),
                  _SecurityRow(
                    label: 'Face ID',
                    value: _faceId,
                    onChanged: (v) => setState(() => _faceId = v),
                  ),
                  _SecurityRow(
                    label: 'Biometric ID',
                    value: _biometricId,
                    onChanged: (v) => setState(() => _biometricId = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Changer mon mot de passe
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    'Changer mon mot de passe',
                    style: AppTextStyles.regularlight16.copyWith(
                      fontFamily: 'Lexend',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityRow extends StatelessWidget {
  const _SecurityRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.regularlight16.copyWith(
                fontFamily: 'Lexend',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.text,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
