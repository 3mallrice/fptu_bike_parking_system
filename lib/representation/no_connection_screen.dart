import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../core/const/frontend/message.dart';

class NoInternetScreen extends StatelessWidget {
  final String? goToPageRouteName;
  const NoInternetScreen({super.key, this.goToPageRouteName});

  static String routeName = '/exception_screen';

  @override
  Widget build(BuildContext context) {
    var log = Logger();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.outline.withOpacity(0.9),
      body: PopScope(
        canPop: false,
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
                      maxHeight: MediaQuery.of(context).size.height * 0.35,
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
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
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 26,
                              ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'It appears your device is not connected to a network. If you wish to perform an action, please try to reconnect.',
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.05,
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'For more information:',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        GestureDetector(
                          onTap: () {
                            //TODO: Implement FAQ
                            log.d('FAQ is clicked');
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('FAQ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ))),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () => goToPageRouteName != null
            ? Navigator.of(context).pushReplacementNamed(goToPageRouteName!)
            : Navigator.of(context).pop(),
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
