import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:statefulclickcounter/features/customer/profile/data/mock_bailleur_profile.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/client_details_screen.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/property_details_screen.dart';
import 'package:statefulclickcounter/features/customer/profile/widgets/bailleur_header.dart';
import 'package:statefulclickcounter/features/customer/profile/widgets/flux_biens_card.dart';
import 'package:statefulclickcounter/features/customer/profile/widgets/portfolio_card.dart';
import 'package:statefulclickcounter/features/customer/profile/widgets/tenant_row.dart';
import 'package:statefulclickcounter/features/customer/settings/screens/settings_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class BailleurProfileTab extends StatelessWidget {
  const BailleurProfileTab({super.key, required this.onViewChanged});

  final ValueChanged<bool> onViewChanged;

  @override
  Widget build(BuildContext context) {
    const profile = kMockBailleurProfile;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BailleurHeader(
            profile: profile,
            onSettingsTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
            onViewChanged: onViewChanged,
          ),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: FluxBiensSection(profile: profile),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              'profile.bailleur.portfolio'.tr(),
              style: AppTextStyles.sectionTitle.copyWith(
                fontFamily: 'Lexend',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
                height: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 153,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: kMockBailleurProperties.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final p = kMockBailleurProperties[i];
                return PortfolioCard(
                  property: p,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => PropertyDetailsScreen(property: p),
                    ));
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'profile.bailleur.tenantsManagement'.tr(),
                    style: AppTextStyles.sectionTitle.copyWith(
                      fontFamily: 'Lexend',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                      height: 1.0,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'profile.bailleur.seeAll'.tr(),
                    style: AppTextStyles.regular12.copyWith(
                      fontFamily: 'Lexend',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                      height: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: kMockBailleurTenants
                  .map((t) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TenantRow(
                          tenant: t,
                          propertyName: _propertyNameFor(t.propertyId),
                          onDetailsTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ClientDetailsScreen(tenant: t),
                            ));
                          },
                        ),
                      ))
                  .toList(growable: false),
            ),
          ),
        ],
      ),
    );
  }

  String _propertyNameFor(String propertyId) {
    final match = kMockBailleurProperties
        .where((p) => p.id == propertyId)
        .toList(growable: false);
    return match.isEmpty ? '' : match.first.name;
  }
}
