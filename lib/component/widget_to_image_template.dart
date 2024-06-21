import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/helper/asset_helper.dart';

class WidgetToImageTemplate extends StatelessWidget {
  final Widget widget;
  const WidgetToImageTemplate({
    super.key,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    String formatDateTime(DateTime datetime) =>
        DateFormat('dd/MM/yyyy HH:mm:ss').format(datetime);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      color: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          const Image(
            image: AssetImage(AssetHelper.baiLogo),
            height: 30,
            fit: BoxFit.contain,
          ),

          // main widget
          Container(
            padding: const EdgeInsets.only(top: 5, bottom: 10),
            child: widget,
          ),

          // datetime with format dd/MM/yyyy
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                formatDateTime(DateTime.now()),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 9,
                    ),
              ),
              Text(
                'Phuc Bui',
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
