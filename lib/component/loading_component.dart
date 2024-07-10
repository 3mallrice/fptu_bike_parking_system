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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LoadingAnimationWidget.fourRotatingDots(
              color: Theme.of(context).colorScheme.primary,
              size: size ?? 100,
            ),
            const SizedBox(height: 10),
            Text(
              'Loading...',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
