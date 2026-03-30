import 'package:flutter/material.dart';

import 'package:statefulclickcounter/theme/app_colors.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _PropertyData {
  const _PropertyData({
    required this.imagePath,
    required this.name,
    required this.location,
    required this.beds,
    required this.baths,
    required this.kitchens,
    required this.price,
    required this.tag,
  });

  final String imagePath;
  final String name;
  final String location;
  final int beds;
  final int baths;
  final int kitchens;
  final int price;
  final String tag;
}

const _kProperties = [
  _PropertyData(
    imagePath: 'assets/images/appartements-luxe.jpg',
    name: 'Appartement Moderne à Cocody',
    location: 'Cocody Angré, Abidjan – Côte d\'Ivoire',
    beds: 3,
    baths: 2,
    kitchens: 1,
    price: 250000,
    tag: 'Location',
  ),
  _PropertyData(
    imagePath: 'assets/images/luxurious-modern-living-room-with-blue-wall-white-sofa.jpg',
    name: 'Appartement Moderne à Cocody',
    location: 'Cocody Angré, Abidjan – Côte d\'Ivoire',
    beds: 3,
    baths: 2,
    kitchens: 1,
    price: 250000,
    tag: 'Location',
  ),
  _PropertyData(
    imagePath: 'assets/images/modern-elegant-bedroom-interior.jpg',
    name: 'Appartement Moderne à Cocody',
    location: 'Cocody Angré, Abidjan – Côte d\'Ivoire',
    beds: 3,
    baths: 2,
    kitchens: 1,
    price: 250000,
    tag: 'Location',
  ),
  _PropertyData(
    imagePath: 'assets/images/cozy-living-room-interior-with-panoramic-window.jpg',
    name: 'Appartement Moderne à Cocody',
    location: 'Cocody Angré, Abidjan – Côte d\'Ivoire',
    beds: 3,
    baths: 2,
    kitchens: 1,
    price: 250000,
    tag: 'Location',
  ),
  _PropertyData(
    imagePath: 'assets/images/villa-ultra-moderna-carignan.jpg',
    name: 'Villa Ultra Moderna',
    location: 'Riviera Palmeraie, Abidjan – Côte d\'Ivoire',
    beds: 4,
    baths: 3,
    kitchens: 1,
    price: 450000,
    tag: 'Vente',
  ),
  _PropertyData(
    imagePath: 'assets/images/3d-rendering-loft-luxury-living-room-with-shelf-near-dining-table-counter.jpg',
    name: 'Loft Luxueux Plateau',
    location: 'Plateau, Abidjan – Côte d\'Ivoire',
    beds: 2,
    baths: 1,
    kitchens: 1,
    price: 180000,
    tag: 'Location',
  ),
];

// ─── Category pill data ────────────────────────────────────────────────────────

class _CategoryData {
  const _CategoryData({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

const _kCategories = [
  _CategoryData(label: 'Maison', icon: Icons.house_outlined),
  _CategoryData(label: 'Appartement', icon: Icons.apartment_rounded),
  _CategoryData(label: 'Hotel', icon: Icons.hotel_rounded),
  _CategoryData(label: 'Terrain', icon: Icons.landscape_rounded),
];

// ─── Main screen ──────────────────────────────────────────────────────────────

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  String _selectedCategory = 'Appartement';
  bool _isGridView = true;
  bool _searchActive = false;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  late List<_PropertyData> _properties;

  @override
  void initState() {
    super.initState();
    _properties = List.of(_kProperties);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _remove(_PropertyData item) {
    setState(() => _properties.remove(item));
  }

  List<_PropertyData> get _filtered {
    if (_query.isEmpty) return _properties;
    final q = _query.toLowerCase();
    return _properties
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.location.toLowerCase().contains(q))
        .toList();
  }

  void _toggleSearch() {
    setState(() {
      _searchActive = !_searchActive;
      if (!_searchActive) {
        _searchController.clear();
        _query = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayed = _filtered;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
          child: Row(
            children: [
              if (!_searchActive) ...[
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Favoris',
                  style: TextStyle(
                    color: AppColors.dark,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
                const Spacer(),
              ] else ...[
                Expanded(
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFE7E7E7)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded,
                            color: AppColors.muted, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            style: const TextStyle(
                              color: AppColors.dark,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Rechercher un bien...',
                              hintStyle: TextStyle(
                                color: AppColors.muted,
                                fontSize: 14,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (v) => setState(() => _query = v),
                          ),
                        ),
                        if (_query.isNotEmpty)
                          GestureDetector(
                            onTap: () => setState(() {
                              _searchController.clear();
                              _query = '';
                            }),
                            child: const Icon(Icons.close_rounded,
                                color: AppColors.muted, size: 18),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              GestureDetector(
                onTap: _toggleSearch,
                child: Icon(
                  _searchActive ? Icons.close_rounded : Icons.search_rounded,
                  color: AppColors.dark,
                  size: 26,
                ),
              ),
            ],
          ),
        ),

        // ── Category pills
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            itemCount: _kCategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final cat = _kCategories[i];
              final selected = cat.label == _selectedCategory;
              return _CategoryPill(
                label: cat.label,
                icon: cat.icon,
                selected: selected,
                onTap: () => setState(() => _selectedCategory = cat.label),
              );
            },
          ),
        ),

        // ── Count + view toggle
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
          child: Row(
            children: [
              Text(
                '${displayed.length} favoris',
                style: const TextStyle(
                  color: AppColors.dark,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _isGridView = false),
                child: Icon(
                  Icons.format_list_bulleted_rounded,
                  color:
                      _isGridView ? AppColors.muted : AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => setState(() => _isGridView = true),
                child: Icon(
                  Icons.grid_view_rounded,
                  color:
                      _isGridView ? AppColors.primary : AppColors.muted,
                  size: 22,
                ),
              ),
            ],
          ),
        ),

        // ── Grid or List
        Expanded(
          child: _isGridView
              ? GridView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 198 / 201,
                  ),
                  itemCount: displayed.length,
                  itemBuilder: (_, i) => _PropertyCard(data: displayed[i]),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                  itemCount: displayed.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => Dismissible(
                    key: ValueKey(displayed[i].imagePath + i.toString()),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (_) => _remove(displayed[i]),
                    background: Stack(
                      children: [
                        Positioned(
                          top: 40,
                          left: 11,
                          child: Container(
                            width: 135,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            alignment: Alignment.center,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.delete_rounded,
                                    color: Colors.white, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  'Supprimer',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    child: _PropertyListCard(data: displayed[i]),
                  ),
                ),
        ),
      ],
    );
  }
}

// ─── Category pill ─────────────────────────────────────────────────────────────

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: selected
              ? null
              : Border.all(color: const Color(0xFFE7E7E7)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? Colors.white : AppColors.dark,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.dark,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Property card ─────────────────────────────────────────────────────────────

class _PropertyCard extends StatelessWidget {
  const _PropertyCard({required this.data});

  final _PropertyData data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        // Scale proportionally to Figma reference (198px wide card)
        final scale = w / 198;
        final imgH = 110 * scale;
        final fs = (scale * 11).clamp(9.0, 14.0);
        final fsSmall = (scale * 9).clamp(7.5, 12.0);
        final iconSz = (scale * 11).clamp(9.0, 13.0);
        final hPad = (scale * 8).clamp(6.0, 12.0);
        final vPad = (scale * 4).clamp(3.0, 7.0);

        return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                child: Image.asset(
                  data.imagePath,
                  height: imgH,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: imgH,
                    color: const Color(0xFFE2E8F0),
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_rounded,
                        color: AppColors.muted, size: 36),
                  ),
                ),
              ),
              // Tag
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.dark,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    data.tag,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: fsSmall,
                    ),
                  ),
                ),
              ),
              // Heart
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.red,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),

          // ── Info
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(hPad, vPad, hPad, vPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    data.name,
                    style: TextStyle(
                      color: AppColors.dark,
                      fontWeight: FontWeight.w900,
                      fontSize: fs,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: vPad * 0.4),
                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: iconSz, color: AppColors.muted),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          data.location,
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: fsSmall,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: vPad * 0.6),
                  // Meta
                  Wrap(
                    spacing: 5,
                    runSpacing: 2,
                    children: [
                      _MetaInfo(
                          icon: Icons.bed_rounded,
                          fontSize: fsSmall,
                          text: '${data.beds} Chambres'),
                      _MetaInfo(
                          icon: Icons.bathtub_outlined,
                          fontSize: fsSmall,
                          text: '${data.baths} Salle de bains'),
                      _MetaInfo(
                          icon: Icons.kitchen_rounded,
                          fontSize: fsSmall,
                          text: '${data.kitchens} Cuisine'),
                    ],
                  ),
                  const Spacer(),
                  // Price + button
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${_fmt(data.price)} Fcfa',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: fs,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: hPad * 0.9, vertical: vPad * 0.8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Voir les détails',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: fsSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
        );
      },
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

// ─── Property list card ────────────────────────────────────────────────────────

class _PropertyListCard extends StatelessWidget {
  const _PropertyListCard({required this.data});

  final _PropertyData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              data.imagePath,
              width: 130,
              height: 110,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 130,
                height: 110,
                color: const Color(0xFFE2E8F0),
                alignment: Alignment.center,
                child: const Icon(Icons.image_rounded,
                    color: AppColors.muted, size: 36),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + heart
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        data.name,
                        style: const TextStyle(
                          color: AppColors.dark,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.withValues(alpha: 0.1),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.red,
                        size: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 13, color: AppColors.muted),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        data.location,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Meta
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    _MetaInfo(
                        icon: Icons.bed_rounded,
                        text: '${data.beds} Chambres',
                        fontSize: 11),
                    _MetaInfo(
                        icon: Icons.bathtub_outlined,
                        text: '${data.baths} Salle de bains',
                        fontSize: 11),
                    _MetaInfo(
                        icon: Icons.kitchen_rounded,
                        text: '${data.kitchens} Cuisine',
                        fontSize: 11),
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

// ─── Meta info chip ────────────────────────────────────────────────────────────

class _MetaInfo extends StatelessWidget {
  const _MetaInfo({
    required this.icon,
    required this.text,
    required this.fontSize,
  });

  final IconData icon;
  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: fontSize, color: AppColors.primary),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(
            color: AppColors.muted,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
