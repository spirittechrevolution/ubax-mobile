import 'package:flutter/material.dart';

import 'package:statefulclickcounter/features/customer/hotels/screens/hotel_details_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

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

const _kAppartementProperties = [
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
    imagePath: 'assets/images/chambre11.jpg',
    name: 'Studio meublé au Plateau',
    location: 'Plateau, Abidjan – Côte d\'Ivoire',
    beds: 1,
    baths: 1,
    kitchens: 1,
    price: 180000,
    tag: 'Location',
  ),
  _PropertyData(
    imagePath: 'assets/images/chambre12.jpg',
    name: 'Duplex moderne à Marcory',
    location: 'Marcory, Abidjan – Côte d\'Ivoire',
    beds: 4,
    baths: 2,
    kitchens: 1,
    price: 320000,
    tag: 'Location',
  ),
  _PropertyData(
    imagePath: 'assets/images/chambre13.jpg',
    name: 'Appartement vue panoramique',
    location: 'Cocody, Abidjan – Côte d\'Ivoire',
    beds: 2,
    baths: 1,
    kitchens: 1,
    price: 210000,
    tag: 'Location',
  ),
];

const _kMaisonProperties = [
  _PropertyData(
    imagePath: 'assets/images/villa6.jpg',
    name: 'Villa Ultra Moderna',
    location: 'Riviera Palmeraie, Abidjan – Côte d\'Ivoire',
    beds: 4,
    baths: 3,
    kitchens: 1,
    price: 450000,
    tag: 'Vente',
  ),
  _PropertyData(
    imagePath: 'assets/images/villa3.jpg',
    name: 'Maison familiale à Cocody',
    location: 'Cocody Angré, Abidjan – Côte d\'Ivoire',
    beds: 5,
    baths: 3,
    kitchens: 1,
    price: 520000,
    tag: 'Vente',
  ),
  _PropertyData(
    imagePath: 'assets/images/chambre4.jpg',
    name: 'Maison avec jardin',
    location: 'Bingerville, Abidjan – Côte d\'Ivoire',
    beds: 3,
    baths: 2,
    kitchens: 1,
    price: 390000,
    tag: 'Vente',
  ),
  _PropertyData(
    imagePath: 'assets/images/chambre5.jpg',
    name: 'Maison moderne',
    location: 'Riviera, Abidjan – Côte d\'Ivoire',
    beds: 4,
    baths: 2,
    kitchens: 1,
    price: 410000,
    tag: 'Vente',
  ),
];

const _kHotelProperties = [
  _PropertyData(
    imagePath: 'assets/images/chambre.jpg',
    name: 'Suite luxueuse',
    location: 'Plateau, Abidjan – Côte d\'Ivoire',
    beds: 1,
    baths: 1,
    kitchens: 0,
    price: 95000,
    tag: 'Nuit',
  ),
  _PropertyData(
    imagePath: 'assets/images/chambre10.jpg',
    name: 'Chambre standard',
    location: 'Cocody, Abidjan – Côte d\'Ivoire',
    beds: 1,
    baths: 1,
    kitchens: 0,
    price: 45000,
    tag: 'Nuit',
  ),
  _PropertyData(
    imagePath: 'assets/images/chambre11.jpg',
    name: 'Suite junior',
    location: 'Marcory, Abidjan – Côte d\'Ivoire',
    beds: 1,
    baths: 1,
    kitchens: 0,
    price: 65000,
    tag: 'Nuit',
  ),
  _PropertyData(
    imagePath: 'assets/images/chambre12.jpg',
    name: 'Suite familiale',
    location: 'Riviera, Abidjan – Côte d\'Ivoire',
    beds: 2,
    baths: 1,
    kitchens: 0,
    price: 75000,
    tag: 'Nuit',
  ),
];

const _kTerrainProperties = [
  _PropertyData(
    imagePath: 'assets/images/piscine.jpg',
    name: 'Terrain à vendre',
    location: 'Grand-Bassam – Côte d\'Ivoire',
    beds: 0,
    baths: 0,
    kitchens: 0,
    price: 1200000,
    tag: 'Vente',
  ),
  _PropertyData(
    imagePath: 'assets/images/villa1.jpg',
    name: 'Parcelle viabilisée',
    location: 'Bingerville – Côte d\'Ivoire',
    beds: 0,
    baths: 0,
    kitchens: 0,
    price: 950000,
    tag: 'Vente',
  ),
  _PropertyData(
    imagePath: 'assets/images/villa2.jpg',
    name: 'Terrain angle',
    location: 'Anyama – Côte d\'Ivoire',
    beds: 0,
    baths: 0,
    kitchens: 0,
    price: 650000,
    tag: 'Vente',
  ),
  _PropertyData(
    imagePath: 'assets/images/villa3.jpg',
    name: 'Terrain en lotissement',
    location: 'Songon – Côte d\'Ivoire',
    beds: 0,
    baths: 0,
    kitchens: 0,
    price: 780000,
    tag: 'Vente',
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
  bool _isSwitchingCategory = false;
  bool _isGridView = true;
  bool _searchActive = false;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  late final Map<String, List<_PropertyData>> _propertiesByCategory;

  @override
  void initState() {
    super.initState();
    _propertiesByCategory = {
      'Maison': List.of(_kMaisonProperties),
      'Appartement': List.of(_kAppartementProperties),
      'Hotel': List.of(_kHotelProperties),
      'Terrain': List.of(_kTerrainProperties),
    };
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _remove(_PropertyData item) {
    final list = _propertiesByCategory[_selectedCategory];
    if (list == null) return;
    setState(() => list.remove(item));
  }

  List<_PropertyData> get _filtered {
    final base =
        _propertiesByCategory[_selectedCategory] ?? const <_PropertyData>[];
    if (_query.isEmpty) return base;
    final q = _query.toLowerCase();
    return base
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.location.toLowerCase().contains(q))
        .toList();
  }

  Future<void> _handleCategoryChanged(String next) async {
    if (next == _selectedCategory || _isSwitchingCategory) return;
    setState(() => _isSwitchingCategory = true);
    await Future<void>.delayed(const Duration(milliseconds: 420));
    if (!mounted) return;
    setState(() {
      _selectedCategory = next;
      _isSwitchingCategory = false;
    });
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
                Text(
                  'Favoris',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.text,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
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
                            color: AppColors.dark, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            style: const TextStyle(
                              color: AppColors.text,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Rechercher un bien...',
                              hintStyle: TextStyle(
                                color: AppColors.text,
                                fontSize: 13,
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
                                color: AppColors.dark, size: 18),
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

        // ── Categories
        SizedBox(
          height: 48,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            scrollDirection: Axis.horizontal,
            itemCount: _kCategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final c = _kCategories[i];
              return _CategoryPill(
                label: c.label,
                icon: c.icon,
                selected: c.label == _selectedCategory,
                onTap: () => _handleCategoryChanged(c.label),
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
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _isGridView = false),
                child: Icon(
                  Icons.format_list_bulleted_rounded,
                  color: _isGridView ? AppColors.muted : AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => setState(() => _isGridView = true),
                child: Icon(
                  Icons.grid_view_rounded,
                  color: _isGridView ? AppColors.primary : AppColors.muted,
                  size: 22,
                ),
              ),
            ],
          ),
        ),

        // ── Grid or List
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: _isSwitchingCategory
                ? _FavoritesSkeleton(
                    key: ValueKey<String>(
                        'skeleton_${_isGridView ? 'grid' : 'list'}'),
                    grid: _isGridView,
                  )
                : _isGridView
                    ? GridView.builder(
                        key: ValueKey<String>('grid_$_selectedCategory'),
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.84,
                        ),
                        itemCount: displayed.length,
                        itemBuilder: (_, i) =>
                            _PropertyCard(data: displayed[i]),
                      )
                    : ListView.separated(
                        key: ValueKey<String>('list_$_selectedCategory'),
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                        itemCount: displayed.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) => _SwipeToDelete(
                          key: ValueKey(displayed[i].imagePath + i.toString()),
                          onDelete: () => _remove(displayed[i]),
                          child: _PropertyListCard(data: displayed[i]),
                        ),
                      ),
          ),
        ),
      ],
    );
  }
}

class _FavoritesSkeleton extends StatelessWidget {
  const _FavoritesSkeleton({super.key, required this.grid});

  final bool grid;

  @override
  Widget build(BuildContext context) {
    Widget block({required double h}) {
      return Container(
        height: h,
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(18),
        ),
      );
    }

    if (grid) {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.84,
        ),
        itemCount: 4,
        itemBuilder: (_, __) => block(h: 230),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => block(h: 230),
    );
  }
}

class _SwipeToDelete extends StatefulWidget {
  const _SwipeToDelete({
    super.key,
    required this.child,
    required this.onDelete,
  });

  final Widget child;
  final VoidCallback onDelete;

  @override
  State<_SwipeToDelete> createState() => _SwipeToDeleteState();
}

class _SwipeToDeleteState extends State<_SwipeToDelete> {
  static const double _maxReveal = 150;
  double _dragOffset = 0;
  double _targetOffset = 0;

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer'),
        content: const Text('Voulez-vous vraiment supprimer cet élément ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (ok == true) {
      widget.onDelete();
    }
    if (!mounted) return;
    setState(() {
      _dragOffset = 0;
      _targetOffset = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final next = (_dragOffset + details.delta.dx).clamp(0.0, _maxReveal);
        setState(() {
          _dragOffset = next;
          _targetOffset = next;
        });
      },
      onHorizontalDragEnd: (_) {
        final shouldOpen = _dragOffset > (_maxReveal * 0.45);
        setState(() {
          _targetOffset = shouldOpen ? _maxReveal : 0;
          _dragOffset = _targetOffset;
        });
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 11),
                child: GestureDetector(
                  onTap: _confirmDelete,
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
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: _targetOffset),
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            builder: (_, value, child) {
              return Transform.translate(
                offset: Offset(value, 0),
                child: child,
              );
            },
            child: widget.child,
          ),
        ],
      ),
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
          border: selected ? null : Border.all(color: const Color(0xFFE7E7E7)),
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
                fontFamily: 'Lexend',
                color: selected ? Colors.white : AppColors.dark,
                fontWeight: FontWeight.w300,
                fontSize: 13,
                height: 1.4,
                letterSpacing: 0,
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

  void _openDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HotelDetailsScreen(
          imagePath: data.imagePath,
          name: data.name,
          location: data.location,
          price: data.price,
          rating: 4.7,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        // Scale proportionally to Figma reference (198px wide card)
        final scale = w / 198;
        final fs = (scale * 10).clamp(8.5, 13.0);
        final fsSmall = (scale * 8).clamp(7.0, 11.0);
        final iconSz = (scale * 11).clamp(9.0, 13.0);
        final hPad = (scale * 8).clamp(6.0, 12.0);
        final vPad = (scale * 3).clamp(2.0, 5.0);

        return GestureDetector(
          onTap: () => _openDetails(context),
          child: Container(
            height: 230,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
                width: 0.3,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x03000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Image
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          data.imagePath,
                          height: 114,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 114,
                            color: const Color(0xFFE2E8F0),
                            alignment: Alignment.center,
                            child: const Icon(Icons.image_rounded,
                                color: AppColors.dark, size: 36),
                          ),
                        ),
                      ),
                      // Tag
                      Positioned(
                        top: 12,
                        left: 6,
                        child: Container(
                          width: 51,
                          height: 15,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.dark,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            data.tag,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 7,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      // Heart
                      const Positioned(
                        top: 12,
                        right: 6,
                        child: Icon(
                          Icons.favorite_rounded,
                          color: Colors.red,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Name
                        // const SizedBox(height: 4),
                        Text(
                          data.name,
                          style: const TextStyle(
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.w300,
                            fontSize: 9,
                            height: 1.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Location
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: iconSz, color: AppColors.textBlack),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                data.location,
                                style: const TextStyle(
                                  color: AppColors.textBlack,
                                  fontSize: 7,
                                  fontWeight: FontWeight.w300,
                                  height: 1.0,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 9),
                        // Meta
                        Wrap(
                          spacing: 10,
                          runSpacing: 2,
                          children: [
                            _MetaInfo(
                                icon: Icons.bed_rounded,
                                fontSize: 7,
                                text: '${data.beds} Chambres'),
                            _MetaInfo(
                                icon: Icons.bathtub_outlined,
                                fontSize: 7,
                                text: '${data.baths} Sdb'),
                            _MetaInfo(
                                icon: Icons.kitchen_rounded,
                                fontSize: 7,
                                text: '${data.kitchens} Cuisine'),
                          ],
                        ),
                        // const Spacer(),
                        const SizedBox(height: 10),
                        // Price + button
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${_fmt(data.price)} Fcfa',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _openDetails(context),
                              child: Container(
                                width: 77,
                                height: 18,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const Text(
                                  'Voir les détails',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 7,
                                  ),
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
      width: double.infinity,
      height: 119,
      padding: const EdgeInsets.all(8),
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
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              data.imagePath,
              width: 127,
              height: 102,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 127,
                height: 102,
                color: const Color(0xFFE2E8F0),
                alignment: Alignment.center,
                child: const Icon(Icons.image_rounded,
                    color: AppColors.dark, size: 36),
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
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        data.name,
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: Icon(
                        Icons.favorite_rounded,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 13, color: AppColors.dark),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        data.location,
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.text,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Meta
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    _MetaInfo(
                        icon: Icons.bed_rounded,
                        text: '${data.beds} Chambres',
                        fontSize: 8),
                    _MetaInfo(
                        icon: Icons.bathtub_outlined,
                        text: '${data.baths} Salle de bains',
                        fontSize: 8),
                    _MetaInfo(
                        icon: Icons.kitchen_rounded,
                        text: '${data.kitchens} Cuisine',
                        fontSize: 8),
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
            color: AppColors.textBlack,
            fontSize: fontSize,
            fontWeight: FontWeight.w300,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}
