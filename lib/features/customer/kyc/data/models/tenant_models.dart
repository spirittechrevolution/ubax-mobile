class TenantProfile {
  const TenantProfile({
    required this.id,
    required this.status,
    required this.hasGuarantor,
    required this.qualified,
    this.fullName,
    this.email,
    this.employmentStatus,
    this.employerName,
    this.monthlyIncome,
    this.guarantorName,
    this.guarantorPhone,
    this.guarantorEmail,
    this.idDocumentUrl,
    this.idDocumentType,
    this.idDocumentNumber,
    this.idDocumentExpiry,
    this.incomeProofUrl,
    this.addressProofUrl,
    this.rejectionReason,
    this.propertyId,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String status; // INCOMPLETE | PENDING_REVIEW | QUALIFIED | REJECTED | BLACKLISTED
  final bool hasGuarantor;
  final bool qualified;
  final String? fullName;
  final String? email;
  final String? employmentStatus;
  final String? employerName;
  final double? monthlyIncome;
  final String? guarantorName;
  final String? guarantorPhone;
  final String? guarantorEmail;
  final String? idDocumentUrl;
  final String? idDocumentType;
  final String? idDocumentNumber;
  final String? idDocumentExpiry;
  final String? incomeProofUrl;
  final String? addressProofUrl;
  final String? rejectionReason;
  final String? propertyId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory TenantProfile.fromJson(Map<String, dynamic> json) {
    return TenantProfile(
      id: (json['id'] ?? '').toString(),
      status: (json['status'] ?? 'INCOMPLETE').toString(),
      hasGuarantor: json['hasGuarantor'] == true,
      qualified: json['qualified'] == true,
      fullName: _str(json['fullName']),
      email: _str(json['email']),
      employmentStatus: _str(json['employmentStatus']),
      employerName: _str(json['employerName']),
      monthlyIncome: (json['monthlyIncome'] is num)
          ? (json['monthlyIncome'] as num).toDouble()
          : double.tryParse(json['monthlyIncome']?.toString() ?? ''),
      guarantorName: _str(json['guarantorName']),
      guarantorPhone: _str(json['guarantorPhone']),
      guarantorEmail: _str(json['guarantorEmail']),
      idDocumentUrl: _str(json['idDocumentUrl']),
      idDocumentType: _str(json['idDocumentType']),
      idDocumentNumber: _str(json['idDocumentNumber']),
      idDocumentExpiry: _str(json['idDocumentExpiry']),
      incomeProofUrl: _str(json['incomeProofUrl']),
      addressProofUrl: _str(json['addressProofUrl']),
      rejectionReason: _str(json['rejectionReason']),
      propertyId: _str(json['propertyId']),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  static String? _str(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }
}

class UploadResult {
  const UploadResult({
    required this.fileUrl,
    this.objectName,
    this.bucket,
    this.fileName,
    this.mimeType,
  });

  final String fileUrl;
  final String? objectName;
  final String? bucket;
  final String? fileName;
  final String? mimeType;

  factory UploadResult.fromJson(Map<String, dynamic> json) {
    return UploadResult(
      fileUrl: (json['fileUrl'] ?? '').toString(),
      objectName: json['objectName']?.toString(),
      bucket: json['bucket']?.toString(),
      fileName: json['fileName']?.toString(),
      mimeType: json['mimeType']?.toString(),
    );
  }
}
