class APIResponse<T> {
  final T? data;
  final String? message;
  final int? totalRecord;

  APIResponse({
    this.data,
    this.message,
    this.totalRecord,
  });

  factory APIResponse.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return APIResponse<T>(
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'],
      totalRecord: json['totalRecord'],
    );
  }

  @override
  String toString() {
    return 'APIResponse{data: $data, message: $message, totalRecord: $totalRecord}';
  }
}
