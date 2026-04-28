import 'package:flutter/material.dart';

import 'package:statefulclickcounter/features/customer/profile/screens/ticket_details_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class TicketSentScreen extends StatelessWidget {
  const TicketSentScreen({super.key, required this.ticketNumber});

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
                      'ticket envoyé',
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
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Illustration with light circular bg
                  const SizedBox(height: 60),
                  Center(
                    child: Image.asset(
                      'assets/images/recu.png',
                      width: 208,
                      height: 208,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.task_alt_rounded,
                        color: AppColors.primary,
                        size: 80,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Description
                  Text(
                    'Le ticket a été transmis avec succès à l\u2019agence qui gère votre bien.\nVous serez informé de l\u2019évolution du traitement.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.regular12.copyWith(
                      color: AppColors.text,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Dashed ticket number box
                  CustomPaint(
                    painter: _DashedBorderPainter(),
                    child: Container(
                      height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        ticketNumber,
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.text,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Voir mes tickets button
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.dark,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => TicketDetailsScreen(
                              ticketNumber: ticketNumber,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Voir mes tickets',
                        style: AppTextStyles.button,
                      ),
                    ),
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

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF64748B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const dashWidth = 7.0;
    const dashSpace = 4.0;
    const radius = 12.0;

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
