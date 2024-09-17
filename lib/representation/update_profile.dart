import 'package:bai_system/component/app_bar_component.dart';
import 'package:bai_system/component/response_handler.dart';
import 'package:bai_system/core/const/frontend/message.dart';
import 'package:bai_system/core/helper/local_storage_helper.dart';
import 'package:bai_system/representation/navigation_bar.dart';
import 'package:flutter/material.dart';

import '../api/service/bai_be/customer_service.dart';
import '../component/dialog.dart';
import '../component/snackbar.dart';
import '../core/helper/loading_overlay_helper.dart';

class UpdateProfile extends StatefulWidget {
  final String name;
  const UpdateProfile({super.key, required this.name});

  static const String routeName = '/update_profile';

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> with ApiResponseHandler {
  late TextEditingController textController;
  bool isSuccessful = false;
  bool isUpdating = false;

  final callCustomerApi = CallCustomerApi();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.name);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How would you like to be addressed?',
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                          letterSpacing: 1,
                          textBaseline: TextBaseline.alphabetic,
                        ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'E.g. \'Mr President\'',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Center(
                  child: TextField(
                    controller: textController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showAlertDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.outline,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    LabelMessage.save,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.surface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Cập nhật dữ liệu người dùng
  Future<bool> updateUserData() async {
    try {
      LoadingOverlayHelper.show(context);

      final response =
          await callCustomerApi.updateCustomerInfo(textController.text);

      if (!mounted) return false;
      final bool isResponseValid = await handleApiResponse(
        context: context,
        response: response,
        showErrorDialog: _showErrorDialog,
      );

      if (!isResponseValid) {
        return false;
      }

      setState(() {
        isUpdating = false;
        isSuccessful = true;
      });

      await SetLocalHelper.setUserData(textController.text);

      return true;
    } catch (e) {
      return false;
    } finally {
      LoadingOverlayHelper.hide();
    }
  }

  // Hiển thị Snackbar tùy chỉnh
  void showCustomSnackBar(bool isSuccessful, {String? message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: MySnackBar(
          prefix: Icon(
            isSuccessful ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: Colors.white,
          ),
          message: message ??
              (isSuccessful
                  ? Message.editSuccess(message: ListName.profile)
                  : Message.editUnSuccess(message: ListName.profile)),
          backgroundColor: isSuccessful ? Colors.green : Colors.red,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
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
          ),
        );
      },
    );
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmDialog(
            title: Message.confirmTitle,
            content: Text(
              Message.editConfirmation,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            positiveLabel: LabelMessage.ok,
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: () async {
              await updateUserData().then((value) {
                showCustomSnackBar(value);
                if (value) {
                  Navigator.of(context).pushNamed(MyNavigationBar.routeName);
                }
              });
            });
      },
    );
  }
}
