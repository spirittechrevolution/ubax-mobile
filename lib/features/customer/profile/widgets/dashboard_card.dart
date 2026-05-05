import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:statefulclickcounter/features/customer/profile/data/mock_tenant_profile.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';

class DashboardCard extends StatefulWidget {
  const DashboardCard({
    super.key,
    required this.profile,
    required this.onPayRent,
    required this.onViewHistory,
  });

  final TenantProfile profile;
  final VoidCallback onPayRent;
  final VoidCallback onViewHistory;

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool _amountVisible = true;

  String _formatBalance(int value) {
    final abs = value.abs().toString();
    final buf = StringBuffer();
    for (var i = 0; i < abs.length; i++) {
      final fromEnd = abs.length - i;
      buf.write(abs[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(' ');
    }
    final formatted = buf.toString().trim();
    return value < 0 ? '-$formatted f' : '$formatted f';
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.profile;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount + eye toggle
              Expanded(
                child: Row(
                  children: [
                    Text(
                      _amountVisible ? _formatBalance(p.balance) : '••••••••',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _amountVisible = !_amountVisible),
                      child: Icon(
                        _amountVisible
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),

              // Pie chart
              Container(
                width: 118,
                height: 118,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 0,
                    startDegreeOffset: -60,
                    sections: [
                      PieChartSectionData(
                        value: p.paidCount.toDouble(),
                        color: AppColors.statusPaid,
                        radius: 50,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: p.pendingCount.toDouble(),
                        color: AppColors.statusPending,
                        radius: 50,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: p.unpaidCount.toDouble(),
                        color: AppColors.statusUnpaid,
                        radius: 50,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Legend
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LegendItem(
                    color: AppColors.statusPaid,
                    label: 'profile.dashboard.paid'.tr(),
                    count: '${p.paidCount}',
                  ),
                  const SizedBox(height: 8),
                  _LegendItem(
                    color: AppColors.statusPending,
                    label: 'profile.dashboard.pending'.tr(),
                    count: '${p.pendingCount}',
                  ),
                  const SizedBox(height: 8),
                  _LegendItem(
                    color: AppColors.statusUnpaid,
                    label: 'profile.dashboard.unpaid'.tr(),
                    count: '${p.unpaidCount}',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Actions row: [Prochain loyer + Payer mon loyer] | Voir l'historique
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'profile.dashboard.nextRent'
                        .tr(namedArgs: {'date': p.nextRentDate}),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: widget.onPayRent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        'profile.dashboard.payRent'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: widget.onViewHistory,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_month_rounded,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'profile.dashboard.viewHistory'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.count,
  });

  final Color color;
  final String label;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 10,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
