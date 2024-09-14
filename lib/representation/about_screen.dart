import 'package:bai_system/component/app_bar_component.dart';
import 'package:bai_system/component/shadow_container.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../core/helper/asset_helper.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  static String routeName = '/about_screen';

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final _log = Logger();
  late PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    try {
      final PackageInfo info = await PackageInfo.fromPlatform();
      setState(() {
        _packageInfo = info;
      });
    } catch (e) {
      _log.e('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCom(
        leading: true,
        appBarText: 'About Bai',
      ),
      body: SingleChildScrollView(
        child: Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShadowContainer(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Application Description
                    aboutItem(
                      'Application Description',
                      subtitle: Text(
                          'The FPTU parking management software streamlines checkout by allowing users to preload an e-wallet and pay automatically, reducing wait times and enhancing user experience.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary),
                          textAlign: TextAlign.justify),
                      leading: Image.asset(
                        AssetHelper.imgLogo,
                        width: 24,
                        fit: BoxFit.fitWidth,
                      ),
                    ),

                    Divider(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      thickness: 1,
                    ),
                    aboutItem(
                      'Terms of Service',
                      leading: const Icon(Icons.rule),
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      thickness: 1,
                    ),
                    aboutItem(
                      'Privacy Policy',
                      leading: const Icon(Icons.privacy_tip),
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      thickness: 1,
                    ),
                    aboutItem(
                      'Contact Us',
                      leading: const Icon(Icons.quick_contacts_mail_rounded),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 7),
              ShadowContainer(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    aboutItem(
                      'Developer Information',
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // developer name
                          Text('Developed by: Bai team',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary)),

                          // developer email
                          Text('Email: bai@bai.com',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary)),
                        ],
                      ),
                      leading: const Icon(Icons.developer_board),
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      thickness: 1,
                    ),
                    aboutItem(
                      'Application Information',
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // app name
                          Text('App Name: ${_packageInfo.appName} App',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary)),

                          // version
                          Text('Version: ${_packageInfo.version}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary)),

                          // installer store
                          Text(
                            'Installer Store: ${_packageInfo.installerStore}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary),
                          ),
                        ],
                      ),
                      leading: const Icon(Icons.info),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget aboutItem(String title,
      {Widget? subtitle,
      Widget? leading,
      void Function()? onTap,
      bool? isEnable}) {
    return ListTile(
      title: Text(title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.normal,
                color: Theme.of(context).colorScheme.outline,
                fontSize: 19,
              )),
      subtitle: subtitle != null
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: subtitle,
            )
          : null,
      subtitleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.normal,
            color: Theme.of(context).colorScheme.outline,
          ),
      contentPadding: const EdgeInsets.all(10),
      leading: leading != null
          ? Padding(padding: const EdgeInsets.all(5), child: leading)
          : null,
      iconColor: Theme.of(context).colorScheme.outline,
      enabled: isEnable ?? false,
      onTap: onTap,
      visualDensity: VisualDensity.compact,
    );
  }
}
