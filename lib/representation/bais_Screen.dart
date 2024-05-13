import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';

class BaisScreen extends StatefulWidget {
  const BaisScreen({super.key});

  static String routeName = '/bais_screen';

  @override
  State<BaisScreen> createState() => _BaisScreenState();
}

class _BaisScreenState extends State<BaisScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: ShadowContainer(
            padding: EdgeInsets.zero,
            width: MediaQuery.of(context).size.width * 0.9,
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total bais',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '2',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      //kkk
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      color: Theme.of(context).colorScheme.primary,
                      child: Icon(
                        Icons.add_rounded,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
