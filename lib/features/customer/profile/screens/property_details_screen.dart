import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:statefulclickcounter/features/customer/profile/data/mock_bailleur_profile.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/client_details_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class PropertyDetailsScreen extends StatefulWidget {
  const PropertyDetailsScreen({super.key, required this.property});

  final BailleurProperty property;

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  bool _rentTab = true;

  @override
  Widget build(BuildContext context) {
    final p = widget.property;
    final tenants = kMockBailleurTenants.where((t) {
      if (t.propertyId != p.id) return false;
      if (_rentTab) return t.contractType == BailleurContractType.location;
      return t.contractType == BailleurContractType.vente;
    }).toList(growable: false);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Hero(property: p),
            // const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: _StatsCard(property: p),
            ),
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'profile.bailleur.clientList'.tr(),
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontFamily: 'Lexend',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text,
                        height: 1.0,
                      ),
                    ),
                  ),
                  _SegmentToggle(
                    rentSelected: _rentTab,
                    onChanged: (v) => setState(() => _rentTab = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (tenants.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: SizedBox(
                  height: 140,
                  child: Center(
                    child: Text(
                      'Aucun client',
                      style: AppTextStyles.regular12.copyWith(
                        fontFamily: 'Lexend',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.muted,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: 269,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: tenants.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, i) => _TenantCard(tenant: tenants[i]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.property});
  final BailleurProperty property;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 250 + topPadding,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(property.imageAsset),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.15),
                BlendMode.darken,
              ),
            ),
          ),
        ),
        Positioned(
          top: topPadding + 14,
          left: 14,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 16),
            ),
          ),
        ),
        Positioned(
          top: topPadding + 18,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'profile.bailleur.propertyDetailsTitle'.tr(),
              style: AppTextStyles.regularlight16.copyWith(
                fontFamily: 'Lexend',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -1,
          left: 0,
          right: 0,
          child: Container(
            height: 30,
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.property});
  final BailleurProperty property;

  @override
  Widget build(BuildContext context) {
    int pct(int n) => property.totalApartments == 0
        ? 0
        : ((n / property.totalApartments) * 100).round();

    return Container(
      height: 227,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            property.name,
            style: AppTextStyles.regularlight16.copyWith(
              fontFamily: 'Lexend',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  color: AppColors.primary, size: 13),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  property.location,
                  style: AppTextStyles.regular12.copyWith(
                    fontFamily: 'Lexend',
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                    color: AppColors.text,
                    height: 1.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  labelKey: 'profile.bailleur.totalApartments',
                  value: property.totalApartments,
                  percent: 100,
                  background: const Color(0xFFF2F5F9),
                  textColor: AppColors.dark,
                  barColor: AppColors.dark,
                  valueColor: AppColors.dark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatTile(
                  labelKey: 'profile.bailleur.availableApartments',
                  value: property.availableApartments,
                  percent: pct(property.availableApartments),
                  background: const Color(0xFFDCE8FF),
                  textColor: const Color(0xFF2563EB),
                  barColor: const Color(0xFF2563EB),
                  valueColor: const Color(0xFF2563EB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  labelKey: 'profile.bailleur.rentedApartments',
                  value: property.rentedApartments,
                  percent: pct(property.rentedApartments),
                  background: const Color(0xFFFDE3CC),
                  textColor: AppColors.primary,
                  barColor: AppColors.primary,
                  valueColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatTile(
                  labelKey: 'profile.bailleur.soldApartments',
                  value: property.soldApartments,
                  percent: pct(property.soldApartments),
                  background: const Color(0xFFD5F3DF),
                  textColor: AppColors.statusPaid,
                  barColor: AppColors.statusPaid,
                  valueColor: AppColors.statusPaid,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.labelKey,
    required this.value,
    required this.percent,
    required this.background,
    required this.textColor,
    required this.barColor,
    required this.valueColor,
  });

  final String labelKey;
  final int value;
  final int percent;
  final Color background;
  final Color textColor;
  final Color barColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  labelKey.tr(),
                  style: AppTextStyles.regular12.copyWith(
                    fontFamily: 'Lexend',
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                    color: textColor,
                    height: 1.1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '$value',
                style: AppTextStyles.regularlight16.copyWith(
                  fontFamily: 'Lexend',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: valueColor,
                  height: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$percent %',
            style: AppTextStyles.regular12.copyWith(
              fontFamily: 'Lexend',
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: textColor,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 2),
          LayoutBuilder(
            builder: (_, c) {
              final w = c.maxWidth;
              return Stack(
                children: [
                  Container(
                    width: w,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    width: w * (percent / 100).clamp(0.0, 1.0),
                    height: 5,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SegmentToggle extends StatelessWidget {
  const _SegmentToggle({required this.rentSelected, required this.onChanged});

  final bool rentSelected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SegmentBtn(
          text: 'profile.bailleur.rent'.tr(),
          selected: rentSelected,
          bg: AppColors.primary,
          onTap: () => onChanged(true),
        ),
        SizedBox(
          width: 9,
        ),
        _SegmentBtn(
          text: 'profile.bailleur.sale'.tr(),
          selected: !rentSelected,
          bg: AppColors.primary,
          onTap: () => onChanged(false),
        ),
      ],
    );
  }
}

class _SegmentBtn extends StatelessWidget {
  const _SegmentBtn({
    required this.text,
    required this.selected,
    required this.bg,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final Color bg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 94,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? bg : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: selected
              ? null
              : Border.all(color: const Color(0xFFE3E8EE), width: 1),
        ),
        child: Text(
          text,
          style: AppTextStyles.regular12.copyWith(
            fontFamily: 'Lexend',
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: selected ? Colors.white : AppColors.dark,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}

class _TenantCard extends StatelessWidget {
  const _TenantCard({required this.tenant});
  final BailleurTenant tenant;

  @override
  Widget build(BuildContext context) {
    final badgeLabel = tenant.contractType == BailleurContractType.vente
        ? 'profile.bailleur.sold'.tr()
        : 'profile.bailleur.rented'.tr();

    return Container(
      width: 192.52,
      height: 269,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: Image.asset(
                  tenant.apartmentImage,
                  width: 192.52,
                  height: 130.93,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 192.52,
                    height: 130.93,
                    color: AppColors.dark,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  width: 65,
                  height: 22,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Center(
                    child: Text(
                      badgeLabel,
                      style: AppTextStyles.regular12.copyWith(
                        fontFamily: 'Lexend',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 3,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'profile.bailleur.apartment'
                            .tr(namedArgs: {'num': tenant.apartmentNumber}),
                        style: AppTextStyles.regularlight16.copyWith(
                          fontFamily: 'Lexend',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.text,
                          height: 1.0,
                        ),
                      ),
                    ),
                    Text(
                      tenant.floor,
                      style: AppTextStyles.regular12.copyWith(
                        fontFamily: 'Lexend',
                        fontSize: 9,
                        fontWeight: FontWeight.w300,
                        color: AppColors.primary,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _KeyValue(
                  labelKey: 'profile.bailleur.tenantLabel',
                  value: tenant.name,
                  labelColor: AppColors.primary,
                ),
                const SizedBox(height: 10),
                _KeyValue(
                  labelKey: 'profile.bailleur.bailLabel',
                  value: tenant.bailYears == 1
                      ? '1 ${'profile.bailleur.year'.tr()}'
                      : '${tenant.bailYears} ${'profile.bailleur.years'.tr()}',
                  labelColor: AppColors.primary,
                ),
                const SizedBox(height: 10),
                _KeyValue(
                  labelKey: 'profile.bailleur.phoneLabel',
                  value: tenant.phone,
                  labelColor: AppColors.primary,
                ),
                const SizedBox(height: 13),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ClientDetailsScreen(tenant: tenant),
                    ));
                  },
                  child: Container(
                    width: 171,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.dark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'profile.bailleur.consultClient'.tr(),
                      style: AppTextStyles.regular12.copyWith(
                        fontFamily: 'Lexend',
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyValue extends StatelessWidget {
  const _KeyValue({
    required this.labelKey,
    required this.value,
    required this.labelColor,
  });

  final String labelKey;
  final String value;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.regular12.copyWith(
          fontFamily: 'Lexend',
          fontSize: 9,
          fontWeight: FontWeight.w400,
          color: AppColors.text,
          height: 1.0,
        ),
        children: [
          TextSpan(
            text: '${labelKey.tr()} : ',
            style: AppTextStyles.regular12.copyWith(
              fontFamily: 'Lexend',
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: labelColor,
              height: 1.0,
            ),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
