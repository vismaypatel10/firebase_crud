import 'dart:core';

import 'package:flutter/material.dart';

class custom_textformfield extends StatelessWidget {
  final TextEditingController? textController;
  final String? Function(String?) validator;
  final String? labeltext;
  final String? initialValue;
  void Function(String)? onChanged;
  final TextInputType? keyboardType;
  bool obscureText;
  int? maxlength;

  custom_textformfield({
    Key? key,
    this.maxlength,
    this.textController,
    this.labeltext,
    required this.validator,
    this.initialValue,
    this.onChanged,
    this.keyboardType,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      maxLength: maxlength,
      controller: textController,
      onChanged: onChanged,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: labeltext,
        //labelText: 'Name',
      ),
    );
  }
}
