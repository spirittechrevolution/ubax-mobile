import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class View360Screen extends StatefulWidget {
  const View360Screen({
    super.key,
    required this.imagePath,
    required this.title,
    required this.location,
    required this.beds,
    required this.baths,
    required this.kitchens,
  });

  final String imagePath;
  final String title;
  final String location;
  final int beds;
  final int baths;
  final int kitchens;

  @override
  State<View360Screen> createState() => _View360ScreenState();
}

class _View360ScreenState extends State<View360Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isFavorite = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dimensions RÉELLES sans SafeArea pour couvrir tout l'écran
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── IMAGE PANORAMIQUE 360 ──────────────────────────────────
                Positioned.fill(
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      if (_scrollController.hasClients) {
                        final newOffset =
                            _scrollController.offset - details.delta.dx;
                        _scrollController.jumpTo(
                          newOffset.clamp(
                            0.0,
                            _scrollController.position.maxScrollExtent,
                          ),
                        );
                      }
                    },
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: SizedBox(
                        width: screenWidth * 2.5,
                        height: screenHeight,
                        child: Image.asset(
                          widget.imagePath,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.medium,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFF111111),
                            child: const Center(
                              child: Icon(
                                Icons.panorama_outlined,
                                color: Colors.white24,
                                size: 80,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── GRADIENT OVERLAY ───────────────────────────────────────
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.55),
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withOpacity(0.80),
                          ],
                          stops: const [0.0, 0.2, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

                // ── HEADER ─────────────────────────────────────────────────
                Positioned(
                  top: topPadding + 8,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: _GlassButton(
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      Text(
                        "Vue 360°",
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: Colors.white,
                          fontSize: 17,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(width: 38),
                    ],
                  ),
                ),

                // ── BOTTOM CONTENT ─────────────────────────────────────────
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: bottomPadding + 16,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icônes contrôle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          _ControlHint(
                            icon: Icons.pinch_outlined,
                            label: "Pincez\npour Zoomer",
                          ),
                          _ControlHint(
                            icon: Icons.swap_horiz_rounded,
                            label: "Glissez\npour Naviguer",
                          ),
                          _ControlHint(
                            icon: Icons.touch_app_outlined,
                            label: "Taper\npour Sélectionner",
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Card propriété
                      _PropertyCard(
                        imagePath: widget.imagePath,
                        title: widget.title,
                        location: widget.location,
                        beds: widget.beds,
                        baths: widget.baths,
                        kitchens: widget.kitchens,
                        isFavorite: _isFavorite,
                        onFavoriteTap: () =>
                            setState(() => _isFavorite = !_isFavorite),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _GlassButton extends StatelessWidget {
  const _GlassButton({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Center(child: child),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _ControlHint extends StatelessWidget {
  const _ControlHint({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 7),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _PropertyCard extends StatelessWidget {
  const _PropertyCard({
    required this.imagePath,
    required this.title,
    required this.location,
    required this.beds,
    required this.baths,
    required this.kitchens,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  final String imagePath;
  final String title;
  final String location;
  final int beds;
  final int baths;
  final int kitchens;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 119,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              imagePath,
              width: 125,
              height: 102,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 125,
                height: 102,
                color: const Color(0xFFEEEEEE),
                child: const Icon(Icons.home_outlined, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.text,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: onFavoriteTap,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, anim) =>
                            ScaleTransition(scale: anim, child: child),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          key: ValueKey(isFavorite),
                          color: const Color(0xFFEF4444),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 12, color: AppColors.primary),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        location,
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.text,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                Wrap(
                  spacing: 8,
                  runSpacing: 3,
                  children: [
                    _Meta(
                        icon: Icons.bed_rounded,
                        text: '$beds  Chambres'),
                    _Meta(
                        icon: Icons.bathtub_outlined,
                        text: '$baths  Salle de bains'),
                    _Meta(
                        icon: Icons.kitchen_rounded,
                        text: '$kitchens  Cuisine'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: AppColors.primary),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Lexend',
            color: AppColors.text,
            fontSize: 7,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
