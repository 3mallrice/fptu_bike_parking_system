import 'package:bai_system/api/model/bai_model/login_model.dart';
import 'package:bai_system/component/shadow_container.dart';
import 'package:bai_system/core/helper/local_storage_helper.dart';
import 'package:bai_system/representation/about_screen.dart';
import 'package:bai_system/representation/cashless_hero.dart';
import 'package:bai_system/representation/faq.dart';
import 'package:bai_system/representation/feedback.dart';
import 'package:bai_system/representation/settings&profile.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MeScreen extends StatefulWidget {
  const MeScreen({super.key});

  static String routeName = '/me_screen';

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  var log = Logger();

  late final UserData? userData;
  late final _currentEmail = LocalStorageHelper.getCurrentUserEmail() ?? '';

  void goToPageHelper({String? routeName}) {
    routeName != null
        ? Navigator.of(context).pushNamed(routeName)
        : Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    userData = GetLocalHelper.getUserData(_currentEmail);
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
                            _getInitials(userData?.name ?? 'Anonymous User'),
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                  fontSize: 30,
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
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontSize: 12,
                        ),
                  ),
                  const SizedBox(height: 40),
                  ShadowContainer(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _meItem(
                          Icons.settings_suggest_outlined,
                          Text(
                            'Settings & profile',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 16),
                          ),
                          onTap: () => goToPageHelper(
                              routeName: SettingAndProfileScreen.routeName),
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          thickness: 1,
                        ),
                        _meItem(
                          Icons.feedback_outlined,
                          Text(
                            'Feedbacks',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 16),
                          ),
                          onTap: () => goToPageHelper(
                              routeName: FeedbackScreen.routeName),
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          thickness: 1,
                        ),
                        _meItem(
                          Icons.stars_outlined,
                          Text(
                            'Heroic Achievements',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 16),
                          ),
                          onTap: () =>
                              goToPageHelper(routeName: CashlessHero.routeName),
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          thickness: 1,
                        ),
                        _meItem(
                          Icons.help_outlined,
                          Text(
                            'Help Center',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 16),
                          ),
                          onTap: () =>
                              goToPageHelper(routeName: FAQScreen.routeName),
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          thickness: 1,
                        ),
                        _meItem(
                          Icons.info_outlined,
                          Text(
                            'About Bai',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 16),
                          ),
                          onTap: () =>
                              goToPageHelper(routeName: AboutUs.routeName),
                        ),
                      ],
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
  String _getInitials(String name) {
    List<String> parts = name.split(' ');
    String initials = '';
    for (var part in parts) {
      initials += part[0];
    }
    return initials.toUpperCase();
  }

  Widget _meItem(IconData iconData, Widget content,
      {VoidCallback? onTap, Widget? trailing}) {
    return ListTile(
      horizontalTitleGap: 13,
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outline,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          iconData,
          size: 20,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
      trailing: trailing,
      title: Padding(padding: const EdgeInsets.all(5), child: content),
      onTap: onTap,
    );
  }
}
