import 'package:flutter/material.dart';

typedef FieldValidator = String? Function(String? newText);

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final int maxLines;
  FieldValidator? validator;
  TextEditingController? controller;

  CustomTextFormField(
      {super.key,
      required this.labelText,
      required this.hintText,
      this.maxLines = 1,
      this.validator,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: true,
      maxLines: maxLines,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
