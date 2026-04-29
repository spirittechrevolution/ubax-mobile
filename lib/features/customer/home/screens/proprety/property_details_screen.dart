import 'package:flutter/material.dart';
import 'package:statefulclickcounter/features/customer/chat/screens/chat_screen.dart';
import 'package:statefulclickcounter/features/customer/home/screens/appointment_booking_screen.dart';
import 'package:statefulclickcounter/features/customer/home/screens/payment/reservation_payment_screen.dart';
import 'package:statefulclickcounter/features/customer/home/screens/proprety/view_360_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class PropertyDetailsScreen extends StatefulWidget {
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

  static const _bg = AppColors.background;
  static const _dark = AppColors.dark;
  static const _orange = AppColors.primary;
  static const text = AppColors.text;

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  static const _extraGallery = [
    'assets/images/modern-elegant-living-room-interior-with-abstract-art.jpg',
    'assets/images/cozy-living-room-interior-with-panoramic-window.jpg',
    'assets/images/modern-luxurious-bedroom-interior-design.jpg',
    'assets/images/modern-elegant-bedroom-interior.jpg',
    'assets/images/luxurious-modern-living-room-with-blue-wall-white-sofa.jpg',
    'assets/images/appartements-luxe.jpg',
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
          final rentAmount = _parseAmount(widget.price);
          final advance = (rentAmount * 0.5).round();
          final deposit = (rentAmount * 0.5).round();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ReservationPaymentScreen(
                imagePath: _currentImage,
                title: widget.title,
                location: widget.location,
                beds: widget.beds,
                baths: widget.baths,
                kitchens: widget.kitchens,
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
                title: widget.title,
                location: widget.location,
              ),
            ),
          );
        },
      ),
      body: Column(
        children: [
          _Header(
            height: headerHeight,
            imagePath: _currentImage,
            gallery: _gallery,
            galleryExpanded: _galleryExpanded,
            onToggleGallery: () =>
                setState(() => _galleryExpanded = !_galleryExpanded),
            onSelectImage: (path) => setState(() => _currentImage = path),
            onBack: () => Navigator.of(context).pop(),
            onFavorite: () {},
            onView360: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => View360Screen(
                    imagePath: _currentImage,
                    title: widget.title,
                    location: widget.location,
                    beds: widget.beds,
                    baths: widget.baths,
                    kitchens: widget.kitchens,
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -8),
              child: _Content(
                title: widget.title,
                price: widget.price,
                location: widget.location,
                beds: widget.beds,
                baths: widget.baths,
                kitchens: widget.kitchens,
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
            Container(
              height: 61,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE7E7E7), width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      // color: PropertyDetailsScreen._bg,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.home_rounded,
                        color: PropertyDetailsScreen.text),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Aigle Immobilier',
                            style: AppTextStyles.sectionTitle.copyWith(
                                color: PropertyDetailsScreen.text,
                                fontSize: 13),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Agence Immobilière',
                            style: AppTextStyles.regular12.copyWith(
                                color: PropertyDetailsScreen.text,
                                fontWeight: FontWeight.w300,
                                fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _MiniAction(
                    icon: Icons.chat_bubble_outline,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ChatScreen()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _MiniAction(icon: Icons.person_outline_rounded),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 49,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PropertyDetailsScreen._orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: onInterested,
                child: const Text(
                  'Je suis intéressée',
                  style: AppTextStyles.button,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 49,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PropertyDetailsScreen._dark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: onBookVisit,
                icon: const Icon(
                  Icons.calendar_month_rounded,
                  size: 24,
                ),
                label: const Text(
                  'Réserver une visite',
                  style: AppTextStyles.button,
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
    required this.gallery,
    required this.galleryExpanded,
    required this.onToggleGallery,
    required this.onSelectImage,
    required this.onBack,
    required this.onFavorite,
    required this.onView360,
  });

  final double height;
  final String imagePath;
  final List<String> gallery;
  final bool galleryExpanded;
  final VoidCallback onToggleGallery;
  final ValueChanged<String> onSelectImage;
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
                  Text(
                    'Détails',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: Colors.white,
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
            top: 135,
            child: Container(
              width: 54,
              height: 211,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.22),
                borderRadius: BorderRadius.circular(50),
              ),
              child: ScrollConfiguration(
                behavior: const _NoGlowBehavior(),
                child: SingleChildScrollView(
                  physics: galleryExpanded
                      ? const BouncingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var i = 0;
                          i < (galleryExpanded ? gallery.length : 3) &&
                              i < gallery.length;
                          i++) ...[
                        _GalleryThumb(
                          imagePath: gallery[i],
                          onTap: () => onSelectImage(gallery[i]),
                        ),
                        const SizedBox(height: 8),
                      ],
                      _GalleryMore(
                        countText: '+${(gallery.length - 3).clamp(0, 99)}',
                        onTap: onToggleGallery,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 15,
            bottom: 20,
            child: InkWell(
              onTap: onView360,
              borderRadius: BorderRadius.circular(22.5),
              child: Container(
                width: 113,
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xA1000000),
                  borderRadius: BorderRadius.circular(22.5),
                ),
                child: Text('Vue 360',
                    style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white)),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
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
              height: 132,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
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
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: PropertyDetailsScreen._dark,
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
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: PropertyDetailsScreen._orange, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          location,
                          style: AppTextStyles.regular12.copyWith(
                            color: PropertyDetailsScreen.text,
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
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
            Text(
              'Description',
              style: AppTextStyles.sectionTitle.copyWith(
                color: PropertyDetailsScreen._orange,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Situé au cœur de Cocody Angré, l\'un des quartiers les plus recherchés pour son équilibre entre confort moderne, sécurité et proximité avec les services essentiels, cet appartement 3 pièces offre un cadre de vie exceptionnel, pensé pour répondre aux besoins d\'une famille, d\'un cadre ou d\'un investisseur à la recherche d\'un bien de qualité.',
              style: AppTextStyles.regular12.copyWith(
                color: PropertyDetailsScreen.text,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Détails & Commodités',
              style: AppTextStyles.sectionTitle.copyWith(
                color: PropertyDetailsScreen._orange,
              ),
            ),
            const SizedBox(height: 12),
            const _AmenitiesGrid(),
            const SizedBox(height: 18),
            Text(
              'Localisation',
              style: AppTextStyles.sectionTitle.copyWith(
                color: PropertyDetailsScreen._orange,
              ),
            ),
            const SizedBox(height: 12),
            const _LocationCard(),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

class _AmenitiesGrid extends StatelessWidget {
  const _AmenitiesGrid();

  static const _items = [
    _AmenityData(Icons.open_in_full_rounded, 'Surface', '150m²'),
    _AmenityData(Icons.ac_unit_rounded, 'Climatisation', '2'),
    _AmenityData(Icons.stairs_rounded, 'Etage', '2ème'),
    _AmenityData(Icons.local_pharmacy_outlined, 'Pharmacie', '300m'),
    _AmenityData(Icons.local_hospital_outlined, 'Clinique', '700 m'),
    _AmenityData(Icons.restaurant_rounded, 'Restaurant', '50m'),
    _AmenityData(Icons.account_balance_outlined, 'Banque', '1.5 Km'),
    _AmenityData(Icons.shopping_cart_outlined, 'Supermarché', '500m'),
    _AmenityData(Icons.local_gas_station_outlined, 'Stations', '1km'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (row) {
        return Padding(
          padding: EdgeInsets.only(bottom: row == 2 ? 0 : 10),
          child: Row(
            children: List.generate(3, (col) {
              final item = _items[row * 3 + col];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: col == 2 ? 0 : 8),
                  child: _AmenityCard(item: item),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

class _AmenityData {
  const _AmenityData(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;
}

class _AmenityCard extends StatelessWidget {
  const _AmenityCard({required this.item});
  final _AmenityData item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 27.22,
            height: 27.22,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
            ),
            alignment: Alignment.center,
            child: Icon(item.icon,
                color: PropertyDetailsScreen._dark, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: AppTextStyles.regular12.copyWith(
                    color: PropertyDetailsScreen.text,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    height: 1.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.value,
                  style: AppTextStyles.regular12.copyWith(
                    color: PropertyDetailsScreen._orange,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
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

class _LocationCard extends StatelessWidget {
  const _LocationCard();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 170,
            width: double.infinity,
            color: const Color(0xFFE9EEF3),
            alignment: Alignment.center,
            child: const Icon(Icons.map_rounded,
                color: Color(0xFFB8C4D0), size: 60),
          ),
        ),
        Positioned(
          right: 14,
          bottom: 14,
          child: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: PropertyDetailsScreen._orange,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.map_outlined,
                color: Colors.white, size: 22),
          ),
        ),
      ],
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
  const _GalleryThumb({required this.imagePath, this.onTap});

  final String imagePath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ClipOval(
        child: Image.asset(
          imagePath,
          width: 38,
          height: 38,
          fit: BoxFit.cover,
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
        width: 38,
        height: 38,
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
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFECF2F7),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Container(
            width: 31,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.5),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: AppColors.primary, size: 21),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: AppTextStyles.regular12.copyWith(
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    label,
                    style: AppTextStyles.regular12.copyWith(
                        color: AppColors.text,
                        fontWeight: FontWeight.w300,
                        fontSize: 9),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

class _MiniAction extends StatelessWidget {
  const _MiniAction({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 41,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.dark,
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: Colors.white,
          size: 17,
        ),
      ),
    );
  }
}
