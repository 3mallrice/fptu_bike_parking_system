import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingCircle extends StatelessWidget {
  final bool? isBlur;
  final double? size;
  final bool isHeight;

  const LoadingCircle({
    super.key,
    this.isBlur = true,
    this.size,
    this.isHeight = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: isHeight ? MediaQuery.of(context).size.height * 0.6 : null,
        alignment: Alignment.center,
        child: LoadingAnimationWidget.fourRotatingDots(
          color: Theme.of(context).colorScheme.primary,
          size: size ?? 100,
        ),
      ),
    );
  }
}
