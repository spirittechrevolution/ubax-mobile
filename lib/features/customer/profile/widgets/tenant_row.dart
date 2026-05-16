import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:statefulclickcounter/features/customer/profile/data/mock_bailleur_profile.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class TenantRow extends StatelessWidget {
  const TenantRow({
    super.key,
    required this.tenant,
    required this.propertyName,
    required this.onDetailsTap,
  });

  final BailleurTenant tenant;
  final String propertyName;
  final VoidCallback onDetailsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              tenant.avatarAsset,
              width: 38,
              height: 38,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 38,
                height: 38,
                color: AppColors.dark,
                child: const Icon(Icons.person, color: Colors.white, size: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tenant.name,
                  style: AppTextStyles.regularlight16.copyWith(
                    fontFamily: 'Lexend',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.circle,
                        color: AppColors.statusPaid, size: 6),
                    const SizedBox(width: 4),
                    Flexible(
                      child: RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: AppTextStyles.regular12.copyWith(
                            fontFamily: 'Lexend',
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                            color: AppColors.text,
                            height: 1.0,
                          ),
                          children: [
                            TextSpan(text: '$propertyName - '),
                            TextSpan(
                              text: 'profile.bailleur.paid'.tr(),
                              style: AppTextStyles.regular12.copyWith(
                                fontFamily: 'Lexend',
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppColors.statusPaid,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onDetailsTap,
            child: Container(
              width: 74,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'profile.bailleur.details'.tr(),
                style: AppTextStyles.regular12.copyWith(
                  fontFamily: 'Lexend',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                  height: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
