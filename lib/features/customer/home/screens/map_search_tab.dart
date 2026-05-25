import 'package:flutter/material.dart';
import 'dart:async';

import 'package:statefulclickcounter/core/widgets/recommended_tile.dart';
import 'package:go_router/go_router.dart';
import 'package:statefulclickcounter/core/navigation/app_router.dart';
import 'package:statefulclickcounter/core/favorites/favorites_store.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:statefulclickcounter/features/auth/presentation/bloc/auth/auth_bloc.dart';

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

class _RadarFillPainter extends CustomPainter {
  const _RadarFillPainter({
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
    final easedT = Curves.easeOut.transform(t);
    final gated = ((easedT - 0.08) / 0.92).clamp(0.0, 1.0);
    final opacity = (gated * (1.0 - gated)) * 0.92;

    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _RadarFillPainter oldDelegate) {
    return oldDelegate.t != t ||
        oldDelegate.color != color ||
        oldDelegate.minRadius != minRadius ||
        oldDelegate.maxRadius != maxRadius;
  }
}

const _kMapProperties = <_MapProperty>[
  _MapProperty(
    dx: -20,
    dy: -170,
    image: 'assets/images/chambre.jpg',
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
    image: 'assets/images/chambre4.jpg',
    title: 'Suite Luxueuse',
    location: "Cocody Angré, Abidjan – Côte d'Ivoire",
  ),
  _MapProperty(
    dx: -90,
    dy: 110,
    image: 'assets/images/chambre13.jpg',
    title: 'Appartement Vue Panoramique',
    location: "Cocody Les Jardins, Abidjan – Côte d'Ivoire",
  ),
  _MapProperty(
    dx: 100,
    dy: 110,
    image: 'assets/images/chambre11.jpg',
    title: 'Salon Moderne à Cocody',
    location: "Cocody II Plateaux, Abidjan – Côte d'Ivoire",
  ),
];

class MapSearchTab extends StatefulWidget {
  const MapSearchTab({super.key, required this.isActive});

  final bool isActive;

  @override
  State<MapSearchTab> createState() => _MapSearchTabState();
}

class _MapSearchTabState extends State<MapSearchTab> {
  int? _selected;
  final Map<String, bool> _favoriteStates = {};

  void _toggle(int i) {
    setState(() => _selected = _selected == i ? null : i);
  }

  void _toggleFavorite(String propertyId) {
    FavoritesStore.instance.toggle(propertyId);
    setState(() {
      _favoriteStates[propertyId] =
          FavoritesStore.instance.isFavorite(propertyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected != null ? _kMapProperties[_selected!] : null;

    return Stack(
      children: [
        // ── Map background (use image asset if available, otherwise tint)
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFE9EEF3),
              image: DecorationImage(
                image: AssetImage('assets/images/map_bg.png'),
                fit: BoxFit.cover,
                opacity: 0.98,
              ),
            ),
            // subtle overlay to match original tint
            child: Container(color: const Color(0x55FFFFFF)),
          ),
        ),

        // ── Radius + avatar + pins
        Positioned.fill(
          child: _MapOverlay(
            properties: _kMapProperties,
            selectedIndex: _selected,
            onPinTap: _toggle,
            isActive: widget.isActive,
          ),
        ),

        // ── Top address card
        Positioned(
          top: 10,
          left: 14,
          right: 14,
          child: _AddressCard(
            onChange: () {
              context.push(AppRoutes.addressSearch);
            },
          ),
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
                  isFavorite: _favoriteStates[
                          'map-${selected.title}-${selected.location}'] ??
                      false,
                  onFavoriteToggle: () => _toggleFavorite(
                    'map-${selected.title}-${selected.location}',
                  ),
                  onTap: () {
                    context.push(
                      AppRoutes.propertyDetails,
                      extra: PropertyDetailsArgs(
                        propertyId:
                            'map-${selected.title}-${selected.location}',
                        coverImageFallback: selected.image,
                        mockTitle: selected.title,
                        mockLocation: selected.location,
                        mockPrice: '250 000 Fcfa',
                        mockDescription:
                            'Situé au cœur de Cocody Angré, l\'un des quartiers les plus recherchés pour son équilibre entre confort moderne, sécurité et proximité avec les services essentiels, ce bien offre un cadre de vie exceptionnel.',
                        mockBeds: 6,
                        mockBaths: 4,
                        mockKitchens: 1,
                      ),
                    );
                  },
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
  const _AddressCard({required this.onChange});

  final VoidCallback onChange;

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
            onTap: onChange,
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
    required this.isActive,
  });

  final List<_MapProperty> properties;
  final int? selectedIndex;
  final ValueChanged<int> onPinTap;
  final bool isActive;

  @override
  State<_MapOverlay> createState() => _MapOverlayState();
}

class _MapOverlayState extends State<_MapOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _pulse;
  int _revealedPins = 0;
  Timer? _pinRevealTimer;
  // Per-pin animation controllers for fade + slide
  late List<AnimationController> _pinControllers;
  late List<Animation<double>> _pinOpacities;
  late List<Animation<double>> _pinSlidesY;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // initialize pin animations
    _initPinAnimations(widget.properties.length);

    _revealedPins = widget.properties.isEmpty ? 0 : 1;

    if (widget.isActive) {
      _start();
    }
  }

  void _start() {
    _pulse.repeat();
    _pinRevealTimer?.cancel();
    _pinRevealTimer = Timer.periodic(const Duration(milliseconds: 280), (_) {
      if (!mounted) return;
      final next = (_revealedPins + 1).clamp(0, widget.properties.length);
      if (next == _revealedPins) return;
      setState(() {
        _revealedPins = next;
      });
      // start animations for all revealed pins with 60ms stagger
      for (var j = 0; j < _revealedPins && j < _pinControllers.length; j++) {
        final controller = _pinControllers[j];
        if (controller.status == AnimationStatus.dismissed) {
          Future.delayed(Duration(milliseconds: 60 * j), () {
            if (mounted) controller.forward();
          });
        }
      }
    });
  }

  void _stop() {
    _pulse.stop();
    _pinRevealTimer?.cancel();
    _pinRevealTimer = null;
  }

  void _resetPins() {
    setState(() {
      _revealedPins = widget.properties.isEmpty ? 0 : 1;
    });
    for (final c in _pinControllers) {
      c.reset();
    }
    if (_pinControllers.isNotEmpty && _revealedPins > 0) {
      _pinControllers.first.forward();
    }
  }

  void _initPinAnimations(int count) {
    // dispose previous if any
    _pinControllers = List.generate(
      count,
      (_) => AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200)),
    );

    _pinOpacities = _pinControllers
        .map((c) => Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();
    _pinSlidesY = _pinControllers
        .map((c) => Tween<double>(begin: 12.0, end: 0.0)
            .animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();
  }

  @override
  void dispose() {
    _pulse.dispose();
    _pinRevealTimer?.cancel();
    for (final c in _pinControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _MapOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.properties.length != widget.properties.length) {
      // recreate pin controllers
      for (final c in _pinControllers) {
        c.dispose();
      }
      _initPinAnimations(widget.properties.length);
    }

    if (!oldWidget.isActive && widget.isActive) {
      _resetPins();
      _start();
    } else if (oldWidget.isActive && !widget.isActive) {
      _stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final center = Offset(w / 2, h * 0.5);
        const outerR = 190.0;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedBuilder(
              animation: _pulse,
              builder: (context, _) {
                final t = Curves.easeOut.transform(_pulse.value);

                const avatarR = 78.6 / 2;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Outer radius (static)
                    Positioned(
                      left: center.dx - outerR,
                      top: center.dy - outerR,
                      child: Container(
                        width: outerR * 2,
                        height: outerR * 2,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.18),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Scanning fill: darker background that starts behind avatar and expands to outer radius
                    Positioned(
                      left: center.dx - outerR,
                      top: center.dy - outerR,
                      child: IgnorePointer(
                        child: CustomPaint(
                          size: const Size(outerR * 2, outerR * 2),
                          painter: _RadarFillPainter(
                            color: AppColors.primary,
                            t: t,
                            minRadius: avatarR + 6,
                            maxRadius: outerR,
                          ),
                        ),
                      ),
                    ),
                    // Inner radius — orange background behind the avatar (radar)
                    // Positioned(
                    //   left: center.dx - innerR,
                    //   top: center.dy - innerR,
                    //   child: Transform.scale(
                    //     scale: innerScale,
                    //     child: Container(
                    //       width: innerR * 2,
                    //       height: innerR * 2,
                    //       decoration: BoxDecoration(
                    //         color: AppColors.primary.withOpacity(innerOpacity),
                    //         shape: BoxShape.circle,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Avatar (center) — orange ring + photo
                    Positioned(
                      left: center.dx - 98 / 2,
                      top: center.dy - 98 / 2,
                      child: Container(
                        width: 98,
                        height: 98,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x22000000),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: BlocBuilder<AuthBloc, AuthState>(
                          buildWhen: (prev, next) =>
                              prev.currentUser?.avatarUrl !=
                              next.currentUser?.avatarUrl,
                          builder: (context, state) {
                            final rawUrl = state.currentUser?.avatarUrl;
                            final hasUrl =
                                rawUrl != null && rawUrl.trim().isNotEmpty;
                            final cacheKey = (state.currentUser?.updatedAt ??
                                state.currentUser?.userId ??
                                '');
                            final url = rawUrl ?? '';
                            final cacheBustedUrl = hasUrl
                                ? (url.contains('?')
                                    ? '$url&v=$cacheKey'
                                    : '$url?v=$cacheKey')
                                : null;

                            return CircleAvatar(
                              radius: 37,
                              backgroundColor: const Color(0xFFD0DDE8),
                              backgroundImage: hasUrl
                                  ? NetworkImage(cacheBustedUrl!)
                                      as ImageProvider
                                  : null,
                              child: hasUrl
                                  ? null
                                  : const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // ── Pins (reveal one per radar pulse)
            Stack(
              clipBehavior: Clip.none,
              children: [
                for (var i = 0; i < widget.properties.length; i++)
                  _pinAt(
                    center,
                    widget.properties[i].dx,
                    widget.properties[i].dy,
                    widget.properties[i].image,
                    index: i,
                    selected: widget.selectedIndex == i,
                    onTap: () => widget.onPinTap(i),
                  ),
              ],
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
    required int index,
    required bool selected,
    required VoidCallback onTap,
  }) {
    const pinW = 58.0;
    const pinH = 72.0;
    // Pin tip (dx, dy) maps to (center + dx, center + dy).
    final tipX = center.dx + dx;
    final tipY = center.dy + dy;

    final visible = index < _revealedPins;

    // compute fade duration as portion of the pulse duration so opacity
    // change is synced with the radar pulse. Use 60% of the pulse.
    // The actual animated widget below uses per-pin controllers; we keep
    // fade behaviour driven by the per-pin controllers started on reveal.
    final animIndex = index;
    Widget pinChild = _Pin(image: image, selected: selected);

    if (animIndex < _pinControllers.length) {
      pinChild = AnimatedBuilder(
        animation: _pinControllers[animIndex],
        builder: (context, child) {
          final opacity = _pinOpacities[animIndex].value;
          final dy = _pinSlidesY[animIndex].value;
          return Opacity(
            opacity: visible ? opacity : 0.0,
            child: Transform.translate(
              offset: Offset(0, dy),
              child: child,
            ),
          );
        },
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: pinChild,
        ),
      );
    } else {
      pinChild = GestureDetector(
          onTap: onTap, behavior: HitTestBehavior.opaque, child: pinChild);
    }

    return Positioned(left: tipX - pinW / 2, top: tipY - pinH, child: pinChild);
  }
}

// ─── Teardrop pin with property image ────────────────────────────────────────

class _Pin extends StatelessWidget {
  const _Pin({required this.image, required this.selected});

  final String image;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 72,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          if (selected)
            Positioned.fill(
              child: Opacity(
                opacity: 0.18,
                child: CustomPaint(
                  size: const Size(58, 72),
                  painter: _PinPainter(color: AppColors.primary),
                ),
              ),
            ),
          // Teardrop background
          CustomPaint(
            size: const Size(58, 72),
            painter: _PinPainter(
                color: selected ? AppColors.primary : AppColors.dark),
          ),
          // Image disc with white + orange rings
          Positioned(
            top: 4,
            child: Container(
              width: 48,
              height: 52,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(2),
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
