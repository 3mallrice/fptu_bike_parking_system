import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final List<Widget>? action;

  const CustomTextField({
    super.key,
    this.hintText,
    this.controller,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NUMBER',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
          ),
        )
      ],
    );
  }
}
