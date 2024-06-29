import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? color;
  final Widget? child;
  final Border? border;

  const ShadowContainer({
    /// A widget that wraps a child with a shadow effect.
    /// made by [Maotou] with ❤️.
    super.key,
    this.width,

    /// The width of the container.
    this.height,
    this.margin,
    this.padding,

    /// The margin of the container.
    this.borderRadius,

    /// The border radius of the container.
    this.color,

    /// The color of the container.
    this.child,
    this.border,

    /// The child of the container.
    /// It can be any widget, but it is recommended to use a column or row widget.
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
        border: border,
        color: color ?? Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
