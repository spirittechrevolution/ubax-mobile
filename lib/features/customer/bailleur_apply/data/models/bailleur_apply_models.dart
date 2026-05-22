class BailleurApplication {
  const BailleurApplication({
    required this.id,
    required this.agencyId,
    required this.agencyName,
    required this.status,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.idType,
    this.idNumber,
    this.idDocRectoUrl,
    this.idDocVersoUrl,
    this.description,
    this.rejectionReason,
    this.createdAt,
  });

  final String id;
  final String agencyId;
  final String agencyName;
  final String status; // PENDING | APPROVED | REJECTED
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final String? idType;
  final String? idNumber;
  final String? idDocRectoUrl;
  final String? idDocVersoUrl;
  final String? description;
  final String? rejectionReason;
  final DateTime? createdAt;

  factory BailleurApplication.fromJson(Map<String, dynamic> json) {
    return BailleurApplication(
      id: (json['id'] ?? '').toString(),
      agencyId: (json['agencyId'] ?? '').toString(),
      agencyName: (json['agencyName'] ?? '').toString(),
      status: (json['status'] ?? 'PENDING').toString(),
      firstName: _str(json['firstName']),
      lastName: _str(json['lastName']),
      phone: _str(json['phone']),
      email: _str(json['email']),
      idType: _str(json['idType']),
      idNumber: _str(json['idNumber']),
      idDocRectoUrl: _str(json['idDocRectoUrl']),
      idDocVersoUrl: _str(json['idDocVersoUrl']),
      description: _str(json['description']),
      rejectionReason: _str(json['rejectionReason']),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  static String? _str(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }
}
