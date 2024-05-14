import 'package:flutter/material.dart';

class MeScreen extends StatefulWidget {
  const MeScreen({super.key});

  static String routeName = '/me_screen';

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Me Screen'),
      ),
    );
  }
}
