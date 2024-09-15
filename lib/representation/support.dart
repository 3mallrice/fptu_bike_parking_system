import 'package:bai_system/component/app_bar_component.dart';
import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static const String routeName = '/support';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarCom(
        leading: true,
        appBarText: 'Support',
      ),
      body: Center(
        child: Text('Support'),
      ),
    );
  }
}
