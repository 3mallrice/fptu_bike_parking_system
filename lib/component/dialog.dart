import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/core/const/frondend/message.dart';

//OKDialog
class OKDialog extends StatelessWidget {
  final String title;
  final Widget? content;
  final Function? onClick;
  const OKDialog({
    super.key,
    required this.title,
    this.content,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      content: Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: content,
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            if (onClick != null) onClick!();
          },
          child: Text(
            LabelMessage.ok,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

//ConfirmDialog
class ConfirmDialog extends StatelessWidget {
  final String title;
  final Widget? content;
  final Function? onConfirm;
  final Function? onCancel;
  final String? positiveLabel;
  const ConfirmDialog({
    super.key,
    required this.title,
    this.content,
    this.onConfirm,
    this.onCancel,
    this.positiveLabel,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      content: Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: content,
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            if (onCancel != null) onCancel!();
          },
          child: Text(
            LabelMessage.cancel,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        CupertinoDialogAction(
          onPressed: () {
            if (onConfirm != null) onConfirm!();
          },
          child: Text(
            positiveLabel ?? LabelMessage.ok,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
