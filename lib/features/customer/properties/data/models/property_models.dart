class PropertyMedia {
  PropertyMedia({
    required this.id,
    required this.fileUrl,
    required this.mediaType,
    required this.cover,
    required this.sortOrder,
  });

  final String id;
  final String fileUrl;
  final String mediaType;
  final bool cover;
  final int sortOrder;

  factory PropertyMedia.fromJson(Map<String, dynamic> json) {
    return PropertyMedia(
      id: (json['id'] ?? '').toString(),
      fileUrl: (json['fileUrl'] ?? '').toString(),
      mediaType: (json['mediaType'] ?? '').toString(),
      cover: json['cover'] == true,
      sortOrder: (json['sortOrder'] is int)
          ? json['sortOrder'] as int
          : int.tryParse(json['sortOrder']?.toString() ?? '') ?? 0,
    );
  }
}

class PropertyDetailResponse {
  PropertyDetailResponse({required this.property, required this.media});

  final PropertyItem property;
  final List<PropertyMedia> media;

  List<String> get photoUrls {
    final photos = media.where((m) => m.mediaType == 'PHOTO').toList()
      ..sort((a, b) {
        if (a.cover && !b.cover) return -1;
        if (!a.cover && b.cover) return 1;
        return a.sortOrder.compareTo(b.sortOrder);
      });
    return photos.map((m) => m.fileUrl).where((u) => u.isNotEmpty).toList();
  }
}

class PropertyAmenity {
  PropertyAmenity({required this.id, required this.code, this.description});

  final String id;
  final String code;
  final String? description;

  factory PropertyAmenity.fromJson(Map<String, dynamic> json) {
    return PropertyAmenity(
      id: (json['id'] ?? '').toString(),
      code: (json['code'] ?? '').toString(),
      description: (json['description'] ?? '').toString().trim().isEmpty
          ? null
          : (json['description'] ?? '').toString(),
    );
  }
}

class PropertyItem {
  PropertyItem({
    required this.id,
    required this.title,
    required this.city,
    required this.district,
    required this.address,
    required this.propertyType,
    required this.transactionType,
    required this.price,
    required this.rooms,
    required this.bedrooms,
    required this.bathrooms,
    required this.coverPhotoUrl,
    required this.boosted,
    required this.amenities,
    this.hotelId,
    this.hotelName,
    this.agencyName,
    this.ownerName,
    this.description,
    this.condition,
    this.yearBuilt,
    this.surfaceTotal,
    this.surfaceLiving,
    this.balconies,
    this.floor,
    this.totalFloors,
    this.street,
    this.latitude,
    this.longitude,
  });

  final String id;
  final String title;
  final String city;
  final String district;
  final String address;
  final String propertyType;
  final String transactionType;
  final double price;
  final int rooms;
  final int bedrooms;
  final int bathrooms;
  final String? coverPhotoUrl;
  final bool boosted;
  final List<PropertyAmenity> amenities;
  final String? hotelId;
  final String? hotelName;
  final String? agencyName;
  final String? ownerName;
  final String? description;
  final String? condition;
  final int? yearBuilt;
  final double? surfaceTotal;
  final double? surfaceLiving;
  final int? balconies;
  final int? floor;
  final int? totalFloors;
  final String? street;
  final double? latitude;
  final double? longitude;

  factory PropertyItem.fromJson(Map<String, dynamic> json) {
    final amenitiesRaw = json['amenities'];
    final List<PropertyAmenity> amenities;
    if (amenitiesRaw is List) {
      amenities = amenitiesRaw
          .whereType<Map<String, dynamic>>()
          .map(PropertyAmenity.fromJson)
          .toList(growable: false);
    } else {
      amenities = const [];
    }

    return PropertyItem(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      district: (json['district'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      propertyType: (json['propertyType'] ?? '').toString(),
      transactionType: (json['transactionType'] ?? '').toString(),
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '') ?? 0,
      rooms: (json['rooms'] is int)
          ? json['rooms'] as int
          : int.tryParse(json['rooms']?.toString() ?? '') ?? 0,
      bedrooms: (json['bedrooms'] is int)
          ? json['bedrooms'] as int
          : int.tryParse(json['bedrooms']?.toString() ?? '') ?? 0,
      bathrooms: (json['bathrooms'] is int)
          ? json['bathrooms'] as int
          : int.tryParse(json['bathrooms']?.toString() ?? '') ?? 0,
      coverPhotoUrl: (json['coverPhotoUrl'] ?? '').toString().trim().isEmpty
          ? null
          : (json['coverPhotoUrl'] ?? '').toString(),
      boosted: json['boosted'] == true,
      amenities: amenities,
      hotelId: (json['hotelId'] ?? '').toString().trim().isEmpty
          ? null
          : (json['hotelId'] ?? '').toString(),
      hotelName: (json['hotelName'] ?? '').toString().trim().isEmpty
          ? null
          : (json['hotelName'] ?? '').toString(),
      agencyName: (json['agencyName'] ?? '').toString().trim().isEmpty
          ? null
          : (json['agencyName'] ?? '').toString(),
      ownerName: (json['ownerName'] ?? '').toString().trim().isEmpty
          ? null
          : (json['ownerName'] ?? '').toString(),
      description: (json['description'] ?? '').toString().trim().isEmpty
          ? null
          : (json['description'] ?? '').toString(),
      condition: (json['condition'] ?? '').toString().trim().isEmpty
          ? null
          : (json['condition'] ?? '').toString(),
      yearBuilt: (json['yearBuilt'] is int)
          ? json['yearBuilt'] as int
          : int.tryParse(json['yearBuilt']?.toString() ?? ''),
      surfaceTotal: (json['surfaceTotal'] is num)
          ? (json['surfaceTotal'] as num).toDouble()
          : double.tryParse(json['surfaceTotal']?.toString() ?? ''),
      surfaceLiving: (json['surfaceLiving'] is num)
          ? (json['surfaceLiving'] as num).toDouble()
          : double.tryParse(json['surfaceLiving']?.toString() ?? ''),
      balconies: (json['balconies'] is int)
          ? json['balconies'] as int
          : int.tryParse(json['balconies']?.toString() ?? ''),
      floor: (json['floor'] is int)
          ? json['floor'] as int
          : int.tryParse(json['floor']?.toString() ?? ''),
      totalFloors: (json['totalFloors'] is int)
          ? json['totalFloors'] as int
          : int.tryParse(json['totalFloors']?.toString() ?? ''),
      street: (json['street'] ?? '').toString().trim().isEmpty
          ? null
          : (json['street'] ?? '').toString(),
      latitude: (json['latitude'] is num)
          ? (json['latitude'] as num).toDouble()
          : double.tryParse(json['latitude']?.toString() ?? ''),
      longitude: (json['longitude'] is num)
          ? (json['longitude'] as num).toDouble()
          : double.tryParse(json['longitude']?.toString() ?? ''),
    );
  }
}

class PropertiesPage {
  PropertiesPage({
    required this.totalItems,
    required this.page,
    required this.perPage,
    required this.totalPages,
    required this.results,
  });

  final int totalItems;
  final int page;
  final int perPage;
  final int totalPages;
  final List<PropertyItem> results;

  factory PropertiesPage.fromJson(Map<String, dynamic> json) {
    final raw = json['results'];
    final List<PropertyItem> results;
    if (raw is List) {
      results = raw
          .whereType<Map<String, dynamic>>()
          .map(PropertyItem.fromJson)
          .toList(growable: false);
    } else {
      results = const [];
    }

    return PropertiesPage(
      totalItems: (json['total-items'] is int)
          ? json['total-items'] as int
          : int.tryParse(json['total-items']?.toString() ?? '') ?? 0,
      page: (json['page'] is int)
          ? json['page'] as int
          : int.tryParse(json['page']?.toString() ?? '') ?? 0,
      perPage: (json['perPage'] is int)
          ? json['perPage'] as int
          : int.tryParse(json['perPage']?.toString() ?? '') ?? 0,
      totalPages: (json['total-pages'] is int)
          ? json['total-pages'] as int
          : int.tryParse(json['total-pages']?.toString() ?? '') ?? 0,
      results: results,
    );
  }
}
