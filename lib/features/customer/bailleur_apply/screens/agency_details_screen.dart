import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:statefulclickcounter/features/customer/bailleur_apply/data/models/agency_models.dart';
import 'package:statefulclickcounter/features/customer/bailleur_apply/screens/bailleur_application_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class AgencyDetailsScreen extends StatelessWidget {
  const AgencyDetailsScreen({super.key, required this.agency});

  final AgencyItem agency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'bailleur_apply.step1.details_title'.tr(),
          style: AppTextStyles.regularlight16.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Hero
          _HeroSection(agency: agency),

          // ── Contenu scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats
                  if (agency.memberSince != null || agency.propertiesCount != null)
                    _StatsRow(agency: agency),

                  // Description
                  if (agency.description != null &&
                      agency.description!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      'bailleur_apply.step1.description'.tr(),
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x08000000),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        agency.description!,
                        style: AppTextStyles.regular12.copyWith(
                          fontSize: 13,
                          color: AppColors.text,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bouton flottant en bas
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BailleurApplicationScreen(agency: agency),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'bailleur_apply.step1.join_as_bailleur'.tr(),
                style: AppTextStyles.regular12.copyWith(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Hero ─────────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.agency});

  final AgencyItem agency;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // ── Image de fond
          SizedBox(
            height: 260 + topPadding,
            width: double.infinity,
            child: Image.asset(
              'assets/images/appartements-luxe.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // ── Overlay sombre
          Container(
            height: 260 + topPadding,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x99000000),
                  Color(0xCC1A3047),
                ],
              ),
            ),
          ),

          // ── Contenu hero
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Column(
              children: [
                // Logo circulaire avec bordure orange
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2.5),
                    color: Colors.white,
                  ),
                  child: ClipOval(
                    child: agency.logoUrl != null
                        ? Image.network(
                            agency.logoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _LogoInitial(name: agency.name),
                          )
                        : _LogoInitial(name: agency.name),
                  ),
                ),
                const SizedBox(height: 12),

                // Nom
                Text(
                  agency.name,
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Ville
                if (agency.city != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    agency.city!,
                    style: AppTextStyles.regular12.copyWith(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],

                // Téléphone + email
                if (agency.phone != null || agency.email != null) ...[
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (agency.phone != null) ...[
                        _ContactChip(
                          icon: Icons.phone_outlined,
                          label: agency.phone!,
                        ),
                        if (agency.email != null)
                          const SizedBox(width: 20),
                      ],
                      if (agency.email != null)
                        _ContactChip(
                          icon: Icons.email_outlined,
                          label: agency.email!,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoInitial extends StatelessWidget {
  const _LogoInitial({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.dark,
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'A',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          fontFamily: 'Lexend',
        ),
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  const _ContactChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 16, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.regular12.copyWith(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// ─── Stats ────────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.agency});

  final AgencyItem agency;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (agency.memberSince != null)
          Expanded(
            child: _StatCard(
              icon: Icons.calendar_today_outlined,
              label: 'bailleur_apply.step1.member_since'.tr(),
              value: '${agency.memberSince}',
            ),
          ),
        if (agency.memberSince != null && agency.propertiesCount != null)
          const SizedBox(width: 12),
        if (agency.propertiesCount != null)
          Expanded(
            child: _StatCard(
              icon: Icons.apartment_outlined,
              label: 'bailleur_apply.step1.properties_managed'.tr(),
              value: '${agency.propertiesCount}',
            ),
          ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 22, color: AppColors.dark),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.regular12.copyWith(
                  fontSize: 11,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.sectionTitle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
