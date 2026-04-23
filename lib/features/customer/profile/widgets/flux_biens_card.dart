import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:statefulclickcounter/features/customer/profile/data/mock_bailleur_profile.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class FluxBiensSection extends StatelessWidget {
  const FluxBiensSection({super.key, required this.profile});

  final BailleurProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'profile.bailleur.fluxBiens'.tr(),
                style: AppTextStyles.sectionTitle.copyWith(
                  fontFamily: 'Lexend',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.dark,
                  height: 1.0,
                ),
              ),
            ),
            const _PeriodDropdown(),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 146,
          child: Row(
            children: [
              Expanded(child: _DonutCard(profile: profile)),
              const SizedBox(width: 10),
              Expanded(child: _RevenueCard(profile: profile)),
            ],
          ),
        ),
      ],
    );
  }
}

class _PeriodDropdown extends StatelessWidget {
  const _PeriodDropdown();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE3E8EE)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'profile.bailleur.thisMonth'.tr(),
            style: AppTextStyles.regular12.copyWith(
              fontFamily: 'Lexend',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down_rounded,
              size: 14, color: AppColors.dark),
        ],
      ),
    );
  }
}

class _DonutCard extends StatelessWidget {
  const _DonutCard({required this.profile});

  final BailleurProfile profile;

  @override
  Widget build(BuildContext context) {
    final total = profile.totalProperties;
    final sold = profile.soldCount;
    final rented = profile.rentedCount;
    final available = profile.availableCount;

    int pct(int n) => total == 0 ? 0 : ((n / total) * 100).round();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF1F3F7), width: 1),
      ),
      child: Row(
        children: [
          // Figma ratio: chart 123.21 / card width 217
          Expanded(
            flex: 12321,
            child: AspectRatio(
              aspectRatio: 123.21 / 122.14,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 30,
                      startDegreeOffset: -90,
                      sections: [
                        PieChartSectionData(
                          value: sold.toDouble(),
                          color: const Color(0xFF22C55E),
                          radius: 22,
                          showTitle: false,
                        ),
                        PieChartSectionData(
                          value: rented.toDouble(),
                          color: AppColors.primary,
                          radius: 22,
                          showTitle: false,
                        ),
                        PieChartSectionData(
                          value: available.toDouble(),
                          color: const Color(0xFF2563EB),
                          radius: 22,
                          showTitle: false,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$total',
                        style: AppTextStyles.regularlight16.copyWith(
                          fontFamily: 'Lexend',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.dark,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'profile.bailleur.biens'.tr(),
                        style: AppTextStyles.regular12.copyWith(
                          fontFamily: 'Lexend',
                          fontSize: 7,
                          fontWeight: FontWeight.w500,
                          color: AppColors.muted,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 8779, // 217 - 123.21 - 6 (≈ 87.79)
            child: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DonutLegend(
                    color: const Color(0xFF22C55E),
                    label: 'profile.bailleur.sold'.tr(),
                    count: sold,
                    percent: pct(sold),
                  ),
                  const SizedBox(height: 14),
                  _DonutLegend(
                    color: AppColors.primary,
                    label: 'profile.bailleur.rented'.tr(),
                    count: rented,
                    percent: pct(rented),
                  ),
                  const SizedBox(height: 14),
                  _DonutLegend(
                    color: const Color(0xFF2563EB),
                    label: 'profile.bailleur.available'.tr(),
                    count: available,
                    percent: pct(available),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutLegend extends StatelessWidget {
  const _DonutLegend({
    required this.color,
    required this.label,
    required this.count,
    required this.percent,
  });

  final Color color;
  final String label;
  final int count;
  final int percent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 7,
          height: 7,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.regular12.copyWith(
                  fontFamily: 'Lexend',
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: AppColors.dark,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '$count ${'profile.bailleur.biens'.tr()} - $percent%',
                style: AppTextStyles.regular12.copyWith(
                  fontFamily: 'Lexend',
                  fontSize: 7,
                  fontWeight: FontWeight.w400,
                  color: AppColors.muted,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RevenueCard extends StatelessWidget {
  const _RevenueCard({required this.profile});

  final BailleurProfile profile;

  String _formatAmount(int amount) {
    final abs = amount.abs().toString();
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
    final spots = profile.revenuePoints
        .map((p) => FlSpot(p.x, p.y))
        .toList(growable: false);
    final maxY = profile.revenuePoints
        .map((p) => p.y)
        .fold<double>(0, (a, b) => a > b ? a : b);
    final lastX = spots.last.x;
    final lastY = spots.last.y;

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF1F3F7), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_formatAmount(profile.monthlyRevenue)} fcfa',
                      style: AppTextStyles.regularlight16.copyWith(
                        fontFamily: 'Lexend',
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.dark,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.arrow_upward_rounded,
                            color: Color(0xFF22C55E), size: 9),
                        Text(
                          '+${profile.revenueEvolutionPercent}% ',
                          style: AppTextStyles.regular12.copyWith(
                            fontFamily: 'Lexend',
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF22C55E),
                            height: 1.0,
                          ),
                        ),
                        Text(
                          'profile.bailleur.thisMonth'.tr(),
                          style: AppTextStyles.regular12.copyWith(
                            fontFamily: 'Lexend',
                            fontSize: 8,
                            fontWeight: FontWeight.w300,
                            color: AppColors.muted,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: lastX,
                minY: 0,
                maxY: maxY * 1.2,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(show: false),
                lineTouchData: const LineTouchData(enabled: false),
                extraLinesData: ExtraLinesData(
                  verticalLines: [
                    VerticalLine(
                      x: lastX,
                      color: AppColors.primary.withValues(alpha: 0.45),
                      strokeWidth: 1,
                      dashArray: const [3, 3],
                    ),
                  ],
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: const Color(0xFF22C55E),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, _) => spot.x == lastX,
                      getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                        radius: 3,
                        color: AppColors.primary,
                        strokeWidth: 0,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF22C55E).withValues(alpha: 0.25),
                          const Color(0xFF22C55E).withValues(alpha: 0.02),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.center,
            child: Text(
              '${_formatAmount(lastY.round()).substring(0, 3)}k',
              style: AppTextStyles.regular12.copyWith(
                fontFamily: 'Lexend',
                fontSize: 8,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
