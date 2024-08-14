import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/api_response.dart';
import 'package:fptu_bike_parking_system/api/service/bai_be/bai_service.dart';
import 'package:fptu_bike_parking_system/component/snackbar.dart';
import 'package:fptu_bike_parking_system/core/const/frondend/message.dart';
import 'package:fptu_bike_parking_system/core/const/utilities/regex.dart';
import 'package:fptu_bike_parking_system/core/const/utilities/util_helper.dart';
import 'package:fptu_bike_parking_system/core/helper/loading_overlay_helper.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';

import '../api/model/bai_model/bai_model.dart';
import '../component/app_bar_component.dart';
import '../component/image_not_found_component.dart';
import '../core/helper/return_login_dialog.dart';

class BaiDetails extends StatefulWidget {
  final BaiModel baiModel;
  const BaiDetails({
    super.key,
    required this.baiModel,
  });

  static String routeName = '/bai_details';

  @override
  State<BaiDetails> createState() => _BaiDetailsState();
}

class _BaiDetailsState extends State<BaiDetails> {
  late BaiModel bai = widget.baiModel;
  late String plateNumber = UltilHelper.formatPlateNumber(bai.plateNumber);
  late String vehicleType = bai.vehicleType;

  final callVehicleApi = CallBikeApi();

  var log = Logger();

  String _selectedVehicleTypeId = '';
  List<VehicleTypeModel> _vehicleType = [];

  final plController = TextEditingController();
  final typeController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    _fetchVehicleType();
    _selectedVehicleTypeId = bai.vehicleType;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleTextStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.outline,
          fontWeight: FontWeight.bold,
        );

    TextStyle contentTextStyle =
        Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.outline,
            );

    plController.text = bai.plateNumber;

    return Scaffold(
      appBar: AppBarCom(
        leading: true,
        appBarText: 'Bai Details: $plateNumber',
        action: [
          if (bai.status == 'PENDING' || bai.status == 'REJECTED')
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  log.d('Edit button clicked');
                  setState(() {
                    isEdit = !isEdit;
                    log.d('Edit status: $isEdit');
                  });
                },
                child: Icon(
                  Icons.rotate_90_degrees_ccw_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 25,
                ),
              ),
            )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      children: [
                        SizedBox(
                          // height: MediaQuery.of(context).size.height * 0.25,
                          child: CachedNetworkImage(
                            width: double.infinity,
                            imageUrl: bai.plateImage,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor:
                                  Theme.of(context).colorScheme.background,
                              highlightColor:
                                  Theme.of(context).colorScheme.outlineVariant,
                              child: Container(color: Colors.grey),
                            ),
                            errorWidget: (context, url, error) =>
                                const ImageNotFound(),
                          ),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),

                        Text(
                          plateNumber,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),

                        // Vehicle Type
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Vehicle Type',
                                style: titleTextStyle,
                              ),
                              Text(
                                bai.vehicleType,
                                style: contentTextStyle,
                              ),
                            ],
                          ),
                        ),

                        // Date
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Create Date',
                                style: titleTextStyle,
                              ),
                              Text(
                                UltilHelper.formatDateMMMddyyyy(bai.createDate),
                                style: contentTextStyle,
                              ),
                            ],
                          ),
                        ),

                        // Status
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status',
                                style: titleTextStyle,
                              ),
                              Text(
                                bai.status,
                                style: contentTextStyle.copyWith(
                                  color: _getStatusColor(bai.status, context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  GestureDetector(
                    onTap: () {
                      log.d('Delete button clicked');
                      //TODO: Implement Delete function
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outline,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        LabelMessage.delete,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isEdit,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _editIteam(
                      label: ListName.plateNumber,
                      widget: TextField(
                        controller: plController,
                        maxLengthEnforcement: MaxLengthEnforcement.none,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '29MĐ123456',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7.5,
                          ),
                          isDense: true,
                          counter: const Visibility(
                            visible: false,
                            child: SizedBox(),
                          ),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                        ),
                        style: contentTextStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // Vehicle Type
                    _editIteam(
                      label: ListName.vehicleType,
                      widget: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: DropdownButton<String>(
                          hint: Text(
                            'Select vehicle type',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          icon: const Offstage(),
                          underline: const Offstage(),
                          value: _vehicleType
                                  .map((vehicleType) => vehicleType.id)
                                  .contains(_selectedVehicleTypeId)
                              ? _selectedVehicleTypeId
                              : null,
                          items: _vehicleType
                              .map((VehicleTypeModel vehicleType) {
                                return DropdownMenuItem<String>(
                                  value: vehicleType.id,
                                  child: Text(
                                    bai.vehicleType == vehicleType.name
                                        ? '${vehicleType.name} (Current)'
                                        : vehicleType.name,
                                    style: contentTextStyle,
                                  ),
                                );
                              })
                              .toSet()
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedVehicleTypeId = newValue!;
                              log.d(
                                  'Selected vehicle type: $_selectedVehicleTypeId ${bai.vehicleType}');
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // Save button
                    GestureDetector(
                      onTap: () {
                        _handleSave();
                      },
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            LabelMessage.save,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSave() {
    LoadingOverlayHelper.show(context);
    log.d('Save button clicked');

    String plateNumber = plController.text;
    String vehicleTypeId = _selectedVehicleTypeId;

    if (_isInputInvalid(plateNumber, vehicleTypeId)) {
      LoadingOverlayHelper.hide();
      return;
    }

    _editBai(
      UpdateBaiModel(
        vehicleId: bai.id,
        plateNumber: plateNumber,
        vehicleTypeId: vehicleTypeId,
      ),
    );

    LoadingOverlayHelper.hide();
  }

  bool _isInputInvalid(String plateNumber, String vehicleTypeId) {
    if (plateNumber.isEmpty || !Regex.plateRegExp.hasMatch(plateNumber)) {
      log.e('Plate number is empty or invalid');
      //TODO: Show error message
      _showSnackBar(
          ErrorMessage.inputInvalid(message: ListName.plateNumber), false);
      LoadingOverlayHelper.hide();
      return true;
    }
    if (vehicleTypeId.isEmpty || vehicleTypeId == bai.vehicleType) {
      log.e('Vehicle type is empty or unchanged');
      //TODO: Show error message
      _showSnackBar(
          ErrorMessage.inputInvalid(message: ListName.vehicleType), false);
      LoadingOverlayHelper.hide();
      return true;
    }
    return false;
  }

  // show SnackBar
  void _showSnackBar(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: MySnackBar(
          prefix: Icon(
            isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
            color: Theme.of(context).colorScheme.surface,
          ),
          message: message,
          backgroundColor: isSuccess
              ? Theme.of(context).colorScheme.onError
              : Theme.of(context).colorScheme.error,
        ),
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(10),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // edit item
  Widget _editIteam({required String label, required Widget widget}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          child: widget,
        )
      ],
    );
  }

  // Update bai
  Future<void> _editBai(UpdateBaiModel updateBaiModel) async {
    try {
      APIResponse<int> response =
          await callVehicleApi.updateBai(updateBaiModel);

      if (response.isTokenValid == false &&
          response.message == ErrorMessage.tokenInvalid) {
        log.e('Token is invalid');

        if (!mounted) return;
        ReturnLoginDialog.returnLogin(context);
        return;
      }

      switch (response.data) {
        case 200:
          log.d('Update bai success');
          setState(() {
            isEdit = false;
          });
          break;
        default:
          log.e('Update bai failed: ${response.message}');
          break;
      }
    } catch (e) {
      log.e('Error during update bai: $e');
    }
  }

  // Delete bai
  Future<void> _deleteBai(String id) async {
    try {
      APIResponse<int> response = await callVehicleApi.deleteBai(id);

      if (response.isTokenValid == false &&
          response.message == ErrorMessage.tokenInvalid) {
        log.e('Token is invalid');

        if (!mounted) return;
        ReturnLoginDialog.returnLogin(context);
        return;
      }

      switch (response.data) {
        case 200:
          log.d('Delete bai success');
          break;
        default:
          log.e('Delete bai failed: ${response.message}');
          break;
      }
    } catch (e) {
      log.e('Error during delete bai: $e');
    }
  }

  // Get vehicle type
  Future<void> _fetchVehicleType() async {
    try {
      List<VehicleTypeModel>? vehicleType =
          await callVehicleApi.getVehicleType();

      if (mounted) {
        setState(() {
          _vehicleType = vehicleType ?? [];
        });
      }
    } catch (e) {
      log.e('Error fetching vehicle type: $e');
    }
  }

  // Get status color
  Color _getStatusColor(String status, BuildContext context) {
    switch (status) {
      case 'ACTIVE':
        return Theme.of(context).colorScheme.primary;
      case 'INACTIVE':
        return Theme.of(context).colorScheme.outline;
      case 'PENDING':
        return Theme.of(context).colorScheme.onSecondary;
      case 'REJECTED':
        return Theme.of(context).colorScheme.error;
      default:
        return Theme.of(context).colorScheme.outline;
    }
  }
}
