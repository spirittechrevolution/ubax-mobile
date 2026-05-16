import 'package:flutter/material.dart';
import 'package:statefulclickcounter/features/customer/profile/data/mock_bailleur_profile.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class PortfolioCard extends StatelessWidget {
  const PortfolioCard({
    super.key,
    required this.property,
    required this.onTap,
  });

  final BailleurProperty property;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final badgeColor = propertyStatusColor(property.status);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 163,
        height: 153,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 3),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Image.asset(
                      property.imageAsset,
                      width: 154,
                      height: 115,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 154,
                        height: 115,
                        color: AppColors.dark,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          propertyStatusLabel(property.status),
                          style: AppTextStyles.regular12.copyWith(
                            fontFamily: 'Lexend',
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    property.name,
                    style: AppTextStyles.regularlight16.copyWith(
                      fontFamily: 'Lexend',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.text,
                      height: 1.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.dark, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
