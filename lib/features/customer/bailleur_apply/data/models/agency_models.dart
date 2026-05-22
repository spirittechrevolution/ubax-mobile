class AgencyItem {
  const AgencyItem({
    required this.id,
    required this.name,
    required this.verified,
    this.description,
    this.logoUrl,
    this.address,
    this.city,
    this.country,
    this.phone,
    this.email,
    this.website,
    this.memberSince,
    this.propertiesCount,
  });

  final String id;
  final String name;
  final bool verified;
  final String? description;
  final String? logoUrl;
  final String? address;
  final String? city;
  final String? country;
  final String? phone;
  final String? email;
  final String? website;
  final int? memberSince;
  final int? propertiesCount;

  factory AgencyItem.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    // memberSince : année extraite de createdAt ou champ dédié
    int? memberSince;
    final createdAt = json['createdAt']?.toString() ?? json['memberSince']?.toString();
    if (createdAt != null && createdAt.length >= 4) {
      memberSince = int.tryParse(createdAt.substring(0, 4));
    }
    memberSince ??= parseInt(json['memberSince']);

    return AgencyItem(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      verified: json['verified'] == true,
      description: _str(json['description']),
      logoUrl: _str(json['logoUrl']),
      address: _str(json['address']),
      city: _str(json['city']),
      country: _str(json['country']),
      phone: _str(json['phone']),
      email: _str(json['email']),
      website: _str(json['website']),
      memberSince: memberSince,
      propertiesCount: parseInt(json['propertiesCount'] ?? json['propertyCount']),
    );
  }

  static String? _str(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }
}

class AgenciesPage {
  const AgenciesPage({
    required this.results,
    required this.totalElements,
    required this.totalPages,
    required this.page,
    required this.size,
  });

  final List<AgencyItem> results;
  final int totalElements;
  final int totalPages;
  final int page;
  final int size;

  bool get isLast => page >= totalPages - 1;

  factory AgenciesPage.fromJson(Map<String, dynamic> json) {
    final raw = json['results'] ?? json['content'];
    final List<AgencyItem> results;
    if (raw is List) {
      results = raw
          .whereType<Map<String, dynamic>>()
          .map(AgencyItem.fromJson)
          .toList(growable: false);
    } else {
      results = const [];
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

    return AgenciesPage(
      results: results,
      totalElements: readInt(const ['totalElements', 'total-items']),
      totalPages: readInt(const ['totalPages', 'total-pages']),
      page: readInt(const ['number', 'page']),
      size: readInt(const ['size', 'perPage']),
    );
  }
}
