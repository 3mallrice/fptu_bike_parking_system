// ignore_for_file: unnecessary_null_comparison

import 'package:bai_system/api/service/bai_be/bai_service.dart';
import 'package:bai_system/component/dialog.dart';
import 'package:bai_system/component/shadow_container.dart';
import 'package:bai_system/component/snackbar.dart';
import 'package:bai_system/core/const/utilities/regex.dart';
import 'package:bai_system/core/const/utilities/util_helper.dart';
import 'package:bai_system/representation/navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';

import '../api/model/bai_model/api_response.dart';
import '../api/model/bai_model/bai_model.dart';
import '../component/app_bar_component.dart';
import '../component/image_not_found_component.dart';
import '../core/const/frontend/message.dart';
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
  final callVehicleApi = CallBikeApi();

  final plateNumberController = TextEditingController();
  late String _vehicleTypeId;

  var log = Logger();

  List<VehicleTypeModel> _vehicleType = [];

  bool isEdit = false;

  late TextStyle titleTextStyle =
      Theme.of(context).textTheme.displayLarge!.copyWith(
            color: Theme.of(context).colorScheme.outline,
            fontSize: 28,
          );

  late TextStyle contentTextStyle =
      Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.outline,
          );

  late final color = switch (bai.status) {
    'ACTIVE' => Theme.of(context).colorScheme.primary,
    'PENDING' => Theme.of(context).colorScheme.onError,
    'REJECTED' => Theme.of(context).colorScheme.error,
    'INACTIVE' => Theme.of(context).colorScheme.outline,
    _ => contentTextStyle.color,
  };

  @override
  void initState() {
    super.initState();
    getVehicleType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCom(
        appBarText: 'Bai Details',
        leading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              (bai.plateImage == null)
                  ? const ImageNotFound()
                  : CachedNetworkImage(
                      width: double.infinity,
                      imageUrl: bai.plateImage,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Theme.of(context).colorScheme.background,
                        highlightColor:
                            Theme.of(context).colorScheme.outlineVariant,
                        child: Container(color: Colors.grey),
                      ),
                    ),
              const SizedBox(height: 30),
              ShadowContainer(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      UltilHelper.formatPlateNumber(bai.plateNumber),
                      style: titleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Created at:',
                          style: contentTextStyle,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          UltilHelper.formatDateMMMddyyyy(bai.createDate),
                          style: contentTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vehicle type:',
                          style: contentTextStyle,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          bai.vehicleType,
                          style: contentTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status:',
                          style: contentTextStyle,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          bai.status,
                          style: contentTextStyle.copyWith(
                              color: color, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            //Todo: Delete Bai
                            deleteBaiDialog();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSecondary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: bai.status == 'PENDING' ||
                              bai.status == 'REJECTED',
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isEdit = !isEdit;
                                log.d('Edit status: $isEdit');
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.edit_document,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: isEdit,
                child: ShadowContainer(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  margin: const EdgeInsets.only(bottom: 20),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextField(
                        controller: plateNumberController,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          hintText: 'Enter plate number',
                          hintStyle: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            gapPadding: 2.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onSecondary,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: Theme.of(context).colorScheme.onSecondary,
                          hoverColor: Theme.of(context).colorScheme.primary,
                          focusColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onSecondary,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        hint: Text(
                          bai.vehicleType,
                          style: contentTextStyle.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary),
                        ),
                        items: _vehicleType
                            .map(
                              (e) => DropdownMenuItem<String>(
                                value: e.id,
                                child: Text(
                                  bai.vehicleType == e.name
                                      ? '${e.name} (Current)'
                                      : e.name,
                                  style: contentTextStyle,
                                ),
                              ),
                            )
                            .toSet()
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _vehicleTypeId = value!;
                          });
                          log.d('Selected vehicle type: $_vehicleTypeId');
                        },
                      ),
                      const SizedBox(height: 5),
                      Container(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            String plateNumber =
                                plateNumberController.text.trim().toUpperCase();
                            bool isValid =
                                _isInputInvalid(plateNumber, _vehicleTypeId);
                            isValid
                                ? showSnackBar(
                                    message: ErrorMessage.inputInvalid(
                                        message:
                                            'Plate number or Vehicle type'),
                                    isSuccessful: false)
                                : editBaiDialog(
                                    UpdateBaiModel(
                                      vehicleId: bai.id,
                                      plateNumber: plateNumber,
                                      vehicleTypeId: _vehicleTypeId,
                                    ),
                                  );
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.outline,
                            ),
                            overlayColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: Text(
                            LabelMessage.save,
                            style: contentTextStyle.copyWith(
                              color: Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // edit Bai
  Future<void> editBai(UpdateBaiModel baiModel) async {
    try {
      APIResponse<int> response = await callVehicleApi.updateBai(baiModel);

      if (response.isTokenValid == false &&
          response.message == ErrorMessage.tokenInvalid) {
        log.e('Token is invalid');
        if (!mounted) return;
        ReturnLoginDialog.returnLogin(context);
        return;
      }

      switch (response.data.toString()) {
        case '200':
          log.d('Edit Bai successfully');
          goToPage(routeName: MyNavigationBar.routeName, arguments: 1);
          showSnackBar(
              message: Message.editSuccess(message: ListName.bai),
              isSuccessful: true);
          break;
        case '409':
          log.d('Edit Bai failed: Not Authorized');
          showSnackBar(message: Message.permissionDeny, isSuccessful: false);
          break;
        default:
          log.e('Failed to edit Bai: ${response.message}');
          showSnackBar(
              message: Message.editUnSuccess(message: ListName.bai),
              isSuccessful: false);
          break;
      }
      return;
    } catch (e) {
      log.e('Error during edit Bai: $e');
      showSnackBar(
          message: Message.editUnSuccess(message: ListName.bai),
          isSuccessful: false);
    }
  }

  // Delete Bai
  Future<void> deleteBai(String id) async {
    try {
      APIResponse<int> response = await callVehicleApi.deleteBai(bai.id);

      if (response.isTokenValid == false &&
          response.message == ErrorMessage.tokenInvalid) {
        log.e('Token is invalid');
        if (!mounted) return;
        ReturnLoginDialog.returnLogin(context);
        return;
      }

      switch (response.data.toString()) {
        case '200':
          log.d('Delete Bai successfully');
          goToPage(routeName: MyNavigationBar.routeName, arguments: 1);
          showSnackBar(
              message: Message.deleteSuccess(message: ListName.bai),
              isSuccessful: true);
          break;
        case '409':
          log.d('Delete Bai failed: Not Authorized');
          showSnackBar(message: Message.permissionDeny, isSuccessful: false);
          break;
        default:
          log.e('Failed to delete Bai: ${response.message}');
          showSnackBar(
              message: Message.deleteUnSuccess(message: ListName.bai),
              isSuccessful: false);
          break;
      }
      return;
    } catch (e) {
      log.e('Error during delete Bai: $e');
      showSnackBar(
          message: Message.deleteUnSuccess(message: ListName.bai),
          isSuccessful: false);
    }
  }

  Future<void> fetchBaiDetail(String id) async {
    try {
      APIResponse<BaiModel> response =
          await callVehicleApi.getCustomerBaiById(id);

      if (response.isTokenValid == false &&
          response.message == ErrorMessage.tokenInvalid) {
        log.e('Token is invalid');
        if (!mounted) return;
        ReturnLoginDialog.returnLogin(context);
        return;
      }

      if (response.data != null) {
        setState(() {
          bai = response.data!;
        });
      } else {
        log.e('Failed to fetch Bai details: ${response.message}');
      }
    } catch (e) {
      log.e('Error during fetch Bai details: $e');
    }
  }

  //Get Vehicle Type
  Future<void> getVehicleType() async {
    try {
      List<VehicleTypeModel> response = await callVehicleApi.getVehicleType();

      if (response.isNotEmpty) {
        setState(() {
          _vehicleType = response;
        });
      } else {
        log.e('Failed to fetch Vehicle Type: $response');
      }
    } catch (e) {
      log.e('Error during fetch Vehicle Type: $e');
    }
  }

  //Edit Bai Dialog
  Future<void> editBaiDialog(UpdateBaiModel baiModel) async {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: Message.confirmTitle,
        content: Text(Message.editConfirmation(message: ListName.bai),
            style: contentTextStyle),
        positiveLabel: LabelMessage.yes,
        onConfirm: () => editBai(baiModel),
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  //Delete Bai Dialog
  Future<void> deleteBaiDialog() async {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: Message.confirmTitle,
        content: Text(Message.deleteConfirmation(message: ListName.bai),
            style: contentTextStyle),
        positiveLabel: LabelMessage.yes,
        onConfirm: () => deleteBai(bai.id),
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  //Go to page
  void goToPage({String? routeName, dynamic arguments}) {
    if (routeName != null) {
      Navigator.pushReplacementNamed(
        context,
        routeName,
        arguments: arguments,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  //Show SnackBar
  void showSnackBar({required String message, required bool isSuccessful}) {
    Color background = Theme.of(context).colorScheme.surface;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: MySnackBar(
          prefix: isSuccessful
              ? Icon(
                  Icons.check_circle_rounded,
                  color: background,
                )
              : Icon(
                  Icons.cancel_rounded,
                  color: background,
                ),
          message: message,
          backgroundColor: isSuccessful
              ? Theme.of(context).colorScheme.onError
              : Theme.of(context).colorScheme.error,
        ),
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        padding: const EdgeInsets.all(10),
      ),
    );
  }

  bool _isInputInvalid(String plateNumber, String vehicleTypeId) {
    if (plateNumber.isEmpty || !Regex.plateRegExp.hasMatch(plateNumber)) {
      log.d('Plate number: $plateNumber');
      log.e('Plate number is empty or invalid');
      return true;
    }
    if (vehicleTypeId.isEmpty || vehicleTypeId == bai.vehicleType) {
      log.e('Vehicle type is empty or unchanged');
      return true;
    }
    return false;
  }
}
