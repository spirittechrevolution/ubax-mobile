import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:statefulclickcounter/features/customer/profile/data/mock_tenant_profile.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/documents_screen.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/formalities_screen.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/payment_invoice_screen.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/sav_screen.dart';
import 'package:statefulclickcounter/features/customer/profile/widgets/dashboard_card.dart';
import 'package:statefulclickcounter/features/customer/profile/widgets/profile_header.dart';
import 'package:statefulclickcounter/features/customer/profile/widgets/services_grid.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    const profile = kMockTenantProfile;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero header
          ProfileHeader(
            profile: profile,
            onSettingsTap: () => print('settings'),
            onAgencyTap: () => print('toggle agency'),
            onMyLocalTap: () => print('mon local'),
          ),

          const SizedBox(height: 38),

          // ── Dashboard title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              'profile.dashboard.title'.tr(),
              style: const TextStyle(
                color: AppColors.dark,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Dashboard card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: DashboardCard(
              profile: profile,
              onPayRent: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const PaymentInvoiceScreen()),
                );
              },
              onViewHistory: () => print('view history'),
            ),
          ),

          const SizedBox(height: 18),

          // ── Services grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: ServicesGrid(
              services: [
                ServiceItem(
                  icon: Icons.home_work_outlined,
                  labelKey: 'profile.services.formalities',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const FormalitiesScreen()),
                  ),
                ),
                ServiceItem(
                  icon: Icons.insert_drive_file_outlined,
                  labelKey: 'profile.services.documents',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const DocumentsScreen()),
                  ),
                ),
                ServiceItem(
                  icon: Icons.handyman_rounded,
                  labelKey: 'profile.services.sav',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SavScreen()),
                  ),
                ),
                ServiceItem(
                  icon: Icons.settings_suggest_rounded,
                  labelKey: 'profile.services.ubaxServices',
                  onTap: () => print('services ubax'),
                ),
                ServiceItem(
                  icon: Icons.calendar_month_rounded,
                  labelKey: 'profile.services.reservations',
                  onTap: () => print('mes reservations'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
