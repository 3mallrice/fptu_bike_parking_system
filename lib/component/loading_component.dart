import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingCircle extends StatefulWidget {
  const LoadingCircle({super.key});

  @override
  State<LoadingCircle> createState() => _LoadingCircleState();
}

class _LoadingCircleState extends State<LoadingCircle> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.fourRotatingDots(
        color: Theme.of(context).colorScheme.primary,
        size: 100,
      ),
    );
  }
}
