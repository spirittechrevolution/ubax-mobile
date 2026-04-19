import 'package:flutter/material.dart';

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
    image: 'assets/images/3d-rendering-beautiful-luxury-bedroom-suite-hotel-with-tv-working-table.jpg',
    name: 'Palm Club Plateau',
    location: 'Cocody Angré, Abidjan',
    price: 45000,
    rating: 4.7,
    tag: 'Hôtel',
  ),
  _PropertyResult(
    image: 'assets/images/3d-rendering-beautiful-luxury-bedroom-suite-hotel-with-tv.jpg',
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
    image: 'assets/images/luxurious-modern-living-room-with-blue-wall-white-sofa.jpg',
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
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_kResults.length} biens trouvés',
                      style: AppTextStyles.regular12.copyWith(
                        color: AppColors.muted,
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
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (_, i) => GestureDetector(
                      onTap: () => _openDetails(context, _kResults[i]),
                      child: _ListCard(data: _kResults[i]),
                    ),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25)),
                child: Image.asset(
                  data.image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 120,
                    color: const Color(0xFFE2E8F0),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
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
                  child: const Icon(Icons.favorite_rounded,
                      color: Colors.red, size: 16),
                ),
              ),
            ],
          ),
          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
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
                            color: AppColors.dark,
                            fontSize: 13,
                          ),
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
                          color: AppColors.dark,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  // Location
                  Text(
                    data.location,
                    style: AppTextStyles.regular12.copyWith(
                      color: AppColors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  // Price
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${_fmt(data.price)} FCFA',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        const TextSpan(
                          text: '/ nuit',
                          style: TextStyle(
                            color: AppColors.muted,
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

// ─── List card ────────────────────────────────────────────────────────────────

class _ListCard extends StatelessWidget {
  const _ListCard({required this.data});

  final _PropertyResult data;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 139,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              data.image,
              width: 115,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 115,
                color: const Color(0xFFE2E8F0),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Name + heart
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        data.name,
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.dark,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.favorite_rounded,
                        color: Colors.red, size: 18),
                  ],
                ),
                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 13, color: AppColors.muted),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        data.location,
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.muted,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                // Price + rating
                Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${_fmt(data.price)} FCFA',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          const TextSpan(
                            text: '/ nuit',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.star_rounded,
                        color: Color(0xFFFACC15), size: 14),
                    const SizedBox(width: 2),
                    Text(
                      data.rating.toString(),
                      style: const TextStyle(
                        color: AppColors.dark,
                        fontWeight: FontWeight.w600,
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
