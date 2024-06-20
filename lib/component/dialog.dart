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
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w700,
            ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      surfaceTintColor: Theme.of(context).colorScheme.background,
      content: content,
      actions: <Widget>[
        TextButton(
          onPressed: () => onClick,
          child: Text(LabelMessage.ok),
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
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w700,
            ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      surfaceTintColor: Theme.of(context).colorScheme.background,
      content: content,
      actions: <Widget>[
        TextButton(
          onPressed: () => onCancel,
          child: Text(LabelMessage.cancel),
        ),
        TextButton(
          onPressed: () => onConfirm,
          child: Text(positiveLabel ?? LabelMessage.save),
        ),
      ],
    );
  }
}
