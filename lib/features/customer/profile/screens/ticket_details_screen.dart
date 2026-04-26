import 'package:flutter/material.dart';

import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class TicketDetailsScreen extends StatelessWidget {
  const TicketDetailsScreen({
    super.key,
    this.ticketNumber = 'UBX-SAV-0265',
  });

  final String ticketNumber;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Dark header
          Container(
            padding: EdgeInsets.fromLTRB(18, topPadding + 10, 18, 18),
            decoration: const BoxDecoration(
              color: AppColors.text,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 20),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Détails ticket',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),

          // ── Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SummaryCard(),
                  const SizedBox(height: 18),
                  CustomPaint(
                    painter: _DashedBorderPainter(),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DetailRow('Numéro du ticket', ticketNumber),
                          _DetailRow('Statut', 'En cour'),
                          _DetailRow('Date de création', '30 Avril 2026'),
                          _DetailRow('Dernière mise à jour', '31 Mai 2026'),
                          const _Divider(),
                          _DetailRow('Type de bien', 'Appartement'),
                          _DetailRow('Nom / Référence', 'Appartement 0025'),
                          _DetailRow('Adresse', 'Cocody Angré, Abidjan'),
                          _DetailRow('Agence gestionnaire',
                              'Agence Immobilière Horizon'),
                          const _Divider(),
                          _DetailRow('Problème déclaré', 'Panne électrique'),
                          _DetailRow('Niveau d\u2019urgence', 'Urgent'),
                          _DetailRow('Adresse', 'Cocody Angré, Abidjan'),
                          _DetailRow('Agence gestionnaire',
                              'Agence Immobilière Horizon'),
                          _DetailRow(
                            'Titre du problème',
                            'Coupure totale d\u2019électricité dans l\u2019appartement',
                          ),
                          const _Divider(),
                          const SizedBox(height: 4),
                          Text(
                            'Description :',
                            style: AppTextStyles.regular12.copyWith(
                              color: AppColors.text,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Depuis hier soir, il n\u2019y a plus d\u2019électricité dans tout l\u2019appartement. Le disjoncteur principal se déclenche immédiatement après réactivation.',
                            style: AppTextStyles.regular12.copyWith(
                              color: AppColors.text,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── CTA
          Container(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Marquer comme resolu',
                    style: AppTextStyles.button,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Summary card ─────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
    const accent = AppColors.primary;
    const accentBg = Color(0xFFFFE7D3);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 5, color: accent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
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
                                'Electricité',
                                style: AppTextStyles.sectionTitle.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Résidence Azalai',
                                style: AppTextStyles.sectionTitle.copyWith(
                                  color: AppColors.text,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                'Appartement 0025',
                                style: AppTextStyles.regular12.copyWith(
                                  color: AppColors.text,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'UBX-SAV-0265',
                          style: AppTextStyles.regular12.copyWith(
                            color: AppColors.text,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.calendar_month_rounded,
                            color: AppColors.text,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '30 Avril 2026',
                          style: AppTextStyles.regular12.copyWith(
                            color: AppColors.text,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: accentBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'En cour',
                            style: AppTextStyles.regular12.copyWith(
                              color: accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Detail row ───────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label : ',
            style: AppTextStyles.regular12.copyWith(
              color: AppColors.text,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          SizedBox(
            width: 7,
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.regular12.copyWith(
                color: AppColors.text,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(height: 1, color: Color(0xFFE5E7EB)),
    );
  }
}

// ─── Dashed border painter ────────────────────────────────────────────────────

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF64748B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    const radius = 14.0;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(radius),
    );
    final path = Path()..addRRect(rect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final len = (dashWidth).clamp(0.0, metric.length - distance).toDouble();
        canvas.drawPath(metric.extractPath(distance, distance + len), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
