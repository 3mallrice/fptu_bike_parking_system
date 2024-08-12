import 'package:flutter/material.dart';

import '../../component/return_login_component.dart';

class ReturnLoginDialog {
  static void returnLogin(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const InvalidTokenDialog();
      },
    );
  }
}
