import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:statefulclickcounter/features/customer/profile/data/mock_tenant_profile.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/documents_screen.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/formalities_screen.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/payment_invoice_screen.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/reservations_screen.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/sav_screen.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/services_ubax_screen.dart';
import 'package:statefulclickcounter/features/customer/profile/widgets/dashboard_card.dart';
import 'package:statefulclickcounter/features/customer/profile/widgets/empty_dashboard.dart';
import 'package:statefulclickcounter/features/customer/profile/widgets/profile_header.dart';
import 'package:statefulclickcounter/features/customer/profile/widgets/services_grid.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _hasContract = true;

  List<ServiceItem> _services() {
    final always = [
      ServiceItem(
        icon: Icons.settings_suggest_rounded,
        labelKey: 'profile.services.ubaxServices',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ServicesUbaxScreen()),
        ),
      ),
      ServiceItem(
        icon: Icons.apartment_rounded,
        labelKey: 'profile.services.reservations',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ReservationsScreen()),
        ),
      ),
    ];
    if (!_hasContract) return always;
    return [
      ServiceItem(
        icon: Icons.folder_copy_outlined,
        labelKey: 'profile.services.formalities',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const FormalitiesScreen()),
        ),
      ),
      ServiceItem(
        icon: Icons.insert_drive_file_outlined,
        labelKey: 'profile.services.documents',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DocumentsScreen()),
        ),
      ),
      ServiceItem(
        icon: Icons.handyman_rounded,
        labelKey: 'profile.services.sav',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SavScreen()),
        ),
      ),
      ...always,
    ];
  }

  @override
  Widget build(BuildContext context) {
    const profile = kMockTenantProfile;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(
            profile: profile,
            hasContract: _hasContract,
            onSettingsTap: () => print('settings'),
            onAgencyTap: () => print('toggle agency'),
            onMyLocalTap: () => setState(() => _hasContract = !_hasContract),
          ),

          const SizedBox(height: 38),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              'profile.dashboard.title'.tr(),
              style: AppTextStyles.sectionTitle,
            ),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: _hasContract
                ? DashboardCard(
                    profile: profile,
                    onPayRent: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const PaymentInvoiceScreen()),
                      );
                    },
                    onViewHistory: () => print('view history'),
                  )
                : EmptyDashboard(
                    onFindHome: () => print('find home'),
                  ),
          ),

          const SizedBox(height: 18),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ServicesGrid(services: _services()),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
