import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/login_model.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';
import 'package:fptu_bike_parking_system/core/helper/google_auth.dart';
import 'package:fptu_bike_parking_system/core/helper/local_storage_helper.dart';
import 'package:fptu_bike_parking_system/representation/about_screen.dart';
import 'package:fptu_bike_parking_system/representation/login.dart';
import 'package:fptu_bike_parking_system/representation/profile.dart';
import 'package:logger/logger.dart';

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
    userData = UserData.fromJson(
        LocalStorageHelper.getValue(LocalStorageKey.userData));
    _loadHideBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                              color: Theme.of(context).colorScheme.background,
                            ),
                      )
                    : ClipOval(
                        child: Image.network(
                          userData!.avatar!,
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
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(ProfileScreen.routeName);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_circle_outlined,
                              color: Theme.of(context).colorScheme.outline,
                              size: 28,
                            ),
                            const SizedBox(width: 20),
                            Text(
                              'View Profile',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      thickness: 1,
                    ),
                    InkWell(
                      onTap: _toggleHideBalance,
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              _hideBalance
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Theme.of(context).colorScheme.outline,
                              size: 28,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      thickness: 1,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(AboutUs.routeName);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outlined,
                              color: Theme.of(context).colorScheme.outline,
                              size: 28,
                            ),
                            const SizedBox(width: 20),
                            Text(
                              'About Bai',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ShadowContainer(
                width: MediaQuery.of(context).size.width * 0.9,
                child: GestureDetector(
                  onTap: () => {
                    _logout(),
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'Logout',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 70),
            ],
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
}
