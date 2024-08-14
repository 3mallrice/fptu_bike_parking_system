// ignore_for_file: unnecessary_null_comparison

import 'package:bai_system/api/service/bai_be/bai_service.dart';
import 'package:bai_system/component/dialog.dart';
import 'package:bai_system/component/shadow_container.dart';
import 'package:bai_system/component/snackbar.dart';
import 'package:bai_system/core/const/utilities/util_helper.dart';
import 'package:bai_system/representation/navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';

import '../api/model/bai_model/api_response.dart';
import '../api/model/bai_model/bai_model.dart';
import '../component/app_bar_component.dart';
import '../component/image_not_found_component.dart';
import '../core/const/frondend/message.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCom(
        appBarText: 'Bai Details',
        leading: true,
      ),
      body: SingleChildScrollView(
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
                        visible:
                            bai.status == 'PENDING' || bai.status == 'REJECTED',
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
                              color: Theme.of(context).colorScheme.onSecondary,
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
            const SizedBox(height: 40),
            Visibility(
              visible: isEdit,
              child: ShadowContainer(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Plate number',
                      style: contentTextStyle,
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter plate number',
                        hintStyle: contentTextStyle,
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
                      hint: Text('Select option', style: contentTextStyle),
                      items: const [
                        DropdownMenuItem(
                            value: 'Option 1', child: Text('Option 1')),
                        DropdownMenuItem(
                            value: 'Option 2', child: Text('Option 2')),
                        DropdownMenuItem(
                            value: 'Option 3', child: Text('Option 3')),
                      ],
                      onChanged: (value) {
                        print('Selected: $value');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
}
