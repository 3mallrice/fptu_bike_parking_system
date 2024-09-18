import 'package:bai_system/core/const/frontend/message.dart';
import 'package:flutter/material.dart';

//OKDialog
class OKDialog extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final Widget? content;
  final Function? onClick;
  final EdgeInsetsGeometry? contentPadding;
  final double? maxHeight;

  const OKDialog({
    super.key,
    required this.title,
    this.titleStyle,
    this.content,
    this.onClick,
    this.contentPadding,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      surfaceTintColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: maxHeight ?? constraints.maxHeight * 0.8,
              minWidth: constraints.maxWidth * 0.9,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: contentPadding ??
                    const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight * 0.8,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          title,
                          style: titleStyle ??
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 20,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (content != null) content!,
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            if (onClick != null) {
                              onClick!();
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            LabelMessage.ok,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
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
  final double? maxHeight;

  const ConfirmDialog({
    super.key,
    required this.title,
    this.content,
    this.onConfirm,
    this.onCancel,
    this.positiveLabel,
    this.negativeLabel,
    this.contentPadding,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: maxHeight ?? constraints.maxHeight * 0.8,
              minWidth: constraints.maxWidth * 0.9,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: contentPadding ??
                    const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (content != null) content!,
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (onCancel != null) {
                              onCancel!();
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            negativeLabel ?? LabelMessage.cancel,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            if (onConfirm != null) {
                              onConfirm!();
                            }
                          },
                          child: Text(
                            positiveLabel ?? LabelMessage.save,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
