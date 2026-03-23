import 'package:flutter/material.dart';
import 'package:statefulclickcounter/features/customer/home/screens/appointment_booking_screen.dart';
import 'package:statefulclickcounter/features/customer/home/screens/payment/reservation_payment_screen.dart';
import 'package:statefulclickcounter/features/customer/home/screens/proprety/view_360_screen.dart';

class PropertyDetailsScreen extends StatelessWidget {
  const PropertyDetailsScreen({
    super.key,
    required this.imagePath,
    required this.title,
    required this.location,
    required this.price,
    required this.beds,
    required this.baths,
    required this.kitchens,
  });

  final String imagePath;
  final String title;
  final String location;
  final String price;
  final int beds;
  final int baths;
  final int kitchens;

  static const _bg = Color(0xFFEEF3F7);
  static const _dark = Color(0xFF1E2D3C);
  static const _orange = Color(0xFFE67E22);

  static const _textMuted = Color(0xFF8A97A6);

  static int _parseAmount(String raw) {
    final digits =
        RegExp(r'\d+').allMatches(raw).map((m) => m.group(0)!).join();
    if (digits.isEmpty) return 0;
    return int.tryParse(digits) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final headerHeight = (size.height * 0.40).clamp(280.0, 440.0);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _BottomActions(
        onInterested: () {
          final rentAmount = _parseAmount(price);
          final advance = (rentAmount * 0.5).round();
          final deposit = (rentAmount * 0.5).round();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ReservationPaymentScreen(
                imagePath: imagePath,
                title: title,
                location: location,
                beds: beds,
                baths: baths,
                kitchens: kitchens,
                advanceAmount: advance,
                depositAmount: deposit,
              ),
            ),
          );
        },
        onBookVisit: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AppointmentBookingScreen(
                title: title,
                location: location,
              ),
            ),
          );
        },
      ),
      body: Column(
        children: [
          _Header(
            height: headerHeight,
            imagePath: imagePath,
            onBack: () => Navigator.of(context).pop(),
            onFavorite: () {},
            onView360: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => View360Screen(
                    imagePath: imagePath,
                    title: title,
                    location: location,
                    beds: beds,
                    baths: baths,
                    kitchens: kitchens,
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -18),
              child: _Content(
                title: title,
                price: price,
                location: location,
                beds: beds,
                baths: baths,
                kitchens: kitchens,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.onInterested, required this.onBookVisit});

  final VoidCallback onInterested;
  final VoidCallback onBookVisit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PropertyDetailsScreen._orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: onInterested,
                child: const Text(
                  'Je suis intéressée',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PropertyDetailsScreen._dark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: onBookVisit,
                icon: const Icon(Icons.calendar_month_rounded),
                label: const Text(
                  'Réserver une visite',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.height,
    required this.imagePath,
    required this.onBack,
    required this.onFavorite,
    required this.onView360,
  });

  final double height;
  final String imagePath;
  final VoidCallback onBack;
  final VoidCallback onFavorite;
  final VoidCallback onView360;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(imagePath, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.35),
                  Colors.transparent,
                  Colors.black.withOpacity(0.10),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                14,
                MediaQuery.paddingOf(context).top + 6,
                14,
                0,
              ),
              child: Row(
                children: [
                  _CircleIcon(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: onBack,
                  ),
                  const Spacer(),
                  const Text(
                    'Détails',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  _CircleIcon(
                    icon: Icons.favorite_border_rounded,
                    onTap: onFavorite,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 130,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.22),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  _GalleryThumb(imagePath: imagePath),
                  const SizedBox(height: 8),
                  _GalleryThumb(imagePath: imagePath),
                  const SizedBox(height: 8),
                  _GalleryThumb(imagePath: imagePath),
                  const SizedBox(height: 8),
                  _GalleryMore(countText: '+4', onTap: () {}),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 40,
            child: InkWell(
              onTap: onView360,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.66),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Vue 360',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
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

class _Content extends StatelessWidget {
  const _Content({
    required this.title,
    required this.location,
    required this.price,
    required this.beds,
    required this.baths,
    required this.kitchens,
  });

  final String title;
  final String location;
  final String price;
  final int beds;
  final int baths;
  final int kitchens;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 18,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: PropertyDetailsScreen._dark,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: PropertyDetailsScreen._orange,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          price,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: PropertyDetailsScreen._orange, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            color: PropertyDetailsScreen._textMuted,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _SpecChip(
                          icon: Icons.bed_rounded,
                          value: '$beds',
                          label: 'Chambres',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SpecChip(
                          icon: Icons.bathtub_rounded,
                          value: '$baths',
                          label: 'Salle de bains',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SpecChip(
                          icon: Icons.kitchen_rounded,
                          value: '$kitchens',
                          label: 'Cuisine',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Description',
              style: TextStyle(
                color: PropertyDetailsScreen._orange,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Situé au cœur de Cocody Angré, l\'un des quartiers les plus recherchés pour son équilibre entre confort moderne, sécurité et proximité avec les services essentiels, cet appartement 3 pièces offre un cadre de vie exceptionnel, pensé pour répondre aux besoins d\'une famille, d\'un cadre ou d\'un investisseur à la recherche d\'un bien de qualité.',
              style: TextStyle(
                color: PropertyDetailsScreen._textMuted,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: PropertyDetailsScreen._bg,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.home_rounded,
                        color: PropertyDetailsScreen._dark),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aigle Immobilier',
                          style: TextStyle(
                            color: PropertyDetailsScreen._dark,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Agence Immobilière',
                          style: TextStyle(
                            color: PropertyDetailsScreen._textMuted,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _MiniAction(icon: Icons.chat_bubble_outline),
                  const SizedBox(width: 10),
                  _MiniAction(icon: Icons.person_outline_rounded),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.20),
          borderRadius: BorderRadius.circular(22),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

class _GalleryThumb extends StatelessWidget {
  const _GalleryThumb({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        imagePath,
        width: 30,
        height: 30,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _GalleryMore extends StatelessWidget {
  const _GalleryMore({required this.countText, required this.onTap});

  final String countText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(23),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
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

class _SpecChip extends StatelessWidget {
  const _SpecChip({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFE67E22), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF1E2D3C),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF8A97A6),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniAction extends StatelessWidget {
  const _MiniAction({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D3C),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: Colors.white),
    );
  }
}
