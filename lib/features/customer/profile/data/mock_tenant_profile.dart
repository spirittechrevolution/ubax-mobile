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
  });

  final String name;
  final String role;
  final String agency;
  final String avatarAsset;
  final int balance;
  final int paidCount;
  final int pendingCount;
  final int unpaidCount;
  final String nextRentDate;
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
