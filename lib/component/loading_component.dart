import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingCircle extends StatelessWidget {
  final bool? isBlur;
  final double? size;

  const LoadingCircle({
    super.key,
    this.isBlur = true,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: LoadingAnimationWidget.fourRotatingDots(
          color: Theme.of(context).colorScheme.primary,
          size: size ?? 100,
        ),
      ),
    );
  }
}
