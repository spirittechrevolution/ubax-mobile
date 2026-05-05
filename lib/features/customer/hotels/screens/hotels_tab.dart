import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import 'package:statefulclickcounter/core/widgets/recommended_tile.dart';
import 'package:statefulclickcounter/features/customer/hotels/screens/address_search_screen.dart';
import 'package:statefulclickcounter/features/customer/hotels/screens/hotel_details_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _TypeData {
  const _TypeData(this.label, this.icon);
  final String label;
  final IconData icon;
}

const _kTypes = [
  _TypeData('Hotels', Icons.apartment_rounded),
  _TypeData('Villas', Icons.house_rounded),
  _TypeData('Résidences', Icons.business_rounded),
];

const _kPopulaires = [
  {
    'image': 'assets/images/expedia_group-695130-2cf588-799717.jpg',
    'name': 'Hôtel Azur Cocody',
    'location': 'Cocody Angré, Abidjan',
    'price': 45000,
    'rating': 4.5,
  },
  {
    'image':
        'assets/images/3d-rendering-beautiful-luxury-bedroom-suite-hotel-with-tv-working-table.jpg',
    'name': 'Résidence Lagune Prestige',
    'location': 'Zone 4, Marcory – Abidjan',
    'price': 65000,
    'rating': 4.7,
  },
  {
    'image':
        'assets/images/luxurious-modern-living-room-with-blue-wall-white-sofa.jpg',
    'name': 'Palm Club Plateau',
    'location': 'Centre-ville – Abidjan',
    'price': 55000,
    'rating': 4.8,
  },
  {
    'image': 'assets/images/modern-elegant-bedroom-interior.jpg',
    'name': 'Suite Présidentielle',
    'location': 'Riviera Golf, Abidjan',
    'price': 95000,
    'rating': 4.9,
  },
];

const _kRecommandesData = [
  {
    'image': 'assets/images/appartements-luxe.jpg',
    'name': 'Appartement Moderne à Cocody',
    'location': 'Cocody Angré, Abidjan – Côte d\'Ivoire',
    'beds': 3,
    'baths': 2,
    'salons': 1,
    'price': '250 000',
  },
  {
    'image':
        'assets/images/cozy-living-room-interior-with-panoramic-window.jpg',
    'name': 'Studio meublé au Plateau',
    'location': 'Plateau, Abidjan – Côte d\'Ivoire',
    'beds': 1,
    'baths': 1,
    'salons': 1,
    'price': '180 000',
  },
  {
    'image': 'assets/images/villa-ultra-moderna-carignan.jpg',
    'name': 'Villa Ultra Moderna',
    'location': 'Riviera Palmeraie, Abidjan – Côte d\'Ivoire',
    'beds': 4,
    'baths': 3,
    'salons': 2,
    'price': '450 000',
  },
];

// ─── Main tab ─────────────────────────────────────────────────────────────────

class HotelsTab extends StatefulWidget {
  const HotelsTab({super.key});

  @override
  State<HotelsTab> createState() => _HotelsTabState();
}

class _HotelsTabState extends State<HotelsTab> {
  static const double _kDarkBgHeight = 160.0;

  String _selectedType = 'Hotels';
  String? _selectedAddress;
  DateTime _arrival = DateTime(2026, 3, 15);
  DateTime _departure = DateTime(2026, 3, 18);

  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final clamped = _scrollController.offset.clamp(0.0, _kDarkBgHeight);
      if (clamped != _scrollOffset) {
        setState(() => _scrollOffset = clamped);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickAddress() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const AddressSearchScreen()),
    );
    if (!mounted || result == null) return;
    setState(() => _selectedAddress = result);
  }

  Future<void> _pickDate({required bool isArrival}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isArrival ? _arrival : _departure,
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isArrival) {
        _arrival = picked;
        if (_departure.isBefore(_arrival)) {
          _departure = _arrival.add(const Duration(days: 1));
        }
      } else {
        _departure = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          // ── Dark header
          Container(
            color: AppColors.dark,
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/pexels-ekrulila-2128329.jpg',
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 44,
                      height: 44,
                      color: const Color(0xFF2D4A65),
                      alignment: Alignment.center,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Bonjour ',
                            style: AppTextStyles.regular12.copyWith(
                              color: const Color(0xFF94A3B8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '👋',
                            style: AppTextStyles.regular12,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Arnaud Koffi',
                        style: AppTextStyles.regularlight16.copyWith(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Bell
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.notifications_rounded,
                          color: AppColors.dark, size: 22),
                    ),
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '5',
                          style: AppTextStyles.regular12.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                // CI flag
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipOval(
                        child: CountryFlag.fromCountryCode(
                          'CI',
                          width: 28,
                          height: 28,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down_rounded,
                          size: 16, color: AppColors.dark),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Body
          Expanded(
            child: Stack(
              children: [
                // Dark background extension behind search card — folds on scroll
                Container(
                  height: (_kDarkBgHeight - _scrollOffset)
                      .clamp(0.0, _kDarkBgHeight),
                  decoration: const BoxDecoration(
                    color: AppColors.dark,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Search card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Address
                            GestureDetector(
                              onTap: _pickAddress,
                              child: Container(
                                height: 43,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECF2F7),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined,
                                        size: 20, color: AppColors.dark),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _selectedAddress ??
                                            'Sélectionner une adresse',
                                        style: AppTextStyles.regular12.copyWith(
                                          color: AppColors.text,
                                          fontSize: 12,
                                          fontWeight: _selectedAddress != null
                                              ? FontWeight.w500
                                              : FontWeight.w400,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: AppColors.primary,
                                          size: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Type pills — same style as Mes réservations
                            Row(
                              children: [
                                for (var i = 0; i < _kTypes.length; i++) ...[
                                  Expanded(
                                    child: _TypePill(
                                      data: _kTypes[i],
                                      selected:
                                          _kTypes[i].label == _selectedType,
                                      onTap: () => setState(() =>
                                          _selectedType = _kTypes[i].label),
                                    ),
                                  ),
                                  if (i < _kTypes.length - 1)
                                    const SizedBox(width: 10),
                                ],
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Date pickers
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _pickDate(isArrival: true),
                                    child: _DateCard(
                                      label: 'Arrivée',
                                      date: _arrival,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _pickDate(isArrival: false),
                                    child: _DateCard(
                                      label: 'Départ',
                                      date: _departure,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            // Search button
                            SizedBox(
                              width: double.infinity,
                              height: 43,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: () {},
                                icon:
                                    const Icon(Icons.search_rounded, size: 20),
                                label: Text(
                                  'Rechercher',
                                  style: AppTextStyles.button
                                      .copyWith(fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Populaires
                      _SectionRow(title: 'Populaires', onMore: () {}),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 220,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _kPopulaires.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (_, i) {
                            final p = _kPopulaires[i];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => HotelDetailsScreen(
                                      imagePath: p['image'] as String,
                                      name: p['name'] as String,
                                      location: p['location'] as String,
                                      price: p['price'] as int,
                                      rating: (p['rating'] as num).toDouble(),
                                    ),
                                  ),
                                );
                              },
                              child: _PopularCard(
                                imagePath: p['image'] as String,
                                name: p['name'] as String,
                                location: p['location'] as String,
                                pricePerNight: p['price'] as int,
                                rating: (p['rating'] as num).toDouble(),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Recommandés
                      _SectionRow(
                          title: 'Recommandés pour vous', onMore: () {}),
                      const SizedBox(height: 12),

                      // UBAX banner
                      _UbaxBanner(onTap: () {}),
                      const SizedBox(height: 12),

                      // Tiles
                      ..._kRecommandesData.map(
                        (p) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: RecommendedTile(
                            imagePath: p['image'] as String,
                            title: p['name'] as String,
                            location: p['location'] as String,
                            beds: p['beds'] as int,
                            baths: p['baths'] as int,
                            salons: p['salons'] as int,
                            showShadow: false,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => HotelDetailsScreen(
                                    imagePath: p['image'] as String,
                                    name: p['name'] as String,
                                    location: p['location'] as String,
                                    price: int.tryParse((p['price'] as String)
                                            .replaceAll(' ', '')) ??
                                        0,
                                    rating: 4.7,
                                  ),
                                ),
                              );
                            },
                          ),
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
}

// ─── Date card ────────────────────────────────────────────────────────────────

class _DateCard extends StatelessWidget {
  const _DateCard({required this.label, required this.date});

  final String label;
  final DateTime date;

  static const _months = [
    '',
    'Janv',
    'Févr',
    'Mars',
    'Avr',
    'Mai',
    'Juin',
    'Juil',
    'Août',
    'Sept',
    'Oct',
    'Nov',
    'Déc'
  ];

  @override
  Widget build(BuildContext context) {
    final formatted = '${date.day} ${_months[date.month]} ${date.year}';
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.calendar_month_rounded,
                color: AppColors.dark, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppTextStyles.regular12.copyWith(
                    color: AppColors.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  formatted,
                  style: AppTextStyles.regular12.copyWith(
                    color: AppColors.text,
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
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

// ─── Section row ──────────────────────────────────────────────────────────────

class _SectionRow extends StatelessWidget {
  const _SectionRow({required this.title, required this.onMore});

  final String title;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyles.regular20.copyWith(color: AppColors.text),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onMore,
          child: Text(
            'Tout voir',
            style: AppTextStyles.regular12.copyWith(
              color: AppColors.textBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Popular card ─────────────────────────────────────────────────────────────

class _PopularCard extends StatelessWidget {
  const _PopularCard({
    required this.imagePath,
    required this.name,
    required this.location,
    required this.pricePerNight,
    required this.rating,
  });

  final String imagePath;
  final String name;
  final String location;
  final int pricePerNight;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 156,
        height: 220,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFD0DDE8),
                alignment: Alignment.center,
                child: const Icon(Icons.image_rounded,
                    color: AppColors.dark, size: 40),
              ),
            ),
            // Gradient overlay: transparent → rgba(0,0,0,0.7)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xB3000000)],
                  stops: [0.195, 1.0],
                ),
              ),
            ),
            // Heart
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.favorite_rounded,
                    color: Colors.red, size: 11),
              ),
            ),
            // Info at bottom
            Positioned(
              left: 10,
              right: 10,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.regularlight16.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    location,
                    style: AppTextStyles.regular12.copyWith(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${_fmt(pricePerNight)} ',
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.background,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.06,
                        ),
                      ),
                      Text(
                        'FCFA/',
                        style: AppTextStyles.regular12.copyWith(
                          color: const Color(0xAAFFFFFF),
                          fontSize: 7,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.05,
                        ),
                      ),
                      Text(
                        ' nuit',
                        style: AppTextStyles.regular12.copyWith(
                          color: Colors.white,
                          fontSize: 7,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.05,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFFACC15), size: 14),
                      const SizedBox(width: 2),
                      Text(
                        rating.toString(),
                        style: AppTextStyles.regular12.copyWith(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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

// ─── UBAX banner ──────────────────────────────────────────────────────────────

class _UbaxBanner extends StatelessWidget {
  const _UbaxBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.dark,
          borderRadius: BorderRadius.circular(18),
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          children: [
            // Text
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Trouvez. Emménagez avec',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'UBAX',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Orange panel + image
            Stack(
              children: [
                Container(
                  width: 130,
                  color: AppColors.primary,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/villa-ultra-moderna-carignan.jpg',
                    width: 130,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 130,
                      height: 120,
                      color: AppColors.primary,
                      alignment: Alignment.center,
                      child: const Icon(Icons.apartment_rounded,
                          color: Colors.white, size: 40),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Recommended tile ─────────────────────────────────────────────────────────

// ─── Type pill ────────────────────────────────────────────────────────────────

class _TypePill extends StatelessWidget {
  const _TypePill({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final _TypeData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: selected
              ? null
              : Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.25)
                    : AppColors.background,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                data.icon,
                color: selected ? Colors.white : AppColors.primary,
                size: 14,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                data.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.regular12.copyWith(
                  color: selected ? Colors.white : AppColors.dark,
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w400 : FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
