import 'package:flutter/material.dart';
import 'package:statefulclickcounter/core/favorites/favorites_store.dart';
import 'package:statefulclickcounter/core/widgets/recommended_tile.dart';
import 'package:statefulclickcounter/features/customer/properties/data/models/property_models.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class AllPropertiesScreen extends StatelessWidget {
  const AllPropertiesScreen({
    super.key,
    required this.title,
    required this.popular,
    required this.recommended,
    required this.onItemTap,
  });

  final String title;
  final List<PropertyItem> popular;
  final List<PropertyItem> recommended;

  /// Called when user taps a property card or list tile.
  final void Function(PropertyItem) onItemTap;

  static String _fmtFcfa(num value) {
    final s = value.round().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buf.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(' ');
    }
    return '${buf.toString()} FCFA';
  }

  @override
  Widget build(BuildContext context) {
    final topPopular = popular.take(3).toList(growable: false);
    final rest = [...popular.skip(3), ...recommended];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.dark,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Les biens",
          style: AppTextStyles.regular20.copyWith(
            color: AppColors.dark,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ValueListenableBuilder<Set<String>>(
        valueListenable: FavoritesStore.instance.favorites,
        builder: (context, favs, _) {
          if (popular.isEmpty && recommended.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.home_work_outlined,
                    size: 64,
                    color: AppColors.muted,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun bien disponible',
                    style: AppTextStyles.regular20.copyWith(
                      color: AppColors.text,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (topPopular.isNotEmpty) ...[
                  Text(
                    'Populaires',
                    style: AppTextStyles.regular20.copyWith(
                      color: AppColors.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 194,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: topPopular.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) {
                        final p = topPopular[i];
                        final img =
                            p.coverPhotoUrl ?? 'assets/images/chambre12.jpg';
                        return _PopularCard(
                          property: p,
                          imagePath: img,
                          price: _fmtFcfa(p.price),
                          isFavorite: favs.contains(p.id),
                          onFavoriteToggle: () =>
                              FavoritesStore.instance.toggle(p.id),
                          onTap: () => onItemTap(p),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                if (rest.isNotEmpty) ...[
                  Text(
                    'Tous les biens',
                    style: AppTextStyles.regular20.copyWith(
                      color: AppColors.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...rest.map((p) {
                    final img =
                        p.coverPhotoUrl ?? 'assets/images/chambre11.jpg';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: RecommendedTile(
                        imagePath: img,
                        title: p.title,
                        location: p.district.isNotEmpty
                            ? '${p.district}, ${p.city}'
                            : p.city,
                        beds: p.bedrooms,
                        baths: p.bathrooms,
                        salons: 1,
                        isFavorite: favs.contains(p.id),
                        onFavoriteToggle: () =>
                            FavoritesStore.instance.toggle(p.id),
                        onTap: () => onItemTap(p),
                      ),
                    );
                  }),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PopularCard extends StatelessWidget {
  const _PopularCard({
    required this.property,
    required this.imagePath,
    required this.price,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  final PropertyItem property;
  final String imagePath;
  final String price;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isNetwork =
        imagePath.startsWith('http://') || imagePath.startsWith('https://');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 240,
        height: 194,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: isNetwork
                  ? Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: const Color(0xFFE2E8F0)),
                    )
                  : Image.asset(imagePath, fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x33000000), Color(0x99000000)],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              top: 14,
              child: Text(
                price,
                style: const TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Positioned(
              right: 6,
              top: 6,
              child: InkWell(
                onTap: onFavoriteToggle,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.favorite_rounded,
                    color: isFavorite ? const Color(0xFFEF4444) : Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: const TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.district.isNotEmpty
                        ? '${property.district}, ${property.city}'
                        : property.city,
                    style: const TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _Chip(
                        icon: Icons.bed_rounded,
                        text: '${property.bedrooms} ch.',
                      ),
                      const SizedBox(width: 8),
                      _Chip(
                        icon: Icons.bathtub_rounded,
                        text: '${property.bathrooms} sdb.',
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
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary, size: 11),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Lexend',
            fontSize: 8,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
