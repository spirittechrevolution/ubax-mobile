import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:statefulclickcounter/core/profile/profile_mode.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

Future<void> showProfileSwitcherSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _ProfileSwitcherSheet(),
  );
}

class _ProfileSwitcherSheet extends StatelessWidget {
  const _ProfileSwitcherSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9DEE5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'profile.switcher.title'.tr(),
              style: AppTextStyles.sectionTitle.copyWith(
                fontFamily: 'Lexend',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<ProfileMode>(
              valueListenable: profileModeNotifier,
              builder: (_, current, __) => Column(
                children: [
                  _SwitcherOption(
                    icon: Icons.person_rounded,
                    labelKey: 'profile.switcher.locataire',
                    selected: current == ProfileMode.locataire,
                    onTap: () {
                      profileModeNotifier.value = ProfileMode.locataire;
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 10),
                  _SwitcherOption(
                    icon: Icons.apartment_rounded,
                    labelKey: 'profile.switcher.bailleur',
                    selected: current == ProfileMode.bailleur,
                    onTap: () {
                      profileModeNotifier.value = ProfileMode.bailleur;
                      Navigator.of(context).pop();
                    },
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

class _SwitcherOption extends StatelessWidget {
  const _SwitcherOption({
    required this.icon,
    required this.labelKey,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String labelKey;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.dark : AppColors.background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : AppColors.dark,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                labelKey.tr(),
                style: AppTextStyles.regularlight16.copyWith(
                  fontFamily: 'Lexend',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: selected ? Colors.white : AppColors.dark,
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check_rounded, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}
