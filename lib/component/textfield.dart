import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool? obscureText;
  final int? maxLength;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? enabled;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final FloatingLabelBehavior? floatingLabelBehavior;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.obscureText,
    this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.enabled,
    this.validator,
    this.maxLength,
    this.inputFormatters,
    this.floatingLabelBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      enabled: enabled ?? true,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        floatingLabelBehavior:
            floatingLabelBehavior ?? FloatingLabelBehavior.auto,
      ),
      cursorColor: Theme.of(context).colorScheme.primary,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
    );
  }
}
