import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:statefulclickcounter/features/customer/profile/data/mock_bailleur_profile.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class ClientDetailsScreen extends StatelessWidget {
  const ClientDetailsScreen({super.key, required this.tenant});

  final BailleurTenant tenant;

  String _formatAmount(int value) {
    final abs = value.abs().toString();
    final buf = StringBuffer();
    for (var i = 0; i < abs.length; i++) {
      final fromEnd = abs.length - i;
      buf.write(abs[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(' ');
    }
    return buf.toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Hero(tenant: tenant),
            // const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: _ClientCard(tenant: tenant),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Expanded(
                    child: _PaymentInfoCard(
                      tenant: tenant,
                      formatter: _formatAmount,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _BalanceCard(
                    tenant: tenant,
                    formatter: _formatAmount,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: _ProgressCard(tenant: tenant),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.tenant});
  final BailleurTenant tenant;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 305 + topPadding,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(tenant.apartmentImage),
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
          child: _CircleBack(onTap: () => Navigator.of(context).pop()),
        ),
        Positioned(
          top: topPadding + 18,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'profile.bailleur.clientDetailsTitle'.tr(),
              style: AppTextStyles.regularlight16.copyWith(
                fontFamily: 'Lexend',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
        // Curved white overlay at image bottom
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
        // Info strip
        Positioned(
          left: 9,
          right: 9,
          bottom: 44,
          child: Container(
            height: 61,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0x99000000),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'profile.bailleur.apartment'
                            .tr(namedArgs: {'num': tenant.apartmentNumber}),
                        style: AppTextStyles.regularlight16.copyWith(
                          fontFamily: 'Lexend',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              color: AppColors.primary, size: 11),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Cocody Angré, Abidjan – Côte d\'Ivoire',
                              style: AppTextStyles.regular12.copyWith(
                                fontFamily: 'Lexend',
                                fontSize: 8,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 50),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _HeroStat(
                                icon: Icons.bed_outlined,
                                text: '2 ${'profile.bailleur.rooms'.tr()}'),
                          ),
                          Expanded(
                            child: _HeroStat(
                                icon: Icons.weekend_outlined,
                                text:
                                    '1 ${'profile.bailleur.livingRoom'.tr()}'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _HeroStat(
                                icon: Icons.bathtub_outlined,
                                text: '1 ${'profile.bailleur.bathroom'.tr()}'),
                          ),
                          Expanded(
                            child: _HeroStat(
                                icon: Icons.open_in_full_rounded,
                                text: '130 m²'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary, size: 10),
        const SizedBox(width: 3),
        Text(
          text,
          style: AppTextStyles.regular12.copyWith(
            fontFamily: 'Lexend',
            fontSize: 8,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

class _CircleBack extends StatelessWidget {
  const _CircleBack({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
    );
  }
}

class _ClientCard extends StatelessWidget {
  const _ClientCard({required this.tenant});
  final BailleurTenant tenant;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 255,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  tenant.avatarAsset,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 46,
                    height: 46,
                    color: AppColors.dark,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tenant.name,
                      style: AppTextStyles.regularlight16.copyWith(
                        fontFamily: 'Lexend',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          'profile.bailleur.tenantActive'.tr(),
                          style: AppTextStyles.regular12.copyWith(
                            fontFamily: 'Lexend',
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primary,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.circle,
                            color: AppColors.statusPaid, size: 7),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _LineInfo(
                  icon: Icons.phone_rounded,
                  iconColor: AppColors.primary,
                  label: 'profile.bailleur.phone'.tr(),
                  value: tenant.phone,
                ),
              ),
              Expanded(
                child: _LineInfo(
                  icon: Icons.calendar_month_rounded,
                  iconColor: AppColors.primary,
                  label: 'profile.bailleur.date'.tr(),
                  value: '${tenant.startDate} - ${tenant.endDate}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _LineInfo(
                  icon: Icons.numbers_rounded,
                  iconColor: AppColors.primary,
                  label: 'profile.bailleur.reference'.tr(),
                  value: tenant.reference,
                ),
              ),
              Expanded(
                child: _LineInfo(
                  icon: Icons.timer_outlined,
                  iconColor: AppColors.primary,
                  label: 'profile.bailleur.bail'.tr(),
                  value: 'profile.bailleur.monthsValue'
                      .tr(namedArgs: {'count': '${tenant.bailMonths}'}),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          const Row(
            children: [
              Expanded(
                child: _DocumentTile(
                  icon: Icons.description_outlined,
                  labelKey: 'profile.bailleur.docContract',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _DocumentTile(
                  icon: Icons.credit_card_rounded,
                  labelKey: 'profile.bailleur.docIdentity',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _DocumentTile(
                  icon: Icons.receipt_long_rounded,
                  labelKey: 'profile.bailleur.docReceipts',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LineInfo extends StatelessWidget {
  const _LineInfo({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 13),
        const SizedBox(width: 4),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.regular12.copyWith(
                fontFamily: 'Lexend',
                fontSize: 11,
                fontWeight: FontWeight.w300,
                color: AppColors.primary,
                height: 1.1,
              ),
              children: [
                TextSpan(text: '$label : '),
                TextSpan(
                  text: value,
                  style: AppTextStyles.regular12.copyWith(
                    fontFamily: 'Lexend',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.text,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({required this.icon, required this.labelKey});

  final IconData icon;
  final String labelKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 109,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFECF2F7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFECF2F7), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: AppColors.dark, size: 16),
          ),
          const SizedBox(height: 8),
          Text(
            labelKey.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.regular12.copyWith(
              fontFamily: 'Lexend',
              fontSize: 9,
              fontWeight: FontWeight.w400,
              color: AppColors.text,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.dark,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'profile.bailleur.see'.tr(),
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
    );
  }
}

class _PaymentInfoCard extends StatelessWidget {
  const _PaymentInfoCard({required this.tenant, required this.formatter});
  final BailleurTenant tenant;
  final String Function(int) formatter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FinanceLine(
            icon: Icons.attach_money_rounded,
            label: 'profile.bailleur.monthlyRent'.tr(),
            value: '${formatter(tenant.monthlyRent)} Fcfa',
          ),
          const SizedBox(height: 6),
          _FinanceLine(
            icon: Icons.history_rounded,
            label: 'profile.bailleur.lastPayment'.tr(),
            value: tenant.lastPayment,
          ),
          const SizedBox(height: 6),
          _FinanceLine(
            icon: Icons.shield_outlined,
            label: 'profile.bailleur.caution'.tr(),
            value: '${formatter(tenant.caution)} Fcfa',
          ),
          const SizedBox(height: 6),
          _FinanceLine(
            icon: Icons.event_rounded,
            label: 'profile.bailleur.nextPayment'.tr(),
            value: tenant.nextPayment,
          ),
        ],
      ),
    );
  }
}

class _FinanceLine extends StatelessWidget {
  const _FinanceLine({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 13),
        const SizedBox(width: 5),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.regular12.copyWith(
                fontFamily: 'Lexend',
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 1.0,
              ),
              children: [
                TextSpan(text: '$label : '),
                TextSpan(
                  text: value,
                  style: AppTextStyles.regular12.copyWith(
                    fontFamily: 'Lexend',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.tenant, required this.formatter});
  final BailleurTenant tenant;
  final String Function(int) formatter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 188,
      height: 118,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'profile.bailleur.currentBalance'.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.regular12.copyWith(
              fontFamily: 'Lexend',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 121,
            height: 47,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(22.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatter(tenant.currentBalance),
                  style: AppTextStyles.regularlight16.copyWith(
                    fontFamily: 'Lexend',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    'Fcfa',
                    style: AppTextStyles.regular12.copyWith(
                      fontFamily: 'Lexend',
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'profile.bailleur.upToDate'.tr(),
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
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.tenant});
  final BailleurTenant tenant;

  @override
  Widget build(BuildContext context) {
    final fraction = tenant.progressPercent / 100;

    return Container(
      height: 135,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 16),
                child: Text(
                  '${tenant.progressPercent}%',
                  style: AppTextStyles.regularlight16.copyWith(
                    fontFamily: 'Lexend',
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: AppColors.statusPaid,
                    height: 1.0,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F7EC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.arrow_upward_rounded,
                              color: AppColors.statusPaid, size: 10),
                          Text(
                            '+${tenant.progressPercent}%',
                            style: AppTextStyles.regular12.copyWith(
                              fontFamily: 'Lexend',
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: AppColors.statusPaid,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'profile.bailleur.sinceLastMonth'.tr(),
                      style: AppTextStyles.regular12.copyWith(
                        fontFamily: 'Lexend',
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: AppColors.text,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(width: 8),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 20),
              //   child:
              //   Text(
              //     'profile.bailleur.sinceLastMonth'.tr(),
              //     style: AppTextStyles.regular12.copyWith(
              //       fontFamily: 'Lexend',
              //       fontSize: 10,
              //       fontWeight: FontWeight.w300,
              //       color: AppColors.text,
              //       height: 1.0,
              //     ),
              //   ),

              // ),
            ],
          ),
          LayoutBuilder(
            builder: (_, c) {
              final w = c.maxWidth;
              return Stack(
                children: [
                  Container(
                    width: w,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  Container(
                    width: w * fraction,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.statusPaid,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _LegendDot(
                color: AppColors.statusPaid,
                text: '${tenant.paidCount} ${'profile.bailleur.paid'.tr()}',
              ),
              SizedBox(
                width: 13,
              ),
              _LegendDot(
                color: AppColors.primary,
                text:
                    '${tenant.pendingCount} ${'profile.bailleur.pending'.tr()}',
              ),
              SizedBox(
                width: 13,
              ),
              _LegendDot(
                color: Colors.red,
                text: '${tenant.unpaidCount} ${'profile.bailleur.unpaid'.tr()}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.text});
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.regular12.copyWith(
            fontFamily: 'Lexend',
            fontSize: 9,
            fontWeight: FontWeight.w400,
            color: AppColors.text,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}
