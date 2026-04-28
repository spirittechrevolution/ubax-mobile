import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:statefulclickcounter/features/customer/profile/data/mock_bailleur_profile.dart';
import 'package:statefulclickcounter/features/customer/profile/widgets/profile_switcher_sheet.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class BailleurHeader extends StatelessWidget {
  const BailleurHeader({
    super.key,
    required this.profile,
    required this.onSettingsTap,
    required this.onGestionBailTap,
  });

  final BailleurProfile profile;
  final VoidCallback onSettingsTap;
  final VoidCallback onGestionBailTap;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 230 + topPadding,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.dark,
            image: DecorationImage(
              image: AssetImage('assets/images/hidepoint.png'),
              fit: BoxFit.cover,
              opacity: 0.25,
            ),
          ),
        ),

        // Switcher (top-left)
        Positioned(
          top: topPadding + 12,
          left: 18,
          child: GestureDetector(
            onTap: () => showProfileSwitcherSheet(context),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.asset(
                      'assets/icons/logoubaxblue.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.home_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Settings icon
        Positioned(
          top: topPadding + 14,
          right: 18,
          child: GestureDetector(
            onTap: onSettingsTap,
            child: const Icon(Icons.settings_rounded,
                color: Colors.white, size: 26),
          ),
        ),

        // Avatar + Name + Role
        Positioned(
          top: topPadding + 40,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF4DA8DA), width: 3),
                ),
                child: ClipOval(
                  child: Image.asset(
                    profile.avatarAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF2D4A65),
                      child: const Icon(Icons.person,
                          color: Colors.white, size: 40),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                profile.name,
                style: AppTextStyles.regularlight16.copyWith(
                  fontFamily: 'Lexend',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.circle,
                      color: AppColors.statusPaid, size: 8),
                  const SizedBox(width: 5),
                  Text(
                    'profile.role.bailleur'.tr(),
                    style: AppTextStyles.regular12.copyWith(
                      fontFamily: 'Lexend',
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // White curved overlay
        Positioned(
          bottom: -1,
          left: 0,
          right: 0,
          child: Container(
            height: 30,
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
          ),
        ),

        // "Gestion de Bail" pill
        Positioned(
          bottom: -34,
          left: 18,
          right: 18,
          child: GestureDetector(
            onTap: onGestionBailTap,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.dark,
                borderRadius: BorderRadius.circular(26),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.assignment_outlined,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'profile.bailleur.gestionBail'.tr(),
                    style: AppTextStyles.regularlight16.copyWith(
                      fontFamily: 'Lexend',
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
