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
    int readInt(String key) {
      final v = json[key];
      if (v is int) return v;
      return int.tryParse(v?.toString() ?? '') ?? 0;
    }

    return FavoriteItem(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '') ?? 0,
      propertyType: (json['propertyType'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      rooms: readInt('rooms'),
      bedrooms: readInt('bedrooms'),
      bathrooms: readInt('bathrooms'),
      coverPhotoUrl: (json['coverPhotoUrl'] ?? '').toString().trim().isEmpty
          ? null
          : (json['coverPhotoUrl'] ?? '').toString(),
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
