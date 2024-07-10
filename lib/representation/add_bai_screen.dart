import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/bai_model.dart';
import 'package:fptu_bike_parking_system/api/service/bai_be/bai_service.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../component/app_bar_component.dart';
import '../component/shadow_button.dart';

class AddBai extends StatefulWidget {
  static String routeName = '/addBai';

  const AddBai({super.key});

  @override
  State<AddBai> createState() => _AddBaiState();
}

class _AddBaiState extends State<AddBai> {
  var log = Logger();
  String? imageUrl;
  String? _selectedVehicleTypeId;
  String? _plateNumber;
  CallBikeApi api = CallBikeApi();

  @override
  void initState() {
    super.initState();
    log.i('AddBai widget initialized');
    _fetchVehicleType();
    //_saveVehicleRegistration();
  }

  List<VehicleTypeModel> _vehicleType = [];

  // ignore: unused_field
  bool _isEmptyList = true;
  bool isLoaded = false;

  Future<void> selectImage(BuildContext context) async {
    try {
      // Let user choose image from gallery or camera
      ImageSource? source = await showSourceDialog(context);

      // Pick image
      ImagePicker imagePicker = ImagePicker();
      XFile? imageFile =
          await imagePicker.pickImage(source: source ?? ImageSource.gallery);

      // Check if user cancels picking image
      if (imageFile == null) {
        return;
      }

      // Convert image to PNG if not already
      String extension = imageFile.path.split('.').last.toLowerCase();
      if (extension != 'png') {
        // Create new file path with .png extension
        String newPath = imageFile.path.replaceAll(extension, 'png');

        // Rename file to .png
        await File(imageFile.path).rename(newPath);
        imageFile = XFile(newPath);
      }

      // Save image path to state
      setState(() {
        imageUrl = imageFile!.path;
      });

      log.i('Image successfully picked: $imageUrl');
    } catch (e) {
      log.e('Error picking image: $e');
    }
  }

  Future<void> _saveVehicleRegistration() async {
    if (imageUrl != null &&
        _selectedVehicleTypeId != null &&
        _plateNumber != null) {
      BaiModel baiModel = BaiModel(
        plateNumber: _plateNumber,
        plateImageFile: File(imageUrl!),
        vehicleTypeId: _selectedVehicleTypeId!,
      );

      BaiModel? result = await api.createBai(baiModel);

      if (result != null) {
        log.i('Vehicle registration saved successfully');
      } else {
        log.e('Failed to save vehicle registration');
      }
    } else {
      log.e('Vehicle type, image URL, or plate number is null');
    }
  }

  void _fetchVehicleType() async {
    try {
      List<VehicleTypeModel>? vehicleType = await api.getVehicleType();

      if (vehicleType!.isEmpty) {
        setState(() {
          _isEmptyList = true;
          isLoaded = true;
        });
      } else {
        setState(() {
          _vehicleType = vehicleType;
          _isEmptyList = false;
        });
      }
    } catch (e) {
      log.e('Error fetching vehicle type: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    log.i('Building AddBai widget');
    return Scaffold(
      appBar: const AppBarCom(
        leading: true,
        appBarText: 'Add Bike',
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(top: 25),
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShadowContainer(
                  padding: const EdgeInsets.all(0),
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GestureDetector(
                      onTap: () async => await selectImage(context),
                      child: imageUrl == null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_rounded,
                                  size: 50,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Upload your vehicle image\nrequired*',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : Image.file(
                              File(imageUrl!),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle Type',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ShadowContainer(
                      padding: const EdgeInsets.all(10),
                      height: MediaQuery.of(context).size.height * 0.065,
                      child: DropdownButton<String>(
                        hint: Text(
                          'Select vehicle type',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        value: _selectedVehicleTypeId,
                        items: _vehicleType.map((VehicleTypeModel vehicleType) {
                          return DropdownMenuItem<String>(
                            value: vehicleType.id,
                            child: Text(
                              vehicleType.name,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedVehicleTypeId = newValue;
                          });
                          log.i('Selected vehicle type: $newValue');
                        },
                        isExpanded: true,
                        underline: Container(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Plate Number',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ShadowContainer(
                      padding: const EdgeInsets.all(10),
                      height: MediaQuery.of(context).size.height * 0.065,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _plateNumber = value;
                          });
                        },
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.edit_rounded,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      'By tapping ADD you agree to submit request new bike to your account.',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await _saveVehicleRegistration();
                  },
                  child: const ShadowButton(
                    buttonTitle: 'ADD',
                    margin: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<ImageSource?> showSourceDialog(BuildContext context) async {
    return showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Choose image source'),
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image_rounded),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context, ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }
}
