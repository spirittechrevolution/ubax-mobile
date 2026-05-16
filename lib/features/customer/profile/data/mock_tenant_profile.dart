class TenantProfile {
  const TenantProfile({
    required this.name,
    required this.role,
    required this.agency,
    required this.avatarAsset,
    required this.balance,
    required this.paidCount,
    required this.pendingCount,
    required this.unpaidCount,
    required this.nextRentDate,
    this.avatarUrl,
    this.email,
    this.phone,
  });

  final String name;
  final String role;
  final String agency;
  final String avatarAsset;
  final String? avatarUrl;
  final String? email;
  final String? phone;
  final int balance;
  final int paidCount;
  final int pendingCount;
  final int unpaidCount;
  final String nextRentDate;

  TenantProfile copyWith({
    String? name,
    String? role,
    String? agency,
    String? avatarAsset,
    String? avatarUrl,
    String? email,
    String? phone,
    int? balance,
    int? paidCount,
    int? pendingCount,
    int? unpaidCount,
    String? nextRentDate,
  }) {
    return TenantProfile(
      name: name ?? this.name,
      role: role ?? this.role,
      agency: agency ?? this.agency,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      balance: balance ?? this.balance,
      paidCount: paidCount ?? this.paidCount,
      pendingCount: pendingCount ?? this.pendingCount,
      unpaidCount: unpaidCount ?? this.unpaidCount,
      nextRentDate: nextRentDate ?? this.nextRentDate,
    );
  }
}

const kMockTenantProfile = TenantProfile(
  name: 'Arnaud Koffi',
  role: 'Locataire',
  agency: 'Aigle immobilier',
  avatarAsset: 'assets/images/pexels-ekrulila-2128329.jpg',
  balance: -250000,
  paidCount: 5,
  pendingCount: 3,
  unpaidCount: 2,
  nextRentDate: '05 janvier',
);
