import 'package:flutter/material.dart';

import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class ReservationInvoiceScreen extends StatelessWidget {
  const ReservationInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Dark header
          Container(
            padding: EdgeInsets.fromLTRB(18, topPadding + 10, 18, 20),
            decoration: const BoxDecoration(
              color: AppColors.dark,
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
                      'Facture',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),

          // ── Body (scrollable invoice card)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
              child: _InvoiceCard(),
            ),
          ),

          // ── Download button
          Container(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Télécharger',
                    style: AppTextStyles.button.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
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

// ─── Invoice card ────────────────────────────────────────────────────────────

class _InvoiceCard extends StatelessWidget {
  const _InvoiceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User header (avatar + name + contact)
          Center(
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD0DDE8),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/pexels-ekrulila-2128329.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Arnaud Koffi',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Contact row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone_outlined,
                  color: AppColors.muted, size: 14),
              const SizedBox(width: 4),
              Text(
                '+225 01 02 03 04 05',
                style: AppTextStyles.regular12.copyWith(
                  color: AppColors.dark,
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.mail_outline_rounded,
                  color: AppColors.muted, size: 14),
              const SizedBox(width: 4),
              Text(
                'arnaud@gmail.com',
                style: AppTextStyles.regular12.copyWith(
                  color: AppColors.dark,
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Check-in / Check-out
          Row(
            children: [
              Expanded(
                child: _CheckBox(
                  label: 'Check-in',
                  date: '15 Mars 2026',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CheckBox(
                  label: 'Check-out',
                  date: '18 Mars 2026',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Details grid 1
          _DetailGrid(const [
            ['Hotel', 'Résidence Azur'],
            ['Adresse', 'Plateau, Abidjan'],
            ['Type de réservation', 'Séjour hôtelier'],
          ]),
          const SizedBox(height: 10),
          _DetailGrid(const [
            ['Nombre', '2 Adultes'],
            ['Type de logement', 'Chambre Deluxe'],
            ['Date de reservation', '18 Janvier 2026'],
          ]),
          const SizedBox(height: 14),
          const _DashedLine(),
          const SizedBox(height: 14),
          // Pricing grids
          _DetailGrid(const [
            ['Nuitée chambre Deluxe', '45 000 FCFA'],
            ['Nombre de nuits', '3'],
            ['Prix total', '135 000 FCFA'],
          ]),
          const SizedBox(height: 10),
          _DetailGrid(const [
            ['Frais de service UBAX', '5 000 FCFA'],
            ['TVA 0%', '0 FCFA'],
            ['Total à payer', '140 000 FCFA', '_bold'],
          ]),
          const SizedBox(height: 10),
          _DetailGrid(const [
            ['Numéro de facture', 'UBX-HTL-2026-00124'],
            ['Mode de paiement', 'Mobile money', '_orange'],
            ['Date de facturation', '20 janvier 2026'],
          ]),
          const SizedBox(height: 14),
          // QR code
          Center(
            child: Container(
              width: 90,
              height: 90,
              alignment: Alignment.center,
              child: const Icon(
                Icons.qr_code_2_rounded,
                size: 90,
                color: AppColors.dark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Check-in / Check-out box ────────────────────────────────────────────────

class _CheckBox extends StatelessWidget {
  const _CheckBox({required this.label, required this.date});

  final String label;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.calendar_month_rounded,
                color: AppColors.dark, size: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.regular12.copyWith(
                    color: AppColors.dark,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  date,
                  style: AppTextStyles.regular12.copyWith(
                    color: AppColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
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

// ─── 3-column detail grid ────────────────────────────────────────────────────

class _DetailGrid extends StatelessWidget {
  const _DetailGrid(this.rows);

  /// Each row: [label, value] or [label, value, '_orange' | '_bold']
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows.map((r) {
        final modifier = r.length > 2 ? r[2] : null;
        final isOrange = modifier == '_orange';
        final isBold = modifier == '_bold';
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                r[0],
                style: AppTextStyles.regular12.copyWith(
                  color: isOrange ? AppColors.primary : AppColors.dark,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                r[1],
                style: AppTextStyles.regular12.copyWith(
                  color: isOrange ? AppColors.primary : AppColors.muted,
                  fontSize: 10,
                  fontWeight: isBold ? FontWeight.w600 : FontWeight.w300,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─── Dashed line ─────────────────────────────────────────────────────────────

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: CustomPaint(
        painter: _DashedLinePainter(),
        size: const Size(double.infinity, 1),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1;
    const dash = 5.0;
    const gap = 4.0;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dash, 0), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
