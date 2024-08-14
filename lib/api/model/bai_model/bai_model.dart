import 'dart:io';

class BaiModel {
  final String id;
  final String plateNumber;
  final String plateImage;
  final String status;
  final String vehicleType;
  final DateTime createDate;

  BaiModel({
    required this.id,
    required this.plateNumber,
    required this.plateImage,
    required this.status,
    required this.vehicleType,
    required this.createDate,
  });

  factory BaiModel.fromJson(Map<String, dynamic> json) {
    return BaiModel(
      id: json['id'],
      plateNumber: json['plateNumber'],
      plateImage: json['plateImage'],
      status: json['statusVehicle'],
      vehicleType: json['vehicleTypeName'],
      createDate: DateTime.parse(json['createDate']),
    );
  }

  //toString
  @override
  String toString() {
    return 'BaiModel{id: $id, plateNumber: $plateNumber, plateImage: $plateImage, status: $status, vehicleType: $vehicleType, createDate: $createDate}';
  }
}

class AddBaiModel {
  final String plateNumber;
  final File plateImage;
  final String vehicleTypeId;

  AddBaiModel({
    required this.plateNumber,
    required this.plateImage,
    required this.vehicleTypeId,
  });

  //toString
  @override
  String toString() {
    return 'AddBaiModel{plateNumber: $plateNumber, plateImage: $plateImage, vehicleTypeId: $vehicleTypeId}';
  }
}

class AddBaiRespModel {
  final String vehicleId;
  final String imagePlateNumber;
  final String vehicleTypeName;
  final String plateNumber;

  AddBaiRespModel({
    required this.vehicleId,
    required this.imagePlateNumber,
    required this.vehicleTypeName,
    required this.plateNumber,
  });

  factory AddBaiRespModel.fromJson(Map<String, dynamic> json) {
    return AddBaiRespModel(
      vehicleId: json['vehicleId'],
      imagePlateNumber: json['imagePlateNumber'],
      vehicleTypeName: json['vehicleTypeName'],
      plateNumber: json['plateNumber'],
    );
  }

  //toString
  @override
  String toString() {
    return 'AddBaiResponse{vehicleId: $vehicleId, imagePlateNumber: $imagePlateNumber, vehicleTypeName: $vehicleTypeName, plateNumber: $plateNumber}';
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

class UpdateBaiModel {
  final String vehicleId;
  final String plateNumber;
  final String vehicleTypeId;

  UpdateBaiModel({
    required this.vehicleId,
    required this.plateNumber,
    required this.vehicleTypeId,
  });

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'plateNumber': plateNumber,
      'vehicleTypeId': vehicleTypeId,
    };
  }
}
