import 'package:flutter/material.dart';

import '../core/const/frontend/message.dart';
import '../representation/login.dart';
import 'dialog.dart';

class InvalidTokenDialog extends StatelessWidget {
  const InvalidTokenDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return OKDialog(
      title: ErrorMessage.error,
      content: Text(
        ErrorMessage.tokenIsExpired,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onClick: () => Navigator.of(context).pushNamedAndRemoveUntil(
        LoginScreen.routeName,
        (route) => false,
      ),
    );
  }
}
