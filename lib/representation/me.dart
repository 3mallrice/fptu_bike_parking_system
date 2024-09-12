import 'package:bai_system/api/model/bai_model/login_model.dart';
import 'package:bai_system/component/shadow_container.dart';
import 'package:bai_system/core/helper/google_auth.dart';
import 'package:bai_system/core/helper/local_storage_helper.dart';
import 'package:bai_system/representation/about_screen.dart';
import 'package:bai_system/representation/feedback.dart';
import 'package:bai_system/representation/no_connection_screen.dart';
import 'package:bai_system/representation/profile.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'login.dart';

class MeScreen extends StatefulWidget {
  const MeScreen({super.key});

  static String routeName = '/me_screen';

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  bool _hideBalance = false;
  var log = Logger();

  late final UserData? userData;

  Future<void> _loadHideBalance() async {
    bool? hideBalance =
        await LocalStorageHelper.getValue(LocalStorageKey.isHiddenBalance);
    setState(() {
      _hideBalance = hideBalance ?? false;
    });
  }

  Future<void> _toggleHideBalance() async {
    setState(() {
      log.i('Toggle hide balance: $_hideBalance');
      _hideBalance = !_hideBalance;
    });
    await LocalStorageHelper.setValue(
        LocalStorageKey.isHiddenBalance, _hideBalance);
  }

  //log out
  Future<void> _logout() async {
    await LocalStorageHelper.setValue(LocalStorageKey.userData, null);
    await GoogleAuthApi.signOut();
    log.i('Logout success: ${LocalStorageKey.userData}');
    goToPageHelper(routeName: LoginScreen.routeName);
  }

  void goToPageHelper({String? routeName}) {
    routeName != null
        ? Navigator.of(context).pushNamed(routeName)
        : Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    userData = GetLocalHelper.getUserData();
    _loadHideBalance();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
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
                                  color: Theme.of(context).colorScheme.surface,
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
                  Text(
                    userData?.name ?? 'Anonymous',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    userData?.email ?? 'anonymous@fpt.edu.vn',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 40),
                  ShadowContainer(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        meItem(
                          Icons.account_circle_outlined,
                          Text(
                            'View Profile',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 18),
                          ),
                          () {
                            Navigator.of(context)
                                .pushNamed(ProfileScreen.routeName);
                          },
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          thickness: 1,
                        ),
                        meItem(
                          _hideBalance
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hide Balance',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontSize: 18),
                              ),
                              Text(
                                '* Your balances on home screen will appear as ******\n* To reveal, hold on your balance',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      fontSize: 12,
                                    ),
                              ),
                            ],
                          ),
                          _toggleHideBalance,
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          thickness: 1,
                        ),
                        meItem(
                          Icons.feedback_outlined,
                          Text(
                            'Feedbacks',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 18),
                          ),
                          () {
                            Navigator.of(context)
                                .pushNamed(FeedbackScreen.routeName);
                          },
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          thickness: 1,
                        ),
                        meItem(
                            Icons.info_outlined,
                            Text(
                              'About Bai',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontSize: 18),
                            ), () {
                          Navigator.of(context).pushNamed(AboutUs.routeName);
                        }),
                        TextButton(
                            onPressed: () => Navigator.of(context)
                                .pushNamed(NoInternetScreen.routeName),
                            child: const Text('exception'))
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _logout,
                    child: ShadowContainer(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      color: Theme.of(context).colorScheme.primary,
                      child: Text(
                        'Logout',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 18,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
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

  // a ListTile with icon, content and onTap event
  Widget meItem(IconData? iconData, Widget content, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      horizontalTitleGap: 10,
      leadingAndTrailingTextStyle: Theme.of(context).textTheme.titleMedium,
      leading: Icon(
        iconData,
        size: 28,
      ),
      title: Padding(padding: const EdgeInsets.all(10), child: content),
      onTap: onTap,
    );
  }
}
