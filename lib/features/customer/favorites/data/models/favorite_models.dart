class FavoriteItem {
  FavoriteItem({
    required this.id,
    required this.title,
    required this.city,
    required this.price,
    required this.propertyType,
    required this.status,
    required this.rooms,
    required this.bedrooms,
    required this.bathrooms,
    this.coverPhotoUrl,
  });

  final String id;
  final String title;
  final String city;
  final double price;
  final String propertyType;
  final String status;
  final int rooms;
  final int bedrooms;
  final int bathrooms;
  final String? coverPhotoUrl;

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    // API wraps each item as { "property": {...}, "media": [...] }
    final prop = (json['property'] as Map<String, dynamic>?) ?? json;

    int readInt(String key) {
      final v = prop[key];
      if (v is int) return v;
      return int.tryParse(v?.toString() ?? '') ?? 0;
    }

    // Prefer property.coverPhotoUrl, then fall back to media where cover==true
    String? coverPhotoUrl = (prop['coverPhotoUrl'] ?? '').toString().trim().isEmpty
        ? null
        : prop['coverPhotoUrl'].toString();

    if (coverPhotoUrl == null) {
      final media = json['media'] as List?;
      if (media != null) {
        for (final m in media.whereType<Map<String, dynamic>>()) {
          if (m['cover'] == true) {
            final url = m['fileUrl']?.toString() ?? '';
            if (url.isNotEmpty) {
              coverPhotoUrl = url;
              break;
            }
          }
        }
      }
    }

    return FavoriteItem(
      id: (prop['id'] ?? '').toString(),
      title: (prop['title'] ?? '').toString(),
      city: (prop['city'] ?? '').toString(),
      price: (prop['price'] is num)
          ? (prop['price'] as num).toDouble()
          : double.tryParse(prop['price']?.toString() ?? '') ?? 0,
      propertyType: (prop['propertyType'] ?? '').toString(),
      status: (prop['status'] ?? '').toString(),
      rooms: readInt('rooms'),
      bedrooms: readInt('bedrooms'),
      bathrooms: readInt('bathrooms'),
      coverPhotoUrl: coverPhotoUrl,
    );
  }
}

class FavoritesPage {
  FavoritesPage({
    required this.totalItems,
    required this.totalPages,
    required this.page,
    required this.perPage,
    required this.content,
  });

  final int totalItems;
  final int totalPages;
  final int page;
  final int perPage;
  final List<FavoriteItem> content;

  factory FavoritesPage.fromJson(Map<String, dynamic> json) {
    // Backend returns the same paginated shape as PropertiesPage:
    // { "results": [...], "total-items": N, "total-pages": N, "perPage": N, "page": N }
    final raw = json['results'] ?? json['content'];
    final List<FavoriteItem> content;
    if (raw is List) {
      content = raw
          .whereType<Map<String, dynamic>>()
          .map(FavoriteItem.fromJson)
          .toList(growable: false);
    } else {
      content = const [];
    }

    int readInt(List<String> keys) {
      for (final key in keys) {
        final v = json[key];
        if (v is int) return v;
        final parsed = int.tryParse(v?.toString() ?? '');
        if (parsed != null) return parsed;
      }
      return 0;
    }

    return FavoritesPage(
      totalItems: readInt(const ['total-items', 'totalElements']),
      totalPages: readInt(const ['total-pages', 'totalPages']),
      page: readInt(const ['page', 'number']),
      perPage: readInt(const ['perPage', 'size']),
      content: content,
    );
  }
}

class FavoriteAddedRef {
  FavoriteAddedRef({
    required this.favoriteId,
    required this.propertyId,
    required this.addedAt,
  });

  final String favoriteId;
  final String propertyId;
  final DateTime? addedAt;

  factory FavoriteAddedRef.fromJson(Map<String, dynamic> json) {
    return FavoriteAddedRef(
      favoriteId: (json['favoriteId'] ?? '').toString(),
      propertyId: (json['propertyId'] ?? '').toString(),
      addedAt: DateTime.tryParse((json['addedAt'] ?? '').toString()),
    );
  }
}
