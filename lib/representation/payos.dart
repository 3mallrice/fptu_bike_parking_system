import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/component/app_bar_component.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';

class PayOsScreen extends StatefulWidget {
  const PayOsScreen({super.key});

  static String routeName = '/payos_screen';

  @override
  State<PayOsScreen> createState() => _PayOsScreenState();
}

class _PayOsScreenState extends State<PayOsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCom(
        leading: true,
        appBarText: 'View Profile',
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShadowContainer(
                padding: EdgeInsets.zero,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
