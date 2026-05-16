import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';
import 'package:statefulclickcounter/features/customer/hotels/screens/hotel_reservation_details_screen.dart';
import 'package:statefulclickcounter/features/customer/home/screens/home_screen.dart';
import 'package:statefulclickcounter/core/navigation/app_router.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _Amenity {
  const _Amenity(this.icon, this.label);
  final IconData icon;
  final String label;
}

const _kAmenities = [
  _Amenity(Icons.ac_unit_rounded, 'Climatisation'),
  _Amenity(Icons.restaurant_rounded, 'Restaurant'),
  _Amenity(Icons.pool_rounded, 'Piscine'),
  _Amenity(Icons.schedule_rounded, 'Reception\n24h/24'),
];

class _Review {
  const _Review(this.name, this.avatar, this.rating, this.text);
  final String name;
  final String avatar;
  final double rating;
  final String text;
}

const _kReviews = [
  _Review(
    'Marie K',
    'assets/images/villa9.jpg',
    4.6,
    "Emplacement parfait pour le travail. L'appartement est pratique et lumineux",
  ),
  _Review(
    'Ali S',
    'assets/images/sara2.jpg',
    4.5,
    'Appartement très confortable et bien situé. Tout était propre et fonctionnel.',
  ),
  _Review(
    'Kim Borrdy',
    'assets/images/pexels-ekrulila-2128329.jpg',
    4.5,
    'Super accueil et appartement moderne. Je recommande vivement !',
  ),
];

class _RecommendedHotel {
  const _RecommendedHotel({
    required this.image,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
  });
  final String image;
  final String name;
  final String location;
  final int price;
  final double rating;
}

const _kRecommended = [
  _RecommendedHotel(
    image: 'assets/images/chambre11.jpg',
    name: 'Hôtel Ébène City',
    location: 'Plateau, Abidjan',
    price: 70000,
    rating: 4.8,
  ),
  _RecommendedHotel(
    image: 'assets/images/chambre11.jpg',
    name: 'Suite Prestige',
    location: 'Cocody Riviera, Abidjan',
    price: 85000,
    rating: 4.9,
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class HotelDetailsScreen extends StatefulWidget {
  const HotelDetailsScreen({
    super.key,
    required this.imagePath,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
  });

  final String imagePath;
  final String name;
  final String location;
  final int price;
  final double rating;

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  static const _extraGallery = [
    'assets/images/chambre11.jpg',
    'assets/images/chambre12.jpg',
    'assets/images/chambre4.jpg',
    'assets/images/villa9.jpg',
    'assets/images/villa7.jpg',
    'assets/images/villa6.jpg',
  ];

  late List<String> _gallery;
  late String _currentImage;
  bool _galleryExpanded = false;

  @override
  void initState() {
    super.initState();
    _gallery = [widget.imagePath, ..._extraGallery];
    _currentImage = widget.imagePath;
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Hero image
                  Stack(
                    children: [
                      Image.asset(
                        _currentImage,
                        height: 280,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 280,
                          color: const Color(0xFFD0DDE8),
                        ),
                      ),
                      // Gradient overlay
                      Container(
                        height: 100,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0x88000000), Colors.transparent],
                          ),
                        ),
                      ),
                      // Back + title
                      Positioned(
                        top: topPadding + 8,
                        left: 18,
                        right: 18,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                  size: 20),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Détails du bien',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Thumbnail strip
                      Positioned(
                        top: 65,
                        right: 18,
                        child: Container(
                          width: 44,
                          height: 190,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: ScrollConfiguration(
                            behavior: const _NoGlowBehavior(),
                            child: SingleChildScrollView(
                              physics: _galleryExpanded
                                  ? const BouncingScrollPhysics()
                                  : const NeverScrollableScrollPhysics(),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  for (var i = 0;
                                      i <
                                              (_galleryExpanded
                                                  ? _gallery.length
                                                  : 3) &&
                                          i < _gallery.length;
                                      i++) ...[
                                    _ThumbCircle(
                                      image: _gallery[i],
                                      onTap: () => setState(
                                          () => _currentImage = _gallery[i]),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                  _ThumbCircleMore(
                                    countText:
                                        '+${(_gallery.length - 3).clamp(0, 99)}',
                                    onTap: () => setState(() =>
                                        _galleryExpanded = !_galleryExpanded),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ── Content
                  Transform.translate(
                    offset: const Offset(0, -8),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            widget.name,
                            style: AppTextStyles.sectionTitle.copyWith(
                              color: AppColors.text,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Location + rating
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: AppColors.primary, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                widget.location,
                                style: AppTextStyles.regular12.copyWith(
                                  color: AppColors.text,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.star_rounded,
                                  color: Color(0xFFFACC15), size: 16),
                              const SizedBox(width: 2),
                              Text(
                                widget.rating.toString(),
                                style: const TextStyle(
                                  color: AppColors.text,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // ── Installations
                          Row(
                            children: [
                              Text(
                                'installations communes',
                                style: AppTextStyles.sectionTitle.copyWith(
                                  color: AppColors.text,
                                  fontSize: 15,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Tout voir',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: _kAmenities
                                .map((a) => _AmenityIcon(
                                      icon: a.icon,
                                      label: a.label,
                                    ))
                                .toList(),
                          ),

                          const SizedBox(height: 24),

                          // ── Description
                          Text(
                            'Description',
                            style: AppTextStyles.sectionTitle.copyWith(
                              color: AppColors.text,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Situé au cœur de Cocody Angré, l\'un des quartiers les plus recherchés pour son équilibre entre confort moderne, sécurité et proximité avec les services essentiels',
                            style: AppTextStyles.regular12.copyWith(
                              color: AppColors.text,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ── Adresse
                          Row(
                            children: [
                              Text(
                                'Adresse',
                                style: AppTextStyles.sectionTitle.copyWith(
                                  color: AppColors.text,
                                  fontSize: 15,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  homeRequestedTabIndex.value = 2;
                                  context.go(AppRoutes.home);
                                },
                                child: const Text(
                                  'Ouvrir la carte',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Map placeholder
                          Container(
                            height: 140,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(16),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/Map.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            alignment: Alignment.center,
                            // child: Container(
                            //   width: 36,
                            //   height: 36,
                            //   decoration: const BoxDecoration(
                            //     shape: BoxShape.circle,
                            //     color: AppColors.primary,
                            //   ),
                            //   alignment: Alignment.center,
                            //   child: const Icon(Icons.location_on,
                            //       color: Colors.white, size: 20),
                            // ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  color: AppColors.primary, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                widget.location,
                                style: AppTextStyles.regular12.copyWith(
                                  color: AppColors.text,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // ── Reviews
                          Row(
                            children: [
                              Text(
                                'Reviews',
                                style: AppTextStyles.sectionTitle.copyWith(
                                  color: AppColors.text,
                                  fontSize: 15,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Tout voir',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ..._kReviews.map(
                            (r) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _ReviewCard(review: r),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // ── Recommandés
                          Text(
                            'Recommandés pour vous',
                            style: AppTextStyles.sectionTitle.copyWith(
                              color: AppColors.text,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ..._kRecommended.map(
                            (h) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _RecommendedCard(hotel: h),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom bar
          Container(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 10,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Prix',
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.text,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${_fmt(widget.price)} ',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                            const TextSpan(
                              text: 'fCFA ',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const TextSpan(
                              text: '/Nuit',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Reserve button
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.dark,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => HotelReservationDetailsScreen(
                              imagePath: _currentImage,
                              name: widget.name,
                              location: widget.location,
                              price: widget.price,
                              rating: widget.rating,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Reserver',
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

  static String _fmt(int value) {
    final s = value.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buf.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(' ');
    }
    return buf.toString().trim();
  }
}

// ─── Amenity icon ─────────────────────────────────────────────────────────────

class _AmenityIcon extends StatelessWidget {
  const _AmenityIcon({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.dark, size: 26),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// ─── Review card ──────────────────────────────────────────────────────────────

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final _Review review;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        ClipOval(
          child: Image.asset(
            review.avatar,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 40,
              height: 40,
              color: const Color(0xFFD0DDE8),
              child: const Icon(Icons.person, color: AppColors.dark),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name + rating
              Row(
                children: [
                  Text(
                    review.name,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.star_rounded,
                      color: Color(0xFFFACC15), size: 16),
                  const SizedBox(width: 2),
                  Text(
                    review.rating.toString(),
                    style: const TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                review.text,
                style: AppTextStyles.regular12.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Recommended card ─────────────────────────────────────────────────────────

class _RecommendedCard extends StatelessWidget {
  const _RecommendedCard({required this.hotel});

  final _RecommendedHotel hotel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              hotel.image,
              width: 88,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 88,
                height: 70,
                color: const Color(0xFFE2E8F0),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + rating
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        hotel.name,
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.text,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.star_rounded,
                        color: Color(0xFFFACC15), size: 14),
                    const SizedBox(width: 2),
                    Text(
                      hotel.rating.toString(),
                      style: const TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 13, color: AppColors.dark),
                    const SizedBox(width: 3),
                    Text(
                      hotel.location,
                      style: AppTextStyles.regular12.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Price
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${_fmtPrice(hotel.price)} FCFA',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      const TextSpan(
                        text: '/ nuit',
                        style: TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _fmtPrice(int value) {
    final s = value.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buf.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(' ');
    }
    return buf.toString().trim();
  }
}

// ─── Thumb circle ─────────────────────────────────────────────────────────────

class _ThumbCircle extends StatelessWidget {
  const _ThumbCircle({required this.image, this.onTap});

  final String image;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ClipOval(
        child: Image.asset(
          image,
          width: 38,
          height: 38,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 38,
            height: 38,
            color: const Color(0xFFD0DDE8),
          ),
        ),
      ),
    );
  }
}

class _ThumbCircleMore extends StatelessWidget {
  const _ThumbCircleMore({required this.countText, required this.onTap});

  final String countText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(23),
      child: Container(
        width: 33,
        height: 33,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          countText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _NoGlowBehavior extends ScrollBehavior {
  const _NoGlowBehavior();

  @override
  Widget buildOverscrollIndicator(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;
}
