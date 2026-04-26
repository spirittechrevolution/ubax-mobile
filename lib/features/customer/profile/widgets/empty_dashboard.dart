import 'package:flutter/material.dart';

import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class EmptyDashboard extends StatelessWidget {
  const EmptyDashboard({super.key, required this.onFindHome});

  final VoidCallback onFindHome;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.text,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            'Aucun logement actif',
            style: AppTextStyles.sectionTitle.copyWith(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Vous n\u2019avez pas encore loué de bien.\nDès qu\u2019un contrat sera actif, vos paiements et les\nstatistiques apparaîtront ici.',
            textAlign: TextAlign.center,
            style: AppTextStyles.regular12.copyWith(
              color: const Color(0xFF94A3B8),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: onFindHome,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                'Trouver un logement',
                style: AppTextStyles.regular12.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
