class ApiResponse<T> {
  ApiResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    this.data,
  });

  final String status;
  final int statusCode;
  final String message;
  final T? data;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    final raw = json['data'];
    return ApiResponse<T>(
      status: (json['status'] ?? '').toString(),
      statusCode: (json['statusCode'] is int)
          ? json['statusCode'] as int
          : int.tryParse(json['statusCode']?.toString() ?? '') ?? 0,
      message: (json['message'] ?? '').toString(),
      data: raw == null || fromJsonT == null ? null : fromJsonT(raw),
    );
  }
}
