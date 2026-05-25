class ReservationRequest {
  const ReservationRequest({
    required this.propertyId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guestCount,
    this.notes,
  });

  final String propertyId;
  final String checkInDate;
  final String checkOutDate;
  final int guestCount;
  final String? notes;

  Map<String, dynamic> toJson() => {
        'propertyId': propertyId,
        'checkInDate': checkInDate,
        'checkOutDate': checkOutDate,
        'guestCount': guestCount,
        if (notes != null && notes!.isNotEmpty) 'notes': notes,
      };
}

class ReservationResponse {
  const ReservationResponse({
    required this.id,
    required this.propertyTitle,
    required this.propertyCity,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfNights,
    required this.guestCount,
    required this.pricePerNight,
    required this.totalAmount,
    required this.status,
    this.notes,
    this.createdAt,
  });

  final String id;
  final String propertyTitle;
  final String propertyCity;
  final String checkInDate;
  final String checkOutDate;
  final int numberOfNights;
  final int guestCount;
  final double pricePerNight;
  final double totalAmount;
  final String status;
  final String? notes;
  final String? createdAt;

  factory ReservationResponse.fromJson(Map<String, dynamic> json) {
    return ReservationResponse(
      id: (json['id'] ?? '').toString(),
      propertyTitle: (json['propertyTitle'] ?? '').toString(),
      propertyCity: (json['propertyCity'] ?? '').toString(),
      checkInDate: (json['checkInDate'] ?? '').toString(),
      checkOutDate: (json['checkOutDate'] ?? '').toString(),
      numberOfNights: (json['numberOfNights'] as num?)?.toInt() ?? 0,
      guestCount: (json['guestCount'] as num?)?.toInt() ?? 0,
      pricePerNight: (json['pricePerNight'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      status: (json['status'] ?? '').toString(),
      notes: json['notes']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }
}
