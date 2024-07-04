import 'dart:io';

class BaiModel {
  final String? plateNumber;
  final File? plateImage;
  final String? vehicleTypeId;
  final int? totalBike;

  BaiModel({
    this.plateNumber,
    this.plateImage,
    this.vehicleTypeId,
    this.totalBike,
  });

  factory BaiModel.fromJson(Map<String, dynamic> json) {
    return BaiModel(
      plateNumber: json['plateNumber'],
      plateImage: json['plateImage'] != null ? File(json['plateImage']) : null,
      vehicleTypeId: json['vehicleTypeId'],
      totalBike: json['totalBike'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plateNumber': plateNumber,
      'plateImage': plateImage,
      'vehicleTypeId': vehicleTypeId
    };
  }
}

class VehicleTypeModel {
  final String? id;
  final String name;
  final String? description;

  VehicleTypeModel({
    this.id,
    required this.name,
    this.description,
  });

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) {
    return VehicleTypeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
