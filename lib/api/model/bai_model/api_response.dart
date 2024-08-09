import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class APIResponse<T> {
  final T? data;
  final String? message;
  final int? totalRecord;
  final bool isTokenValid;

  APIResponse({
    this.data,
    this.message,
    this.totalRecord,
    this.isTokenValid = true,
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
    return 'APIResponse{data: $data, message: $message, totalRecord: $totalRecord, isTokenValid: $isTokenValid}';
  }
}

class PlateNumberResponse {
  final PlateNumberData? data;
  final String? message;
  final bool? isSuccess;

  PlateNumberResponse({
    this.data,
    this.message,
    this.isSuccess,
  });

  factory PlateNumberResponse.fromJson(Map<String, dynamic> json) {
    return PlateNumberResponse(
      data: PlateNumberData.fromJson(json['data']),
      message: json['message'],
      isSuccess: json['isSuccess'],
    );
  }
}

class PlateNumberData {
  final String plateNumber;
  final String imageBase64;

  PlateNumberData({
    required this.plateNumber,
    required this.imageBase64,
  });

  factory PlateNumberData.fromJson(Map<String, dynamic> json) {
    return PlateNumberData(
      plateNumber: json['plateNumber'],
      imageBase64: json['image'],
    );
  }

  File get image {
    final bytes = base64Decode(imageBase64);
    return File.fromRawPath(Uint8List.fromList(bytes));
  }
}
