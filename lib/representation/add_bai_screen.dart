import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/bai_model.dart';
import 'package:fptu_bike_parking_system/api/service/bai_be/bai_service.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';
import 'package:fptu_bike_parking_system/core/helper/return_login_dialog.dart';
import 'package:fptu_bike_parking_system/representation/navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../api/model/bai_model/api_response.dart';
import '../component/app_bar_component.dart';
import '../component/shadow_button.dart';
import '../component/snackbar.dart';
import '../core/const/frondend/message.dart';
import '../core/const/utilities/regex.dart';
import '../core/helper/loading_overlay_helper.dart';

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
  late String responseText;
  final TextEditingController _plateNumberController = TextEditingController();
  CallBikeApi api = CallBikeApi();
  bool isValidInput = true;

  late Color backgroundColor = Theme.of(context).colorScheme.surface;
  late Color onSuccessful = Theme.of(context).colorScheme.onError;
  late Color onUnsuccessful = Theme.of(context).colorScheme.error;

  @override
  void initState() {
    super.initState();
    log.i('AddBai widget initialized');
    _fetchVehicleType();
  }

  List<VehicleTypeModel> _vehicleType = [];
  bool isLoaded = false;

  Future<void> selectImage(BuildContext context) async {
    try {
      ImageSource? source = await showSourceDialog(context);
      if (source == null) return;

      XFile? imageFile = await ImagePicker().pickImage(source: source);
      if (imageFile == null) return;

      String imagePath = imageFile.path;
      if (mounted) {
        setState(() {
          imageUrl = imagePath;
          _plateNumberController.clear();
        });
      }

      log.i('Image successfully picked: $imageUrl');

      await detectPlateNumber(File(imagePath));
    } catch (e, stackTrace) {
      log.e('Error picking image: $e');
      log.e(stackTrace);
    }
  }

  // Get plate number from image
  Future<void> detectPlateNumber(File imageFile) async {
    try {
      // Show loading
      LoadingOverlayHelper.show(context);

      // Detect plate number
      PlateNumberResponse? plateNumberResponse =
          await api.detectPlateNumber(imageFile);

      // Hide loading
      LoadingOverlayHelper.hide();

      if (plateNumberResponse?.data?.plateNumber != null) {
        if (mounted) {
          setState(() {
            _plateNumberController.text =
                plateNumberResponse!.data!.plateNumber;
          });
        }
      } else {
        log.e('Failed to detect plate number');

        //remove image
        if (mounted) {
          setState(() {
            imageUrl = null;
            _plateNumberController.clear();
          });
        }
      }
    } catch (e, stackTrace) {
      LoadingOverlayHelper.hide();
      log.e('Error detecting plate number: $e');
      log.e(stackTrace);
    }
  }

  Future<void> _saveVehicleRegistration() async {
    if (imageUrl != null && _selectedVehicleTypeId != null) {
      if (_plateNumberController.text.isEmpty) {
        log.e('Plate number is empty');
        showCustomSnackBar(
          MySnackBar(
            prefix: Icon(
              Icons.cancel_rounded,
              color: backgroundColor,
            ),
            message: 'Plate number is required.',
            backgroundColor: onUnsuccessful,
          ),
        );
        return;
      }

      AddBaiModel addBaiModel = AddBaiModel(
        plateNumber: _plateNumberController.text,
        plateImage: File(imageUrl!),
        vehicleTypeId: _selectedVehicleTypeId!,
      );

      log.i('Saving vehicle registration: $addBaiModel');

      APIResponse<AddBaiRespModel> result = await api.createBai(addBaiModel);

      if (result.isTokenValid == false &&
          result.message == ErrorMessage.tokenInvalid) {
        log.e('Token is invalid');

        if (!mounted) return;
        //show login dialog
        ReturnLoginDialog.returnLogin(context);
        return;
      }

      if (result.data != null) {
        log.i('Vehicle registration saved successfully');
        showCustomSnackBar(
          MySnackBar(
            prefix: Icon(
              Icons.check_circle_rounded,
              color: backgroundColor,
            ),
            message: Message.actionSuccessfully(
                action: LabelMessage.add(message: ListName.bai)),
            backgroundColor: onSuccessful,
          ),
        );

        goToPageHelper(
          MyNavigationBar.routeName,
          index: 1,
        );
      } else {
        log.e('Failed to save vehicle registration');
        showCustomSnackBar(
          MySnackBar(
            prefix: Icon(
              Icons.cancel_rounded,
              color: backgroundColor,
            ),
            message: ErrorMessage.somethingWentWrong,
            backgroundColor: onUnsuccessful,
          ),
        );
      }
    } else {
      log.e('Vehicle type, image URL, or plate number is null');

      showCustomSnackBar(
        MySnackBar(
          prefix: Icon(
            Icons.cancel_rounded,
            color: backgroundColor,
          ),
          message: ErrorMessage.inputRequired(message: ListName.vehicle),
          backgroundColor: onUnsuccessful,
        ),
      );
    }
  }

  void _fetchVehicleType() async {
    try {
      List<VehicleTypeModel>? vehicleType = await api.getVehicleType();

      if (mounted) {
        setState(() {
          _vehicleType = vehicleType ?? [];
          isLoaded = true;
        });
      }
    } catch (e) {
      log.e('Error fetching vehicle type: $e');
      if (mounted) {
        setState(() {
          isLoaded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCom(
        leading: true,
        appBarText: 'Add Bike',
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(top: 25),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async => await selectImage(context),
                    child: ShadowContainer(
                      padding: const EdgeInsets.all(0),
                      color: Theme.of(context).colorScheme.outlineVariant,
                      height: MediaQuery.of(context).size.height * 0.35,
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vehicle Type*',
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
                          items:
                              _vehicleType.map((VehicleTypeModel vehicleType) {
                            return DropdownMenuItem<String>(
                              value: vehicleType.id,
                              child: Text(
                                vehicleType.name,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (mounted) {
                              setState(() {
                                _selectedVehicleTypeId = newValue;
                              });
                            }
                            log.i('Selected vehicle type: $newValue');
                          },
                          isExpanded: true,
                          underline: Container(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Plate number label
                      Text(
                        'Plate Number*',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 5,
                      ),

                      // plate number error message
                      if (!isValidInput)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            ErrorMessage.inputInvalid(
                                message: ListName.plateNumber),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      // Plate number input field
                      ShadowContainer(
                        padding: const EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height * 0.065,
                        child: TextField(
                          controller: _plateNumberController,
                          readOnly: imageUrl == null,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onChanged: (value) {
                            String updatedValue = value.toUpperCase();

                            if (mounted) {
                              setState(() {
                                _plateNumberController.value =
                                    _plateNumberController.value.copyWith(
                                  text: updatedValue,
                                  selection: TextSelection.collapsed(
                                      offset: updatedValue.length),
                                );
                              });
                            }
                          },
                          onEditingComplete: () {
                            String currentValue = _plateNumberController.text;
                            if (mounted) {
                              setState(() {
                                isValidInput =
                                    Regex.plateRegExp.hasMatch(currentValue);
                                _plateNumberController.text =
                                    isValidInput ? currentValue : '';
                              });
                            }
                          },
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.edit_rounded,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            hintText: 'ex: 37A012345',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25, bottom: 5),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          'By tapping ADD you agree to submit request new bike to your account.',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // show loading
                      LoadingOverlayHelper.show(context);

                      await _saveVehicleRegistration();

                      // hide loading
                      LoadingOverlayHelper.hide();
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
      ),
    );
  }

  Future<ImageSource?> showSourceDialog(BuildContext context) async {
    return showDialog<ImageSource?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose image source'),
          surfaceTintColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_album),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  // show custom snackbar
  void showCustomSnackBar(MySnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: snackBar,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  void goToPageHelper(String? routeName, {int? index}) {
    routeName == null
        ? Navigator.of(context).pop()
        : Navigator.of(context).pushReplacementNamed(
            routeName,
            arguments: index,
          );
  }
}
