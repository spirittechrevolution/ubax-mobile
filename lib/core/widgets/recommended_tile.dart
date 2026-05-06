import 'package:flutter/material.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class RecommendedTile extends StatelessWidget {
  const RecommendedTile({
    super.key,
    required this.imagePath,
    required this.title,
    required this.location,
    required this.beds,
    required this.baths,
    required this.salons,
    required this.onTap,
    this.isFavorite = true,
  });

  final String imagePath;
  final String title;
  final String location;
  final int beds;
  final int baths;
  final int salons;
  final VoidCallback onTap;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 119,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imagePath,
                width: 125,
                height: 102,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 125,
                  height: 102,
                  color: const Color(0xFFE2E8F0),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.text,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.favorite,
                        color: isFavorite
                            ? const Color(0xFFEF4444)
                            : AppColors.muted,
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 12, color: AppColors.primary),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          location,
                          style: AppTextStyles.regular12.copyWith(
                            color: AppColors.text,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  Wrap(
                    spacing: 8,
                    runSpacing: 3,
                    children: [
                      _Meta(icon: Icons.bed_rounded, text: '$beds  Chambres'),
                      _Meta(
                          icon: Icons.bathtub_outlined,
                          text: '$baths  Salle de bains'),
                      _Meta(
                          icon: Icons.weekend_rounded, text: '$salons  Salon'),
                    ],
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

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: AppColors.primary),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Lexend',
            color: AppColors.text,
            fontSize: 8,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
