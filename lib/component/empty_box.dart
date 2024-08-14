import 'package:flutter/material.dart';

import '../core/const/frondend/message.dart';
import '../core/helper/asset_helper.dart';

class EmptyBox extends StatelessWidget {
  final String? message;
  final String? buttonMessage;
  final Function? buttonAction;

  const EmptyBox({
    super.key,
    this.message,
    this.buttonMessage,
    this.buttonAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AssetHelper.emptyBox,
              width: MediaQuery.of(context).size.width * 0.32,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 15),
            Text(
              message ?? EmptyBoxMessage.empty,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            if (buttonMessage != null && buttonAction != null)
              ElevatedButton(
                onPressed: () => buttonAction!(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.outline,
                ),
                child: Text(
                  buttonMessage!,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.background,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
