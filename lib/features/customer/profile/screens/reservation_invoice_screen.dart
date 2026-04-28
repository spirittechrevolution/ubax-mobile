import 'package:flutter/material.dart';

import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class ReservationInvoiceScreen extends StatelessWidget {
  const ReservationInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final darkHeight = topPadding + 280;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Scrollable area with dark background + overlapping card
          Expanded(
            child: Stack(
              children: [
                // Dark header behind everything
                Container(
                  height: darkHeight,
                  decoration: const BoxDecoration(
                    color: AppColors.dark,
                  ),
                ),
                // Content on top
                Column(
                  children: [
                    SizedBox(height: topPadding + 14),
                    // Title row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
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
                    const SizedBox(height: 20),
                    // Invoice card — starts in dark, extends into light
                    const Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(14, 20, 14, 16),
                        child: _InvoiceCard(),
                      ),
                    ),
                  ],
                ),
              ],
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

  // Y positions of the side notches (relative to card top)
  // MUST match the positions of the inline dashed lines in the column.
  static const _notchYs = [152.0, 346.0];

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _TicketClipper(notchYs: _notchYs),
      child: Stack(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(18, 24, 18, 36),
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
                          color: AppColors.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                // Contact row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone_outlined,
                        color: AppColors.dark, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '+225 01 02 03 04 05',
                      style: AppTextStyles.regular12.copyWith(
                        color: AppColors.text,
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.mail_outline_rounded,
                        color: AppColors.dark, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'arnaud@gmail.com',
                      style: AppTextStyles.regular12.copyWith(
                        color: AppColors.text,
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
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
                const SizedBox(height: 20),
                // Details grid 1
                _DetailGrid(const [
                  ['Hotel', 'Résidence Azur'],
                  ['Adresse', 'Plateau, Abidjan'],
                  ['Type de réservation', 'Séjour hôtelier'],
                ]),
                const SizedBox(height: 14),
                _DetailGrid(const [
                  ['Nombre', '2 Adultes'],
                  ['Type de logement', 'Chambre Deluxe'],
                  ['Date de reservation', '18 Janvier 2026'],
                ]),
                const SizedBox(height: 40),
                // Pricing grids
                _DetailGrid(const [
                  ['Nuitée chambre Deluxe', '45 000 FCFA'],
                  ['Nombre de nuits', '3'],
                  ['Prix total', '135 000 FCFA'],
                ]),
                const SizedBox(height: 14),
                _DetailGrid(const [
                  ['Frais de service UBAX', '5 000 FCFA'],
                  ['TVA 0%', '0 FCFA'],
                  ['Total à payer', '140 000 FCFA', '_bold'],
                ]),
                const SizedBox(height: 14),
                _DetailGrid(const [
                  ['Numéro de facture', 'UBX-HTL-2026-00124'],
                  ['Mode de paiement', 'Mobile money', '_orange'],
                  ['Date de facturation', '20 janvier 2026'],
                ]),
                const SizedBox(height: 20),
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
          ),
          // Overlay dashed lines exactly at notch Y positions
          for (final y in _notchYs)
            Positioned(
              left: 24,
              right: 24,
              top: y,
              child: const _DashedLine(),
            ),
        ],
      ),
    );
  }
}

// ─── Ticket clipper (rounded card with side notches) ─────────────────────────

class _TicketClipper extends CustomClipper<Path> {
  _TicketClipper({required this.notchYs, this.notchRadius = 10});

  final List<double> notchYs;
  final double notchRadius;

  @override
  Path getClip(Size size) {
    const corner = 18.0;
    final path = Path();

    // Top-left corner
    path.moveTo(corner, 0);
    path.lineTo(size.width - corner, 0);
    path.arcToPoint(
      Offset(size.width, corner),
      radius: const Radius.circular(corner),
    );

    // Right edge with notches (top → bottom)
    for (final y in notchYs) {
      path.lineTo(size.width, y - notchRadius);
      path.arcToPoint(
        Offset(size.width, y + notchRadius),
        radius: Radius.circular(notchRadius),
        clockwise: false,
      );
    }
    path.lineTo(size.width, size.height - corner);

    // Bottom-right corner
    path.arcToPoint(
      Offset(size.width - corner, size.height),
      radius: const Radius.circular(corner),
    );
    path.lineTo(corner, size.height);

    // Bottom-left corner
    path.arcToPoint(
      Offset(0, size.height - corner),
      radius: const Radius.circular(corner),
    );

    // Left edge with notches (bottom → top)
    for (final y in notchYs.reversed) {
      path.lineTo(0, y + notchRadius);
      path.arcToPoint(
        Offset(0, y - notchRadius),
        radius: Radius.circular(notchRadius),
        clockwise: false,
      );
    }
    path.lineTo(0, corner);

    // Top-left corner
    path.arcToPoint(
      Offset(corner, 0),
      radius: const Radius.circular(corner),
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _TicketClipper oldClipper) =>
      oldClipper.notchYs != notchYs || oldClipper.notchRadius != notchRadius;
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
                    color: AppColors.text,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  date,
                  style: AppTextStyles.regular12.copyWith(
                    color: AppColors.text,
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
