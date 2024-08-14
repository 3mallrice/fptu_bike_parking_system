import 'package:bai_system/core/const/frondend/message.dart';
import 'package:flutter/material.dart';

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w700,
            ),
        textAlign: TextAlign.center,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      content: content,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (onClick != null) {
              onClick!();
            }
          },
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
  final String? negativeLabel;
  final EdgeInsetsGeometry? contentPadding;

  const ConfirmDialog({
    super.key,
    required this.title,
    this.content,
    this.onConfirm,
    this.onCancel,
    this.positiveLabel,
    this.negativeLabel,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w700,
            ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
      content: content,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (onCancel != null) {
              onCancel!();
            }
          },
          child: Text(negativeLabel ?? LabelMessage.cancel),
        ),
        TextButton(
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!();
            }
          },
          child: Text(positiveLabel ?? LabelMessage.save),
        ),
      ],
    );
  }
}
