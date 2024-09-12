import 'package:bai_system/representation/navigation_bar.dart';
import 'package:flutter/material.dart';

import '../core/const/frontend/message.dart';

class NoInternetScreen extends StatelessWidget {
  final String? goToPageRouteName;
  const NoInternetScreen({super.key, this.goToPageRouteName});

  static String routeName = '/exception_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.outline.withOpacity(0.9),
      body: PopScope(
        canPop: false,
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.height * 0.35,
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.link_off_rounded,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'No connection',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 26,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'It appears your device is not connected to a network. If you wish to perform an action, please try to reconnect.',
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () => Navigator.of(context).pushReplacementNamed(
            goToPageRouteName ?? MyNavigationBar.routeName),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            LabelMessage.ok,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.background,
                fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
