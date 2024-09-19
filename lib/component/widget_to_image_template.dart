import 'package:bai_system/api/model/bai_model/login_model.dart';
import 'package:bai_system/core/const/utilities/util_helper.dart';
import 'package:bai_system/core/helper/local_storage_helper.dart';
import 'package:flutter/material.dart';

import '../core/helper/asset_helper.dart';

class WidgetToImageTemplate extends StatelessWidget {
  final Widget child;

  const WidgetToImageTemplate({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    String currentEmail = LocalStorageHelper.getCurrentUserEmail() ?? "";
    UserData? userData = GetLocalHelper.getUserData(currentEmail);
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 10),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          const Image(
            image: AssetImage(AssetHelper.baiLogo),
            height: 20,
            fit: BoxFit.contain,
          ),

          // main widget
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: child,
          ),

          // datetime with format dd/MM/yyyy
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                UltilHelper.formatDTS(DateTime.now()),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 9,
                    ),
              ),
              Text(
                userData?.name ?? '',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 9,
                    ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
