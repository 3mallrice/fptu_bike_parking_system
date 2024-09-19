import 'package:bai_system/representation/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../api/model/bai_model/login_model.dart';
import '../component/app_bar_component.dart';
import '../component/internet_connection_wrapper.dart';
import '../core/helper/google_auth.dart';
import '../core/helper/local_storage_helper.dart';
import 'login.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  static const String routeName = '/setting_screen';

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _hideBalance = false;
  late int _pageSize = 10;
  late final _currentEmail = LocalStorageHelper.getCurrentUserEmail() ?? '';
  late final UserData? userData = GetLocalHelper.getUserData(_currentEmail);
  var log = Logger();

  Future<void> _toggleHideBalance() async {
    setState(() {
      log.i('Toggle hide balance: $_hideBalance');
      _hideBalance = !_hideBalance;
    });
    await LocalStorageHelper.setValue(
        LocalStorageKey.isHiddenBalance, _hideBalance, _currentEmail);
  }

  Future<void> _updatePageSize(int pageSize) async {
    setState(() {
      log.i('Update page size: $pageSize');
      _pageSize = pageSize;
    });
    await LocalStorageHelper.setValue(
        LocalStorageKey.pageSize, _pageSize, _currentEmail);
  }

  //log out
  Future<void> _logout() async {
    await LocalStorageHelper.clearCurrentUser();
    await GoogleAuthApi.signOut();
    log.i('Logout success: ${LocalStorageKey.userData}');

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.routeName, (route) => false);
  }

  @override
  void initState() {
    super.initState();
    _hideBalance = GetLocalHelper.getHideBalance(_currentEmail);
    _pageSize = GetLocalHelper.getPageSize(_currentEmail);
  }

  @override
  Widget build(BuildContext context) {
    return InternetConnectionWrapper(
      child: Scaffold(
        appBar: const MyAppBar(
          automaticallyImplyLeading: true,
          title: 'Settings & profile',
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    height: MediaQuery.of(context).size.width * 0.25,
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
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                          )
                        : ClipOval(
                            child: Image.network(
                              userData?.avatar ?? '',
                              fit: BoxFit.fill,
                            ),
                          ),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                          height: 1,
                          color: Theme.of(context).colorScheme.outlineVariant)),
                  _settingItem(
                      Icons.person_outline_outlined,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "How would you like to addressed?",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  fontSize: 12,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                          ),
                          Text(
                            userData?.name ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 15),
                          ),
                        ],
                      ), onTap: () {
                    log.i('Update profile');
                    Navigator.of(context).pushNamed(UpdateProfile.routeName,
                        arguments: userData?.name);
                  }),
                  _settingItem(
                      Icons.alternate_email_outlined,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  fontSize: 12,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                          ),
                          Text(
                            userData?.email ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 15),
                          ),
                        ],
                      )),

                  // Settings
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                          height: 1,
                          color: Theme.of(context).colorScheme.outlineVariant)),
                  _settingItem(
                    !_hideBalance
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          !_hideBalance ? 'Hide Balance' : 'Show Balance',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 15),
                        ),
                        Text(
                          '\u2022 Your balances on home screen will appear as ${_hideBalance ? '12345' : '*****'}\n\u2022 To reveal, hold on your balance',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 12,
                              ),
                        ),
                      ],
                    ),
                    onTap: _toggleHideBalance,
                  ),
                  _settingItem(
                    Icons.pageview_outlined,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      color: Theme.of(context).colorScheme.surface,
                      child: DropdownButton<int>(
                        value: _pageSize,
                        items: [10, 15, 20].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              '$value',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                            ),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            _pageSize = newValue!;
                          });
                          _updatePageSize(_pageSize);
                        },
                        elevation: 2,
                        alignment: Alignment.center,
                        borderRadius: BorderRadius.circular(5),
                        dropdownColor: Theme.of(context).colorScheme.surface,
                        style: Theme.of(context).textTheme.bodyMedium!,
                        underline: Container(),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Page Size',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 15),
                        ),
                        Text(
                          'Set the number of items per page',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 12,
                              ),
                        )
                      ],
                    ),
                  ),

                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                        height: 1,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      )),
                  _settingItem(
                    Icons.logout_outlined,
                    iconColor: Theme.of(context).colorScheme.outline,
                    iconBackgroundColor:
                        Theme.of(context).colorScheme.secondary,
                    Text(
                      'Logout',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 15),
                    ),
                    onTap: () {
                      log.i('Logout');
                      _logout();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _settingItem(IconData? iconData, Widget content,
      {VoidCallback? onTap,
      Widget? trailing,
      Color? iconColor,
      iconBackgroundColor}) {
    return ListTile(
      horizontalTitleGap: 15,
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: iconBackgroundColor ?? Theme.of(context).colorScheme.outline,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          iconData,
          size: 20,
          color: iconColor ?? Theme.of(context).colorScheme.surface,
        ),
      ),
      trailing: trailing,
      contentPadding: const EdgeInsets.all(7),
      title: Padding(padding: const EdgeInsets.all(5), child: content),
      onTap: onTap,
    );
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
