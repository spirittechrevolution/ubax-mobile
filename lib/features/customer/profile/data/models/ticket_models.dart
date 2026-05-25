class TicketItem {
  TicketItem({
    required this.id,
    required this.reference,
    required this.category,
    required this.title,
    required this.status,
    required this.createdAt,
    this.residence = '',
    this.apartment = '',
  });

  final String id;
  final String reference;
  final String category;
  final String title;
  final String status;
  final String createdAt;
  final String residence;
  final String apartment;

  bool get isResolved =>
      status.toUpperCase() == 'RESOLVED' || status.toUpperCase() == 'CLOSED';

  factory TicketItem.fromJson(Map<String, dynamic> json) {
    final contract = json['contract'] as Map<String, dynamic>? ?? {};
    final property = contract['property'] as Map<String, dynamic>? ?? {};
    return TicketItem(
      id: (json['id'] ?? '').toString(),
      reference: (json['reference'] ?? json['ticketNumber'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      createdAt: (json['createdAt'] ?? '').toString(),
      residence: (property['name'] ?? property['title'] ?? '').toString(),
      apartment: (contract['apartmentNumber'] ?? contract['unit'] ?? '').toString(),
    );
  }
}

class CreateTicketRequest {
  CreateTicketRequest({
    required this.contractId,
    required this.category,
    required this.title,
    required this.description,
    required this.priority,
  });

  final String contractId;
  final String category;
  final String title;
  final String description;
  final String priority;

  Map<String, dynamic> toJson() => {
        if (contractId.isNotEmpty) 'contractId': contractId,
        'category': category,
        'title': title,
        'description': description,
        'priority': priority,
        'attachments': <dynamic>[],
      };
}
