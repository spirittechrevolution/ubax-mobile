import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';

class ServiceItem {
  const ServiceItem({
    required this.icon,
    required this.labelKey,
    required this.onTap,
  });

  final IconData icon;
  final String labelKey;
  final VoidCallback onTap;
}

class ServicesGrid extends StatelessWidget {
  const ServicesGrid({super.key, required this.services});

  final List<ServiceItem> services;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: services.map((s) => _ServiceCard(service: s)).toList(),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service});

  final ServiceItem service;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: service.onTap,
      child: Container(
        width: 100,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(service.icon, color: AppColors.dark, size: 24),
            const SizedBox(height: 6),
            Text(
              service.labelKey.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.dark,
                fontWeight: FontWeight.w600,
                fontSize: 11,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
