import 'dart:io';

class BaiModel {
  final String? plateNumber;
  final File? plateImageFile;
  final String? plateImage;
  final String? vehicleTypeId;
  final String? status;
  final String? vehicleType;

  BaiModel({
    this.status,
    this.vehicleType,
    this.plateNumber,
    this.plateImageFile,
    this.vehicleTypeId,
    this.plateImage, 
  });

  factory BaiModel.fromJson(Map<String, dynamic> json) {
    return BaiModel(
      plateNumber: json['plateNumber'],
      plateImage: json['plateImage'],
      status: json['statusVehicle'],
      vehicleType: json['vehicleTypeName'],
    );
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
}
