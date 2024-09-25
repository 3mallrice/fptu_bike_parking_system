import 'package:bai_system/api/model/bai_model/login_model.dart';
import 'package:bai_system/api/service/bai_be/bai_service.dart';
import 'package:bai_system/component/dialog.dart';
import 'package:bai_system/component/loading_component.dart';
import 'package:bai_system/component/response_handler.dart';
import 'package:bai_system/component/shadow_container.dart';
import 'package:bai_system/component/snackbar.dart';
import 'package:bai_system/core/const/utilities/regex.dart';
import 'package:bai_system/core/const/utilities/util_helper.dart';
import 'package:bai_system/core/helper/loading_overlay_helper.dart';
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
import '../component/internet_connection_wrapper.dart';
import '../core/const/frontend/message.dart';
import '../core/helper/local_storage_helper.dart';
import 'login.dart';

class BaiDetails extends StatefulWidget {
  final String baiId;
  final VoidCallback onPopCallback;

  const BaiDetails({
    super.key,
    required this.baiId,
    required this.onPopCallback,
  });

  static String routeName = '/bai_details';

  @override
  State<BaiDetails> createState() => _BaiDetailsState();
}

class _BaiDetailsState extends State<BaiDetails> with ApiResponseHandler {
  late final _currentEmail = LocalStorageHelper.getCurrentUserEmail() ?? "";
  late final _currentCustomerType = LocalStorageHelper.getValue(
      LocalStorageKey.currentCustomerType, _currentEmail);
  late String baiId = widget.baiId;

  late BaiModel bai = BaiModel(
    id: '',
    plateNumber: '',
    vehicleType: '',
    status: 'ACTIVE',
    createDate: DateTime.now(),
    plateImage:
        'https://fuparking.khangbpa.com/_next/static/media/Bai_Logo.06963b4e.svg',
  );

  final callVehicleApi = CallBikeApi();

  final plateNumberController = TextEditingController();
  final _overlayHelper = LoadingOverlayHelper();

  var log = Logger();

  List<VehicleTypeModel> _vehicleType = [];

  late TextStyle titleTextStyle;
  late TextStyle contentTextStyle;
  late Color color;

  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    widget.onPopCallback();
    _overlayHelper.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    Set<String> errors = {};

    await fetchBaiDetail(baiId, errors: errors, isAlone: false);
    await getVehicleType(errors: errors, isAlone: false);

    plateNumberController.text = bai.plateNumber;

    if (errors.isNotEmpty) {
      _showErrorDialog(errors.map((e) => '\u2022 $e').join('\n'));
    }

    if (mounted) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    titleTextStyle = Theme.of(context).textTheme.displayLarge!.copyWith(
          color: Theme.of(context).colorScheme.outline,
          fontSize: 28,
        );
    contentTextStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.outline,
        );
    color = switch (bai.status) {
      'ACTIVE' => Theme.of(context).colorScheme.primary,
      'PENDING' => Theme.of(context).colorScheme.onError,
      'REJECTED' => Theme.of(context).colorScheme.error,
      'INACTIVE' => Theme.of(context).colorScheme.outline,
      _ => contentTextStyle.color!,
    };
  }

  Future<String?> _catchError(APIResponse response) async {
    final String? errorMessage = await handleApiResponse(
      context: context,
      response: response,
    );

    if (errorMessage == ApiResponseHandler.invalidToken) {
      goToPage(routeName: LoginScreen.routeName);
      showSnackBar(
        message: ErrorMessage.tokenInvalid,
        isSuccessful: false,
      );
    }

    return errorMessage;
  }

  @override
  Widget build(BuildContext context) {
    return InternetConnectionWrapper(
      child: Scaffold(
        appBar: const MyAppBar(
          title: 'Bai Details',
          automaticallyImplyLeading: true,
        ),
        body: !isLoaded
            ? const LoadingCircle()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 300,
                          minHeight: 200,
                        ),
                        child: CachedNetworkImage(
                          width: double.infinity,
                          imageUrl: _currentCustomerType == CustomerType.paid
                              ? bai.plateImage
                              : 'https://img.freepik.com/premium-photo/guinea-pig-riding-toy-train-cartoon-style_714091-95319.jpg?w=900',
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Theme.of(context).colorScheme.background,
                            highlightColor:
                                Theme.of(context).colorScheme.outlineVariant,
                            child: Container(color: Colors.grey),
                          ),
                          errorWidget: (context, url, error) =>
                              const ImageNotFound(),
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
                                  UltilHelper.formatDateMMMddyyyy(
                                      bai.createDate),
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
                                      color: color,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            if (bai.status == 'REJECTED')
                              SizedBox(
                                child: Text(
                                  'Wrong information. Please check again.',
                                  style: contentTextStyle.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            if (bai.status == 'PENDING')
                              SizedBox(
                                child: Text(
                                  'To activate your registration, please park your vehicle at our facility for the first time.',
                                  style: contentTextStyle.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            const SizedBox(height: 10),
                            if (_currentCustomerType == CustomerType.paid)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      deleteBaiDialog();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Icon(
                                        Icons.delete,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: bai.status == 'PENDING' ||
                                        bai.status == 'REJECTED',
                                    child: GestureDetector(
                                      onTap: _showEditDialog,
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        margin: const EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: Icon(
                                          Icons.edit,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // edit Bai
  Future<void> editBai(UpdateBaiModel baiModel) async {
    try {
      _overlayHelper.show(context);
      APIResponse response = await callVehicleApi.updateBai(baiModel);

      final error = await _catchError(response);
      if (error != null) {
        _showErrorDialog(error);
        return;
      }

      if (mounted) {
        setState(() {
          bai = BaiModel(
            id: bai.id,
            plateNumber: baiModel.plateNumber,
            vehicleType: _vehicleType
                .firstWhere((element) => element.id == baiModel.vehicleTypeId)
                .name,
            status: bai.status,
            createDate: bai.createDate,
            plateImage: bai.plateImage,
          );
        });

        widget.onPopCallback();
        showSnackBar(
            message: Message.editSuccess(message: ListName.bai),
            isSuccessful: true);
      }
    } catch (e) {
      log.e('Error during edit Bai: $e');
      _showErrorDialog(Message.editUnSuccess(message: ListName.bai));
    } finally {
      _overlayHelper.hide();
    }
  }

// Delete Bai
  Future<void> deleteBai(String id) async {
    try {
      Navigator.of(context).pop();
      _overlayHelper.show(context);
      APIResponse response = await callVehicleApi.deleteBai(bai.id);

      final error = await _catchError(response);
      if (error != null) {
        _showErrorDialog(error);
        return;
      }

      widget.onPopCallback();
      goToPage(routeName: MyNavigationBar.routeName, arguments: 1);
      showSnackBar(
          message: Message.deleteSuccess(message: ListName.bai),
          isSuccessful: true);
    } catch (e) {
      log.e('Error during delete Bai: $e');
      _showErrorDialog(Message.deleteUnSuccess(message: ListName.bai));
    } finally {
      _overlayHelper.hide();
    }
  }

  Future<void> fetchBaiDetail(String id,
      {Set<String>? errors, bool isAlone = false}) async {
    try {
      APIResponse<BaiModel> response =
          await callVehicleApi.getCustomerBaiById(id);

      final error = await _catchError(response);
      if (error != null) {
        errors?.add(error);
        if (isAlone) {
          _showErrorDialog(error);
        }
        return;
      }

      if (mounted) {
        setState(() {
          bai = response.data!;
        });
      }
    } catch (e) {
      log.e('Error during fetch Bai details: $e');
      errors?.add(ErrorMessage.somethingWentWrong);
      if (isAlone) {
        _showErrorDialog(ErrorMessage.somethingWentWrong);
      }
    }
  }

  //Get Vehicle Type
  Future<void> getVehicleType(
      {Set<String>? errors, bool isAlone = false}) async {
    try {
      APIResponse<List<VehicleTypeModel>> response =
          await callVehicleApi.getVehicleType();

      final error = await _catchError(response);
      if (error != null) {
        errors?.add(error);
        if (isAlone) {
          _showErrorDialog(error);
        }
        return;
      }

      if (mounted) {
        setState(() {
          _vehicleType = response.data!;
        });
      }
    } catch (e) {
      log.e('Error during fetch Vehicle Type: $e');
      errors?.add(ErrorMessage.somethingWentWrong);
      if (isAlone) {
        _showErrorDialog(ErrorMessage.somethingWentWrong);
      }
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
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
    );
  }

  //Edit bai Dialog
  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _EditBaiDialog(
          bai: bai,
          vehicleTypes: _vehicleType,
          onSave: (UpdateBaiModel updatedBai) {
            editBai(updatedBai);
          },
        );
      },
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OKDialog(
          title: ErrorMessage.error,
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.justify,
          ),
        );
      },
    );
  }
}

class _EditBaiDialog extends StatefulWidget {
  final BaiModel bai;
  final List<VehicleTypeModel> vehicleTypes;
  final Function(UpdateBaiModel) onSave;

  const _EditBaiDialog({
    required this.bai,
    required this.vehicleTypes,
    required this.onSave,
  });

  @override
  _EditBaiDialogState createState() => _EditBaiDialogState();
}

class _EditBaiDialogState extends State<_EditBaiDialog> {
  late TextEditingController _plateNumberController;
  String? _selectedVehicleTypeId;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _plateNumberController =
        TextEditingController(text: widget.bai.plateNumber);
    _selectedVehicleTypeId = widget.vehicleTypes
        .firstWhere((vt) => vt.name == widget.bai.vehicleType)
        .id;
  }

  @override
  Widget build(BuildContext context) {
    return ConfirmDialog(
        title: 'Edit Bai',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _plateNumberController,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: _buildInputDecoration(
                labelText: 'Plate Number',
                hintText: 'Enter plate number',
              ),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedVehicleTypeId,
              items: widget.vehicleTypes
                  .map((vt) => DropdownMenuItem(
                        value: vt.id,
                        child: Text(
                          vt.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.outline,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedVehicleTypeId = value;
                });
              },
              decoration: _buildInputDecoration(
                labelText: 'Vehicle Type',
                hintText: 'Select vehicle type',
                icon: Icons.motorcycle_sharp,
              ),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: 13,
                  ),
              dropdownColor: Theme.of(context).colorScheme.surface,
            ),
            const SizedBox(height: 16),
            Visibility(
              visible: _errorMessage.isNotEmpty,
              child: Text(
                _errorMessage,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.all(20),
        positiveLabel: LabelMessage.save,
        negativeLabel: LabelMessage.cancel,
        onConfirm: () {
          String currentValue = _plateNumberController.text
              .trim()
              .replaceAll('-', '')
              .replaceAll('.', '')
              .replaceAll(' ', '')
              .toUpperCase();

          String currentType = widget.vehicleTypes
              .firstWhere((vt) => vt.id == _selectedVehicleTypeId)
              .name;
          String? errorMessage = _isInputValid(currentValue, currentType);
          if (errorMessage == null) {
            final updatedBai = UpdateBaiModel(
              vehicleId: widget.bai.id,
              plateNumber: _plateNumberController.text,
              vehicleTypeId: _selectedVehicleTypeId!,
            );
            widget.onSave(updatedBai);
            Navigator.of(context).pop();
          } else {
            setState(() {
              _errorMessage = errorMessage;
            });
          }
        });
  }

  InputDecoration _buildInputDecoration(
      {String labelText = '',
      String hintText = '',
      IconData icon = Icons.numbers_sharp}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
      hintText: hintText,
      hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: 2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      prefixIcon: Icon(
        icon,
        size: 20,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }

  String? _isInputValid(String currentValue, String currentType) {
    if (currentValue.isEmpty) {
      return 'Please enter a plate number.';
    }

    if (_selectedVehicleTypeId == null) {
      return 'Please select a vehicle type.';
    }

    if (!Regex.plateRegExp.hasMatch(currentValue)) {
      return 'Invalid plate number format. Please enter a correct plate number.';
    }

    if (currentValue == widget.bai.plateNumber &&
        currentType == widget.bai.vehicleType) {
      return 'No changes detected in plate number or vehicle type.';
    }

    return null;
  }

  @override
  void dispose() {
    _plateNumberController.dispose();
    super.dispose();
  }
}
