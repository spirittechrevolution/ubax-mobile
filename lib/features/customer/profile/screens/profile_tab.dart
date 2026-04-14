import 'package:flutter/material.dart';

import 'package:statefulclickcounter/features/customer/profile/screens/formalities_screen.dart';
import 'package:statefulclickcounter/features/customer/profile/screens/payment_invoice_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _QuickAction {
  const _QuickAction(this.icon, this.label);
  final IconData icon;
  final String label;
}

const _kActionsNoContract = [
  _QuickAction(Icons.settings_suggest_rounded, 'Services UBAX'),
  _QuickAction(Icons.calendar_month_rounded, 'Mes reservations'),
];

const _kActionsWithContract = [
  _QuickAction(Icons.home_work_outlined, 'Formalités'),
  _QuickAction(Icons.insert_drive_file_outlined, 'Documents'),
  _QuickAction(Icons.handyman_rounded, 'SAV'),
  _QuickAction(Icons.settings_suggest_rounded, 'Services UBAX'),
  _QuickAction(Icons.calendar_month_rounded, 'Mes reservations'),
];

// ─── Profile Tab ──────────────────────────────────────────────────────────────

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  // Toggle between no-contract and with-contract for demo
  bool _hasContract = false;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero header with background image
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Background image
              Container(
                height: 230 + topPadding,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: _hasContract
                      ? const DecorationImage(
                          image: AssetImage('assets/images/villa.jpg'),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: _hasContract ? null : const Color(0xFFD4935A),
                ),
                child: Container(
                  color: _hasContract
                      ? const Color(0xAA1A3047)
                      : const Color(0x44000000),
                ),
              ),
              // Settings icon
              Positioned(
                top: topPadding + 10,
                right: 18,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.settings_rounded,
                      color: Colors.white, size: 22),
                ),
              ),
              // Agency selector (with contract)
              if (_hasContract)
                Positioned(
                  top: topPadding + 12,
                  left: 18,
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.home_rounded,
                            color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down_rounded,
                          color: Colors.white, size: 20),
                    ],
                  ),
                ),
              // Avatar + Name
              Positioned(
                top: topPadding + 50,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF4DA8DA), width: 3),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/pexels-ekrulila-2128329.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFF2D4A65),
                            child: const Icon(Icons.person,
                                color: Colors.white, size: 40),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Arnaud Koffi',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    if (_hasContract) ...[
                      const SizedBox(height: 4),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.circle, color: Color(0xFF22C55E), size: 8),
                          SizedBox(width: 5),
                          Text(
                            'Locataire',
                            style: TextStyle(
                              color: Color(0xFFE87D1E),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ' : Aigle immobilier',
                            style: TextStyle(
                              color: Color(0xFFB0C4DE),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // White curved overlay at bottom of photo
              Positioned(
                bottom: -1,
                left: 0,
                right: 0,
                child: Container(
                  height: 30,
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                ),
              ),
              // "Ma maison" / "Mon local" pill
              Positioned(
                bottom: -34,
                left: 18,
                right: 18,
                child: GestureDetector(
                  onTap: () => setState(() => _hasContract = !_hasContract),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.dark,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.home_outlined,
                            color: Colors.white, size: 22),
                        const SizedBox(width: 10),
                        Text(
                          _hasContract ? 'Mon local' : 'Ma maison',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 38),

          // ── Tableau de bord
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              'Tableau de Bord',
              style: TextStyle(
                color: AppColors.dark,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Dashboard card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: _hasContract
                ? const _DashboardWithContract()
                : const _DashboardNoContract(),
          ),

          const SizedBox(height: 18),

          // ── Quick actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: _QuickActionsGrid(
              actions:
                  _hasContract ? _kActionsWithContract : _kActionsNoContract,
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// ─── Dashboard: No contract ───────────────────────────────────────────────────

class _DashboardNoContract extends StatelessWidget {
  const _DashboardNoContract();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Text(
            'Aucun logement actif',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Vous n\'avez pas encore loué de bien.\nDès qu\'un contrat sera actif, vos paiements et les\nstatistiques apparaîtront ici.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {},
            child: const Text(
              'Trouver un logement',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Dashboard: With contract ─────────────────────────────────────────────────

class _DashboardWithContract extends StatefulWidget {
  const _DashboardWithContract();

  @override
  State<_DashboardWithContract> createState() => _DashboardWithContractState();
}

class _DashboardWithContractState extends State<_DashboardWithContract> {
  bool _amountVisible = true;

  @override
  Widget build(BuildContext context) {
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
              // Amount + icon
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _amountVisible ? '-250 000 f' : '••••••••',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
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
                  ],
                ),
              ),
              // Pie chart placeholder
              SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(
                  painter: _PieChartPainter(),
                ),
              ),
              const SizedBox(width: 10),
              // Legend
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LegendItem(
                      color: Color(0xFF22C55E), label: 'Payés', count: '5'),
                  SizedBox(height: 8),
                  _LegendItem(
                      color: Color(0xFFFACC15), label: 'En attente', count: ''),
                  SizedBox(height: 8),
                  _LegendItem(
                      color: Color(0xFFEF4444), label: 'Impayé', count: '2'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Prochain loyer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Prochain loyer  le 05 janvier',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const PaymentInvoiceScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Text(
                          'Payer mon loyer',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Voir l'historique
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_month_rounded,
                        color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Voir l\'historique',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
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
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: count.isNotEmpty
              ? Text(
                  count,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                )
              : null,
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

// ─── Pie chart painter ────────────────────────────────────────────────────────

class _PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 18.0;
    final rect =
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    // Green (paid) ~55%
    final greenPaint = Paint()
      ..color = const Color(0xFF22C55E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, -1.5708, 3.456, false, greenPaint);

    // Yellow (pending) ~20%
    final yellowPaint = Paint()
      ..color = const Color(0xFFFACC15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, -1.5708 + 3.456, 1.257, false, yellowPaint);

    // Red (unpaid) ~25%
    final redPaint = Paint()
      ..color = const Color(0xFFEF4444)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, -1.5708 + 3.456 + 1.257, 1.570, false, redPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Quick actions grid ───────────────────────────────────────────────────────

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({required this.actions});

  final List<_QuickAction> actions;

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
        children: actions.map((a) => _ActionCard(action: a)).toList(),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.action});

  final _QuickAction action;

  void _onTap(BuildContext context) {
    if (action.label == 'Formalités') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const FormalitiesScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
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
            Icon(action.icon, color: AppColors.dark, size: 24),
            const SizedBox(height: 6),
            Text(
              action.label,
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
