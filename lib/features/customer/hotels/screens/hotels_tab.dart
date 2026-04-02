import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import 'package:statefulclickcounter/features/customer/hotels/screens/address_search_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';

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
  String _selectedType = 'Hotels';
  String? _selectedAddress;
  DateTime _arrival = DateTime(2026, 3, 15);
  DateTime _departure = DateTime(2026, 3, 18);

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
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Bonjour ',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          Text('👋', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Arnaud Koffi',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
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
                        child: const Text(
                          '5',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800),
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
                // Dark background extension behind search card
                Container(
                  height: 160,
                  decoration: const BoxDecoration(
                    color: AppColors.dark,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                ),
                SingleChildScrollView(
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
                              height: 52,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      size: 20, color: AppColors.muted),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _selectedAddress ?? 'Sélectionner une adresse',
                                      style: TextStyle(
                                        color: _selectedAddress != null
                                            ? AppColors.dark
                                            : AppColors.muted,
                                        fontSize: 14,
                                        fontWeight: _selectedAddress != null
                                            ? FontWeight.w600
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
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(17),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Colors.white,
                                        size: 20),
                                  ),
                                ],
                              ),
                            ),
                            ),
                            const SizedBox(height: 12),
                            // Type pills
                            SizedBox(
                              height: 42,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: _kTypes.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 8),
                                itemBuilder: (_, i) {
                                  final t = _kTypes[i];
                                  final selected = t.label == _selectedType;
                                  return GestureDetector(
                                    onTap: () =>
                                        setState(() => _selectedType = t.label),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? AppColors.primary
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(22),
                                        border: selected
                                            ? null
                                            : Border.all(
                                                color: const Color(0xFFE7E7E7)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(t.icon,
                                              size: 16,
                                              color: selected
                                                  ? Colors.white
                                                  : AppColors.dark),
                                          const SizedBox(width: 6),
                                          Text(
                                            t.label,
                                            style: TextStyle(
                                              color: selected
                                                  ? Colors.white
                                                  : AppColors.dark,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
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
                                label: const Text(
                                  'Rechercher',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
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
                            return _PopularCard(
                              imagePath: p['image'] as String,
                              name: p['name'] as String,
                              location: p['location'] as String,
                              pricePerNight: p['price'] as int,
                              rating: (p['rating'] as num).toDouble(),
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
                          child: _RecommendedTile(
                            imagePath: p['image'] as String,
                            name: p['name'] as String,
                            location: p['location'] as String,
                            beds: p['beds'] as int,
                            baths: p['baths'] as int,
                            salons: p['salons'] as int,
                            price: p['price'] as String,
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
      height: 57,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE7E7E7), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.calendar_month_rounded,
                color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
                Text(
                  formatted,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 1.4,
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
          style: const TextStyle(
            color: AppColors.dark,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            height: 24 / 16,
            letterSpacing: 0.08,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onMore,
          child: const Text(
            'Tout voir',
            style: TextStyle(
              color: AppColors.dark,
              fontWeight: FontWeight.w700,
              fontSize: 13,
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
                    color: AppColors.muted, size: 40),
              ),
            ),
            // Gradient overlay
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xCC000000)],
                  stops: [0.4, 1.0],
                ),
              ),
            ),
            // Heart
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.favorite_rounded,
                    color: Colors.red, size: 16),
              ),
            ),
            // Info at bottom
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      height: 22 / 13,
                      letterSpacing: 0.065,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    location,
                    style: const TextStyle(
                      color: Color(0xCCFFFFFF),
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      height: 1.0,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${_fmt(pricePerNight)} ',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          height: 20 / 12,
                          letterSpacing: 0.06,
                        ),
                      ),
                      const Text(
                        'FCFA/',
                        style: TextStyle(
                          color: Color(0xAAFFFFFF),
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          height: 20 / 10,
                          letterSpacing: 0.05,
                        ),
                      ),
                      const Text(
                        ' nuit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          height: 20 / 10,
                          letterSpacing: 0.05,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFFACC15), size: 14),
                      const SizedBox(width: 2),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
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
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Trouvez. Emménagez avec',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        height: 24 / 16,
                      ),
                    ),
                    Text(
                      'UBAX',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
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

class _RecommendedTile extends StatelessWidget {
  const _RecommendedTile({
    required this.imagePath,
    required this.name,
    required this.location,
    required this.beds,
    required this.baths,
    required this.salons,
    required this.price,
  });

  final String imagePath;
  final String name;
  final String location;
  final int beds;
  final int baths;
  final int salons;
  final String price;

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
              imagePath,
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
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 13, color: AppColors.muted),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(
                            color: AppColors.muted, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 8,
                  runSpacing: 3,
                  children: [
                    _InfoChip(icon: Icons.bed_rounded, text: '$beds Chambres'),
                    _InfoChip(
                        icon: Icons.bathtub_outlined,
                        text: '$baths Salle de bains'),
                    _InfoChip(
                        icon: Icons.weekend_rounded, text: '$salons Salon'),
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

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.primary),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}
