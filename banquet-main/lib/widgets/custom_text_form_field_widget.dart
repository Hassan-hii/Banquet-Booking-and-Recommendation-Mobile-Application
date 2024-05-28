import 'package:flutter/material.dart';

class CustomTextFormFieldWidget extends StatelessWidget {

  const CustomTextFormFieldWidget({super.key,
    this.labelText, this.keyboardType, this.validator,
    this.obscureText, this.suffixIcon, this.textInputAction,
    this.controller, this.textCapitalization, this.maxLines = 1, this.maxLength, this.hintText});

  final String? labelText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final TextCapitalization? textCapitalization;
  final int? maxLines;
  final int? maxLength;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      // autovalidateMode: AutovalidateMode.always,
      validator: validator,
      obscureText: obscureText ?? false,
      textInputAction: textInputAction,
      maxLines: maxLines,
      maxLength: maxLength,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      decoration: InputDecoration(
        counterText: '',
        hintText: hintText,
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
