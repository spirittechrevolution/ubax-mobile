import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _nameController = TextEditingController(text: 'Arnaud Koffi');
  final _emailController = TextEditingController(text: 'Arnaud@gmail.com');
  final _phoneController = TextEditingController(text: '07 12 34 56 78');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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
              padding: EdgeInsets.fromLTRB(14, topPadding + 10, 14, 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.text, size: 20),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Profil',
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

            // ── Avatar + Modifier
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/images/pexels-ekrulila-2128329.jpg',
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 90,
                            height: 90,
                            color: AppColors.text,
                            child: const Icon(Icons.person,
                                color: Colors.white, size: 40),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Modifier',
                    style: AppTextStyles.regular12.copyWith(
                      fontFamily: 'Lexend',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ── Form card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 430,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _Label(text: 'Nom'),
                    const SizedBox(height: 8),
                    _PillField(controller: _nameController),
                    const SizedBox(height: 20),
                    _Label(text: 'Email'),
                    const SizedBox(height: 6),
                    _PillField(controller: _emailController),
                    const SizedBox(height: 20),
                    _Label(text: 'Numéro de téléphone'),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          width: 110,
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECF2F7),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipOval(
                                child: CountryFlag.fromCountryCode(
                                  'CI',
                                  width: 26,
                                  height: 26,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '+225',
                                style: AppTextStyles.regularlight16.copyWith(
                                  fontFamily: 'Lexend',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.text,
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.text, size: 18),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _PillField(controller: _phoneController),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _Label(text: 'Documents d\'identité'),
                    const SizedBox(height: 6),
                    Container(
                      height: 52,
                      padding: const EdgeInsets.only(left: 18, right: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECF2F7),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Téléverser vos documents',
                              style: AppTextStyles.regularlight16.copyWith(
                                fontFamily: 'Lexend',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.upload_rounded,
                                color: AppColors.text, size: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),

            // ── Update button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Mettre à jour',
                    style: AppTextStyles.button.copyWith(
                      fontFamily: 'Lexend',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
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

class _Label extends StatelessWidget {
  const _Label({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.regular12.copyWith(
        fontFamily: 'Lexend',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.text,
      ),
    );
  }
}

class _PillField extends StatelessWidget {
  const _PillField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFECF2F7),
        borderRadius: BorderRadius.circular(25),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        style: AppTextStyles.regularlight16.copyWith(
          fontFamily: 'Lexend',
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.text,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
