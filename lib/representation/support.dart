import 'package:bai_system/component/app_bar_component.dart';
import 'package:bai_system/core/helper/asset_helper.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  SupportScreen({super.key}) {
    _log = Logger();
  }

  static const String routeName = '/support';
  late final Logger _log;

  @override
  Widget build(BuildContext context) {
    _log.i('Building SupportScreen');
    return Scaffold(
      appBar: const MyAppBar(
        automaticallyImplyLeading: true,
        title: 'Support 24/7',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: MediaQuery.of(context).size.height * 0.05,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "SOCIAL MEDIA",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                ),
                const SizedBox(height: 20),
                _buildSupportItem(
                  context,
                  Image.asset(
                    AssetHelper.facebookLogo,
                    width: 35,
                  ),
                  'Facebook',
                  'Connect with us on Facebook',
                  () => _launchUrl(Uri.parse(
                      'https://www.facebook.com/share/AqyvXyiPwqfEvnQ5/?mibextid=qi2Omg')),
                ),
                _buildSupportItem(
                  context,
                  Image.asset(
                    AssetHelper.messengerLogo,
                    width: 23,
                  ),
                  'Messenger',
                  'Chat with us on Messenger',
                  () => _launchUrl(
                      Uri.parse('https://m.me/university.fpt.edu.vn')),
                ),
                _buildSupportItem(
                  context,
                  Image.asset(
                    AssetHelper.zaloLogo,
                    width: 23,
                  ),
                  'Zalo',
                  'Connect with us on Zalo',
                  () => _launchUrl(Uri.parse('https://zalo.me/g/bqmzza008')),
                ),
                const SizedBox(height: 30),
                Text(
                  "PHONE",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                ),
                const SizedBox(height: 20),
                _buildSupportItem(
                  context,
                  Icon(Icons.phone,
                      color: Theme.of(context).colorScheme.outline),
                  'Hotline',
                  '028.73005585',
                  () => _launchUrl(Uri.parse('tel:028.73005585')),
                ),
                const SizedBox(height: 30),
                Text(
                  "EMAIL",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                ),
                const SizedBox(height: 20),
                _buildSupportItem(
                  context,
                  Icon(Icons.email_outlined,
                      color: Theme.of(context).colorScheme.outline),
                  'Email',
                  'baiparking.system@gmail.com',
                  () => _launchUrl(Uri.parse(
                      'mailto:baiparking.system@gmail.com?subject=[Support Request][]&body=I want to request support for...')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSupportItem(
    BuildContext context,
    Widget leadingWidget,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    _log.d('Building support item: $title');
    return Card(
      elevation: 2,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: leadingWidget,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_sharp,
          size: 16,
          color: Theme.of(context).colorScheme.outline,
        ),
        onTap: () {
          _log.i('Support item tapped: $title');
          onTap();
        },
      ),
    );
  }

  Future<void> _launchUrl(Uri uri) async {
    _log.d('Attempting to launch URL: $uri');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        _log.i('Successfully launched URL: $uri');
      } else {
        _log.w('Could not launch URL: $uri');
      }
    } catch (e) {
      _log.e('Error launching URL: $uri', error: e);
    }
  }
}
