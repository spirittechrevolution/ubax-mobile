import 'package:flutter/material.dart';

import 'package:statefulclickcounter/features/customer/profile/screens/reservation_invoice_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class LeaveReviewScreen extends StatefulWidget {
  const LeaveReviewScreen({
    super.key,
    required this.image,
    required this.title,
    required this.location,
    required this.arrival,
    required this.departure,
  });

  final String image;
  final String title;
  final String location;
  final String arrival;
  final String departure;

  @override
  State<LeaveReviewScreen> createState() => _LeaveReviewScreenState();
}

class _LeaveReviewScreenState extends State<LeaveReviewScreen> {
  static const _maxChars = 350;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final remaining = _maxChars - _controller.text.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Header

          Padding(
            padding: EdgeInsets.fromLTRB(20, topPadding + 10, 20, 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: AppColors.dark, size: 18),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Laisser un avis',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // ── Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reservation card
                  _ReviewReservationCard(
                    image: widget.image,
                    title: widget.title,
                    location: widget.location,
                    arrival: widget.arrival,
                    departure: widget.departure,
                  ),

                  const SizedBox(height: 26),
                  Text(
                    'Ajouter des photos',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _DashedBox(
                    borderRadius: 12,
                    color: AppColors.text,
                    strokeWidth: 1.5,
                    dash: 4,
                    gap: 4,
                    child: SizedBox(
                      width: double.infinity,
                      height: 143,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud_upload_outlined,
                              color: AppColors.primary, size: 34),
                          const SizedBox(height: 10),
                          Text(
                            'Appuyer pour téléverser des  photos',
                            style: AppTextStyles.regular12.copyWith(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),
                  Text(
                    'Ecrivez votre avis',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _DashedBox(
                    borderRadius: 12,
                    color: AppColors.text,
                    strokeWidth: 1.5,
                    dash: 4,
                    gap: 4,
                    child: SizedBox(
                      height: 199,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextField(
                          controller: _controller,
                          maxLines: null,
                          expands: true,
                          maxLength: _maxChars,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            hintText:
                                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard',
                            hintStyle: AppTextStyles.regular12.copyWith(
                              color: AppColors.text,
                              fontSize: 11,
                              fontWeight: FontWeight.w300,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            counterText: '',
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: AppTextStyles.regular12.copyWith(
                            color: AppColors.text,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$remaining characters  restants',
                      style: AppTextStyles.regular12.copyWith(
                        color: AppColors.text,
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Submit button
          Container(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 18),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Laisser un avis',
                    style: AppTextStyles.button.copyWith(
                      fontSize: 14,
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

// ─── Reservation card (compact for review screen) ────────────────────────────

class _ReviewReservationCard extends StatelessWidget {
  const _ReviewReservationCard({
    required this.image,
    required this.title,
    required this.location,
    required this.arrival,
    required this.departure,
  });

  final String image;
  final String title;
  final String location;
  final String arrival;
  final String departure;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 139,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              image,
              width: 128,
              height: 127,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 128,
                height: 127,
                color: const Color(0xFFE2E8F0),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 11),
                        child: Text(
                          title,
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.text,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD7F5DD),
                        borderRadius: BorderRadius.circular(14.5),
                      ),
                      child: Text(
                        'Terminée',
                        style: AppTextStyles.regular12.copyWith(
                          color: const Color(0xFF22C55E),
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: AppColors.dark, size: 14),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        location,
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.text,
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded,
                        color: AppColors.dark, size: 12),
                    const SizedBox(width: 3),
                    Text(
                      arrival,
                      style: AppTextStyles.regular12.copyWith(
                        color: AppColors.text,
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.calendar_month_rounded,
                        color: AppColors.dark, size: 12),
                    const SizedBox(width: 3),
                    Text(
                      departure,
                      style: AppTextStyles.regular12.copyWith(
                        color: AppColors.text,
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ReservationInvoiceScreen(),
                      ),
                    ),
                    child: Container(
                      height: 26,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.description_outlined,
                              color: AppColors.dark, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            'Voir la facture',
                            style: AppTextStyles.regular12.copyWith(
                              color: AppColors.text,
                              fontSize: 8,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

// ─── Dashed rounded rectangle border ─────────────────────────────────────────

class _DashedBox extends StatelessWidget {
  const _DashedBox({
    required this.child,
    required this.borderRadius,
    required this.color,
    this.strokeWidth = 1,
    this.dash = 5,
    this.gap = 4,
  });

  final Widget child;
  final double borderRadius;
  final Color color;
  final double strokeWidth;
  final double dash;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: CustomPaint(
          foregroundPainter: _DashedRectPainter(
            color: color,
            radius: borderRadius,
            strokeWidth: strokeWidth,
            dash: dash,
            gap: gap,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  _DashedRectPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dash,
    required this.gap,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        final end = (d + dash).clamp(0.0, m.length);
        canvas.drawPath(m.extractPath(d, end), paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRectPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.radius != radius ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.dash != dash ||
      oldDelegate.gap != gap;
}
