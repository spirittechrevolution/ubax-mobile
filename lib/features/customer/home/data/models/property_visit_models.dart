class AvailableSlot {
  AvailableSlot({required this.date, required this.timeSlots});

  final String date;
  final List<String> timeSlots;

  factory AvailableSlot.fromJson(Map<String, dynamic> json) {
    final raw = json['timeSlots'] ?? json['slots'] ?? json['times'];
    final List<String> timeSlots;
    if (raw is List) {
      timeSlots = raw.map((e) => e.toString()).toList(growable: false);
    } else {
      timeSlots = const [];
    }
    return AvailableSlot(
      date: (json['date'] ?? '').toString(),
      timeSlots: timeSlots,
    );
  }
}

class PropertyVisitRequest {
  PropertyVisitRequest({
    required this.propertyId,
    required this.requestedDate,
    required this.requestedTimeSlot,
    this.clientNotes,
  });

  final String propertyId;
  final String requestedDate;
  final String requestedTimeSlot;
  final String? clientNotes;

  Map<String, dynamic> toJson() => {
        'propertyId': propertyId,
        'requestedDate': requestedDate,
        'requestedTimeSlot': requestedTimeSlot,
        if (clientNotes != null && clientNotes!.isNotEmpty)
          'clientNotes': clientNotes,
      };
}

class PropertyVisitResponse {
  PropertyVisitResponse({required this.id, required this.status});

  final String id;
  final String status;

  factory PropertyVisitResponse.fromJson(Map<String, dynamic> json) {
    return PropertyVisitResponse(
      id: (json['id'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
    );
  }
}
