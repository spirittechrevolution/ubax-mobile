import 'package:flutter/material.dart';

import 'package:statefulclickcounter/core/widgets/recommended_tile.dart';
import 'package:statefulclickcounter/features/customer/hotels/screens/hotel_details_screen.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _PropertyResult {
  const _PropertyResult({
    required this.image,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.tag,
  });

  final String image;
  final String name;
  final String location;
  final int price;
  final double rating;
  final String tag;
}

const _kResults = [
  _PropertyResult(
    image:
        'assets/images/3d-rendering-beautiful-luxury-bedroom-suite-hotel-with-tv-working-table.jpg',
    name: 'Palm Club Plateau',
    location: 'Cocody Angré, Abidjan',
    price: 45000,
    rating: 4.7,
    tag: 'Hôtel',
  ),
  _PropertyResult(
    image:
        'assets/images/3d-rendering-beautiful-luxury-bedroom-suite-hotel-with-tv.jpg',
    name: 'Palm Club Plateau',
    location: 'Cocody Angré, Abidjan',
    price: 45000,
    rating: 4.7,
    tag: 'Hôtel',
  ),
  _PropertyResult(
    image: 'assets/images/modern-elegant-bedroom-interior.jpg',
    name: 'Palm Club Plateau',
    location: 'Cocody Angré, Abidjan',
    price: 45000,
    rating: 4.7,
    tag: 'Hôtel',
  ),
  _PropertyResult(
    image:
        'assets/images/luxurious-modern-living-room-with-blue-wall-white-sofa.jpg',
    name: 'Palm Club Plateau',
    location: 'Cocody Angré, Abidjan',
    price: 45000,
    rating: 4.7,
    tag: 'Hôtel',
  ),
  _PropertyResult(
    image: 'assets/images/expedia_group-695130-2cf588-799717.jpg',
    name: 'Chambre de luxe',
    location: 'Cocody Angré, Abidjan',
    price: 45000,
    rating: 4.7,
    tag: 'Hôtel',
  ),
  _PropertyResult(
    image: 'assets/images/cozy-living-room-interior-with-panoramic-window.jpg',
    name: 'Chambre de luxe',
    location: 'Cocody Angré, Abidjan',
    price: 45000,
    rating: 4.7,
    tag: 'Hôtel',
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({
    super.key,
    required this.addressTitle,
    required this.addressSubtitle,
  });

  final String addressTitle;
  final String addressSubtitle;

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  bool _isGridView = true;

  void _openDetails(BuildContext context, _PropertyResult item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HotelDetailsScreen(
          imagePath: item.image,
          name: item.name,
          location: item.location,
          price: item.price,
          rating: item.rating,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Dark header
          Container(
            padding: EdgeInsets.fromLTRB(18, topPadding + 10, 18, 20),
            decoration: const BoxDecoration(
              color: AppColors.dark,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(26),
              ),
            ),
            child: Column(
              children: [
                // Title row
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Résultats',
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 16),
                // Address info card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF243E55),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on,
                          color: Color(0xFFE05A2B), size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.addressTitle,
                              style: AppTextStyles.sectionTitle.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              widget.addressSubtitle,
                              style: AppTextStyles.regular12.copyWith(
                                color: const Color(0xFF94A3B8),
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
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
          ),

          // ── Results header
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Résultats',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_kResults.length} biens trouvés',
                      style: AppTextStyles.regular12.copyWith(
                        color: AppColors.text,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
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

          // ── Results list or grid
          Expanded(
            child: _isGridView
                ? GridView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 198 / 227,
                    ),
                    itemCount: _kResults.length,
                    itemBuilder: (_, i) => GestureDetector(
                      onTap: () => _openDetails(context, _kResults[i]),
                      child: _GridCard(data: _kResults[i]),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                    itemCount: _kResults.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final p = _kResults[i];
                      return RecommendedTile(
                        imagePath: p.image,
                        title: p.name,
                        location: p.location,
                        beds: 3,
                        baths: 2,
                        salons: 1,
                        onTap: () => _openDetails(context, p),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Grid card ────────────────────────────────────────────────────────────────

class _GridCard extends StatelessWidget {
  const _GridCard({required this.data});

  final _PropertyResult data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 198,
      height: 227,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    data.image,
                    width: 185,
                    height: 146,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 185,
                      height: 146,
                      color: const Color(0xFFE2E8F0),
                    ),
                  ),
                ),
                // Tag

                Positioned(
                  top: 12,
                  left: 10,
                  child: Container(
                    width: 46,
                    height: 19,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0x40000000),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data.tag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
                // Heart
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.favorite_rounded,
                        color: Colors.red, size: 12),
                  ),
                ),
              ],
            ),
          ),
          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 10, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + rating
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data.name,
                          style: AppTextStyles.sectionTitle.copyWith(
                              color: AppColors.text,
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFFACC15), size: 14),
                      const SizedBox(width: 2),
                      Text(
                        data.rating.toString(),
                        style: const TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  // Location
                  Text(
                    data.location,
                    style: AppTextStyles.regular12.copyWith(
                      color: AppColors.text,
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // const Spacer(),
                  SizedBox(
                    height: 7,
                  ),
                  // Price
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${_fmt(data.price)} FCFA',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                        const TextSpan(
                          text: '/ nuit',
                          style: TextStyle(
                            color: AppColors.text,
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                          ),
                        ),
                      ],
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

// ─── Helpers ──────────────────────────────────────────────────────────────────

String _fmt(int value) {
  final s = value.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    final fromEnd = s.length - i;
    buf.write(s[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(' ');
  }
  return buf.toString().trim();
}
