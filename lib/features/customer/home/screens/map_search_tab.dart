import 'package:flutter/material.dart';

import 'package:statefulclickcounter/core/widgets/recommended_tile.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class _MapProperty {
  const _MapProperty({
    required this.dx,
    required this.dy,
    required this.image,
    required this.title,
    required this.location,
  });

  final double dx;
  final double dy;
  final String image;
  final String title;
  final String location;
}

const _kMapProperties = <_MapProperty>[
  _MapProperty(
    dx: -20,
    dy: -170,
    image: 'assets/images/modern-elegant-bedroom-interior.jpg',
    title: 'Chambre Moderne à Cocody',
    location: "Cocody Angré, Abidjan – Côte d'Ivoire",
  ),
  _MapProperty(
    dx: 140,
    dy: -100,
    image: 'assets/images/appartements-luxe.jpg',
    title: 'Appartement de Luxe',
    location: "Cocody Riviéra, Abidjan – Côte d'Ivoire",
  ),
  _MapProperty(
    dx: -150,
    dy: -50,
    image: 'assets/images/modern-luxurious-bedroom-interior-design.jpg',
    title: 'Suite Luxueuse',
    location: "Cocody Angré, Abidjan – Côte d'Ivoire",
  ),
  _MapProperty(
    dx: -90,
    dy: 110,
    image: 'assets/images/cozy-living-room-interior-with-panoramic-window.jpg',
    title: 'Appartement Vue Panoramique',
    location: "Cocody Les Jardins, Abidjan – Côte d'Ivoire",
  ),
  _MapProperty(
    dx: 100,
    dy: 110,
    image:
        'assets/images/modern-elegant-living-room-interior-with-abstract-art.jpg',
    title: 'Salon Moderne à Cocody',
    location: "Cocody II Plateaux, Abidjan – Côte d'Ivoire",
  ),
];

class MapSearchTab extends StatefulWidget {
  const MapSearchTab({super.key});

  @override
  State<MapSearchTab> createState() => _MapSearchTabState();
}

class _MapSearchTabState extends State<MapSearchTab> {
  int? _selected;

  void _toggle(int i) {
    setState(() => _selected = _selected == i ? null : i);
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected != null ? _kMapProperties[_selected!] : null;

    return Stack(
      children: [
        // ── Map background (placeholder tint)
        Positioned.fill(
          child: Container(color: const Color(0xFFE9EEF3)),
        ),

        // ── Radius + avatar + pins
        Positioned.fill(
          child: _MapOverlay(
            properties: _kMapProperties,
            selectedIndex: _selected,
            onPinTap: _toggle,
          ),
        ),

        // ── Top address card
        const Positioned(
          top: 10,
          left: 14,
          right: 14,
          child: _AddressCard(),
        ),

        // ── Bottom selected property preview (only when a pin is tapped)
        if (selected != null)
          Positioned(
            bottom: 14,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 351,
                child: RecommendedTile(
                  imagePath: selected.image,
                  title: selected.title,
                  location: selected.location,
                  beds: 6,
                  baths: 4,
                  salons: 2,
                  onTap: () {},
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Top address card ────────────────────────────────────────────────────────

class _AddressCard extends StatelessWidget {
  const _AddressCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: AppColors.primary, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Adresse ( Rayon de 10 km )',
                      style: AppTextStyles.regular12.copyWith(
                        color: AppColors.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Cocody Angré, Abidjan',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.dark,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.edit_outlined,
                      color: Colors.white, size: 14),
                  const SizedBox(width: 5),
                  Text(
                    'Changer',
                    style: AppTextStyles.regular12.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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

// ─── Radius + avatar + pins layer ────────────────────────────────────────────

class _MapOverlay extends StatefulWidget {
  const _MapOverlay({
    required this.properties,
    required this.selectedIndex,
    required this.onPinTap,
  });

  final List<_MapProperty> properties;
  final int? selectedIndex;
  final ValueChanged<int> onPinTap;

  @override
  State<_MapOverlay> createState() => _MapOverlayState();
}

class _MapOverlayState extends State<_MapOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final center = Offset(w / 2, h * 0.5);
        const outerR = 210.0;
        const midR = 135.0;
        const innerR = 68.0;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedBuilder(
              animation: _pulse,
              builder: (context, _) {
                final t = Curves.easeOut.transform(_pulse.value);

                final outerScale = 1.0 + (0.06 * t);
                final midScale = 1.0 + (0.10 * t);
                final innerScale = 1.0 + (0.14 * t);

                final outerOpacity = 0.22 - (0.10 * t);
                final midOpacity = 0.40 - (0.18 * t);
                final innerOpacity = 0.65 - (0.30 * t);

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Outer radius (static)
                    Positioned(
                      left: center.dx - outerR,
                      top: center.dy - outerR,
                      child: Transform.scale(
                        scale: outerScale,
                        child: Container(
                          width: outerR * 2,
                          height: outerR * 2,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(outerOpacity),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    // Scanning ring inside outer radius
                    Positioned(
                      left: center.dx - outerR,
                      top: center.dy - outerR,
                      child: IgnorePointer(
                        child: CustomPaint(
                          size: const Size(outerR * 2, outerR * 2),
                          painter: _RadarRingPainter(
                            color: AppColors.primary,
                            t: t,
                            minRadius: midR,
                            maxRadius: outerR,
                          ),
                        ),
                      ),
                    ),
                    // Middle radius (radar pulse)
                    Positioned(
                      left: center.dx - midR,
                      top: center.dy - midR,
                      child: Transform.scale(
                        scale: midScale,
                        child: Container(
                          width: midR * 2,
                          height: midR * 2,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(midOpacity),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    // Scanning ring inside middle radius
                    Positioned(
                      left: center.dx - midR,
                      top: center.dy - midR,
                      child: IgnorePointer(
                        child: CustomPaint(
                          size: const Size(midR * 2, midR * 2),
                          painter: _RadarRingPainter(
                            color: AppColors.primary,
                            t: t,
                            minRadius: innerR,
                            maxRadius: midR,
                          ),
                        ),
                      ),
                    ),
                    // Inner radius — orange background behind the avatar (radar)
                    Positioned(
                      left: center.dx - innerR,
                      top: center.dy - innerR,
                      child: Transform.scale(
                        scale: innerScale,
                        child: Container(
                          width: innerR * 2,
                          height: innerR * 2,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(innerOpacity),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    // Avatar (center) — white ring + photo, sits on inner radius
                    Positioned(
                      left: center.dx - 78.6 / 2,
                      top: center.dy - 78.6 / 2,
                      child: Container(
                        width: 78.6,
                        height: 78.6,
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x22000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/pexels-ekrulila-2128329.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFFD0DDE8),
                              child: const Icon(Icons.person,
                                  color: Colors.white, size: 30),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // ── Pins (static)
            for (var i = 0; i < widget.properties.length; i++)
              _pinAt(
                center,
                widget.properties[i].dx,
                widget.properties[i].dy,
                widget.properties[i].image,
                selected: widget.selectedIndex == i,
                onTap: () => widget.onPinTap(i),
              ),
          ],
        );
      },
    );
  }

  Widget _pinAt(
    Offset center,
    double dx,
    double dy,
    String image, {
    required bool selected,
    required VoidCallback onTap,
  }) {
    const pinW = 44.0;
    const pinH = 62.0;
    // Pin tip (dx, dy) maps to (center + dx, center + dy).
    final tipX = center.dx + dx;
    final tipY = center.dy + dy;

    return Positioned(
      left: tipX - pinW / 2,
      top: tipY - pinH,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: _Pin(image: image),
      ),
    );
  }
}

class _RadarRingPainter extends CustomPainter {
  const _RadarRingPainter({
    required this.color,
    required this.t,
    required this.minRadius,
    required this.maxRadius,
  });

  final Color color;
  final double t;
  final double minRadius;
  final double maxRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = minRadius + ((maxRadius - minRadius) * t);
    final opacity = (1.0 - t) * 0.55;

    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _RadarRingPainter oldDelegate) {
    return oldDelegate.t != t ||
        oldDelegate.color != color ||
        oldDelegate.minRadius != minRadius ||
        oldDelegate.maxRadius != maxRadius;
  }
}

// ─── Teardrop pin with property image ────────────────────────────────────────

class _Pin extends StatelessWidget {
  const _Pin({required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 52,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Teardrop background
          CustomPaint(
            size: const Size(44, 52),
            painter: _PinPainter(),
          ),
          // Image disc
          Positioned(
            top: 4,
            child: ClipOval(
              child: Image.asset(
                image,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 36,
                  height: 36,
                  color: const Color(0xFFE2E8F0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PinPainter extends CustomPainter {
  _PinPainter({this.color = AppColors.dark});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final r = w / 2;

    // Tail meets the circle at ±60° from the bottom (angles 30° from the
    // downward axis), giving a smooth continuous teardrop silhouette.
    final tailHalfDx = r * 0.5; // = r * cos(60°)
    final tailY = r + r * 0.866; // = r + r * sin(60°)

    final path = Path()
      // Lower-left tangent point on the circle
      ..moveTo(cx - tailHalfDx, tailY)
      // 300° clockwise arc up and around the circle to the mirror point
      ..arcToPoint(
        Offset(cx + tailHalfDx, tailY),
        radius: Radius.circular(r),
        clockwise: true,
        largeArc: true,
      )
      // Down to the tip
      ..lineTo(cx, h)
      // Close back to the left tangent point
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PinPainter oldDelegate) =>
      oldDelegate.color != color;
}
