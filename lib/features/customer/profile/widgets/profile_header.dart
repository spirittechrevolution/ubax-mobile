import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:statefulclickcounter/features/customer/profile/data/mock_tenant_profile.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.profile,
    required this.hasContract,
    required this.onSettingsTap,
    required this.onAgencyTap,
    required this.onMyLocalTap,
  });

  final TenantProfile profile;
  final bool hasContract;
  final VoidCallback onSettingsTap;
  final VoidCallback onAgencyTap;
  final VoidCallback onMyLocalTap;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background image
        Container(
          height: 230 + topPadding,
          width: double.infinity,
          decoration: hasContract
              ? const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/villa.jpg'),
                    fit: BoxFit.cover,
                  ),
                )
              : const BoxDecoration(color: Color(0xFFA65B2E)),
          child: Container(
            color: hasContract
                ? const Color(0xAA1A3047)
                : const Color(0x33000000),
          ),
        ),

        // Settings icon
        Positioned(
          top: topPadding + 14,
          right: 18,
          child: GestureDetector(
            onTap: onSettingsTap,
            child: hasContract
                ? const Icon(Icons.settings_rounded,
                    color: Colors.white, size: 26)
                : Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.settings_rounded,
                        color: Colors.white, size: 20),
                  ),
          ),
        ),

        // Agency selector — only when contract
        if (hasContract)
          Positioned(
            top: topPadding + 12,
            left: 18,
            child: GestureDetector(
              onTap: onAgencyTap,
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
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Colors.white, size: 20),
                ],
              ),
            ),
          ),

        // Avatar + Name + Role
        Positioned(
          top: topPadding + 50,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: const Color(0xFF4DA8DA), width: 3),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              if (hasContract) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.circle,
                        color: AppColors.statusPaid, size: 8),
                    const SizedBox(width: 5),
                    Text(
                      'profile.role.tenant'.tr(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ' : ${profile.agency}',
                      style: const TextStyle(
                        color: Color(0xFFB0C4DE),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
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
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(30)),
            ),
          ),
        ),

        // "Mon local" pill
        Positioned(
          bottom: -34,
          left: 18,
          right: 18,
          child: GestureDetector(
            onTap: onMyLocalTap,
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
                  const Icon(Icons.home_outlined,
                      color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    hasContract
                        ? 'profile.myLocal'.tr()
                        : 'Ma maison',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
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
