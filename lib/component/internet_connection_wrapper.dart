import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../representation/no_connection_screen.dart';
import '../service/internet_connection_checker.dart';

class InternetConnectionWrapper extends StatelessWidget {
  final String? goToPageRouteName;
  final Widget child;

  const InternetConnectionWrapper(
      {super.key, required this.child, this.goToPageRouteName});

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetConnectionService>(
      builder: (context, internetService, _) {
        return StreamBuilder<bool>(
          stream: internetService.connectionStream,
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.data!) {
              return NoInternetScreen(
                goToPageRouteName: goToPageRouteName,
              );
            }
            return Container(
              color: Theme.of(context).colorScheme.surface,
              child: child,
            );
          },
        );
      },
    );
  }
}
