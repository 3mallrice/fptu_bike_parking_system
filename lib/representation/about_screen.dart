import 'package:bai_system/component/app_bar_component.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../core/helper/asset_helper.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  static const String routeName = '/about_screen';

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final _log = Logger();
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() => _packageInfo = info);
    } catch (e) {
      _log.e('Error initializing package info: $e');
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
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.9,
          color: Theme.of(context).colorScheme.outlineVariant,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildInfoSection(context),
              _buildLinksSection(context),
              _buildFooterSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return _buildCard(
      context,
      child: Column(
        children: [
          _buildLogo(context),
          const SizedBox(height: 7),
          Text(
            'Version ${_packageInfo.version}',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const _Divider(),
          Text(
            'Bai is a parking software that lets users preload an e-wallet for automatic payments, speeding up checkout.',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
            textAlign: TextAlign.justify,
          )
        ],
      ),
    );
  }

  Widget _buildLinksSection(BuildContext context) {
    return _buildCard(
      context,
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLinkItem(context, 'Rate Bai', Icons.star_rate_rounded),
          const _Divider(),
          _buildLinkItem(context, 'Terms of Service', Icons.rule),
          const _Divider(),
          _buildLinkItem(context, 'Privacy Policy', Icons.privacy_tip_outlined),
        ],
      ),
    );
  }

  Widget _buildFooterSection(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Text(
            'BAI PARKING TEAM',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: 16,
                ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Lot E2a-7, D1 Street, Hi-Tech Park, Long Thanh My Ward, Thu Duc City, Ho Chi Minh City',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 13,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              // TODO: Implement phone call
            },
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Hotline: ',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  TextSpan(
                    text: '028.73005585',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () {
              // TODO: Implement phone call
            },
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Email: ',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  TextSpan(
                    text: 'support@bai.com',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              '© 2024 Bai. All rights reserved.\nTerms | Privacy Policy',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.outline,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required Widget child, EdgeInsetsGeometry? margin}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: margin,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
            offset: const Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Image.asset(
        AssetHelper.imgLogo,
        width: 30,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget _buildLinkItem(BuildContext context, String title, IconData icon) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.normal,
              color: Theme.of(context).colorScheme.outline,
              fontSize: 16,
            ),
      ),
      leading: Icon(icon, color: Theme.of(context).colorScheme.outline),
      // contentPadding: const EdgeInsets.all(10),
      horizontalTitleGap: 25,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        color: Theme.of(context).colorScheme.outlineVariant,
        thickness: 1,
      ),
    );
  }
}
