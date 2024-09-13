import 'dart:async';

import 'package:bai_system/api/model/bai_model/login_model.dart';
import 'package:bai_system/component/app_bar_component.dart';
import 'package:bai_system/component/dialog.dart';
import 'package:bai_system/component/response_handler.dart';
import 'package:bai_system/component/shadow_container.dart';
import 'package:bai_system/core/const/frontend/message.dart';
import 'package:bai_system/core/helper/loading_overlay_helper.dart';
import 'package:bai_system/core/helper/local_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../api/service/bai_be/customer_service.dart';
import '../component/snackbar.dart';
import '../core/helper/google_auth.dart';
import 'login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static String routeName = '/profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with ApiResponseHandler {
  var log = Logger();
  late final UserData? userData;
  late final TextEditingController nameTextController;
  bool isUpdating = false;
  bool isSuccessful = false;
  final callCustomerApi = CallCustomerApi();

  @override
  void initState() {
    super.initState();
    userData = GetLocalHelper.getUserData();
    nameTextController = TextEditingController(text: userData?.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCom(
        leading: true,
        appBarText: 'Your Profile',
      ),
      body: SingleChildScrollView(
        child: Align(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: const EdgeInsets.only(top: 30),
            child: Column(
              children: [
                Container(
                  // padding: const EdgeInsets.all(1),
                  height: MediaQuery.of(context).size.width * 0.36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  child: userData == null
                      ? Text(
                          getInitials(userData?.name ?? 'Anonymous User'),
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                fontSize: 64,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).colorScheme.background,
                              ),
                        )
                      : ClipOval(
                          child: Image.network(
                            userData?.avatar ?? '',
                            fit: BoxFit.fill,
                          ),
                        ),
                ),
                const SizedBox(height: 15),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fullname',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                      const SizedBox(height: 5),
                      ShadowContainer(
                        height: 55,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: nameTextController,
                          textInputAction: TextInputAction.done,
                          enabled: isUpdating,
                          style: Theme.of(context).textTheme.titleMedium,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffix: isUpdating
                                ? const Icon(
                                    Icons.edit,
                                    size: 18,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                      const SizedBox(height: 5),
                      ShadowContainer(
                        height: 55,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          userData?.email ?? 'anonymous@fpt.edu.vn',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isUpdating = !isUpdating;
                    });

                    String name = nameTextController.text.trim();
                    if (!isUpdating) {
                      //if customer name is not change or empty, return
                      if (name == userData?.name || name.isEmpty) {
                        return showCustomSnackBar(false,
                            message: "Fullname is empty or not change");
                      }
                      showAlertDialog();
                    }
                  },
                  child: ShadowContainer(
                    height: 50,
                    width: 120,
                    alignment: Alignment.center,
                    color: Theme.of(context).colorScheme.outline,
                    child: Text(
                      isUpdating
                          ? LabelMessage.save.toUpperCase()
                          : LabelMessage.edit.toUpperCase(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.background,
                          ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // update user data
  Future<bool> updateUserData() async {
    try {
      LoadingOverlayHelper.show(context);

      final response =
          await callCustomerApi.updateCustomerInfo(nameTextController.text);

      if (!mounted) return false;
      final bool isResponseValid = await handleApiResponse(
        context: context,
        response: response,
        showErrorDialog: _showErrorDialog,
      );

      if (!isResponseValid) {
        log.e('Update user data failed');
        return false;
      }

      log.i('Update user data successfully');

      if (mounted) {
        setState(() {
          isUpdating = false;
          isSuccessful = true;
        });
      }

      return true;
    } catch (e) {
      log.e('Error during updateUserData: $e');
      return false;
    } finally {
      LoadingOverlayHelper.hide();
    }
  }

  // show custom snackbar
  void showCustomSnackBar(bool isSuccessful, {String? message}) {
    Color backgroundColor = Theme.of(context).colorScheme.surface;
    Color onSuccessful = Theme.of(context).colorScheme.onError;
    Color onUnsuccessful = Theme.of(context).colorScheme.error;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: MySnackBar(
          prefix: Icon(
            isSuccessful ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: backgroundColor,
          ),
          message: message ??
              (isSuccessful
                  ? Message.editSuccess(message: ListName.profile)
                  : Message.editUnSuccess(message: ListName.profile)),
          backgroundColor: isSuccessful ? onSuccessful : onUnsuccessful,
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

  //show dialog
  void showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmDialog(
            title: Message.confirmTitle,
            content: Text(
              "${Message.editConfirmation} After update successfully, you will automatically log out and need to log in again.",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            positiveLabel: LabelMessage.ok,
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: () async {
              await updateUserData().then((value) => {
                    showCustomSnackBar(value),
                  });

              // if update successfully, log out
              isSuccessful ? _logout() : redirectToPage();
            });
      },
    );
  }

  //log out
  Future<void> _logout() async {
    await LocalStorageHelper.setValue(LocalStorageKey.userData, null);
    await GoogleAuthApi.signOut();
    log.i('Logout success: ${LocalStorageKey.userData}');
    redirectToPage(routeName: LoginScreen.routeName);
  }

  void redirectToPage({String? routeName}) {
    routeName == null
        ? Navigator.pop(context)
        : Navigator.pushNamedAndRemoveUntil(
            context, routeName, (route) => false);
  }

  // split name into many parts by space and get the first letter of each part
  String getInitials(String name) {
    List<String> parts = name.split(' ');
    String initials = '';
    for (var part in parts) {
      initials += part[0];
    }
    return initials.toUpperCase();
  }
}
